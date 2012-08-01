# [Context Traits](https://github.com/tagae/context-traits).
# Copyright © 2012 UCLouvain.

# Extend `Context` with methods related to activation.

_.extend Context.prototype,

    activate: ->
      if ++this.activationCount == 1
        this.activationStamp = ++this.manager.totalActivations
        this.activateAdaptations()
      this

    deactivate: ->
      if this.activationCount > 0
        if --this.activationCount == 0
          this.deactivateAdaptations()
          delete this.activationStamp
      this

    isActive: ->
      this.activationCount > 0
