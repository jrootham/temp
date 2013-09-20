#
#   static branching classes for parsing and editing
#

dy = require "./dynamic-all"
linkable = require "./linkable"

#
#  Base classes
#
 
Monadic = class extends linkable.Linkable
  constructor: (linkid, @argument) ->
    super linkid
    
Dyadic = class extends linkable.Linkable
  constructor: (linkid, @left, @right) ->
    super linkid
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
 
  parse: (next, source, parseStack) =>
    descendent = @argument.parse next, source, parseStack
    
    if descendent
      result = new dy.Parentheses next.next(), @, descendent
    else
      result = null
     
#
#   Define a repetition in the parse tree
#
  Repeat: class extends Monadic

    parse: (next, source, parseStack) =>
      result = new dy.Repeat next.next(), @
      
      while item = @argument.parse next, source, parseStack
        result.add item
        
      return result
#
#  define a concatenation in the parse tree
#
  AndJoin: class extends Dyadic
  
    parse: (next, source, parseStack) =>
      leftParse = @left.parse next, source, parseStack
      rightParse = @right.parse next, source, parseStack
      if leftParse && rightParse
        result = new dy.AndJoin next.next(), @, leftParse, rightParse
      else
        result = null
        
      return result
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
    
    parse: (next, source, parseStack) =>
      source.save
      parseStack.push new ParseSave
      
      descendent = @left.parse next, source, parseStack
      
      if ! descendent
        source.restore
        parseStack.pop().restore
           
        descendent = @right.parse next, source, parseStack
          
      if descendent
        commit source, parseStack
        result = new dy.OrJoin next.next(), @, descendent
      else
        source.restore
        parseStack.pop().restore
        result = null
        
      return result
      
