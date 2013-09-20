#
#  base class for linkable objects
#

module.exports =
  Linkable: class
    constructor: (@linkid) ->
    
  Next: class
    constructor: (@current) ->
    
    next: -> @current
    
