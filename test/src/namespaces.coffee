# Context Traits
# https://github.com/tagae/context-traits
# Copyright © 2012 UCLouvain.
# Licensed under Apache Licence, Version 2.0.

module "Context Namespaces"

test "Infrastruture", ->
  ok Namespace?,
    "Namespace prototype exists."
  ok $.isFunction(Context.prototype.path),
    "Method for context path retrieval exists."

test "Default namespaces", ->
  ok contexts instanceof Namespace,
    "Root namespace `contexts` exists."

test "Context paths", ->
  context = new Context()
  ok !context.path(),
    "Freshly created context does not belong to any namespace."
  # Generate random name through representation of number in base 36 (maximum).
  name = makeName()
  # Register context in namespace
  contexts[name] = context
  # Find out context path
  path = context.path()
  ok path,
    "Context in root namespace is effectively found by `path` method."
  ok $.isArray(path),
    "Context path is an array."
  ok path.every((element) -> _.isString(element)),
    "Context path contains only names (strings)."
  deepEqual path, [ name ],
    "A context in the root namespace has a path consisting of only its name."
  # Remove context from namespace
  delete contexts[name]
  ok !context.path(),
    "Context removed from its namespace is no longer found by `path` method."
  name2 = makeName()
  contexts[name] = new Namespace contexts
  contexts[name][name2] = context
  deepEqual context.path(), [name, name2],
    "Context with path of depth 2 is effectively found."
  delete contexts[name]
  ok !context.path(),
    "Context from trimmed (subtree) namespace is no longer found."
  deepEqual contexts.Default.path(), ["Default"],
    "Default context detects its path correctly."

test "Context name based on path", ->
  context = new Context()
  contexts.a = new Namespace contexts
  contexts.a.b = context
  equal context.name(), "a.b",
    "Context name follows path in the `contexts` namespace."
  delete contexts.a
  equal context.name(), "anonymous",
    "Context name reverts to anonymous when removed from namespace."

asyncTest "Context module loading", ->
  ok !contexts?.platform?,
    "The platform namespace is initially not loaded."
  contexts.load 'platform',
    success: ->
      ok contexts?.platform?,
        "The platform namespace can be loaded."
      ok contexts.platform instanceof Namespace,
        "Loaded object is namespace."
      start()
    failure: (error) ->
      ok false,
        "Failed to load platform namespace: " + error
      start()
