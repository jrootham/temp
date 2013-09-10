#
#  test parsing classes
#

should = require("chai").should()

sp = require "../bin/static-parse"
Source = require "../bin/source"

describe "Test parsing classes", ->
  describe "Test Constant", ->
    source = new Source "foobar"
    parser = new sp.Constant "foo"
    first = parser.parse source
    second = parser.parse source
    
    it "first should be complete", ->
      first.isComplete().should.be.true
      
    it "first should point at the parser", ->
      first.pointer.should.equal parser

    it "second should be null", ->
      should.equal second, null
      
  describe "Test Unsigned", ->
    source = new Source "123bar-345"
    parser = new sp.Unsigned
    first = parser.parse source
    second = parser.parse source
    
    it "first should be complete", ->
      first.isComplete().should.be.true
      
    it "first should point at the parser", ->
      first.pointer.should.equal parser

    it "first value should be 123", ->
      first.value.should.equal 123
      
    it "second should be null", ->
      should.equal second, null
      
  describe "Test Integer", ->
    source = new Source "123bar-345"
    parser = new sp.Integer
    first = parser.parse source
    second = parser.parse source
    other = new sp.Constant "bar"
    other.parse source
    third = parser.parse source
    
    it "first should be complete", ->
      first.isComplete().should.be.true
      
    it "first should point at the parser", ->
      first.pointer.should.equal parser

    it "first value should be 123", ->
      first.value.should.equal 123
      
    it "second should be null", ->
      should.equal second, null

    it "third value should be -345", ->
      third.value.should.equal -345
          
  describe "Test Fixed", ->
    source = new Source "123.34bar-345.bar567"
    parser = new sp.Fixed
    first = parser.parse source
    second = parser.parse source
    other = new sp.Constant "bar"
    other.parse source
    third = parser.parse source
    other.parse source
    fourth = parser.parse source
    
    it "first should be complete", ->
      first.isComplete().should.be.true
      
    it "first should point at the parser", ->
      first.pointer.should.equal parser

    it "first value should be 123.34", ->
      first.value.should.equal 123.34
      
    it "second should be null", ->
      should.equal second, null

    it "third value should be -345", ->
      third.value.should.equal -345
      
    it "fourth value should be 567", ->
      fourth.value.should.equal 567
      


