
TARGET = paper

all: figures $(TARGET).pdf

figures:
	@make --no-print-directory -C fig all

$(TARGET).pdf: fig/.updated $(TARGET).tex $(TARGET).sty sec/* $(TARGET).bib
	pdflatex $(TARGET).tex -interaction=nonstopmode -halt-on-error
	bibtex $(TARGET)
	pdflatex $(TARGET).tex -interaction=nonstopmode -halt-on-error
	pdflatex $(TARGET).tex -interaction=nonstopmode -halt-on-error

clean:
	rm -f $(TARGET).{out,log,aux,pdf,bbl,blg,vtc}
	@make --no-print-directory -C fig clean

zip: all
	rm -f '$(TARGET).zip'
	zip -r '$(TARGET).zip' \
		$(TARGET).tex \
		$(TARGET).bib \
		$(TARGET).sty \
		sec/{,**/}*.tex \
		fig/*.pdf

eurocg17: all
	rm -f '$(TARGET).zip'
	zip -r '$(TARGET).zip' \
		$(TARGET).tex \
		$(TARGET).bib \
		$(TARGET).sty \
		sec/{,**/}*.tex \
		fig/*.pdf
		#fig/*.pdf \
		#$(TARGET)-author-agreement.pdf

