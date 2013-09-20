#
#   Leaf dynamic classes
#

Dynamic = require "./dynamic"

class Leaf extends Dynamic
  constructor: (linkid, pointer) ->
    super linkid, pointer
    
  isComplete: ->
    return true
 
class Value extends Leaf
  constructor: (linkid, pointer, @value) ->
    super linkid, pointer
    
class Numeric extends Value
  constructor: (linkid, pointer, value) ->
    super linkid, pointer, +value
 
module.exports =
  Constant: class extends Leaf
  
  Unsigned: class extends Numeric
    
  Integer: class extends Numeric
    
  Fixed: class extends Numeric
    
  Float: class extends Numeric
    
  FixedBCD: class extends Numeric
    
  StringType: class extends Value
    
  SingleQuotes: class extends Value
    
  DoubleQuotes: class extends Value
    
  Symbol: class extends Value
    
  Match: class extends Value
    
  OptionalWhite: class extends Leaf
    
  RequiredWhite: class extends Leaf
    
