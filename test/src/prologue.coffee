# [Context Traits](https://github.com/tagae/context-traits).
# Copyright © 2012 UCLouvain.

# QUnit
# -----

# Extend QUnit with "noerror", the reciprocal of the "throws" assertion.
noerror = (block, message) ->
  try
    block.call()
  catch error
    QUnit.pushFailure message, null, "Unexpected exception: #{error.message}"
    return
  QUnit.push true, null, null, message


# Ancillary functions
# -------------------

makeName = (length = 5) ->
  # Generate random name through representation of number in base 36.
  Math.random().toString(36).substring(length)
