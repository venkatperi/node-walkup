should = require( "should" )
assert = require( "assert" )
walkup = require '../index'
path = require "path"

fixturesDir = path.join __dirname, "fixtures"
expectedDir = path.join __dirname, "expected"
dir11 = path.join __dirname, "fixtures", "dir1", "dir11"

relativePath = ( p ) -> p[ __dirname.length + 1..-1 ]

fixPaths = ( list ) ->
  for item in list
    dir : relativePath item.dir
    files : item.files


describe "walkup", ->

  it "walks up the dir tree looking for a given pattern", ( done ) ->
    pattern = "10108158-0ca9-4570-b451-804777df1eef"
    walkup pattern, cwd : dir11, ( err, res ) ->
      res = fixPaths res
      assert.deepEqual res, require path.join( expectedDir, "#{pattern}.json" )
      done()

  it "resolves a promise", ( done ) ->
    pattern = "10108158-0ca9-4570-b451-804777df1eef"
    walkup( pattern, cwd : dir11 )
    .then ( res ) ->
      res = fixPaths res
      assert.deepEqual res, require path.join( expectedDir, "#{pattern}.json" )
      done()
    .fail done


  it "another pattern", ( done ) ->
    pattern = "????????-????-????-????-????????????"
    walkup pattern, cwd : dir11, ( err, res ) ->
      res = fixPaths res
      res[ 0 ].files.length.should.equal 1
      res[ 1 ].files.length.should.equal 5
      res[ 2 ].files.length.should.equal 10
      done()


  it "limit to two levels", ( done ) ->
    pattern = "*.txt"
    walkup pattern, cwd : dir11, maxResults : 2, ( err, res ) ->
      res.length.should.equal 2
      done()

  it "limit to three levels", ( done ) ->
    pattern = "*.txt"
    walkup pattern, cwd : dir11, maxResults : 3, ( err, res ) ->
      res.length.should.equal 3
      done()

  it "returns an empty array no match", ( done ) ->
    pattern = "*.blah"
    walkup pattern, cwd : dir11, ( err, res ) ->
      res.length.should.equal 0
      done()

  it "bad dir", ( done ) ->
    pattern = "*.blah"
    walkup pattern, cwd : "/*blah", ( err, res ) ->
      res.length.should.equal 0
      done()

  it "match event", ( done ) ->
    pattern = "*.txt"
    w = new walkup.WalkUp pattern, maxResults : 1, cwd : dir11
    w.on "match", ( match ) ->
      assert.notEqual match.dir, undefined
      done()

  it "end event", ( done ) ->
    pattern = "*.txt"
    w = new walkup.WalkUp pattern, cwd : dir11
    w.on "end", ( matches ) ->
      done()



