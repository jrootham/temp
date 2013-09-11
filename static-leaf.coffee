#
#   Leaf static classes for parsing and editing
#

dynamic = require "./dynamic"

class Leaf
  constructor: ->

class Value extends Leaf
  constructor: (@value) ->
    super

doMatch = (source, pattern, flags, pointer, make) ->
  match = source.match pattern, flags
  if match
    result = make pointer, match
  else
    result = null
  return result
  
module.exports =

# Constant

  Constant: class extends Value
      
    parse: (source, parseStack) =>
      match = source.next(@value)
      if match
        result = new dynamic.Constant(@)
      else
        result = null
      return result

# Match
          
  Match: class extends Leaf
    constructor: (@pattern, @flags) ->
      super
    
    make:  (pointer, value) ->
      return new dynamic.Match pointer, value
      
    parse: (source, parseStack) =>
      return doMatch source, @pattern, @flags, @, @make

# Unsigned
  
  Unsigned: class extends Leaf
    
    make: (pointer, value) ->
      return new dynamic.Unsigned pointer, value
      
    parse: (source, parseStack) =>
      return doMatch source, "[0-9]*", "", @, @make

# Integer
  
  Integer: class extends Leaf
    
    make: (pointer, value) ->
      return new dynamic.Integer pointer, value
      
    parse: (source, parseStack) =>
      return doMatch source, "\-?[0-9]*", "", @, @make

# Fixed
  
  Fixed: class extends Leaf
    
    make: (pointer, value) ->
      return new dynamic.Fixed pointer, value
      
    parse: (source, parseStack) =>
      return doMatch source, "-?[0-9]*(\\.[0-9]*)?", "", @, @make

# Float
  
  Float: class extends Leaf
    
    make: (pointer, value) ->
      return new dynamic.Float pointer, value
      
    parse: (source, parseStack) =>
      pattern = "-?[0-9]*(\\.[0-9]*)?((e|E)-?[0-9]*)?"
      return doMatch source, pattern, "", @, @make


# FixedBCD
  
  FixedBCD: class extends Leaf
    
    make: (pointer, value) ->
      return new dynamic.FixedBCD pointer, value
      
    parse: (source, parseStack) =>
      return doMatch source, "-?[0-9]*(\\.[0-9]*)?", "", @, @make


# StringType
  
  StringType: class extends Leaf
    
    parse: (source, parseStack) =>
      return dynamic.SingleQuotes @, source.stringType

# SingleQuotes
  
  SingleQuotes: class extends Leaf
    
    parse: (source, parseStack) =>
      return dynamic.SingleQuotes @, source.singleQuotes

# DoubleQuotes
  
  DoubleQuotes: class extends Leaf
    
    parse: (source, parseStack) =>
      return dynamic.DoubleQuotes @, source.doubleQuotes

# Symbol
  
  Symbol: class extends Leaf
    constructor: (@pattern = "([A-Z]|[a-z]|_)([A-Z]|[a-z]|[0-9]|_)*") ->
    
    make: (pointer, value) ->
      return new dynamic.Symbol pointer, value
      
    parse: (source, parseStack) =>
      return doMatch source, @pattern, "", @, @make


# OptionalWhite
  
  OptionalWhite: class extends Leaf
    
    parse: (source, parseStack) =>
      match = source.match "\\s*"
      return new dynamic.OptionalWhite @

# RequiredWhite
 
  RequiredWhite: class extends Leaf
    
    make: (pointer, value) ->
      return new dynamic.RequiredWhite pointer
      
    parse: (source, parseStack) =>
      return doMatch source, "\\s*", "", @, @make

