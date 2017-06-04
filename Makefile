# Makefile for larlib.jl

SRC_DIR=./src/tex

DOC_DIR = ./doc
PDF_DIR = $(DOC_DIR)/pdf

CODE_DIR = ./lib/jl
TEST_DIR = ./test/jl

PKG_DIR = ./pkg

LIB_SRC_DIR = $(SRC_DIR)/pkg
LIB_SRC_NAME_DIR = larlib

all: lib

lib: lib_pdf lib_clean

lib_code:
	cp $(LIB_SRC_DIR)/*.tex ./
	cp $(LIB_SRC_DIR)/*.bib ./
	for f in *.tex; do mv -- "$$f" "$${f%.tex}.w"; done
	for f in *.w; do nuweb -n $$f; done

lib_pdf: $(LIB_SRC_DIR)/*.tex
	make lib_code
	
	for f in *.tex; do pdflatex $$f; done
	for f in *.w; do nuweb -n $$f; done
	for f in *.aux; do bibtex $$f; done
	for f in *.tex; do pdflatex $$f; done
	for f in *.tex; do pdflatex $$f; done
	
lib_clean:
	-mv -fv *.pdf $(PDF_DIR)
	-rm -v *.tex *.w *.aux *.log *.out *.toc *.bib *.bbl *.blg
	
test:

pkg: lib test
	$(eval VERSION := $(shell cat ./VERSION))
	git clone https://github.com/cvdlab/larlib.jl $(PKG_DIR)
	cp -Rf $(CODE_DIR)/* $(PKG_DIR)/src/
	cp -Rf $(PDF_DIR)/* $(PKG_DIR)/doc/
	#cp -Rf $(TEST_DIR)/* $(PKG_DIR)/test/
	cd $(PKG_DIR); \
	    git add --all; \
	    git commit -m "Version $(VERSION)"; \
	    git push    
	make clean

clean: lib_clean
	-rm -R $(CODE_DIR)/*
	-rm -R $(TEST_DIR)/*
	-rm -R $(PDF_DIR)/*
	-rm -Rf $(PKG_DIR)
