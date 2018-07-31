.PHONY: all clean
.SECONDARY:

TEX=$(shell find tex -name '*.tex')
HTML=$(patsubst tex/%.tex,html/%.html,$(TEX))

all: $(HTML) index.js katex/katex.min.css

html/%.html: tex/%.tex
	cat $< | head -c-2 | tail -c+2 | katex > $@

index.js: $(HTML)
	printf 'const __MATH__  = [ "%s" ] ;\n' '$(shell joinarray '", "' $^)' > index.js

katex/katex.min.css: /usr/lib/node_modules/katex/dist/katex.min.css
	cp -r /usr/lib/node_modules/katex/dist katex

clean:
	rm -rf $(HTML) index.js katex
