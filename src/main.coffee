'use strict'

{Keypad} = require '../node_modules/keypad/lib/Keypad.js'

pad = new Keypad
	text: 'Hello,\n'

(document.getElementById 'key-1').addEventListener 'click', (-> pad.emit 'press', '1')
(document.getElementById 'key-2').addEventListener 'click', (-> pad.emit 'press', '2')
(document.getElementById 'key-3').addEventListener 'click', (-> pad.emit 'press', '3')
(document.getElementById 'key-4').addEventListener 'click', (-> pad.emit 'press', '4')
(document.getElementById 'key-5').addEventListener 'click', (-> pad.emit 'press', '5')
(document.getElementById 'key-6').addEventListener 'click', (-> pad.emit 'press', '6')
(document.getElementById 'key-7').addEventListener 'click', (-> pad.emit 'press', '7')
(document.getElementById 'key-8').addEventListener 'click', (-> pad.emit 'press', '8')
(document.getElementById 'key-9').addEventListener 'click', (-> pad.emit 'press', '9')
(document.getElementById 'key-a').addEventListener 'click', (-> pad.emit 'press', '*')
(document.getElementById 'key-0').addEventListener 'click', (-> pad.emit 'press', '0')
(document.getElementById 'key-b').addEventListener 'click', (-> pad.emit 'press', '#')

document.addEventListener 'keydown', (event) ->
	switch event.keyCode
		when 49 then pad.emit 'press', '1'
		when 50 then pad.emit 'press', '2'
		when 51 then pad.emit 'press', '3'
		when 81 then pad.emit 'press', '4'
		when 87 then pad.emit 'press', '5'
		when 69 then pad.emit 'press', '6'
		when 65 then pad.emit 'press', '7'
		when 83 then pad.emit 'press', '8'
		when 68 then pad.emit 'press', '9'
		when 90 then pad.emit 'press', '*'
		when 88 then pad.emit 'press', '0'
		when 67 then pad.emit 'press', '#'
		when  8 then pad.emit 'press', 'c'

setInterval ->
	(document.getElementById 'screen-inner-text').innerHTML = pad.text.replace '\n', '<br>'
	(document.getElementById 'screen-inner-character').innerHTML = pad.character
	(document.getElementById 'screen-inner-case').innerHTML = pad.case
, 25
