all: lib/main.js

lib/main.js: src/main.coffee src/Keypad.coffee ./node_modules/.bin/coffee
	mkdir -p lib
	./node_modules/.bin/coffee --map --compile --output lib src

lib/browser.js: lib/main.js
	./node_modules/.bin/browserify lib/main.js -o lib/browser.js --debug

./node_modules/.bin/coffee:
	npm install

clean:
	rm -rf lib
