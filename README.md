# Keypad

12-key keyboard layout emulation, similar to one that is used in mobile phones.

## Usage

 - `delay`: Key press delay between letters are reset, *default*: `50`
 - `layout`: Mainly affects punctuation, *default*: `'nokia'`

```
var Keypad = require('keypad').Keypad;
pad = new Keypad({
    delay: 100,
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
