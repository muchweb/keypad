'use strict'

{Keypad} = require '../node_modules/keypad/lib/Keypad.js'

pad = new Keypad
	text: 'Hello,\n'

(document.getElementById 'key-1').addEventListener 'click', -> pad.emit 'push', '1'
(document.getElementById 'key-2').addEventListener 'click', -> pad.emit 'push', '2'
(document.getElementById 'key-3').addEventListener 'click', -> pad.emit 'push', '3'
(document.getElementById 'key-4').addEventListener 'click', -> pad.emit 'push', '4'
(document.getElementById 'key-5').addEventListener 'click', -> pad.emit 'push', '5'
(document.getElementById 'key-6').addEventListener 'click', -> pad.emit 'push', '6'
(document.getElementById 'key-7').addEventListener 'click', -> pad.emit 'push', '7'
(document.getElementById 'key-8').addEventListener 'click', -> pad.emit 'push', '8'
(document.getElementById 'key-9').addEventListener 'click', -> pad.emit 'push', '9'
(document.getElementById 'key-a').addEventListener 'click', -> pad.emit 'push', '*'
(document.getElementById 'key-0').addEventListener 'click', -> pad.emit 'push', '0'
(document.getElementById 'key-b').addEventListener 'click', -> pad.emit 'push', '#'

setInterval ->
	(document.getElementById 'screen-inner-text').innerHTML = pad.text.replace '\n', '<br>'
	(document.getElementById 'screen-inner-character').innerHTML = pad.character
	(document.getElementById 'screen-inner-case').innerHTML = pad.case
, 25
