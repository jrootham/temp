#
#   Build a parsing graph and parse input
#    validate the resulting graph
#

should = require("chai").should()

Source = require "../bin/source"
sp = require "../bin/static-parse"
linkable = require "../bin/linkable"
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
p = new sp.OptionalWhite next.next(), "s"
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

parsed = root.parse dynext, source, parseStack

console.log parsed.displayGraph ""

describe "Test graph construction", ->
  it "The graph should be complete", ->
    parsed.complete.should.equal true
    
 
  
