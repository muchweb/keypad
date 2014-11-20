{Keypad} = require '..'

exports.Interrupt =

	'interrupt': (test) ->
		item = new Keypad
		test.strictEqual item.text, ''

		item.emit 'press', '2'
		test.strictEqual item.character, 'a'
		test.strictEqual item.text, ''

		item.emit 'press', '5'
		test.strictEqual item.character, 'j'
		test.strictEqual item.text, 'A'

		item.emit 'timeout'

		test.strictEqual item.character, null
		test.strictEqual item.text, 'Aj'

		test.done()
