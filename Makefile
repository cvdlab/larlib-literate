# Makefile for larlib.jl

SRC_DIR = ./src/tex

DOC_DIR = ./doc
PDF_DIR = $(DOC_DIR)/pdf

LIB_DIR = ./lib/jl

PKG_DIR = $(SRC_DIR)/pkg
PKG_NAME = larlib

all:
	make pkg

pkg:
	make pkg_pdf
	make pkg_clean

pkg_code:
	cp $(PKG_DIR)/$(PKG_NAME).tex $(PKG_NAME).w
	nuweb $(PKG_NAME).w

pkg_pdf: $(PKG_DIR)/$(PKG_NAME).tex
	make pkg_code
	
	pdflatex $(PKG_NAME).tex
	nuweb $(PKG_NAME).w
	pdflatex $(PKG_NAME).tex
	
pkg_clean:
	-mv -fv $(PKG_NAME).pdf $(PDF_DIR)
	-rm -v $(PKG_NAME).*
	
clean:
	make pkg_clean
	-rm -R $(LIB_DIR)/*
	-rm -R $(PDF_DIR)/*
