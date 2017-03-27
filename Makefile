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
	cp $(LIB_SRC_DIR)/$(LIB_SRC_NAME_DIR).tex $(LIB_SRC_NAME_DIR).w
	nuweb $(LIB_SRC_NAME_DIR).w

lib_pdf: $(LIB_SRC_DIR)/$(LIB_SRC_NAME_DIR).tex
	make lib_code
	
	pdflatex $(LIB_SRC_NAME_DIR).tex
	nuweb $(LIB_SRC_NAME_DIR).w
	pdflatex $(LIB_SRC_NAME_DIR).tex
	
lib_clean:
	-mv -fv $(LIB_SRC_NAME_DIR).pdf $(PDF_DIR)
	-rm -v $(LIB_SRC_NAME_DIR).*
	
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
	-rm -R $(PDF_DIR)/*
	-rm -Rf $(PKG_DIR)
