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
    return unless _.isString dir

    opts = _.extend {}, @opts, cwd : dir, noglobstar : true

    glob @pattern, opts, ( err, res ) =>
      if !err and !_.isEmpty res
        @results.push dir : dir, files : res
        @emit "files", res
      parent = path.dirname dir
      if parent in [ "", path.sep, "." ] or (@results.length >= @opts.maxResults)
        return @cb( @results )
        @emit "done"
      @walk parent

module.exports = WalkUp
