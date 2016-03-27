path = require( 'path' )
fs = require( 'fs' )
glob = require "glob"
_ = require "underscore"
EventEmitter = require( "events" ).EventEmitter

class WalkUp extends EventEmitter

  constructor : ( @pattern, @opts, @cb ) ->
    @results = []
    @walk @opts.cwd

  walk : ( dir ) =>
    return @onDone() if @aborted or !_.isString dir
    opts = _.extend {}, @opts, cwd : dir, noglobstar : true, matchBase: false, nonull: false
    glob @pattern, opts, @visitor( dir )

  visitor : ( dir ) => ( err, files ) =>
    return @onError err if err?

    @onMatch dir, files if files? && !_.isEmpty files

    parent = path.dirname dir
    if parent in [ "", path.sep, "." ] or (@results.length >= @opts.maxResults)
      @onDone()
    else
      @walk parent

  onMatch : ( dir, files ) =>
    res =
      dir : dir
      files : files
    @results.push res
    @emit "match", res

  onError : ( err ) =>
    return if @aborted
    @emit "error", err
    @cb err if @cb?

  onDone : =>
    return if @aborted
    @emit "end"
    @cb null, @results if @cb?

  abort : =>
    glob.abort()
    @aborted = true
    @emit "aborted"

module.exports = WalkUp
