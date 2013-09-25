#
#   dynamic branching classes for parsing and editing
#

#
#  Base classes
#

Dynamic = require "./dynamic"

Monadic = class extends Dynamic
  constructor: (linkid, pointer, @argument) ->
    super linkid, pointer
       
Dyadic = class extends Dynamic
  constructor: (linkid, pointer, @left, @right) ->
    super linkid, pointer
    
    
module.exports =
#
#   Define a repetition in the parse tree
#
  Repeat: class extends Dynamic
    constructor: (linkid, pointer)->
      super linkid, pointer
      @list = []

    name: "Repeat"

    add: (item) =>
      @list.push item
      
    isComplete: =>
      result = true
      
      for item in @list
        result = result && item.isComplete()
      
      return result
      
    displayGraph: (indent) ->
      result = indent + @name + "\n"
      for item in @list
        if item
          result += item.displayGraph indent + "  "
        else
          result += indent + "  " + "item is null\n"
    
      return result

    preorder: (fn) ->
      fn @
      for item in @list
        item.preorder fn

#
#  define a concatenation in the parse tree
#
  AndJoin: class extends Dyadic
  
    name: "AndJoin"

    isComplete: ->
      return @left.isComplete() && @right.isComplete()

    displayGraph: (indent) ->
      result =indent + @name + "\n"
      if @left
        result += @left.displayGraph indent + "  "
      else
        result += indent + "  " + "left is null\n"

      if @right
        result += @right.displayGraph indent + "  "
      else
        result += indent + "  " + "left is null\n"
      return result

    preorder: (fn) ->
      @left.preorder fn
      fn @
      @right.preorder fn
    
#
#  define a choice point in the parse tree
#

  OrJoin: class extends Monadic

    name: "OrJoin"

    displayGraph: (indent) ->
      result =indent + @name + "\n"
      if @argument
        result += @argument.displayGraph indent + "  "
      else
        result += indent + "  " + "argument is null\n"

    isComplete: ->
      @argument.isComplete()

    preorder: (fn) ->
      fn @
      @argument.preorder fn

