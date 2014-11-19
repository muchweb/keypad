all: dist/browser.js

dist/browser.js: lib/browser.js
	mkdir -p dist
	cp lib/browser.js dist/browser.js

lib/browser.js: lib/main.js ./node_modules/.bin/browserify
	./node_modules/.bin/browserify lib/main.js -o lib/browser.js --debug

lib/main.js: src/main.coffee ./node_modules/.bin/coffee
	mkdir -p lib
	./node_modules/.bin/coffee --map --compile --output lib src

./node_modules/.bin/coffee ./node_modules/.bin/browserify:
	npm install

clean:
	rm -rf lib
