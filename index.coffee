WalkUp = require "./lib/WalkUp"

walkup = ( params, opts, cb ) ->
  new WalkUp params, opts, cb

walkup.WalkUp = WalkUp

module.exports = walkup
  
  