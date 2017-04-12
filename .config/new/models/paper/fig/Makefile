
figures=#figure1.pdf

all: $(figures) .updated

.updated:
	touch .updated

clean:
	rm -f $(figures) .updated

#figure1.pdf: figures.ipe
	#ipetoipe -pdf -export -view 1-1 figures.ipe figure1.pdf
	#touch .updated
