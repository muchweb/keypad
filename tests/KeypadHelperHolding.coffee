{KeypadHelper} = require '..'

exports.KeypadHelperHolding =

	'KeypadHelperHolding': (test) ->
		item = new KeypadHelper

		item.emit 'down', '2'
		test.strictEqual item.character, null
		test.strictEqual item.GetInsertCharacter(), null
		test.strictEqual item.text, ''

		setTimeout ->
			item.emit 'up', '2'
			test.strictEqual item.character, null
			test.strictEqual item.GetInsertCharacter(), null
			test.strictEqual item.text, '2'

			test.done()
		, 1100
