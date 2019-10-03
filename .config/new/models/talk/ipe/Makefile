.PHONY: all clean

all: talk.pdf
	killall -HUP mupdf || true

talk.pdf: talk.ipe
	ipetoipe -pdf -export talk.ipe talk.pdf

clean:
	rm talk.pdf
