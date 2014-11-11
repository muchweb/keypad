# Keypad  [![Build Status](https://travis-ci.org/muchweb/keypad.svg)](https://travis-ci.org/muchweb/keypad) [![NPM version](https://badge.fury.io/js/keypad.svg)](http://badge.fury.io/js/keypad) ![License: GPLv3+](http://img.shields.io/badge/license-GPLv3%2B-brightgreen.svg)

12-key keyboard layout emulation, similar to one that is used in mobile phones.

Nokia mappings were manually typed to match (both are confirmed to use the same mapping):

 - Nokia 5220
 - Nokia X3-02

Sony Ericsson mapping was typed in from this model:

 - Sony Ericsson C902

## Usage

 - `delay`: Key press delay between letters are reset, *default*: `50`
 - `layout`: Mainly affects punctuation, *default*: `'nokia'`

```
var Keypad = require('keypad').Keypad;
pad = new Keypad({
    delay: 500,
    layout: 'nokia',
});
```

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

This program is free software: you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation, either version 3 of the License, or
(at your option) any later version.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with this program.  If not, see <http://www.gnu.org/licenses/>.
