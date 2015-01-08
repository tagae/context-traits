# [Context Traits](https://github.com/tagae/context-traits).
# Copyright © 2012—2015 UCLouvain.

traits = {}

traits.Extensible = Trait
  proceed: ->
    manager = contexts.Default.manager
    invocations = manager.invocations
    if invocations.length == 0
      throw new Error "Proceed must be called from an adaptation"
    [object, method, name, args] = invocations.top()
    # Arguments passed to `proceed` take precedence over those of the
    # original invocation.
    args = if arguments.length == 0 then args else arguments
    # Find next method.
    alternatives = manager.orderedMethods object, name
    index = alternatives.indexOf method
    if index == -1
      throw new Error "Cannot proceed from an inactive adaptation"
    if index + 1 == alternatives.length
      throw new Error "Cannot proceed further"
    # Invoke next method.
    alternatives[index+1].apply this, args

traceableMethod = (object, name, method) ->
  wrapper = ->
    invocations = contexts.Default.manager.invocations
    invocations.push [object, wrapper, name, arguments]
    try
      method.apply this, arguments
    finally
      invocations.pop()
  wrapper

traceableTrait = (trait, object) ->
  newTrait = Trait.compose trait # copy
  for own name, propdesc of newTrait when _.isFunction propdesc.value
    propdesc.value = traceableMethod object, name, propdesc.value
  newTrait

# Extend `Manager` with methods related to composition.

_.extend Manager.prototype,

  orderedMethods: (object, name) ->
    adaptations = this.adaptationChainFor object
    for adaptation in adaptations
      adaptation.trait[name].value

# Extend `Policy` with methods related to composition.

_.extend Policy.prototype,

  order: (adaptations) ->
    self = this
    adaptations.sort (adaptation1, adaptation2) ->
      if adaptation1.object isnt adaptation2.object
        throw new Error "Refusing to order adaptations of different objects"
      self.compare adaptation1, adaptation2

  compare: (adaptation1, adaptation2) ->
    throw new Error "There is no criterium to order adaptations"

  toString: ->
    this.name() + ' policy'

  name: ->
    'anonymous'

# ### Activation Age Policy

# The _activation age policy_ is the policy used by the default
# context manager.

ActivationAgePolicy = ->
  Policy.call this
  this

ActivationAgePolicy.inheritFrom Policy

_.extend ActivationAgePolicy.prototype,

  compare: (adaptation1, adaptation2) ->
    # Result as expected by `Array.sort()`
    adaptation1.context.activationAge() - adaptation2.context.activationAge()

  name: ->
    'activation age'

_.extend Context.prototype,

  activationAge: ->
    this.manager.totalActivations - this.activationStamp
