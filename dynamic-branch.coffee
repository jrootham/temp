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
#   Define parentheses in the parse tree
#
  Parentheses: class extends Monadic

    isComplete: -> @argument.isComplete()
 
#
#   Define a repetition in the parse tree
#
  Repeat: class extends Dynamic
    constructor: (linkid, pointer)->
      super linkid, pointer
      @list = []

  add: (item) =>
    @list.push item
    
  isComplete: ->
    result = true
    result &= item.isComplete for item in list

#
#  define a concatenation in the parse tree
#
  AndJoin: class extends Dyadic
  
    isComplete: ->
      @left.isComplete() && @right.isComplete()

#
#  define a choice point in the parse tree
#

  OrJoin: class extends Monadic

    isComplete: ->
      @left.isComplete() || @right.isComplete()

