#
#   Build a parse tree and confirm its structure
#

should = require("chai").should()

sp = require "../bin/static-parse"

describe "Test tree construction", ->

  u = new sp.Unsigned
  i = new sp.Integer
  f = new sp.Fixed
  l = new sp.Float
  b = new sp.FixedBCD
  s = new sp.StringType
  d = new sp.DoubleQuotes
  q = new sp.SingleQuotes
  y = new sp.Symbol
  m = new sp.Match "[a-z]"
  p = new sp.OptionalWhite
  r = new sp.RequiredWhite
  c = new sp.Constant "foo"
  
  pr = new sp.Parentheses u
  
  rp = new sp.Repeat i
  
  o1 = new sp.OrJoin pr, rp
  o2 = new sp.OrJoin f, l
  o3 = new sp.OrJoin b, s
  o4 = new sp.OrJoin d, q
  o5 = new sp.OrJoin y, m
  o6 = new sp.OrJoin p, r
  
  a1 = new sp.AndJoin c, o1
  a2 = new sp.AndJoin o2, o3
  a3 = new sp.AndJoin o4, o5
  a4 = new sp.AndJoin o6, a1
  
  a5 = new sp.AndJoin a1, a2
  a6 = new sp.AndJoin a3, a4
 
  root = new sp.AndJoin a5, a6

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
  
