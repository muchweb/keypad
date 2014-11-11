all: lib/main.js lib/Keypad.js

lib/main.js lib/Keypad.js: src/main.coffee src/Keypad.coffee ./node_modules/.bin/coffee
	mkdir -p lib
	./node_modules/.bin/coffee --map --compile --output lib src

./node_modules/.bin/coffee:
	npm install

clean:
	rm -rf lib
