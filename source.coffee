#
#		Source module
#
#   Deliver source text to the parser

module.exports = class Source
  constructor: (@text) ->

# current is the cursor

    @current =
      index: 0
      line: 1
      column: 1
    
    @stack = new Array     # Stack for save, restore


#
#  next matches a fixed string target
#  returns
#    success/fail
#  skips the string in the source text
#

  next: (target) =>
    length = target.length

    if target == @text.substr(@current.index, length)
      result = true
      @current.index += length
      @scanForNewlines target
    else
      result = false
    
    return result

#
#  match matches a regex
#   returns
#     success/fail
#     string matched
#   skips matched string
#

  match: (expression, flags="") =>
    
    tail = @text.substr @current.index
    regex = new RegExp "^"+expression, "m"+flags
    located = regex.exec(tail)
    
    if located
      matched = located[0]
      @scanForNewlines matched
      @current.index += matched.length
    else
      matched = null
      
    return matched
    
    
# getLocation returns the current line and column numbers

  getLocation: =>
    result =
      line: @current.line
      column: @current.column
      
    return result

# save saves the current location

  save: =>
    @stack.push(JSON.parse(JSON.stringify(@current)))
    
# restore restores a previously saved location
  
  restore: =>
    @current = @stack.pop()
    
# commit removes a previously saved location
  
  commit: =>
    @stack.pop()
    
#
#  update line and column, found is the string found by next or match
#  pass in @current to update
#

  scanForNewlines: (found)=>
    scanIndex = 0
    while -1 != (newIndex = found.indexOf("\n", scanIndex))
      scanIndex = newIndex + 1
      @current.line++
      @current.column = 1
      
    @current.column += found.length - scanIndex

