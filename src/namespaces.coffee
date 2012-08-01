# [Context Traits](https://github.com/tagae/context-traits).
# Copyright © 2012 UCLouvain.

Namespace = (name, parent = null) ->
  unless name
    throw new Error "Namespaces must have a name"
  this.name = name
  this.parent = parent
  unless parent
    this.home = findScriptHome()
  this

# Define main behaviour of `Namespace`.

_.extend Namespace.prototype,

  root: ->
    if this.parent?
      this.parent.root()
    else
      this

  path: () ->
    if this.parent?
      path = this.parent.path()
      path.push this.name
      path
    else
      [ this.name ]

  normalizePath: (path) ->
    if _.isString path
      path = path.split '.'
    else if _.isArray path
      path
    else
      throw new Error "Invalid path specification"

  ensure: (path) ->
    path = this.normalizePath path
    namespace = this
    for name in path
      unless namespace[name]?
        namespace[name] = new Namespace(name, namespace)
      namespace = namespace[name]
    namespace

  add: (properties) ->
    _.extend this, properties

  load: (path, options) ->
    success = options.success or (->)
    failure = options.failure or (->)
    path = this.normalizePath path
    if document?
      this.loadInBrowser path, success, failure
    else
      throw new Error "Loading of context modules not supported in current JavaScript platform."

  loadInBrowser: (path, success, failure) ->
    unless $?
      throw new Error "Context module loading depends on jQuery"
    target = this
    url = target.root().home + (target.path().concat path).join('/') + '.js'
    $.ajax
      url: url
      dataType: "text" # Prevent premature evaluation
      success: (data, textStatus, jqXHR) ->
        try
          if window.hasOwnProperty 'exports'
            origExports = window.exports
          window.exports = {}
          $.globalEval data
          leaf = target.ensure path
          leaf.add window.exports
          if origExports?
            window.exports = origExports
          else
            delete window.exports
          console.log 'Loaded ' + url
          success()
        catch error
          failure error
      error: (jqXHR, status, error) ->
        console.log "Failed to load #{url} (#{status}): #{error}"
        failure error

# Extend `Context` with behaviour related to namespaces.

_.extend Context.prototype,

  path: (from = contexts) ->
    keys = _.keys(from)
    values = _.values(from)
    i = values.indexOf this
    if i != -1
      [ keys[i] ]
    else
      for subspace, i in values
        if subspace instanceof Namespace and keys[i] != 'parent'
          p = this.path subspace
          if p
            p.unshift keys[i]
            return p
      false

  name: ->
    path = this.path()
    if path
      path.join '.'
    else
      'anonymous'

  toString: ->
    this.name() + ' context'

# Ancilliary Functions
# --------------------

# Find the absolute path from which the current script has been
# loaded. If unable, return a falsy value.

findScriptHome = ->
  try
    throw new Error
  catch error
    # Obtain textual stacktrace from exception object
    trace = error.stack or error.stacktrace
    if trace
      # Find first line mentioning a URL
      for line in trace.split '\n'
        matches = /(http|file):\/\/[^/]*(\/.*\/)[^/]*\.js/.exec line
        if matches?
          return matches[2]
    else if error.sourceURL
      # Internet Explorer
      throw new Error 'TODO: error.sourceURL not supported yet.'
    else
      throw new Error 'Could not determine script home directory.'
  null
