(function(){var require = function (file, cwd) {
    var resolved = require.resolve(file, cwd || '/');
    var mod = require.modules[resolved];
    if (!mod) throw new Error(
        'Failed to resolve module ' + file + ', tried ' + resolved
    );
    var cached = require.cache[resolved];
    var res = cached? cached.exports : mod();
    return res;
};

require.paths = [];
require.modules = {};
require.cache = {};
require.extensions = [".js",".coffee",".json"];

require._core = {
    'assert': true,
    'events': true,
    'fs': true,
    'path': true,
    'vm': true
};

require.resolve = (function () {
    return function (x, cwd) {
        if (!cwd) cwd = '/';
        
        if (require._core[x]) return x;
        var path = require.modules.path();
        cwd = path.resolve('/', cwd);
        var y = cwd || '/';
        
        if (x.match(/^(?:\.\.?\/|\/)/)) {
            var m = loadAsFileSync(path.resolve(y, x))
                || loadAsDirectorySync(path.resolve(y, x));
            if (m) return m;
        }
        
        var n = loadNodeModulesSync(x, y);
        if (n) return n;
        
        throw new Error("Cannot find module '" + x + "'");
        
        function loadAsFileSync (x) {
            x = path.normalize(x);
            if (require.modules[x]) {
                return x;
            }
            
            for (var i = 0; i < require.extensions.length; i++) {
                var ext = require.extensions[i];
                if (require.modules[x + ext]) return x + ext;
            }
        }
        
        function loadAsDirectorySync (x) {
            x = x.replace(/\/+$/, '');
            var pkgfile = path.normalize(x + '/package.json');
            if (require.modules[pkgfile]) {
                var pkg = require.modules[pkgfile]();
                var b = pkg.browserify;
                if (typeof b === 'object' && b.main) {
                    var m = loadAsFileSync(path.resolve(x, b.main));
                    if (m) return m;
                }
                else if (typeof b === 'string') {
                    var m = loadAsFileSync(path.resolve(x, b));
                    if (m) return m;
                }
                else if (pkg.main) {
                    var m = loadAsFileSync(path.resolve(x, pkg.main));
                    if (m) return m;
                }
            }
            
            return loadAsFileSync(x + '/index');
        }
        
        function loadNodeModulesSync (x, start) {
            var dirs = nodeModulesPathsSync(start);
            for (var i = 0; i < dirs.length; i++) {
                var dir = dirs[i];
                var m = loadAsFileSync(dir + '/' + x);
                if (m) return m;
                var n = loadAsDirectorySync(dir + '/' + x);
                if (n) return n;
            }
            
            var m = loadAsFileSync(x);
            if (m) return m;
        }
        
        function nodeModulesPathsSync (start) {
            var parts;
            if (start === '/') parts = [ '' ];
            else parts = path.normalize(start).split('/');
            
            var dirs = [];
            for (var i = parts.length - 1; i >= 0; i--) {
                if (parts[i] === 'node_modules') continue;
                var dir = parts.slice(0, i + 1).join('/') + '/node_modules';
                dirs.push(dir);
            }
            
            return dirs;
        }
    };
})();

require.alias = function (from, to) {
    var path = require.modules.path();
    var res = null;
    try {
        res = require.resolve(from + '/package.json', '/');
    }
    catch (err) {
        res = require.resolve(from, '/');
    }
    var basedir = path.dirname(res);
    
    var keys = (Object.keys || function (obj) {
        var res = [];
        for (var key in obj) res.push(key);
        return res;
    })(require.modules);
    
    for (var i = 0; i < keys.length; i++) {
        var key = keys[i];
        if (key.slice(0, basedir.length + 1) === basedir + '/') {
            var f = key.slice(basedir.length);
            require.modules[to + f] = require.modules[basedir + f];
        }
        else if (key === basedir) {
            require.modules[to] = require.modules[basedir];
        }
    }
};

(function () {
    var process = {};
    var global = typeof window !== 'undefined' ? window : {};
    var definedProcess = false;
    
    require.define = function (filename, fn) {
        if (!definedProcess && require.modules.__browserify_process) {
            process = require.modules.__browserify_process();
            definedProcess = true;
        }
        
        var dirname = require._core[filename]
            ? ''
            : require.modules.path().dirname(filename)
        ;
        
        var require_ = function (file) {
            var requiredModule = require(file, dirname);
            var cached = require.cache[require.resolve(file, dirname)];

            if (cached && cached.parent === null) {
                cached.parent = module_;
            }

            return requiredModule;
        };
        require_.resolve = function (name) {
            return require.resolve(name, dirname);
        };
        require_.modules = require.modules;
        require_.define = require.define;
        require_.cache = require.cache;
        var module_ = {
            id : filename,
            filename: filename,
            exports : {},
            loaded : false,
            parent: null
        };
        
        require.modules[filename] = function () {
            require.cache[filename] = module_;
            fn.call(
                module_.exports,
                require_,
                module_,
                module_.exports,
                dirname,
                filename,
                process,
                global
            );
            module_.loaded = true;
            return module_.exports;
        };
    };
})();


require.define("path",Function(['require','module','exports','__dirname','__filename','process','global'],"function filter (xs, fn) {\n    var res = [];\n    for (var i = 0; i < xs.length; i++) {\n        if (fn(xs[i], i, xs)) res.push(xs[i]);\n    }\n    return res;\n}\n\n// resolves . and .. elements in a path array with directory names there\n// must be no slashes, empty elements, or device names (c:\\) in the array\n// (so also no leading and trailing slashes - it does not distinguish\n// relative and absolute paths)\nfunction normalizeArray(parts, allowAboveRoot) {\n  // if the path tries to go above the root, `up` ends up > 0\n  var up = 0;\n  for (var i = parts.length; i >= 0; i--) {\n    var last = parts[i];\n    if (last == '.') {\n      parts.splice(i, 1);\n    } else if (last === '..') {\n      parts.splice(i, 1);\n      up++;\n    } else if (up) {\n      parts.splice(i, 1);\n      up--;\n    }\n  }\n\n  // if the path is allowed to go above the root, restore leading ..s\n  if (allowAboveRoot) {\n    for (; up--; up) {\n      parts.unshift('..');\n    }\n  }\n\n  return parts;\n}\n\n// Regex to split a filename into [*, dir, basename, ext]\n// posix version\nvar splitPathRe = /^(.+\\/(?!$)|\\/)?((?:.+?)?(\\.[^.]*)?)$/;\n\n// path.resolve([from ...], to)\n// posix version\nexports.resolve = function() {\nvar resolvedPath = '',\n    resolvedAbsolute = false;\n\nfor (var i = arguments.length; i >= -1 && !resolvedAbsolute; i--) {\n  var path = (i >= 0)\n      ? arguments[i]\n      : process.cwd();\n\n  // Skip empty and invalid entries\n  if (typeof path !== 'string' || !path) {\n    continue;\n  }\n\n  resolvedPath = path + '/' + resolvedPath;\n  resolvedAbsolute = path.charAt(0) === '/';\n}\n\n// At this point the path should be resolved to a full absolute path, but\n// handle relative paths to be safe (might happen when process.cwd() fails)\n\n// Normalize the path\nresolvedPath = normalizeArray(filter(resolvedPath.split('/'), function(p) {\n    return !!p;\n  }), !resolvedAbsolute).join('/');\n\n  return ((resolvedAbsolute ? '/' : '') + resolvedPath) || '.';\n};\n\n// path.normalize(path)\n// posix version\nexports.normalize = function(path) {\nvar isAbsolute = path.charAt(0) === '/',\n    trailingSlash = path.slice(-1) === '/';\n\n// Normalize the path\npath = normalizeArray(filter(path.split('/'), function(p) {\n    return !!p;\n  }), !isAbsolute).join('/');\n\n  if (!path && !isAbsolute) {\n    path = '.';\n  }\n  if (path && trailingSlash) {\n    path += '/';\n  }\n  \n  return (isAbsolute ? '/' : '') + path;\n};\n\n\n// posix version\nexports.join = function() {\n  var paths = Array.prototype.slice.call(arguments, 0);\n  return exports.normalize(filter(paths, function(p, index) {\n    return p && typeof p === 'string';\n  }).join('/'));\n};\n\n\nexports.dirname = function(path) {\n  var dir = splitPathRe.exec(path)[1] || '';\n  var isWindows = false;\n  if (!dir) {\n    // No dirname\n    return '.';\n  } else if (dir.length === 1 ||\n      (isWindows && dir.length <= 3 && dir.charAt(1) === ':')) {\n    // It is just a slash or a drive letter with a slash\n    return dir;\n  } else {\n    // It is a full dirname, strip trailing slash\n    return dir.substring(0, dir.length - 1);\n  }\n};\n\n\nexports.basename = function(path, ext) {\n  var f = splitPathRe.exec(path)[2] || '';\n  // TODO: make this comparison case-insensitive on windows?\n  if (ext && f.substr(-1 * ext.length) === ext) {\n    f = f.substr(0, f.length - ext.length);\n  }\n  return f;\n};\n\n\nexports.extname = function(path) {\n  return splitPathRe.exec(path)[3] || '';\n};\n\n//@ sourceURL=path"
));

require.define("__browserify_process",Function(['require','module','exports','__dirname','__filename','process','global'],"var process = module.exports = {};\n\nprocess.nextTick = (function () {\n    var canSetImmediate = typeof window !== 'undefined'\n        && window.setImmediate;\n    var canPost = typeof window !== 'undefined'\n        && window.postMessage && window.addEventListener\n    ;\n\n    if (canSetImmediate) {\n        return function (f) { return window.setImmediate(f) };\n    }\n\n    if (canPost) {\n        var queue = [];\n        window.addEventListener('message', function (ev) {\n            if (ev.source === window && ev.data === 'browserify-tick') {\n                ev.stopPropagation();\n                if (queue.length > 0) {\n                    var fn = queue.shift();\n                    fn();\n                }\n            }\n        }, true);\n\n        return function nextTick(fn) {\n            queue.push(fn);\n            window.postMessage('browserify-tick', '*');\n        };\n    }\n\n    return function nextTick(fn) {\n        setTimeout(fn, 0);\n    };\n})();\n\nprocess.title = 'browser';\nprocess.browser = true;\nprocess.env = {};\nprocess.argv = [];\n\nprocess.binding = function (name) {\n    if (name === 'evals') return (require)('vm')\n    else throw new Error('No such module. (Possibly not yet loaded)')\n};\n\n(function () {\n    var cwd = '/';\n    var path;\n    process.cwd = function () { return cwd };\n    process.chdir = function (dir) {\n        if (!path) path = require('path');\n        cwd = path.resolve(dir, cwd);\n    };\n})();\n\n//@ sourceURL=__browserify_process"
));

require.define("/node_modules/keypad/lib/Keypad.js",Function(['require','module','exports','__dirname','__filename','process','global'],"// Generated by CoffeeScript 1.8.0\n\n/**\n\t@module Keypad\n\t@author muchweb\n */\n\n(function() {\n  'use strict';\n  var EventEmitter,\n    __hasProp = {}.hasOwnProperty,\n    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };\n\n  EventEmitter = require('events').EventEmitter;\n\n  exports.Keypad = (function(_super) {\n    __extends(_Class, _super);\n\n\n    /**\n    \t\tName of selected map\n    \t\t@property map_name\n    \t\t@type String\n    \t\t@default 'nokia'\n     */\n\n    _Class.prototype.map_name = 'nokia';\n\n\n    /**\n    \t\tInput language\n    \t\t@property map_language\n    \t\t@type String\n    \t\t@default 'en'\n     */\n\n    _Class.prototype.map_language = 'en';\n\n\n    /**\n    \t\tFull typed in text\n    \t\t@property text\n    \t\t@type String\n    \t\t@default ''\n     */\n\n    _Class.prototype.text = '';\n\n\n    /**\n    \t\tCharacter that is currently being typed\n    \t\t@property character\n    \t\t@type String\n    \t\t@default null\n     */\n\n    _Class.prototype.character = null;\n\n\n    /**\n    \t\tCurrently used mapping\n    \t\t@property mapping\n    \t\t@type Object\n    \t\t@default null\n     */\n\n    _Class.prototype.mapping = null;\n\n\n    /**\n    \t\tTimeout that is used to interrupt typing\n    \t\t@property timeout\n    \t\t@type Object\n    \t\t@default null\n     */\n\n    _Class.prototype.timeout = null;\n\n\n    /**\n    \t\tDelay for typing timeout\n    \t\t@property delay\n    \t\t@type Number\n    \t\t@default 500\n     */\n\n    _Class.prototype.delay = 500;\n\n\n    /**\n    \t\tList of available cases\n    \t\t@static\n    \t\t@property caselist\n    \t\t@type Object\n     */\n\n    _Class.caselist = ['Abc', 'abc', 'ABC', '123'];\n\n\n    /**\n    \t\tUppercase of lowercase\n    \t\t@property case\n    \t\t@type String\n    \t\t@default 'Abc'\n     */\n\n    _Class.prototype[\"case\"] = null;\n\n\n    /**\n    \t\tCharacters that interrupt a sentence\n    \t\t@property interrupt_case\n    \t\t@type String\n    \t\t@default '.\\n'\n     */\n\n    _Class.prototype.interrupt_case = '.\\n';\n\n\n    /**\n    \t\tLoading all pre-built keymaps\n    \t\t@property maps\n    \t\t@type Object\n    \t\t@default null\n     */\n\n    _Class.prototype.maps = null;\n\n\n    /**\n    \t\t12-key keyboard layout emulation, similar to one that is used in mobile phones\n    \t\t@class Keypad\n    \t\t@extends EventEmitter\n    \t\t@param {[Object]} options Overwrite default `Keypad` options\n     */\n\n    function _Class(options) {\n      var key, val;\n      if (options == null) {\n        options = {};\n      }\n      for (key in options) {\n        val = options[key];\n        this[key] = val;\n      }\n      if (this.maps == null) {\n        this.maps = {\n          nokia: require('./MapNokia.js'),\n          sonyericsson: require('./MapSonyericsson.js'),\n          siemens: require('./MapSiemens.js')\n        };\n      }\n      if (this.mapping == null) {\n        this.SetMapping(this.map_name, this.map_language);\n      }\n      this[\"case\"] = exports.Keypad.caselist[0];\n      this.on('press', this.ProcessKeyPress);\n      this.on('hold', this.ProcessKeyHold);\n      this.on('timeout', this.Timeout);\n    }\n\n\n    /**\n    \t\tSet keypad mapping\n    \t\t@method SetMapping\n    \t\t@param {String} name Target mapping name\n     */\n\n    _Class.prototype.SetMapping = function(name, language) {\n      if (language == null) {\n        language = this.map_language;\n      }\n      if (name == null) {\n        throw new Error('Please specify target map name');\n      }\n      if (this.maps[name] == null) {\n        throw new Error('Specified map name does not exist');\n      }\n      if (this.maps[name][language] == null) {\n        throw new Error('Specified language does not exist in a mapping');\n      }\n      this.map_name = name;\n      this.map_language = language;\n      return this.mapping = this.maps[this.map_name][this.map_language];\n    };\n\n\n    /**\n    \t\tProcess a keyhold\n    \t\t@method ProcessKeyHold\n    \t\t@param {String} key Key character\n     */\n\n    _Class.prototype.ProcessKeyHold = function(key) {\n      if (key == null) {\n        throw new Error('Please specify pressed key code');\n      }\n      if (key === 'c') {\n        return this.Backspace();\n      }\n      if (this.mapping[key] == null) {\n        throw new Error(\"This key code was not found in mapping: '\" + key + \"'\");\n      }\n      return this.InsertCharacter(key);\n    };\n\n\n    /**\n    \t\tProcess a keypress\n    \t\t@method ProcessKeyPress\n    \t\t@param {String} key Key character\n     */\n\n    _Class.prototype.ProcessKeyPress = function(key, immediate) {\n      var current_index;\n      if (immediate == null) {\n        immediate = false;\n      }\n      if (key == null) {\n        throw new Error('Please specify pressed key code');\n      }\n      if (key === 'c') {\n        return this.Backspace();\n      }\n      if (this.mapping[key] == null) {\n        throw new Error(\"This key code was not found in mapping: '\" + key + \"'\");\n      }\n      current_index = this.mapping[key].indexOf(this.character);\n      if (current_index >= 0) {\n        this.RestartTimeout();\n        if (this.mapping[key][current_index + 1] != null) {\n          return this.character = this.mapping[key][current_index + 1];\n        }\n        return this.character = this.mapping[key][0];\n      }\n      this.InsertCharacter(this.character);\n      this.character = this.mapping[key][0];\n      if (this.character === 'CASE') {\n        return this.LoopCase();\n      }\n      if (immediate) {\n        this.InsertCharacter(this.character);\n        return this.ClearTimeout();\n      }\n      return this.RestartTimeout();\n    };\n\n\n    /**\n    \t\tRemove last character\n    \t\t@method Backspace\n     */\n\n    _Class.prototype.Backspace = function() {\n      this.ClearKeys();\n      if (this.text.length === 0) {\n        return null;\n      }\n      return this.text = this.text.slice(0, -1);\n    };\n\n\n    /**\n    \t\tLooping through available cases\n    \t\t@method LoopCase\n     */\n\n    _Class.prototype.LoopCase = function() {\n      var current_index;\n      this.ClearKeys();\n      current_index = exports.Keypad.caselist.indexOf(this[\"case\"]);\n      if (exports.Keypad.caselist[current_index + 1] != null) {\n        return this[\"case\"] = exports.Keypad.caselist[current_index + 1];\n      }\n      return this[\"case\"] = exports.Keypad.caselist[0];\n    };\n\n\n    /**\n    \t\tReturns character that will be inserted, with current case\n    \t\t@method GetInsertCharacter\n    \t\t@param {String} text Selected (typed) string\n     */\n\n    _Class.prototype.GetInsertCharacter = function(text) {\n      if (text == null) {\n        text = this.character;\n      }\n      if (text == null) {\n        return null;\n      }\n      if (this[\"case\"][0] === 'A') {\n        return text.toUpperCase();\n      }\n      return text;\n    };\n\n\n    /**\n    \t\tApply selected (typed) text\n    \t\t@method InsertCharacter\n    \t\t@param {String} text Selected (typed) string\n     */\n\n    _Class.prototype.InsertCharacter = function(text) {\n      var inserted;\n      if (text == null) {\n        text = this.character;\n      }\n      if (text == null) {\n        return;\n      }\n      inserted = this.GetInsertCharacter(text);\n      this.text += inserted;\n      this.ClearKeys();\n      if (this[\"case\"] !== 'ABC') {\n        this[\"case\"] = 'abc';\n      }\n      if (this[\"case\"] !== 'ABC' && (this.interrupt_case.indexOf(inserted)) >= 0) {\n        return this[\"case\"] = 'Abc';\n      }\n    };\n\n\n    /**\n    \t\tResetting current typing state\n    \t\t@method ClearKeys\n     */\n\n    _Class.prototype.ClearKeys = function() {\n      this.character = null;\n      return this.ClearTimeout();\n    };\n\n\n    /**\n    \t\tResetting typing tymeout\n    \t\t@method RestartTimeout\n     */\n\n    _Class.prototype.RestartTimeout = function() {\n      this.ClearTimeout();\n      return this.timeout = setTimeout(((function(_this) {\n        return function() {\n          return _this.Timeout();\n        };\n      })(this)), this.delay);\n    };\n\n\n    /**\n    \t\tWhen timeout happens, inserting new character and clearing the timeout\n    \t\t@method Timeout\n     */\n\n    _Class.prototype.Timeout = function() {\n      this.InsertCharacter();\n      return this.ClearTimeout();\n    };\n\n\n    /**\n    \t\tClear current keys timeout\n    \t\t@method ClearTimeout\n     */\n\n    _Class.prototype.ClearTimeout = function() {\n      if (this.timeout != null) {\n        clearTimeout(this.timeout);\n      }\n      return this.timeout = null;\n    };\n\n    return _Class;\n\n  })(EventEmitter);\n\n}).call(this);\n\n//@ sourceURL=/node_modules/keypad/lib/Keypad.js"
));

require.define("events",Function(['require','module','exports','__dirname','__filename','process','global'],"if (!process.EventEmitter) process.EventEmitter = function () {};\n\nvar EventEmitter = exports.EventEmitter = process.EventEmitter;\nvar isArray = typeof Array.isArray === 'function'\n    ? Array.isArray\n    : function (xs) {\n        return Object.prototype.toString.call(xs) === '[object Array]'\n    }\n;\nfunction indexOf (xs, x) {\n    if (xs.indexOf) return xs.indexOf(x);\n    for (var i = 0; i < xs.length; i++) {\n        if (x === xs[i]) return i;\n    }\n    return -1;\n}\n\n// By default EventEmitters will print a warning if more than\n// 10 listeners are added to it. This is a useful default which\n// helps finding memory leaks.\n//\n// Obviously not all Emitters should be limited to 10. This function allows\n// that to be increased. Set to zero for unlimited.\nvar defaultMaxListeners = 10;\nEventEmitter.prototype.setMaxListeners = function(n) {\n  if (!this._events) this._events = {};\n  this._events.maxListeners = n;\n};\n\n\nEventEmitter.prototype.emit = function(type) {\n  // If there is no 'error' event listener then throw.\n  if (type === 'error') {\n    if (!this._events || !this._events.error ||\n        (isArray(this._events.error) && !this._events.error.length))\n    {\n      if (arguments[1] instanceof Error) {\n        throw arguments[1]; // Unhandled 'error' event\n      } else {\n        throw new Error(\"Uncaught, unspecified 'error' event.\");\n      }\n      return false;\n    }\n  }\n\n  if (!this._events) return false;\n  var handler = this._events[type];\n  if (!handler) return false;\n\n  if (typeof handler == 'function') {\n    switch (arguments.length) {\n      // fast cases\n      case 1:\n        handler.call(this);\n        break;\n      case 2:\n        handler.call(this, arguments[1]);\n        break;\n      case 3:\n        handler.call(this, arguments[1], arguments[2]);\n        break;\n      // slower\n      default:\n        var args = Array.prototype.slice.call(arguments, 1);\n        handler.apply(this, args);\n    }\n    return true;\n\n  } else if (isArray(handler)) {\n    var args = Array.prototype.slice.call(arguments, 1);\n\n    var listeners = handler.slice();\n    for (var i = 0, l = listeners.length; i < l; i++) {\n      listeners[i].apply(this, args);\n    }\n    return true;\n\n  } else {\n    return false;\n  }\n};\n\n// EventEmitter is defined in src/node_events.cc\n// EventEmitter.prototype.emit() is also defined there.\nEventEmitter.prototype.addListener = function(type, listener) {\n  if ('function' !== typeof listener) {\n    throw new Error('addListener only takes instances of Function');\n  }\n\n  if (!this._events) this._events = {};\n\n  // To avoid recursion in the case that type == \"newListeners\"! Before\n  // adding it to the listeners, first emit \"newListeners\".\n  this.emit('newListener', type, listener);\n\n  if (!this._events[type]) {\n    // Optimize the case of one listener. Don't need the extra array object.\n    this._events[type] = listener;\n  } else if (isArray(this._events[type])) {\n\n    // Check for listener leak\n    if (!this._events[type].warned) {\n      var m;\n      if (this._events.maxListeners !== undefined) {\n        m = this._events.maxListeners;\n      } else {\n        m = defaultMaxListeners;\n      }\n\n      if (m && m > 0 && this._events[type].length > m) {\n        this._events[type].warned = true;\n        console.error('(node) warning: possible EventEmitter memory ' +\n                      'leak detected. %d listeners added. ' +\n                      'Use emitter.setMaxListeners() to increase limit.',\n                      this._events[type].length);\n        console.trace();\n      }\n    }\n\n    // If we've already got an array, just append.\n    this._events[type].push(listener);\n  } else {\n    // Adding the second element, need to change to array.\n    this._events[type] = [this._events[type], listener];\n  }\n\n  return this;\n};\n\nEventEmitter.prototype.on = EventEmitter.prototype.addListener;\n\nEventEmitter.prototype.once = function(type, listener) {\n  var self = this;\n  self.on(type, function g() {\n    self.removeListener(type, g);\n    listener.apply(this, arguments);\n  });\n\n  return this;\n};\n\nEventEmitter.prototype.removeListener = function(type, listener) {\n  if ('function' !== typeof listener) {\n    throw new Error('removeListener only takes instances of Function');\n  }\n\n  // does not use listeners(), so no side effect of creating _events[type]\n  if (!this._events || !this._events[type]) return this;\n\n  var list = this._events[type];\n\n  if (isArray(list)) {\n    var i = indexOf(list, listener);\n    if (i < 0) return this;\n    list.splice(i, 1);\n    if (list.length == 0)\n      delete this._events[type];\n  } else if (this._events[type] === listener) {\n    delete this._events[type];\n  }\n\n  return this;\n};\n\nEventEmitter.prototype.removeAllListeners = function(type) {\n  // does not use listeners(), so no side effect of creating _events[type]\n  if (type && this._events && this._events[type]) this._events[type] = null;\n  return this;\n};\n\nEventEmitter.prototype.listeners = function(type) {\n  if (!this._events) this._events = {};\n  if (!this._events[type]) this._events[type] = [];\n  if (!isArray(this._events[type])) {\n    this._events[type] = [this._events[type]];\n  }\n  return this._events[type];\n};\n\n//@ sourceURL=events"
));

require.define("/node_modules/keypad/lib/MapNokia.js",Function(['require','module','exports','__dirname','__filename','process','global'],"// Generated by CoffeeScript 1.8.0\n\n/**\n\t@module Keypad\n\t@author muchweb\n */\n\n(function() {\n  'use strict';\n  exports.en = {\n    '1': ['.', ',', '?', '!', '\\'', '\"', '1', '-', '(', ')', '@', '/', ':', '_'],\n    '2': ['a', 'b', 'c', '2', 'ä', 'æ', 'å', 'à', 'á', 'â', 'ã', 'ç'],\n    '3': ['d', 'e', 'f', '3', 'è', 'é', 'ê', 'ð'],\n    '4': ['g', 'h', 'i', '4', 'ì', 'í', 'î', 'ï'],\n    '5': ['j', 'k', 'l', '5', '£'],\n    '6': ['m', 'n', 'o', '6', 'ö', 'ø', 'ò', 'ó', 'ô', 'õ', 'ñ'],\n    '7': ['p', 'q', 'r', 's', '7', 'ß', '$'],\n    '8': ['t', 'u', 'v', '8', 'ù', 'ú', 'û', 'ü'],\n    '9': ['w', 'x', 'y', 'z', '9', 'ý', 'þ'],\n    '*': [],\n    '0': [' ', '0', '\\n'],\n    '#': ['CASE']\n  };\n\n  exports.de = {\n    '1': ['.', ',', '?', '!', '\\'', '\"', '1', '-', '(', ')', '@', '/', ':', '_'],\n    '2': ['a', 'b', 'c', '2', 'ä', 'à', 'á', 'ã', 'â', 'å', 'æ', 'ç'],\n    '3': ['d', 'e', 'f', '3', 'è', 'é', 'ë', 'ê', 'ð'],\n    '4': ['g', 'h', 'i', '4', 'ì', 'í', 'î', 'ï'],\n    '5': ['j', 'k', 'l', '5', '£'],\n    '6': ['m', 'n', 'o', '6', 'ò', 'ó', 'ô', 'õ', 'ö', 'ø', 'ñ'],\n    '7': ['p', 'q', 'r', 's', '7', 'ß', '$'],\n    '8': ['t', 'u', 'v', '8', 'ü', 'ù', 'ú', 'û'],\n    '9': ['w', 'x', 'y', 'z', '9', 'ý', 'þ'],\n    '*': [],\n    '0': [' ', '0', '\\n'],\n    '#': ['CASE']\n  };\n\n}).call(this);\n\n//@ sourceURL=/node_modules/keypad/lib/MapNokia.js"
));

require.define("/node_modules/keypad/lib/MapSonyericsson.js",Function(['require','module','exports','__dirname','__filename','process','global'],"// Generated by CoffeeScript 1.8.0\n\n/**\n\t@module Keypad\n\t@author muchweb\n */\n\n(function() {\n  'use strict';\n  exports.en = {\n    '1': ['.', ',', '-', '?', '!', '\\'', '@', ':', ';', '/', '(', ')', '1'],\n    '2': ['a', 'b', 'c', '2'],\n    '3': ['d', 'e', 'f', '3'],\n    '4': ['g', 'h', 'i', '4'],\n    '5': ['j', 'k', 'l', '5'],\n    '6': ['m', 'n', 'o', '6'],\n    '7': ['p', 'q', 'r', 's', '7'],\n    '8': ['t', 'u', 'v', '8'],\n    '9': ['w', 'x', 'y', 'z', '9'],\n    '*': ['CASE'],\n    '0': ['+', '0'],\n    '#': [' ', '\\n', '¶']\n  };\n\n  exports.de = {\n    '1': ['.', ',', '-', '?', '!', '\\'', '@', ':', ';', '/', '(', ')', '1'],\n    '2': ['a', 'b', 'c', 'ä', 'á', 'à', '2'],\n    '3': ['d', 'e', 'f', 'é', 'è', '3'],\n    '4': ['g', 'h', 'i', '4'],\n    '5': ['j', 'k', 'l', '5'],\n    '6': ['m', 'n', 'o', 'ö', '6'],\n    '7': ['p', 'q', 'r', 's', 'ß', '7'],\n    '8': ['t', 'u', 'v', 'ü', '8'],\n    '9': ['w', 'x', 'y', 'z', '9'],\n    '*': ['CASE'],\n    '0': ['+', '0'],\n    '#': [' ', '\\n', '¶']\n  };\n\n  exports.es = {\n    '1': ['.', ',', '-', '?', '!', '\\'', '@', ':', ';', '/', '(', ')', '1'],\n    '2': ['a', 'b', 'c', 'á', 'ã', 'ç', '2'],\n    '3': ['d', 'e', 'f', 'é', '3'],\n    '4': ['g', 'h', 'i', 'í', '4'],\n    '5': ['j', 'k', 'l', '5'],\n    '6': ['m', 'n', 'o', 'ó', 'ñ', '6'],\n    '7': ['p', 'q', 'r', 's', '7'],\n    '8': ['t', 'u', 'v', 'ú', 'ü', '8'],\n    '9': ['w', 'x', 'y', 'z', '9'],\n    '*': ['CASE'],\n    '0': ['+', '0'],\n    '#': [' ', '\\n', '¶']\n  };\n\n  exports.fr = {\n    '1': ['.', ',', '-', '?', '!', '\\'', '@', ':', ';', '/', '(', ')', '1'],\n    '2': ['a', 'b', 'c', 'ç', 'à', 'â', 'á', 'ä', '2'],\n    '3': ['d', 'e', 'f', 'é', 'è', 'ê', 'ë', '3'],\n    '4': ['g', 'h', 'i', 'î', 'ï', 'í', '4'],\n    '5': ['j', 'k', 'l', '5'],\n    '6': ['m', 'n', 'o', 'ô', 'ó', 'ö', 'ñ', '6'],\n    '7': ['p', 'q', 'r', 's', 'ß', '7'],\n    '8': ['t', 'u', 'v', 'ù', 'û', 'ú', 'ü', '8'],\n    '9': ['w', 'x', 'y', 'z', '9'],\n    '*': ['CASE'],\n    '0': ['+', '0'],\n    '#': [' ', '\\n', '¶']\n  };\n\n  exports.nl = {\n    '1': ['.', ',', '-', '?', '!', '\\'', '@', ':', ';', '/', '(', ')', '1'],\n    '2': ['a', 'b', 'c', 'ç', 'ä', 'á', 'à', 'â', '2'],\n    '3': ['d', 'e', 'f', 'ë', 'é', 'è', 'ê', '3'],\n    '4': ['g', 'h', 'i', 'ï', 'í', 'ì', 'î', '4'],\n    '5': ['j', 'k', 'l', '5'],\n    '6': ['m', 'n', 'o', 'ö', 'ó', 'ò', 'ô', '6'],\n    '7': ['p', 'q', 'r', 's', 'ß', '7'],\n    '8': ['t', 'u', 'v', 'ü', 'ú', 'û', 'ù', '8'],\n    '9': ['w', 'x', 'y', 'z', '9'],\n    '*': ['CASE'],\n    '0': ['+', '0'],\n    '#': [' ', '\\n', '¶']\n  };\n\n  exports.pt = {\n    '1': ['.', ',', '-', '?', '!', '\\'', '@', ':', ';', '/', '(', ')', '1'],\n    '2': ['a', 'b', 'c', 'ç', 'ã', 'á', 'à', 'â', '2'],\n    '3': ['d', 'e', 'f', 'é', 'ê', '3'],\n    '4': ['g', 'h', 'i', 'í', '4'],\n    '5': ['j', 'k', 'l', '5'],\n    '6': ['m', 'n', 'o', 'õ', 'ó', 'ô', 'ñ', '6'],\n    '7': ['p', 'q', 'r', 's', '7'],\n    '8': ['t', 'u', 'v', 'ú', 'ü', '8'],\n    '9': ['w', 'x', 'y', 'z', '9'],\n    '*': ['CASE'],\n    '0': ['+', '0'],\n    '#': [' ', '\\n', '¶']\n  };\n\n  exports.tr = {\n    '1': ['.', ',', '-', '?', '!', '\\'', '@', ':', ';', '/', '(', ')', '1'],\n    '2': ['a', 'b', 'c', 'ç', 'â', 'ä', 'á', '2'],\n    '3': ['d', 'e', 'f', 'é', '3'],\n    '4': ['g', 'h', 'ı', 'i', 'ğ', 'î', '4'],\n    '5': ['j', 'k', 'l', '5'],\n    '6': ['m', 'n', 'o', 'ö', 'ó', 'ô', '6'],\n    '7': ['p', 'q', 'r', 's', 'ş', '7'],\n    '8': ['t', 'u', 'v', 'ü', 'û', 'ú', '8'],\n    '9': ['w', 'x', 'y', 'z', '9'],\n    '*': ['CASE'],\n    '0': ['+', '0'],\n    '#': [' ', '\\n', '¶']\n  };\n\n}).call(this);\n\n//@ sourceURL=/node_modules/keypad/lib/MapSonyericsson.js"
));

require.define("/node_modules/keypad/lib/MapSiemens.js",Function(['require','module','exports','__dirname','__filename','process','global'],"// Generated by CoffeeScript 1.8.0\n\n/**\n\t@module Keypad\n\t@author muchweb\n */\n\n(function() {\n  'use strict';\n  exports.en = {\n    '1': [' ', '1', '€', '£', '$', '¥'],\n    '2': ['a', 'b', 'c', '2', 'ä', 'ç', 'à'],\n    '3': ['d', 'e', 'f', '3', 'é', 'è'],\n    '4': ['g', 'h', 'i', '4'],\n    '5': ['j', 'k', 'l', '5'],\n    '6': ['m', 'n', 'o', '6', 'ö', 'ñ', 'ò'],\n    '7': ['p', 'q', 'r', 's', '7', 'ß'],\n    '8': ['t', 'u', 'v', '8', 'ü', 'ù'],\n    '9': ['w', 'x', 'y', 'z', '9', 'æ', 'ø', 'å'],\n    '*': ['CASE'],\n    '0': [' ', '0', '\\n'],\n    '#': ['#', '@', '&', '§', 'Γ', 'Δ', 'Θ', 'Λ', 'Ξ', 'Π', 'Σ', 'Φ', 'Ψ', 'Ω']\n  };\n\n}).call(this);\n\n//@ sourceURL=/node_modules/keypad/lib/MapSiemens.js"
));

require.define("/lib/main.js",Function(['require','module','exports','__dirname','__filename','process','global'],"// Generated by CoffeeScript 1.8.0\n(function() {\n  'use strict';\n  var Keypad, pad;\n\n  Keypad = require('../node_modules/keypad/lib/Keypad.js').Keypad;\n\n  pad = new Keypad({\n    text: 'Hello,\\n'\n  });\n\n  (document.getElementById('key-1')).addEventListener('click', (function() {\n    return pad.emit('press', '1');\n  }));\n\n  (document.getElementById('key-2')).addEventListener('click', (function() {\n    return pad.emit('press', '2');\n  }));\n\n  (document.getElementById('key-3')).addEventListener('click', (function() {\n    return pad.emit('press', '3');\n  }));\n\n  (document.getElementById('key-4')).addEventListener('click', (function() {\n    return pad.emit('press', '4');\n  }));\n\n  (document.getElementById('key-5')).addEventListener('click', (function() {\n    return pad.emit('press', '5');\n  }));\n\n  (document.getElementById('key-6')).addEventListener('click', (function() {\n    return pad.emit('press', '6');\n  }));\n\n  (document.getElementById('key-7')).addEventListener('click', (function() {\n    return pad.emit('press', '7');\n  }));\n\n  (document.getElementById('key-8')).addEventListener('click', (function() {\n    return pad.emit('press', '8');\n  }));\n\n  (document.getElementById('key-9')).addEventListener('click', (function() {\n    return pad.emit('press', '9');\n  }));\n\n  (document.getElementById('key-a')).addEventListener('click', (function() {\n    return pad.emit('press', '*');\n  }));\n\n  (document.getElementById('key-0')).addEventListener('click', (function() {\n    return pad.emit('press', '0');\n  }));\n\n  (document.getElementById('key-b')).addEventListener('click', (function() {\n    return pad.emit('press', '#');\n  }));\n\n  setInterval(function() {\n    (document.getElementById('screen-inner-text')).innerHTML = pad.text.replace('\\n', '<br>');\n    (document.getElementById('screen-inner-character')).innerHTML = pad.character;\n    return (document.getElementById('screen-inner-case')).innerHTML = pad[\"case\"];\n  }, 25);\n\n}).call(this);\n\n//# sourceMappingURL=main.js.map\n\n//@ sourceURL=/lib/main.js"
));
require("/lib/main.js");
})();
