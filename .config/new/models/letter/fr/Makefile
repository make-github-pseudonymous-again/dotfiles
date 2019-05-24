OUTPUT := letter.pdf
SOURCE := letter
LTX := pdflatex -interaction=nonstopmode -halt-on-error

BUILDDIR := _build

all: $(OUTPUT)
	killall -HUP mupdf || true

$(OUTPUT): $(BUILDDIR)/$(SOURCE).pdf
	cp $< $@

$(BUILDDIR)/$(SOURCE).pdf: $(BUILDDIR)/$(SOURCE).tex
	cd $(dir $@); \
		$(LTX) $(SOURCE).tex

$(BUILDDIR)/$(SOURCE).tex: $(SOURCE).tex
	mkdir -p $(BUILDDIR)
	cp $< $@

clean:
	rm -rf $(BUILDDIR)
	rm -f $(OUTPUT)
