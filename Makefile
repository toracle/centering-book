DIST       := dist
BUNDLE     := $(or $(shell which bundle3.3 2>/dev/null),\
                   $(shell which bundle 2>/dev/null),bundle)
FONTS      ?= fonts
FONT_STAMP := fonts/NotoSerifKR-Regular.ttf

.PHONY: all html pdf fonts clean install-deps

all: html pdf

fonts: $(FONT_STAMP)

$(FONT_STAMP): scripts/generate-fonts.sh
	bash scripts/generate-fonts.sh

html:
	@mkdir -p $(DIST)
	$(BUNDLE) exec asciidoctor \
	  -a stylesdir=theme -a stylesheet=html-theme.css \
	  -a toc -a toclevels=1 \
	  -a icons=font -a source-highlighter=rouge \
	  -D $(DIST) -o book.html book.adoc
	@cp theme/html-theme.css $(DIST)/
	@cp site/index.html $(DIST)/index.html
	@echo "→ HTML: $(DIST)/book.html"
	@echo "→ Index: $(DIST)/index.html"

pdf: $(FONT_STAMP)
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
