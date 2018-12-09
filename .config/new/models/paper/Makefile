.PHONY: all figures clean
.SECONDARY:

PAPERS := dev.pdf arxiv.pdf

LTX := pdflatex -interaction=nonstopmode -halt-on-error

FIGSDIR := figures

BUILDDIR := _build

FIGURES := $(shell sed -E -e 's/:.*$$//' Makefile | grep -E '^figures/[a-z0-9-]*\.pdf$$')

all: $(PAPERS)

figures: $(FIGURES)

#figures/myfigure.pdf: view=<page>-<view>

figures/%.pdf: figures/figures.ipe
	ipetoipe -pdf -export -view $(view) figures/figures.ipe $@

%.pdf: $(BUILDDIR)/%/paper.pdf
	cp $< $@
	killall -HUP mupdf || true

$(BUILDDIR)/dev/src.tex: $(shell texdeps dev.tex)
$(BUILDDIR)/arxiv/src.tex: $(shell texdeps arxiv.tex)

$(BUILDDIR)/%/src.tex:
	mkdir -p $(dir $@)
	flatex --include_sty $< - | texshake | textrim > $@

$(BUILDDIR)/%/paper.bib: $(BUILDDIR)/%/src.tex
	texcites < $< | \
		bibfilter $(shell sed -E -n 's/\\bibliography\{(.*)\}/\1/p' $<).bib \
		> $(dir $@)paper.bib

$(BUILDDIR)/%/paper.tex: $(BUILDDIR)/%/src.tex $(BUILDDIR)/%/paper.bib
	cp -t $(dir $@) $(shell texdeps $< | tail +2) $(static) 2>/dev/null || true
	sed -E -e 's:\\bibliography\{.*\}:\\bibliography{paper}:g' \
		   -e 's:\{figures/:{:g' $< > $@

$(BUILDDIR)/%/paper.pdf: $(BUILDDIR)/%/paper.tex
	cd $(dir $@); \
		$(LTX) paper.tex; \
		bibtex paper; \
		$(LTX) paper.tex; \
		$(LTX) paper.tex

arxiv.zip: $(BUILDDIR)/arxiv/paper.zip
	cp $< $@

$(BUILDDIR)/arxiv/paper.zip: $(BUILDDIR)/arxiv/paper.pdf
	cd $(dir $@) ; \
		zip -FS -r 'paper.zip' \
		paper.tex \
		paper.bbl \
		$(shell texdeps $(basename $@).tex | tail +2)

clean:
	rm -rf $(BUILDDIR)
	rm -f $(PAPERS) $(PAPERS:.pdf=.zip)
	rm -f $(FIGURES)
