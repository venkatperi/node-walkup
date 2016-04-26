
/*
  Walks up a folder tree and for each level, returns filenames that match a given pattern
 */
var WalkUp, walkup;

WalkUp = require("./lib/walkup");

walkup = function(params, opts, cb) {
  var w;
  w = new WalkUp(params, opts, cb);
  return w.done;
};

walkup.WalkUp = WalkUp;

module.exports = walkup;
