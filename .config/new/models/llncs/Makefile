
TARGET = paper
SECTIONS = $(find sec | grep '.tex$$')

all: figures $(TARGET).pdf

figures:
	@make --no-print-directory -C fig all

$(TARGET).pdf: fig/.updated $(TARGET).tex $(TARGET).sty $(SECTIONS) $(TARGET).bib
	pdflatex $(TARGET).tex -interaction=nonstopmode -halt-on-error
	bibtex $(TARGET)
	pdflatex $(TARGET).tex -interaction=nonstopmode -halt-on-error
	pdflatex $(TARGET).tex -interaction=nonstopmode -halt-on-error

clean:
	rm -f $(TARGET).{out,log,aux,pdf,bbl,blg,vtc}
	@make --no-print-directory -C fig clean

zip: all
	rm -f $(TARGET).zip
	zip -r $(TARGET).zip \
	$(TARGET).tex \
	$(TARGET).bib \
	aliascnt.sty remreset.sty llncs.cls splncs03.bst \
	$(TARGET).sty \
	sec/{,**/}*.tex \
	fig/*.pdf

arxiv: figures
	rm -f 'arxiv.zip'
	$(eval TMP := $(shell mktemp -d))
	cp -r $(TARGET).tex \
		$(TARGET).bbl \
		aliascnt.sty remreset.sty llncs.cls splncs03.bst \
		$(TARGET).sty \
		sec \
		fig \
		$(TMP)/
	cd $(TMP) ; \
		sed -r \
		-e 's/^\%.*$$/\%/g' \
		-e 's/^(([^%]|\\%)*[^\])%.*$$/\1\%/g' \
		-i {,**/}*.tex $(TARGET).sty ; \
		zip -r 'arxiv.zip' \
		$(TARGET).tex \
		$(TARGET).bbl \
		aliascnt.sty remreset.sty llncs.cls splncs03.bst \
		$(TARGET).sty \
		sec/{,**/}*.tex \
		fig/*.pdf
	cp {$(TMP),.}/arxiv.zip
	rm -r $(TMP)

conf: all
	rm -f '$(TARGET).zip'
	zip -r '$(TARGET).zip' \
		$(TARGET).tex \
		$(TARGET).bib \
		aliascnt.sty remreset.sty llncs.cls splncs03.bst \
		$(TARGET).sty \
		sec/{,**/}*.tex \
		fig/*.pdf
		#fig/*.pdf \
		#$(TARGET)-author-agreement.pdf

