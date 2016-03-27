should = require( "should" )
assert = require( "assert" )
walkup = require '..'
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
    walkup pattern, cwd : dir11, ( res ) ->
      res = fixPaths res
      assert.deepEqual res, require path.join( expectedDir, "#{pattern}.json" )
      done()


  it "another pattern", ( done ) ->
    pattern = "????????-????-????-????-????????????"
    walkup pattern, cwd : dir11, ( res ) ->
      res = fixPaths res
      res[ 0 ].files.length.should.equal 1
      res[ 1 ].files.length.should.equal 5
      res[ 2 ].files.length.should.equal 10
      done()


  it "limit to two levels", ( done ) ->
    pattern = "*.txt"
    walkup pattern, cwd : dir11, maxResults: 2, ( res ) ->
      res.length.should.equal 2
      done()

  it "limit to three levels", ( done ) ->
    pattern = "*.txt"
    walkup pattern, cwd : dir11, maxResults: 3, ( res ) ->
      res.length.should.equal 3
      done()



