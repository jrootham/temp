#
#   Leaf static classes for parsing and editing
#

dynamic = require "./dynamic-all"
linkable = require "./linkable"

#
# base class for leaves
#

class Leaf extends linkable.Linkable
  constructor: (linkid) ->
    super linkid

#
#  base class for leaves who store values in the static tree
#

class Value extends Leaf
  constructor: (linkid, @value) ->
    super linkid

#  A common matching function

doMatch = (next, source, pattern, flags, pointer, make) ->
  match = source.match pattern, flags
  if match
    result = make next, pointer, match
  else
    result = null
  return result
  
module.exports =

# Constant

  Constant: class extends Value
      
    parse: (next, source, parseStack) =>
      match = source.next(@value)
      if match
        result = new dynamic.Constant next.next(), @
      else
        result = null
      return result

# Match
          
  Match: class extends Leaf
    constructor: (linkid, @pattern, @flags) ->
      super linkid
    
    make:  (next, pointer, value) ->
      new dynamic.Match next.next(), pointer, value
      
    parse: (next, source, parseStack) =>
      return doMatch next, source, @pattern, @flags, @, @make

# Unsigned
  
  Unsigned: class extends Leaf
    constructor: (linkid) -> super linkid
    
    make: (next, pointer, value) ->
      new dynamic.Unsigned next.next(), pointer, value
      
    parse: (next, source, parseStack) =>
      return doMatch next, source, "[0-9]*", "", @, @make

# Integer
  
  Integer: class extends Leaf
    constructor: (linkid) -> super linkid
    
    make: (next, pointer, value) ->
      new dynamic.Integer next.next(), pointer, value
      
    parse: (next, source, parseStack) =>
      return doMatch next, source, "\-?[0-9]*", "", @, @make

# Fixed
  
  Fixed: class extends Leaf
    constructor: (linkid) -> super linkid
    
    make: (next, pointer, value) ->
      new dynamic.Fixed next.next(), pointer, value
      
    parse: (next, source, parseStack) =>
      return doMatch next, source, "-?[0-9]*(\\.[0-9]*)?", "", @, @make

# Float
  
  Float: class extends Leaf
    constructor: (linkid) -> super linkid
    
    make: (next, pointer, value) ->
      new dynamic.Float next.next(), pointer, value
      
    parse: (next, source, parseStack) =>
      pattern = "-?[0-9]*(\\.[0-9]*)?((e|E)-?[0-9]*)?"
      return doMatch next, source, pattern, "", @, @make


# FixedBCD
  
  FixedBCD: class extends Leaf
    constructor: (linkid) -> super linkid
    
    make: (next, pointer, value) ->
      new dynamic.FixedBCD next.next(), pointer, value
      
    parse: (next, source, parseStack) =>
      return doMatch next, source, "-?[0-9]*(\\.[0-9]*)?", "", @, @make


# StringType
  
  StringType: class extends Leaf
    constructor: (linkid) -> super linkid
    
    parse: (next, source, parseStack) =>
      return new dynamic.StringType next.next(), @, source.toEOL()

# SingleQuotes
  
  SingleQuotes: class extends Leaf
    constructor: (linkid) -> super linkid
    
    parse: (next, source, parseStack) =>
      matched = source.singleQuotes()
      if matched
        result = new dynamic.SingleQuotes next.next(), @, matched
      else
        result = null
      
      return result
      
# DoubleQuotes
  
  DoubleQuotes: class extends Leaf
    constructor: (linkid) -> super linkid
    
    parse: (next, source, parseStack) =>
      matched = source.doubleQuotes()
      if matched
        result = new dynamic.SingleQuotes next.next(), @, matched
      else
        result = null
      
      return result


# Symbol
  
  Symbol: class extends Leaf
    constructor: (linkid, @pattern = "([A-Z]|[a-z]|_)([A-Z]|[a-z]|[0-9]|_)*") ->
      super linkid
    
    make: (next, pointer, value) ->
      new dynamic.Symbol next.next(), pointer, value
      
    parse: (next, source, parseStack) =>
      return doMatch next, source, @pattern, "", @, @make


# OptionalWhite
  
  OptionalWhite: class extends Leaf
    constructor: (linkid, @whitespace) ->
      super linkid
      
    parse: (next, source, parseStack) =>
      match = source.match "\\s*"
      return new dynamic.OptionalWhite next.next(), @

# RequiredWhite
 
  RequiredWhite: class extends Leaf
    constructor: (linkid, @whitespace) -> super linkid
    
    make: (next, pointer, value) ->
      new dynamic.RequiredWhite next.next(), pointer
      
    parse: (next, source, parseStack) =>
      return doMatch next, source, "\\s*", "", @, @make

