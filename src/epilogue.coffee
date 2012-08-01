# [Context Traits](https://github.com/tagae/context-traits).
# Copyright © 2012 UCLouvain.

# If there is no explicit `exports`, take global namespace
unless exports?
  exports = this

# Export objects.
exports.Context = Context
exports.Namespace = Namespace
exports.Policy = Policy
exports.Trait = Trait # from traits.js

# Export namespaces.
exports.contexts = contexts
