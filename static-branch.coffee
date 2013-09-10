#
#   static branching classes for parsing and editing
#

dy = require "./dynamic"

#
#  Base classes
#
 
Monadic = class
  constructor: (@argument) ->
  
Dyadic = class
  constructor: (@left, @right) ->

#
#  utility classes
#

ParseSave = class
  constructor: ->
    @list = []
    
  restore: =>
    restore for item in @list

  add: (item) =>
    @list.push item
    
  merge: (other) =>
    this.add for item in other.list
    
module.exports =
#
#   Define parentheses in the parse tree
#
  Parentheses: class extends Monadic
 
  parse: (source, parseStack) =>
    return new dy.Parentheses @argument.parse(source, parseStack)
     
#
#   Define a repetition in the parse tree
#
  Repeat: class extends Monadic

    parse: (source, parseStack) =>
      return new dy.Repeat @argument.parse(source, parseStack)
    
#
#  define a concatenation in the parse tree
#
  AndJoin: class extends Dyadic
  
    parse: (source, parseStack) =>
      leftParse = @left.parse source, parseStack
      rightParse = @right.parse source, parseStack
      return new dy.AndJoin leftParse, rightParse
 
#
#  define a choice point in the parse tree
#

  OrJoin: class extends Dyadic

# Utility function that commits to a parse choice

    commit = (source, parseStack) ->
      source.commit
      current = parseStack.pop()
      
      if parseStack.length > 0
        parseStack[parseStack.length].merge current

#  parsing function
    
    parse: (source, parseStack) =>
      source.save
      parseStack.push new ParseSave
      
      result = @left.parse source, parseStack
      
      if result
        commit source, parseStack
        
      else
        source.restore
        parseStack.pop().restore
           
        result = @right.parse source, parseStack
          
      return result
      
