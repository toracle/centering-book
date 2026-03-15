DIST    := dist
BUNDLE  := $(or $(shell which bundle3.3 2>/dev/null),\
               $(shell which bundle 2>/dev/null),bundle)
FONTS   ?= $(or $(wildcard /usr/share/fonts/truetype/nanum),fonts)

.PHONY: all html pdf clean install-deps

all: html pdf

html:
	@mkdir -p $(DIST)
	$(BUNDLE) exec asciidoctor \
	  -a stylesdir=theme -a stylesheet=html-theme.css \
	  -a toc -a toclevels=1 \
	  -a icons=font -a source-highlighter=rouge \
	  -D $(DIST) -o index.html book.adoc
	@cp theme/html-theme.css $(DIST)/
	@echo "→ HTML: $(DIST)/index.html"

pdf:
	@mkdir -p $(DIST)
	$(BUNDLE) exec asciidoctor-pdf \
	  -a pdf-theme=theme/pdf-theme.yml \
	  -a "pdf-fontsdir=$(FONTS)" \
	  -o $(DIST)/book.pdf book.adoc
	@echo "→ PDF:  $(DIST)/book.pdf"

clean:
	rm -rf $(DIST)

install-deps:
	$(BUNDLE) install
