#
#   Base class for dynamic DAG
#

linkable = require "./linkable"

module.exports = class Dynamic extends linkable.Linkable
  constructor: (linkid, @pointer) ->
    super linkid
  

