# tests for Source

should = require("chai").should()

Source = require "../bin/source"

describe "Testing source object", ->
  describe "Simple starting tests", ->
    source = new Source "foobar"
    
    describe "should start at the beginning", ->

      it "line should not move", ->
        {line, column} = source.getLocation()
        line.should.equal 1

      it "column should not move", ->
        {line, column} = source.getLocation()
        column.should.equal 1
      
  describe "Simple next tests", ->
    source = new Source "foobar"

    it "should succeed in getting starting string", ->
      source.next("foo").should.equal true
    
    it "should skip starting string ", ->
      source.next("foo").should.equal false
    
    it "should fail in getting a too long string", ->
      source.next("baroo").should.equal false
    
    it "should succeed in getting next string", ->
      source.next("bar").should.equal true
    

  describe "Simple moving tests", ->
    source = new Source "foobar"
    source.next "foo"
    {line, column} = source.getLocation()
      
    it "line should not move", ->
      line.should.equal 1
      
    it "column should move", ->
      column.should.equal 4
    
  describe "should not move on fail", ->
    source = new Source "foobar"
    source.next "foo"
    source.next "foo"
    {line, column} = source.getLocation()
      
    it "line should not move", ->
      line.should.equal 1
      
    it "column should not move", ->
      column.should.equal 4
    
  describe "Simple match tests", ->
    source = new Source "foobar"

    describe "should succeed in getting starting string", ->
      match = source.match("f[a-z]o")
      it "should return the matched string", ->
        match.should.equal "foo"

      {line, column} = source.getLocation()
      
      it "line should not move", ->
        line.should.equal 1
      it "column should move", ->
        column.should.equal 4
    
  describe "Moving match tests", ->
    source = new Source "foobar"
    match = source.match("f[a-z]o")

    describe "should move past starting string", ->
      it "should skip starting string ", ->
        match = source.match("f[a-z]o")
        should.equal match, null
      
    describe "should move past starting string", ->
      {line, column} = source.getLocation()
      it "line should not move", ->
        line.should.equal 1
      it "column should not move", ->
        column.should.equal 4
    
  describe "More moving match tests", ->
    source = new Source "foobar"
    match = source.match("f[a-z]o")

    describe "should succeed in getting next string", ->
      match = source.match("ba[a-z]")
      it "should return the matched string", ->
        match.should.equal "bar"

    describe "should move past starting string", ->
      {line, column} = source.getLocation()
      
      it "line should not move", ->
        line.should.equal 1
      
      it "column should move", ->
        column.should.equal 7

  describe "Save/restore tests", ->
    source = new Source "foobar"
    source.save()
    match = source.next "foo"
    source.restore()
    
    {line, column} = source.getLocation()
    
    it "line should not move", ->
      line.should.equal 1
    
    it "column should revert", ->
      column.should.equal 1
      
  describe "Counting lines tests", ->
    source = new Source "foo\nbar\n\nhoowawdiddy\nthe end"
    match = source.next "foo\nbar"
    
    describe "getting first", ->
      {line, column} = source.getLocation()
      
      it "line should move", ->
        line.should.equal 2
      
      it "column should move", ->
        column.should.equal 4

    match = source.match "\\s*"
    
    describe "getting second", ->
      {line, column} = source.getLocation()
      
      it "line should move", ->
        line.should.equal 4
      
      it "column should move", ->
        column.should.equal 1
          
    match = source.match "\\w*"
    
    describe "getting third", ->
      {line, column} = source.getLocation()
      
      it "line should move", ->
        line.should.equal 4
      
      it "column should move", ->
        column.should.equal 12
          
    match = source.match "\\sthe"
    
    describe "getting fourth", ->
      {line, column} = source.getLocation()
      
      it "line should move", ->
        line.should.equal 5
      
      it "column should move", ->
        column.should.equal 4
        
  describe "Matching with flags", ->
    source = new Source "FOOBAR"
    match = source.match "foo", "i"

    it "Should find a match", ->
      match.should.equal "FOO"
      
  describe "Restore should remove a save", ->
    source = new Source "FOOBAR"
    source.save()
    match = source.match "foo", "i"
    source.save()
    match = source.match "bar", "i"
    source.commit()
    source.restore()

    {line, column} = source.getLocation()
    
    describe "getting saved state", ->
      {line, column} = source.getLocation()
      it "line should not move", ->
        line.should.equal 1
      
      it "column should not move", ->
        column.should.equal 1


