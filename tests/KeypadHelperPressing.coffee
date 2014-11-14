{KeypadHelper} = require '..'

exports.KeypadHelperPressing =

	'KeypadHelperPressing': (test) ->
		item = new KeypadHelper

		item.emit 'down', '2'
		test.strictEqual item.character, null
		test.strictEqual item.GetInsertCharacter(), null
		test.strictEqual item.text, ''

		setTimeout ->
			item.emit 'up', '2'
			test.strictEqual item.character, 'a'
			test.strictEqual item.GetInsertCharacter(), 'A'
			test.strictEqual item.text, ''

			setTimeout ->
				test.strictEqual item.character, null
				test.strictEqual item.GetInsertCharacter(), null
				test.strictEqual item.text, 'A'

				test.done()
			, 1000
		, 100
