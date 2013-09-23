#
#   static branching classes for parsing and editing
#

dy = require "./dynamic-all"
linkable = require "./linkable"

#
#  Base classes
#
 
#  For single arguments

Monadic = class extends linkable.Linkable
  constructor: (linkid, @argument) ->
    super linkid

  preorder: (fn) ->
    fn @
    @argument.preorder fn
    
  inorder: (fn) ->
    fn @
    @argument.inorder fn
    
  postorder: (fn) ->
    @argument.postorder fn
    fn @

  displayGraph: (indent) ->
    result =indent + @name + "\n"
    if @argument
      result += @argument.displayGraph indent + "  "
    else
      result += indent + "  " + "null pointer\n"

    return result
       
#  For 2 arguments
    
Dyadic = class extends linkable.Linkable
  constructor: (linkid, @left, @right) ->
    super linkid

  preorder: (fn) ->
    fn @
    @left.preorder fn
    @right.preorder fn

  inorder: (fn) ->
    @left.inorder fn
    fn @
    @right.inorder fn

  postorder: (fn) ->
    @left.postorder fn
    @right.postorder fn
    fn @

  displayGraph: (indent) ->
    result = indent + @name + "\n"
    
    if @left
      result += @left.displayGraph indent + "  "
    else
      result += indent + "  " + "null left pointer\n"
    
    if @right
      result += @right.displayGraph indent + "  "
    else
      result += indent + "  " + "null right pointer\n"
    
    return result
#
#  utility classes
#

ParseSave = class
  constructor: ->
    @list = []
    
  restore: =>
    item.restore for item in @list

  add: (item) =>
    @list.push item
    
  merge: (other) =>
    this.add for item in other.list
    
# Utility function that commits to a parse choice

commit = (source, parseStack) ->
  source.commit()
  current = parseStack.pop()
  
  if parseStack.length > 0
    parseStack[parseStack.length - 1].merge current

# Utility function that saves a parse choice

save = (source, parseStack) ->
  source.save()
  parseStack.push new ParseSave()

# Utility function that restores to a saved parse choice

restore = (source, parseStack) ->
  source.restore()
  (parseStack.pop()).restore()

module.exports =
#
#   Define a repetition in the parse tree
#
  Repeat: class extends Monadic

    name: "Repeat"
    
    parse: (next, source, parseStack) =>
      result = new dy.Repeat next.next(), @
      
      save source, parseStack
      
      while item = @argument.parse next, source, parseStack
        result.add item
        commit source, parseStack
        save source, parseStack
        
      restore source, parseStack
      
      return result

#
#  define a concatenation in the parse tree
#
  AndJoin: class extends Dyadic
  
    name: "AndJoin"

    parse: (next, source, parseStack) =>
      save source, parseStack

      leftParse = @left.parse next, source, parseStack
      rightParse = @right.parse next, source, parseStack
      if leftParse && rightParse
        result = new dy.AndJoin next.next(), @, leftParse, rightParse
        commit source, parseStack
      else
        result = null
        restore source, parseStack
        
      return result

#
#  define a choice point in the parse tree
#

  OrJoin: class extends Dyadic

#  parsing function
    
    name: "OrJoin"

    parse: (next, source, parseStack) =>
      save source, parseStack
            
      descendent = @left.parse next, source, parseStack
      
      if ! descendent
        restore source, parseStack
        save source, parseStack
        descendent = @right.parse next, source, parseStack
          
      if descendent
        commit source, parseStack
        result = new dy.OrJoin next.next(), @, descendent
      else
        restore source, parseStack
        result = null
        
      return result

