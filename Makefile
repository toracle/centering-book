DIST       := dist
BUNDLE     := $(or $(shell which bundle3.3 2>/dev/null),\
                   $(shell which bundle 2>/dev/null),bundle)
FONTS      ?= fonts
FONT_STAMP := fonts/NotoSerifKR-Regular.ttf
THEME      := $(abspath theme)
META_URL   ?= https://toracle.github.io/books

.PHONY: all site html pdf fonts clean install-deps \
        html-en html-ko pdf-en pdf-ko

all: site

site: html pdf
	@cp site/index.html $(DIST)/index.html
	@mkdir -p $(DIST)/ko && cp site/ko/index.html $(DIST)/ko/index.html
	@echo "→ Site: $(DIST)/index.html (en), $(DIST)/ko/index.html (ko)"

html: html-en html-ko
pdf:  pdf-en pdf-ko

fonts: $(FONT_STAMP)

$(FONT_STAMP): scripts/generate-fonts.sh
	bash scripts/generate-fonts.sh

# ─── English (default) ───
html-en:
	@mkdir -p $(DIST)
	$(BUNDLE) exec asciidoctor \
	  -a stylesdir=. -a stylesheet=html-theme.css -a linkcss \
	  -a toc -a toclevels=1 \
	  -a icons=font -a source-highlighter=rouge \
	  -a docinfodir=$(THEME) \
	  -a nav-home-url=$(META_URL)/ \
	  -a nav-home-label="← All Books" \
	  -a lang-self=EN \
	  -a lang-other-url=ko/ \
	  -a lang-other-label="한국어" \
	  -D $(DIST) -o book.html contents/en/book.adoc
	@cp theme/html-theme.css $(DIST)/
	@echo "→ HTML EN: $(DIST)/book.html"

pdf-en: $(FONT_STAMP)
	@mkdir -p $(DIST)
	$(BUNDLE) exec asciidoctor-pdf \
	  -a pdf-theme=theme/pdf-theme.yml \
	  -a "pdf-fontsdir=$(FONTS)" \
	  -a allow-uri-read \
	  -o $(DIST)/book.pdf contents/en/book.adoc
	@echo "→ PDF  EN: $(DIST)/book.pdf"

# ─── Korean ───
html-ko:
	@mkdir -p $(DIST)/ko
	$(BUNDLE) exec asciidoctor \
	  -a stylesdir=. -a stylesheet=html-theme.css -a linkcss \
	  -a toc -a toclevels=1 \
	  -a icons=font -a source-highlighter=rouge \
	  -a docinfodir=$(THEME) \
	  -a nav-home-url=$(META_URL)/ko/ \
	  -a nav-home-label="← 책 목록" \
	  -a lang-self=KO \
	  -a lang-other-url=../ \
	  -a lang-other-label="English" \
	  -D $(DIST)/ko -o book.html contents/ko/book.adoc
	@cp theme/html-theme.css $(DIST)/ko/
	@echo "→ HTML KO: $(DIST)/ko/book.html"

pdf-ko: $(FONT_STAMP)
	@mkdir -p $(DIST)/ko
	$(BUNDLE) exec asciidoctor-pdf \
	  -a pdf-theme=theme/pdf-theme.yml \
	  -a "pdf-fontsdir=$(FONTS)" \
	  -a allow-uri-read \
	  -o $(DIST)/ko/book.pdf contents/ko/book.adoc
	@echo "→ PDF  KO: $(DIST)/ko/book.pdf"

clean:
	rm -rf $(DIST)

install-deps:
	$(BUNDLE) install
