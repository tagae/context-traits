# Context Traits
# https://github.com/tagae/context-traits
# Copyright © 2012 UCLouvain.
# Licensed under Apache Licence, Version 2.0.

platform = contexts.ensure 'platform'

_.extend platform,
  Mozilla: new Context()
  WebKit: new Context()
  Opera: new Context()
  IE: new Context()
  NodeJS: new Context()

if $
  for [ browser, flag ] in [
      ['Mozilla', 'mozilla'],
      ['WebKit', 'webkit'],
      ['Opera', 'opera'],
      ['IE', 'msie'] ]
    platform[browser].activate() if $.browser[flag]
