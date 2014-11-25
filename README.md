# Keypad [![Build Status](https://travis-ci.org/muchweb/keypad.svg)](https://travis-ci.org/muchweb/keypad) [![Coverage Status](https://img.shields.io/coveralls/muchweb/keypad.svg)](https://coveralls.io/r/muchweb/keypad) [![Dependency Status](https://gemnasium.com/muchweb/keypad.svg)](https://gemnasium.com/muchweb/keypad) [![NPM version](https://badge.fury.io/js/keypad.svg)](http://badge.fury.io/js/keypad) [![Bower version](https://badge.fury.io/bo/keypad.svg)](http://badge.fury.io/bo/keypad) ![License: GPLv3+](http://img.shields.io/badge/license-GPLv3%2B-brightgreen.svg)

12-key keyboard layout emulation, similar to one that is used in mobile phones.

Nokia mappings compatible with these models:

 - Nokia 5220
 - Nokia X3-02

Sony Ericsson mapping is compatible with this model:

 - Sony Ericsson C902

Sony Siemens mapping is compatible with this model:

 - Siemens A35
 - Siemens M55

## Usage

 - `delay`: Key press delay between letters are reset, *default*: `50`
 - `layout`: Mainly affects punctuation, *default*: `'nokia'`

```javascript
var Keypad = require('keypad').Keypad;
pad = new Keypad({
    delay: 500,
    layout: 'nokia',
});
```

Emulating a button press:
```javascript
pad.emit('press', '1');
```

Emulating a button hold:
```javascript
pad.emit('hold', '2');
```

Getting resulting text:
```javascript
console.log(pad.text);
```

Allowed keys are: `1`, `2`, `3`, `4`, `5`, `6`, `7`, `8`, `9`, `*`,  `0`, `#`,  `c`.

## When is this useful?

When you don't like 'touch-screens'. Arduino, Raspberry PI, Tessel.

## Building

 - **Install dev dependencies**
    ```bash
    npm install
    ```

 - **Compilng :coffee: CoffeeScript**
    ```bash
    make
    ```

 - **Testing**
    ```bash
    npm test
    ```

## :free: License

This program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.

This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for more details.

You should have received a copy of the GNU General Public License along with this program.  If not, see <http://www.gnu.org/licenses/>.
