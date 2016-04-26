###
  Walks up a folder tree and for each level, returns filenames that match a given pattern
###
WalkUp = require "./lib/walkUp"

walkup = ( params, opts, cb ) ->
  w = new WalkUp params, opts, cb
  w.done

walkup.WalkUp = WalkUp

module.exports = walkup


