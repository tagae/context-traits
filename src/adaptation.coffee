# [Context Traits](https://github.com/tagae/context-traits).
# Copyright © 2012 UCLouvain.

# Strategies for composition of adaptations.

strategies =
  compose: (adaptation, trait) ->
    resultingTrait = Trait.compose adaptation.trait, trait
    for own name, propdesc of resultingTrait
      if propdesc.conflict
        throw new Error "Property '#{name}' already adapted for " +
          adaptation.object + " in " + adaptation.context
    resultingTrait
  preserve: (adaptation, trait) ->
    Trait.override adaptation.trait, trait
  override: (adaptation, trait) ->
    Trait.override trait, adaptation.trait
  prevent: (adaptation, trait) ->
    throw new Error adaptation.object +
      " already adapted in " + adaptation.context

# Extend `Context` with methods related to adaptation.

_.extend Context.prototype,

  adapt: (object, trait) ->
    unless object instanceof Object
      throw new Error "Values of type #{typeof object} cannot be adapted."
    contexts.Default.addAdaptation object, Trait(object), strategies.preserve
    this.addAdaptation object, trait, strategies.compose

  addAdaptation: (object, trait, strategy) ->
    trait = traceableTrait trait
    adaptation = this.adaptationFor object
    if adaptation
      adaptation.trait = strategy adaptation, trait
      if this.isActive()
        this.manager.updateBehaviorOf object
    else
      trait = Trait.compose trait, traits.Extensible
      adaptation = new Adaptation this, object, trait
      this.adaptations.push adaptation
      if this.isActive()
        this.manager.deployAdaptation adaptation
    this

  adaptationFor: (object) ->
    _.find this.adaptations, (adaptation) ->
      adaptation.object is object

  activateAdaptations: ->
    for adaptation in this.adaptations
      this.manager.deployAdaptation adaptation

  deactivateAdaptations: ->
    for adaptation in this.adaptations
      this.manager.withdrawAdaptation adaptation

# Extend `Manager` with methods related to adaptation.

_.extend Manager.prototype,

  deployAdaptation: (adaptation) ->
    this.adaptations.push adaptation
    this.updateBehaviorOf adaptation.object

  withdrawAdaptation: (adaptation) ->
    i = this.adaptations.indexOf adaptation
    if i == -1
      throw new Error "Attempt to withdraw unmanaged adaptation"
    this.adaptations.splice i, 1
    this.updateBehaviorOf adaptation.object

  updateBehaviorOf: (object) ->
    this.adaptationChainFor(object)[0].deploy()
    this

  adaptationChainFor: (object) ->
    relevantAdaptations = _.filter this.adaptations, (adaptation) ->
      adaptation.object is object
    if relevantAdaptations.length == 0
      throw new Error "No adaptations found for #{object}"
    this.policy.order relevantAdaptations

# Define main behaviour of `Adaptation`.

_.extend Adaptation.prototype,

  deploy: ->
    # Overwrite current object properties with adaptation properties.
    _.extend this.object, Object.create({}, this.trait)

  toString: ->
    "Adaptation for #{this.object} in #{this.context}"

  equivalent: (other) ->
    this.context is other.context and
      this.object is other.object and
        Trait.eqv this.trait, other.trait
