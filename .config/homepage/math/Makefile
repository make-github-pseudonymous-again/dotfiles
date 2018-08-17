.PHONY: all clean
.SECONDARY:

TEX=$(shell find tex -name '*.tex')
HTML=$(patsubst tex/%.tex,html/%.html,$(TEX))


ifneq ($(wildcard /usr/local/share/.config/yarn/global/node_modules/katex/.),)
	LIB=/usr/local/share/.config/yarn/global
else
	LIB=/usr/lib
endif

all: $(HTML) index.js katex/katex.min.css

html/%.html: tex/%.tex
	cat $< | head -c-2 | tail -c+2 | katex --display-mode > $@

index.js: $(HTML)
	printf 'const __MATH__  = [ "%s" ] ;\n' '$(shell joinarray '", "' $^)' > index.js

katex/katex.min.css: $(LIB)/node_modules/katex/dist/katex.min.css
	cp -r $(LIB)/node_modules/katex/dist katex

clean:
	rm -rf $(HTML) index.js katex
