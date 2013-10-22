ICED=node_modules/.bin/iced
BUILD_STAMP=build-stamp
TEST_STAMP=test-stamp
UGLIFYJS=node_modules/.bin/uglifyjs
WD=`pwd`
BROWSERIFY=node_modules/.bin/browserify

default: build
all: build

lib/%.js: src/%.iced
	$(ICED) -I browserify -c -o `dirname $@` $<

$(BUILD_STAMP): \
	lib/const.js \
	lib/main.js \
	lib/primegen.js \
	lib/primes.js \
	lib/rsa.js \
	lib/util.js \
	lib/bn.js \
	lib/asymmetric.js \
	lib/basex.js \
	lib/symmetric.js \
	lib/pad.js \
	lib/keymanager.js \
	lib/keywrapper.js \
	lib/hash.js \
	lib/rand.js \
	lib/lock.js \
	lib/keybase/encode.js \
	lib/keybase/sign.js \
	lib/keybase/parser.js \
	lib/keybase/packet/all.js \
	lib/keybase/packet/base.js \
	lib/keybase/packet/bundle.js \
	lib/keybase/packet/keymaterial.js \
	lib/keybase/packet/signature.js \
	lib/keybase/packet/userid.js \
	lib/openpgp/armor.js \
	lib/openpgp/buffer.js \
	lib/openpgp/cfb.js \
	lib/openpgp/s2k.js \
	lib/openpgp/util.js \
	lib/openpgp/packet/all.js \
	lib/openpgp/packet/base.js \
	lib/openpgp/packet/userid.js \
	lib/openpgp/packet/keymaterial.js \
	lib/openpgp/packet/signature.js \
	lib/openpgp/parser.js \
	lib/openpgp/processor.js \
	lib/openpgp/cast5.js 
	date > $@

build: $(BUILD_STAMP) 

test-server: $(BUILD_STAMP)
	$(ICED) test/run.iced

test-browser: $(TEST_STAMP) $(BUILD_STAMP)
	@echo "Please visit in your favorite browser --> file://$(WD)/test/browser/index.html"

test/browser/test.js: test/browser/main.iced $(BUILD_STAMP)
	$(BROWSERIFY) -t icsify $< > $@

$(TEST_STAMP): test/browser/test.js
	date > $@

test: test-server test-browser

clean:
	rm -rf lib/* $(BUILD_STAMP) $(TEST_STAMP) test/browser/test.js

setup:
	npm install -d

.PHONY: clean setup test  test-browser
