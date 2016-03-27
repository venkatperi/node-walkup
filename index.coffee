###
  Walks up a folder tree and for each level, returns filenames that match a given pattern
###
WalkUp = require "./lib/WalkUp"

walkup = ( params, opts, cb ) ->
  new WalkUp params, opts, cb

walkup.WalkUp = WalkUp

module.exports = walkup
  
  