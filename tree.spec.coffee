#
#   Build a parse tree and confirm its structure
#

should = require("chai").should()

sp = require "../bin/static-parse"
linkable = require "../bin/linkable"
next = new linkable.Next 0

describe "Test tree construction", ->
  
  u = new sp.Unsigned next.next()
  i = new sp.Integer next.next()
  f = new sp.Fixed next.next()
  l = new sp.Float next.next()
  b = new sp.FixedBCD next.next()
  s = new sp.StringType next.next()
  d = new sp.DoubleQuotes next.next()
  q = new sp.SingleQuotes next.next()
  y = new sp.Symbol next.next()
  m = new sp.Match next.next(), "[a-z]"
  p = new sp.OptionalWhite next.next()
  r = new sp.RequiredWhite next.next()
  c = new sp.Constant next.next(), "foo"
  
  pr = new sp.Parentheses next.next(), u
  
  rp = new sp.Repeat next.next(), i
  
  o1 = new sp.OrJoin next.next(), pr, rp
  o2 = new sp.OrJoin next.next(), f, l
  o3 = new sp.OrJoin next.next(), b, s
  o4 = new sp.OrJoin next.next(), d, q
  o5 = new sp.OrJoin next.next(), y, m
  o6 = new sp.OrJoin next.next(), p, r
  
  a1 = new sp.AndJoin next.next(), c, o1
  a2 = new sp.AndJoin next.next(), o2, o3
  a3 = new sp.AndJoin next.next(), o4, o5
  a4 = new sp.AndJoin next.next(), o6, a1
  
  a5 = new sp.AndJoin next.next(), a1, a2
  a6 = new sp.AndJoin next.next(), a3, a4
 
  root = new sp.AndJoin next.next(), a5, a6
  
  it "root is AndJoin", ->
    root.should.be.an.instanceof sp.AndJoin

  it "with left an AndJoin", ->
    left = root.left
    left.should.be.an.instanceof sp.AndJoin
    
  it "with left left an AndJoin", ->
    left = root.left
    left = left.left
    left.should.be.an.instanceof sp.AndJoin
  
  it "with left left left a Constant", ->
    left = root.left
    left = left.left
    constant = left.left
    constant.should.be.an.instanceof sp.Constant
  
  it "with value foo", ->
    left = root.left
    left = left.left
    constant = left.left
    constant.value.should.equal "foo"
  
  it "with left left right an OrJoin", ->
    left = root.left
    left = left.left
    orjoin = left.right
    orjoin.should.be.an.instanceof sp.OrJoin
  
  it "with left left right left a Parentheses", ->
    left = root.left
    left = left.left
    orjoin = left.right
    left = orjoin.left
    left.should.be.an.instanceof sp.Parentheses
  
  it "with left left right left argument an Usigned", ->
    left = root.left
    left = left.left
    orjoin = left.right
    left = orjoin.left
    argument = left.argument
    argument.should.be.an.instanceof sp.Unsigned
  
  it "with left left right right a Repeat", ->
    left = root.left
    left = left.left
    orjoin = left.right
    right = orjoin.right
    right.should.be.an.instanceof sp.Repeat
  
  it "with left left right right argument am Integer", ->
    left = root.left
    left = left.left
    orjoin = left.right
    right = orjoin.right
    argument = right.argument
    argument.should.be.an.instanceof sp.Integer
  
  it "with left right left left a Fixed", ->
    left = root.left
    right = left.right
    left = right.left
    left = left.left
    left.should.be.an.instanceof sp.Fixed
  
  it "with left right left right a Float", ->
    left = root.left
    right = left.right
    left = right.left
    right = left.right
    right.should.be.an.instanceof sp.Float
  
  it "with left right right left a FixedBCD", ->
    left = root.left
    right = left.right
    right = right.right
    left = right.left
    left.should.be.an.instanceof sp.FixedBCD
  
  it "with left right right right a StringType", ->
    left = root.left
    right = left.right
    right = right.right
    right = right.right
    right.should.be.an.instanceof sp.StringType
  
  it "with right left left left a DoubleQuotes", ->
    right = root.right
    left = right.left
    left = left.left
    left = left.left
    left.should.be.an.instanceof sp.DoubleQuotes
  
  it "with right left left right a SingleQuotes", ->
    right = root.right
    left = right.left
    left = left.left
    right = left.right
    right.should.be.an.instanceof sp.SingleQuotes
  
  it "with right left right left a Symbol", ->
    right = root.right
    left = right.left
    right = left.right
    left = right.left
    left.should.be.an.instanceof sp.Symbol
  
  it "with right left right right a Match", ->
    right = root.right
    left = right.left
    right = left.right
    right = right.right
    right.should.be.an.instanceof sp.Match
  
  it "with right right left left an OptionalWhite", ->
    right = root.right
    right = right.right
    left = right.left
    left = left.left
    left.should.be.an.instanceof sp.OptionalWhite
  
  it "with right right left right a RequiredWhite", ->
    right = root.right
    right = right.right
    left = right.left
    right = left.right
    right.should.be.an.instanceof sp.RequiredWhite
  
