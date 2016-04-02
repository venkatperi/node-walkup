var EventEmitter, Q, WalkUp, _, fs, glob, path,
  bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; },
  extend = function(child, parent) { for (var key in parent) { if (hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; },
  hasProp = {}.hasOwnProperty;

path = require('path');

fs = require('fs');

glob = require("glob");

_ = require("underscore");

EventEmitter = require("events").EventEmitter;

Q = require('q');

WalkUp = (function(superClass) {
  extend(WalkUp, superClass);

  Object.defineProperty(WalkUp.prototype, 'done', {
    get: function() {
      return this.defer.promise;
    }
  });

  function WalkUp(pattern, opts1, cb) {
    this.pattern = pattern;
    this.opts = opts1;
    this.cb = cb;
    this.abort = bind(this.abort, this);
    this.onDone = bind(this.onDone, this);
    this.onError = bind(this.onError, this);
    this.onMatch = bind(this.onMatch, this);
    this.visitor = bind(this.visitor, this);
    this.walk = bind(this.walk, this);
    this.results = [];
    this.defer = Q.defer();
    this.walk(this.opts.cwd);
  }

  WalkUp.prototype.walk = function(dir) {
    var opts;
    if (this.aborted || !_.isString(dir)) {
      return this.onDone();
    }
    opts = _.extend({}, this.opts, {
      cwd: dir,
      noglobstar: true,
      matchBase: false,
      nonull: false
    });
    return glob(this.pattern, opts, this.visitor(dir));
  };

  WalkUp.prototype.visitor = function(dir) {
    return (function(_this) {
      return function(err, files) {
        var parent;
        if (err != null) {
          return _this.onError(err);
        }
        if ((files != null) && !_.isEmpty(files)) {
          _this.onMatch(dir, files);
        }
        parent = path.dirname(dir);
        if ((parent === "" || parent === path.sep || parent === ".") || (_this.results.length >= _this.opts.maxResults)) {
          return _this.onDone();
        } else {
          return _this.walk(parent);
        }
      };
    })(this);
  };

  WalkUp.prototype.onMatch = function(dir, files) {
    var res;
    res = {
      dir: dir,
      files: files
    };
    this.results.push(res);
    return this.emit("match", res);
  };

  WalkUp.prototype.onError = function(err) {
    if (this.aborted) {
      return;
    }
    this.emit("error", err);
    if (this.cb != null) {
      this.cb(err);
    }
    return this.defer.reject(err);
  };

  WalkUp.prototype.onDone = function() {
    if (this.aborted) {
      return;
    }
    this.emit("end");
    if (this.cb != null) {
      this.cb(null, this.results);
    }
    return this.defer.resolve(this.results);
  };

  WalkUp.prototype.abort = function() {
    glob.abort();
    this.aborted = true;
    this.emit("aborted");
    return this.defer.reject(new Error("aborted by user"));
  };

  return WalkUp;

})(EventEmitter);

module.exports = WalkUp;
