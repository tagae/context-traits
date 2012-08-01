# [Context Traits](https://github.com/tagae/context-traits).
# Copyright © 2012 UCLouvain.

module "Context Composition",
  setup: ->
    this.phone =
      advertise: -> 'ringtone'
      toString: -> 'phone'

    this.quiet = new Context 'quiet'
    this.quietPhone = Trait advertise: -> 'vibrator'

    this.screening = new Context 'screening'
    this.screeningPhone = Trait advertise: -> "#{this.proceed()} with screening"

test "Composition through proceed", ->
  this.screening.adapt this.phone, this.screeningPhone
  equal this.phone.advertise(), 'ringtone',
    "Default behaviour is initially exhibited."
  this.screening.activate()
  equal this.phone.advertise(), 'ringtone with screening',
    "Adapted behaviour is overlaid on top of default behaviour"
  this.screening.deactivate()

test "Handling of original arguments in proceed", ->
  person = greet: (peer) -> "Hello #{peer}"
  party = new Context 'party'
  enthusiasticPerson = Trait greet: (peer) -> this.proceed() + '!'
  party.adapt person, enthusiasticPerson
  equal person.greet('Ken'), 'Hello Ken',
    "Default behaviour handles parameter as expected."
  party.activate()
  equal person.greet('Ken'), 'Hello Ken!',
    "Original arguments are passed through by parameter-less proceed invocation."

test "Proceed with explicit arguments", ->
  person = greet: (peer) -> "Hello #{peer}"
  atWork = new Context 'atWork'
  formalPerson = Trait greet: (peer) -> this.proceed "Mr. #{peer}"
  atWork.adapt person, formalPerson
  equal person.greet('Ken'), 'Hello Ken',
    "Default behaviour handles parameter as expected."
  atWork.activate()
  equal person.greet('Loach'), 'Hello Mr. Loach',
    "Adapted behaviour takes explicit proceed parameter into account."

test "Invalid proceed", ->
  this.phone.advertise = -> this.proceed()
  this.screening.adapt this.phone, this.screeningPhone
  this.screening.activate()
  throws (-> this.phone.advertise()),
    /cannot proceed further/i,
    "Cannot proceed from default method."

test "Nested activation", ->
  this.quiet.adapt this.phone, this.quietPhone
  this.screening.adapt this.phone, this.screeningPhone
  equal this.phone.advertise(), 'ringtone',
    "Default behaviour is initially exhibited."
  this.quiet.activate()
  equal this.phone.advertise(), 'vibrator',
    "Adapted behaviour is exhibited after activation of context."
  this.screening.activate()
  equal this.phone.advertise(), 'vibrator with screening',
    "Extended behaviour is overlaid on top of adapted behaviour."
  this.screening.deactivate()
  equal this.phone.advertise(), 'vibrator',
    "Adapted behaviour is exhibited again after deactivation of extended behaviour."
  this.quiet.deactivate()
  equal this.phone.advertise(), 'ringtone',
    "Behaviour is back to default after deactivation of all contexts."

test "Interleaved activation", ->
  this.quiet.adapt this.phone, this.quietPhone
  this.screening.adapt this.phone, this.screeningPhone
  this.quiet.activate()
  equal this.phone.advertise(), 'vibrator',
    "Adapted behaviour is exhibited after activation of context."
  this.screening.activate()
  equal this.phone.advertise(), 'vibrator with screening',
    "Extended behaviour is overlaid on top of adapted behaviour."
  this.quiet.deactivate()
  equal this.phone.advertise(), 'ringtone with screening',
    "Early deactivation of context is supported."
  this.screening.deactivate()
  equal this.phone.advertise(), 'ringtone',
    "Behaviour is restored to default."
