# [Context Traits](https://github.com/tagae/context-traits).
# Copyright © 2012 UCLouvain.

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
    "A fresh context is not initially active."
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

test "Redundant activation", ->
  context = new Context()
  context.activate() for n in [1..10]
  ok context.isActive(),
    "A multiply-activated context remains active."
  context.deactivate() for n in [1..9]
  ok context.isActive(),
    "Context stays active for fewer deactivations than activations."
  context.deactivate()
  ok !context.isActive(),
    "Context becomes inactive after matching number of deactivations."

test "Redundant deactivation", ->
  context = new Context()
  context.activate() for n in [1..3]
  context.deactivate() for n in [1..15]
  ok !context.isActive(),
    "Context becomes inactive after equal or more deactivations than activations"
  context.activate()
  ok context.isActive(),
    "Deactivation does not accumulate once the context has become inactive."
  context.deactivate()
  ok !context.isActive(),
    "Context deactivates normally after single activation."
