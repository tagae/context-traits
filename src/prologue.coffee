# [Context Traits](https://github.com/tagae/context-traits).
# Copyright © 2012—2015 UCLouvain.

# Host Features
# -------------

# Check whether a required object exists. If unavailable, load
# corresponding module: in Node.js, use `require`; in web pages,
# modules must be inserted by hand using `<script>` tags, but this
# function can at least remind the user that such libraries need to be
# loaded.

ensureObject = (name, file, path = []) ->
  object = this[name] # reads current module or `window` object
  unless object?
    if require?
      object = require file
      for attribute in path
        object = object[attribute]
      this[name] = object
    else
      throw new Error "Required object '#{name}' of library '#{file}' not found"

# Check dependencies.
ensureObject '_', 'underscore'
ensureObject 'Trait', 'traits', ['Trait']

# Object Orientation
# ------------------

# Change function prototype so that objects created through this
# constructor will delegate to the given `parent`.
Function.prototype.inheritFrom ?= (parent) ->
  this.prototype = new parent()
  this

# Data Structures
# ---------------

# If there is `push` and `pop` by default, why not `top`?
Array.prototype.top = ->
  this[this.length-1]
