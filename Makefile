# Makefile for larlib.jl

SRC_DIR = ./src/tex

DOC_DIR = ./doc
PDF_DIR = $(DOC_DIR)/pdf

CODE_DIR = ./lib/jl

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
	
clean:
	make lib_clean
	-rm -R $(CODE_DIR)/*
	-rm -R $(PDF_DIR)/*
