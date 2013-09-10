#
#   Leaf dynamic classes
#

class Leaf
  constructor: (@pointer) ->

  isComplete: ->
    return true
 
class Value extends Leaf
  constructor: (pointer, @value) ->
    super pointer
    
class Numeric extends Value
  constructor: (pointer, value) ->
    super pointer, +value
 
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
    
