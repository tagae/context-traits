# [Context Traits](https://github.com/tagae/context-traits).
# Copyright © 2012—2015 UCLouvain.

module "Context Activation"

test "Infrastructure", ->
  ok $.isFunction(Context.prototype.activate),
    "Method for context activation exists."
  ok $.isFunction(Context.prototype.deactivate),
    "Method for context deactivation exists."
  ok $.isFunction(Context.prototype.isActive),
    "Method for context activation state test exists."

test "Basic activation", ->
  context = new Context()
  ok !context.isActive(),
    "A fresh context is initially inactive."
  noerror (-> context.activate()),
    "Freshly created context can be activated."
  ok context.isActive(),
    "Activation leaves the context in an active state."
  noerror (-> context.deactivate()),
    "Freshly activated context can be deactivated."
  ok !context.isActive(),
    "Deactivation leaves the context in an inactive state."
  strictEqual context, context.activate(),
    "activate() returns the receiver object."
  strictEqual context, context.deactivate(),
    "deactivate() returns the receiver object."

test "Multiple activation", ->
  context = new Context()
  context.activate() for n in [1..10]
  ok context.isActive(),
    "A multiply-activated context is active."
  context.deactivate() for n in [1..9]
  ok context.isActive(),
    "Context stays active for fewer deactivations than activations."
  context.deactivate()
  ok !context.isActive(),
    "Context becomes inactive after matching number of deactivations."

test "Disallowed deactivation", ->
  context = new Context()
  throws (-> context.deactivate()),
    /cannot.*deactivate.*context/i,
    "Deactivation of inactive contexts is disallowed."
  context.activate() for n in [1..3]
  context.deactivate() for n in [1..3]
  throws (-> context.deactivate()),
    /cannot.*deactivate.*context/i,
    "Previous context activity should not interfere with disallowed deactivations."
