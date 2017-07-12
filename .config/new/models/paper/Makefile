
TARGET = paper

SECTIONSDIR = sec
SECTIONS := $(shell find $(SECTIONSDIR) -name '*.tex')
APPENDIXDIR = app
APPENDIX := $(shell find $(APPENDIXDIR) -name '*.tex')

all: figures $(TARGET).pdf

diff:
	git difftex $(TARGET).tex > $(TARGET).diff
	pdflatex -synctex=1 -interaction=nonstopmode -halt-on-error $(TARGET).diff
	killall -HUP mupdf

figures:
	@make --no-print-directory -C fig all

$(TARGET).pdf: fig/.updated $(TARGET).tex $(TARGET).sty $(TARGET).bib $(SECTIONS) $(APPENDIX)
	pdflatex $(TARGET).tex -interaction=nonstopmode -halt-on-error
	#bibtex $(TARGET)
	#pdflatex $(TARGET).tex -interaction=nonstopmode -halt-on-error
	pdflatex $(TARGET).tex -interaction=nonstopmode -halt-on-error

clean:
	rm -f $(TARGET).{out,log,aux,pdf,bbl,blg,vtc}
	@make --no-print-directory -C fig clean

zip: all
	rm -f $(TARGET).zip
	zip -r $(TARGET).zip \
		$(TARGET).tex \
		$(TARGET).sty \
		$(TARGET).bib \
		$(SECTIONS) \
		$(APPENDIX) \
		fig/*.pdf
