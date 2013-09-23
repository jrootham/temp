#
#   Leaf dynamic classes
#

Dynamic = require "./dynamic"

class Leaf extends Dynamic
  constructor: (linkid, pointer) ->
    super linkid, pointer

  displayGraph: (indent) ->
    result = indent + @name + "\n"

  isComplete: ->
    return true
    
  preorder: (fn) ->
    fn @
 
  inorder: (fn) ->
    fn @
 
  postorder: (fn) ->
    fn @
 
class Value extends Leaf
  constructor: (linkid, pointer, @value) ->
    super linkid, pointer
    
class Numeric extends Value
  constructor: (linkid, pointer, value) ->
    super linkid, pointer, +value
 
module.exports =
  Constant: class extends Leaf

    name: "Constant"
  
  Unsigned: class extends Numeric

    name: "Unsigned"
    
  Integer: class extends Numeric

    name: "Integer"
    
  Fixed: class extends Numeric

    name: "Fixed"
    
  Float: class extends Numeric

    name: "Float"
    
  FixedBCD: class extends Numeric

    name: "FixedBCD"
    
  StringType: class extends Value

    name: "StringType"
    
  SingleQuotes: class extends Value

    name: "SingleQuotes"
    
  DoubleQuotes: class extends Value

    name: "DoubleQuotes"
    
  Symbol: class extends Value

    name: "Symbol"
    
  Match: class extends Value

    name: "Match"
    
  OptionalWhite: class extends Leaf

    name: "OptionalWhite"
    
  RequiredWhite: class extends Leaf

    name: "RequiredWhite"
    
