all: jquery.ratelimit.md jquery.ratelimit.js

%.md: %.js.sdoc makefile
	sdoc cat markdown::$< > $@

%.js: %.js.sdoc makefile
	sdoc cat code.js::$< > $@
