#
#   dynamic branching classes for parsing and editing
#

#
#  Base classes
#
 
Monadic = class
  constructor: (@argument) ->
  
Dyadic = class
  constructor: (@left, @right) ->

    
module.exports =
#
#   Define parentheses in the parse tree
#
  Parentheses: class extends Monadic
 
#
#   Define a repetition in the parse tree
#
  Repeat: class extends Monadic

#
#  define a concatenation in the parse tree
#
  AndJoin: class extends Dyadic
  
#
#  define a choice point in the parse tree
#

  OrJoin: class extends Monadic

