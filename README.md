# WalkUp
  * Walks up a directory tree from a give subdirectory
  * Returns file names that match a pattern
  * Emits `match` as results are found

WalkUp uses the `glob` library to do it's pattern matching.

## Installation

Install with npm

```
npm install node-walkup
```

## Example

```javascript
var walkup = require("node-walkup")

options = {
  cwd: "/path/to/some/sub/dir/with/files"
}
walkup("*.json", options, function (err, matches) {
  // err is an error object or null.
  // matches is an array of objects
  //  [
  //    {
  //      dir: "/path/to/some/sub/dir/with/files",
  //      files: ["a.json"]
  //    },
  //    {
  //      dir: "/path/to/some/sub/dir/with",
  //      files: ["b.json", "c.json"]
  //    },
  //  ]
})
```


## walkup(pattern, options, cb)

* `pattern` `{String}` Pattern to be matched
* `options` `{Object}`
* `cb` `{Function(err, matches)}`
  * `err` `{Error | null}`
  * `matches` `{Array<Object>}` where `{Object}`
    * `dir`: `{String}` dir where match was found
    * `files`: `Array<String>` filenames found matching the pattern in that dir

Perform an asynchronous glob search. If no matching files are found, then an empty array is returned.

## Class: walkup.WalkUp

Create a WalkUp object by instantiating the `walkup.WalkUp` class.

```javascript
var WalkUp = require("walkup").WalkUp
var matches = new WalkUp(pattern, options, cb)
```

It's an EventEmitter, and starts walking up the dir tree to find matches
immediately.

### Events

* `end` When the matching is finished, this is emitted with all the
  matches found.
* `match` Every time a match is found, this is emitted with the specific
  thing that matched.
* `error` Emitted when an unexpected error is encountered, or whenever
  any fs error occurs if `options.strict` is set.
* `abort` When `abort()` is called, this event is raised.

### Methods

* `abort` Stop the search

### Options

All the options that can be passed to `glob` can also be passed to
WalkUp to change pattern matching behavior with a few exceptions where
such options are unsuitable for `walkup`. Also, some have been added,
or have walkup-specific ramifications.

All options are false by default, unless otherwise noted.

All options are added to the WalkUp object, as well.

* `cwd` The current working directory in which to search.  Defaults
  to `process.cwd()`.
See `glob` for a full list of options.


`Glob` options suppressed in `walkup`:
* `noglobstar` We're walking up a dir tree, so this is always set to false.
* `matchBase` Ditto.
* `nonull` Why not?



