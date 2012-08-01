# [Context Traits](https://github.com/tagae/context-traits).
# Copyright © 2012 UCLouvain.

# Main context namespace.
contexts = new Namespace 'contexts'

contexts.Default = new Context 'default'

# The default context is always active.
contexts.Default.activate()
