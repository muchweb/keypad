{Keypad} = require '..'

exports.Constructing =
	'default typing': (test) ->
		item = new Keypad
		test.strictEqual item.typing, false
		test.done()
