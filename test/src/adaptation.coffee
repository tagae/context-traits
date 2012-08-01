# [Context Traits](https://github.com/tagae/context-traits).
# Copyright © 2012 UCLouvain.

module "Context Adaptation"

test "Infrastructure", ->
  ok $.isFunction(Context.prototype.adapt),
    "Method to define behavioural adaptations exists."

test "Overriding adaptation", ->
  person =
    greet: -> 'hello'
    toString: -> 'person'
  noisy = new Context 'noisy'
  noisyPerson = Trait greet: -> 'HELLO'
  noerror (-> noisy.adapt person, noisyPerson),
    "Definition of a simple adaptation succeeds."
  equal person.greet(), 'hello',
    "Default behaviour is exhibited when context is inactive."
  noisy.activate()
  equal person.greet(), 'HELLO',
    "Adapted behaviour is exhibited after context activation."
  noisy.deactivate()
  equal person.greet(), 'hello',
    "Default behaviour is exhibited again after context deactivation."

test "Adaptation to active context", ->
  person = greet: -> 'hello'
  noisyPerson = Trait greet: -> 'HELLO'
  noisy = new Context()
  noisy.activate()
  equal person.greet(), 'hello',
    "Default behaviour is exhibited prior to introduction of adaptation."
  noerror (-> noisy.adapt person, noisyPerson),
    "Adaptation can be introduced in active context."
  equal person.greet(), 'HELLO',
    "Adapted behaviour for active context is observed."
  noisy.deactivate()
  equal person.greet(), 'hello',
    "Default behaviour is persistent."
  noisy.activate()
  equal person.greet(), 'HELLO',
    "Adapted behaviour is persistent."
  noisy.deactivate()

test "Detection of ambiguous extension", ->
  person = name: -> 'Ken'
  formalPerson = Trait name: -> 'Ken Loach'
  veryFormalPerson = Trait name: -> 'Mr. Ken Loach'
  formal = new Context 'formal'
  noerror (-> formal.adapt person, formalPerson),
    "Method can be adapted to context."
  throws (-> formal.adapt person, veryFormalPerson),
    /property.*already adapted/i,
    "Rejection of two method definitions for the same context."

test "Adaptation extension", ->
  person =
    name: -> 'Ken'
    greet: -> 'Hi there'
  formalPerson = Trait name: -> 'Ken Loach'
  formalGreeter = Trait greet: -> 'Hello'
  formal = new Context 'formal'
  noerror (-> formal.adapt person, formalPerson),
    "Object can be adapted as usual."
  noerror (-> formal.adapt person, formalGreeter),
    "Adaptation of object to same context can be extended with new behaviour."
  formal.activate()
  equal person.name(), "Ken Loach",
    "Original adapted behaviour is exhibited."
  equal person.greet(), "Hello",
    "Additional adapted behaviour is exhibited."
  formal.deactivate()

test "Preservation of receiver identity", ->
  person =
    name: -> this.firstName
    firstName: 'Ken'
    lastName: 'Loach'
  equal person.name(), "Ken",
    "Object identity is well-defined in default behaviour."
  formalPerson = Trait
    name: -> this.firstName + ' ' + this.lastName
  formal = new Context 'formal'
  formal.adapt person, formalPerson
  equal person.name(), "Ken",
    "Object identity is preserved after definition of adaptation."
  formal.activate()
  equal person.name(), "Ken Loach",
    "Object identity is preserved in adapted behaviour."
  formal.deactivate()

test "Adaptation of primitive values", ->
  upsideDown = new Context()
  upsideDownNumber = Trait "+": (a, b) -> a - b
  throws (-> upsideDown.adapt 42, upsideDownNumber),
    /value.*cannot be adapted/i,
    "Numbers cannot be adapted in JavaScript (unfortunately)."
