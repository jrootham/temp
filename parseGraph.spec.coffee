#
#   Build a parsing graph and parse input
#    validate the resulting graph
#

should = require("chai").should()

Source = require "../bin/source"
sp = require "../bin/static-parse"
linkable = require "../bin/linkable"
scaffold = require "./test.scaffold"

unique = scaffold.unique

next = new linkable.Next 0
dynext = new linkable.Next 0

parseStack = []

u = new sp.Unsigned next.next()
rw1 = new sp.RequiredWhite next.next(), "s"
a1 = new sp.AndJoin next.next(), u, rw1

i = new sp.Integer next.next()
rw2 = new sp.RequiredWhite next.next(), "s"
a2 = new sp.AndJoin next.next(), i, rw2

f = new sp.Fixed next.next()
rw3 = new sp.RequiredWhite next.next(), "s"
a3 = new sp.AndJoin next.next(), f, rw3

l = new sp.Float next.next()
rw4 = new sp.RequiredWhite next.next(), "s"
a4 = new sp.AndJoin next.next(), l, rw4

b = new sp.FixedBCD next.next()
rw5 = new sp.RequiredWhite next.next(), "s"
a5 = new sp.AndJoin next.next(), b, rw5

c = new sp.Constant next.next(), "foo"
p = new sp.OptionalWhite next.next(), ""
a6 = new sp.AndJoin next.next(), c, p

y = new sp.Symbol next.next()
rw7 = new sp.RequiredWhite next.next(), "s"
a7 = new sp.AndJoin next.next(), y, rw7

m = new sp.Match next.next(), "[a-z]"
s = new sp.StringType next.next()
a8 = new sp.AndJoin next.next(), m, s

d = new sp.DoubleQuotes next.next()
q = new sp.SingleQuotes next.next()
a9 = new sp.AndJoin next.next(), d, q

a11 = new sp.AndJoin next.next(), a1, a2
a12 = new sp.AndJoin next.next(), a3, a4
a13 = new sp.AndJoin next.next(), a5, a6
a14 = new sp.AndJoin next.next(), a7, a8

o1 = new sp.OrJoin next.next(), a11, a12
o2 = new sp.OrJoin next.next(), a13, a14
o3 = new sp.OrJoin next.next(), o1, o2

root = new sp.Repeat next.next(), o3

text = "123 -345 67.89 1.23e5 54.33 foo thing_1 "
text += "abcdef\n\"a string\"'another string'"

source = new Source text

describe "Test graph construction", ->
  parsed = root.parse dynext, source, parseStack

  it "The graph should be complete", ->
    parsed.isComplete().should.equal true
    
  it "the ids should be unique (throws if not)", ->
    parsed.preorder unique()
  
  it "there should be 4 items in the list", ->
    parsed.list.length.should.equal 4
  
  describe "the first", ->
    it "leftmost should be Unsigned", ->
      parsed.list[0].argument.argument.left.left.name.should.equal "Unsigned"
      
    it "leftmost value 123", ->
      parsed.list[0].argument.argument.left.left.value.should.equal 123
      
    it "the next item is RequiredWhite", ->
      name = parsed.list[0].argument.argument.left.right.name
      name.should.equal "RequiredWhite"
      
    it "after leftmost the insertion characters s", ->
      space = parsed.list[0].argument.argument.left.right.pointer.whitespace
      space.should.equal "s"
      
    it "rightmost should be Integer", ->
      parsed.list[0].argument.argument.right.left.name.should.equal "Integer"
      
    it "rightmost value -345", ->
      parsed.list[0].argument.argument.right.left.value.should.equal -345

  describe "the second", ->
    it "leftmost should be Fixed", ->
      parsed.list[1].argument.argument.left.left.name.should.equal "Fixed"
      
    it "leftmost value 67.89", ->
      parsed.list[1].argument.argument.left.left.value.should.equal 67.89
      
    it "rightmost should be Float", ->
      parsed.list[1].argument.argument.right.left.name.should.equal "Float"
      
    it "rightmost value 123000", ->
      parsed.list[1].argument.argument.right.left.value.should.equal 123000

  describe "the third", ->
    it "leftmost should be FixedBCD", ->
      parsed.list[2].argument.argument.left.left.name.should.equal "FixedBCD"
      
    it "leftmost value 54,33", ->
      parsed.list[2].argument.argument.left.left.value.should.equal 54.33
      
    it "the third rightmost should be Constant", ->
      parsed.list[2].argument.argument.right.left.name.should.equal "Constant"
      
    it "rightmost value foo", ->
      value = parsed.list[2].argument.argument.right.left.pointer.value
      value.should.equal "foo"

    it "trailing item is OptionalWhite", ->
      name = parsed.list[2].argument.argument.right.right.name
      name.should.equal "OptionalWhite"
      
    it "trailing item insertion characters none", ->
      space = parsed.list[2].argument.argument.right.right.pointer.whitespace
      space.should.equal ""

  describe "the fourth", ->
    it "the fourth leftmost should be Symbol", ->
      parsed.list[3].argument.argument.left.left.name.should.equal "Symbol"
      
    it "the fourth leftmost value thing_1", ->
      parsed.list[3].argument.argument.left.left.value.should.equal "thing_1"
      
    it "the fourth middle should be Match", ->
      parsed.list[3].argument.argument.right.left.name.should.equal "Match"
      
    it "fourth middle value a", ->
      parsed.list[3].argument.argument.right.left.value.should.equal "a"

    it "the fourth rightmost should be StringType", ->
      name = parsed.list[3].argument.argument.right.right.name
      name.should.equal "StringType"
      
    it "the fourth rightmost value bcdef", ->
      parsed.list[3].argument.argument.right.right.value.should.equal "bcdef"

