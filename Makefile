.PHONY : test bst doc clean all inst install distclean zip FORCE_MAKE

NAME = gbt-7714-2015
PKGFILES = $(NAME).sty
BSTFILES = $(NAME)-numerical.bst $(NAME)-author-year.bst $(NAME)-bachelor.bst
TEST_DIR = test

SHELL = bash
LATEXMK = latexmk -xelatex -halt-on-error -interaction=nonstopmode
VERSION = $(shell cat $(NAME).dtx | egrep -o "\[\d\d\d\d/\d\d\/\d\d v.+\]" \
	  | egrep -o "v\S+")
LOCAL = $(shell kpsewhich --var-value TEXMFLOCAL)
UTREE = $(shell kpsewhich --var-value TEXMFHOME)

test : inst FORCE_MAKE
	$(MAKE) -C $(TESTDIR) test

all : test doc

bst : $(PKGFILES) $(BSTFILES)

doc : $(NAME).pdf

$(PKGFILES) $(BSTFILES) : $(NAME).dtx
	xetex $<

$(NAME).pdf : $(NAME).dtx FORCE_MAKE
	$(LATEXMK) -xelatex -halt-on-error -interaction=nonstopmode $<

clean :
	$(LATEXMK) -c $(NAME).dtx
	$(MAKE) -C $(TEST_DIR) clean

distclean :
	$(LATEXMK) -C $(NAME).dtx
	$(MAKE) -C $(TEST_DIR) distclean

inst : bst
	mkdir -p $(UTREE)/tex/latex/$(NAME)
	mkdir -p $(UTREE)/bibtex/bst/$(NAME)
	cp $(BSTFILES) $(UTREE)/bibtex/bst/$(NAME)
	cp $(PKGFILES) $(UTREE)/tex/latex/$(NAME)

install : bst doc
	mkdir -p $(LOCAL)/{doc,source,tex}/latex/$(NAME)
	mkdir -p $(LOCAL)/bibtex/bst/$(NAME)
	cp $(BSTFILES) $(LOCAL)/bibtex/bst/$(NAME)
	cp $(NAME).pdf $(LOCAL)/doc/latex/$(NAME)
	cp $(NAME).dtx $(LOCAL)/source/latex/$(NAME)
	cp $(PKGFILES) $(LOCAL)/tex/latex/$(NAME)

zip : bst doc
	ln -sf . $(NAME)
	zip -rq ../$(NAME).zip $(NAME)/{$(NAME).{dtx,pdf} ustc*.bst README.md \
	main.tex ustcextra.sty bib chapters figures .latexmkrc Makefile}
	rm $(NAME)
