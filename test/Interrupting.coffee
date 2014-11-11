{Keypad} = require '..'

exports.Interrupt =

	'interrupt': (test) ->
		item = new Keypad
		test.strictEqual item.text, ''

		item.emit 'push', '1'
		test.strictEqual item.character, '.'
		test.strictEqual item.text, ''

		setTimeout ->
			item.emit 'push', '2'
			test.strictEqual item.character, 'a'
			test.strictEqual item.text, '.'

			setTimeout ->
				test.strictEqual item.character, null
				test.strictEqual item.text, '.a'

				test.done()
			, 200
		, 200
