# [Context Traits](https://github.com/tagae/context-traits).
# Copyright © 2012 UCLouvain.

module "Context Prototypes"

test "Context", ->
  ok Context?,
    "Context prototype exists."
  ok $.isFunction(Context),
    "Context is a (constructor) function."
  noerror (-> new Context()),
    "Contexts can be created."
  ok new Context() instanceof Context,
    "The `instanceof` operator correctly detects contexts."

test "Default context", ->
  ok contexts.Default?,
    "The default context is defined."
  ok contexts.Default instanceof Context,
    "The default context is indeed a context."
  ok contexts.Default.isActive(),
    "The default context is active."
  current = contexts.Default
  strictEqual current, contexts.Default,
    "The default context is persistent."
