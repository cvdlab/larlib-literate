# Makefile for larlib.jl

SRC_DIR=./src/tex

DOC_DIR = ./doc
PDF_DIR = $(DOC_DIR)/pdf

CODE_DIR = ./lib/jl
TEST_DIR = ./test/jl
EXAMPLES_DIR = ./examples/jl
LIBHELP_DIR = ./lib-utilities

PKG_DIR = ./pkg

LIB_SRC_DIR = $(SRC_DIR)/pkg
LIB_SRC_NAME_DIR = larlib

all: lib

lib: lib_pdf lib_clean

lib_code:
	cp $(LIB_SRC_DIR)/*.tex ./
	cp $(LIB_SRC_DIR)/*.bib ./
	mkdir img
	cp $(LIB_SRC_DIR)/img/*.pdf ./img/
	cp $(LIB_SRC_DIR)/img/*.png ./img/
	python tex_merger.py
	nuweb -n book

lib_pdf: $(LIB_SRC_DIR)/*.tex
	make lib_code
	
	pdflatex book
	nuweb -n book
	bibtex book
	pdflatex book
	pdflatex book
	
lib_clean:
	-mv -fv *.pdf $(PDF_DIR)
	-rm -Rv *.tex *.w *.aux *.log *.out *.toc *.bib *.bbl *.blg ./img
	
test:

pkg_docker:
	if test ! -z "$$INDOCKER"; then \
		echo $$PUSH_CREDENTIALS > /root/.git-credentials && \
		git config --global --replace-all credential.helper 'store' && \
		git config --global push.default simple && \
		git config --global user.email "$$GIT_AUTHOR_EMAIL" && \
  		git config --global user.name "$$GIT_AUTHOR_NAME" && \
		make pkg; \
	fi

pkg: lib test
	$(eval VERSION := $(shell cat ./VERSION))
	git clone https://github.com/cvdlab/larlib.jl $(PKG_DIR)
	cp -Rf $(CODE_DIR)/* $(PKG_DIR)/src/
	cp -Rf $(PDF_DIR)/* $(PKG_DIR)/doc/
	cp -Rf $(TEST_DIR)/* $(PKG_DIR)/test/
	cp -Rf $(EXAMPLES_DIR)/* $(PKG_DIR)/examples/
	cp -Rf $(LIBHELP_DIR)/* $(PKG_DIR)

	cd $(PKG_DIR) && git add --all && git commit -m "Version $(VERSION)" && git tag -a v$(VERSION) -m "Version $(VERSION)" && git push
	make clean	


clean: lib_clean
	-rm -R $(CODE_DIR)/*
	-rm -R $(TEST_DIR)/*
	-rm -R $(PDF_DIR)/*
	-rm -Rf $(PKG_DIR)

docker-all: 
	-docker run --rm -v $(PWD):/data furio/larlib-literate:latest make all

docker-lib_pdf: 
	-docker run --rm -v $(PWD):/data furio/larlib-literate:latest make lib_pdf

docker-lib_code: 
	-docker run --rm -v $(PWD):/data furio/larlib-literate:latest make lib_code

docker-lib_clean: 
	-docker run --rm -v $(PWD):/data furio/larlib-literate:latest make lib_clean	

docker-pkg:
	if test -z "$$PUSH_CREDENTIALS"; then \
		echo "Configure PUSH_CREDENTIALS env var before this command"; \
		exit 127; \
	else \
		if test -z "$$PUSH_AUTHOR_NAME"; then PUSH_AUTHOR_NAME=LarLib; fi; \
		if test -z "$$PUSH_AUTHOR_EMAIL"; then PUSH_AUTHOR_EMAIL=larlib@cvlab.org; fi; \
		docker run -e "INDOCKER=1" \
			-e "PUSH_CREDENTIALS=$$PUSH_CREDENTIALS" \
			-e "GIT_AUTHOR_NAME=$$PUSH_AUTHOR_NAME" -e "GIT_AUTHOR_EMAIL=$$PUSH_AUTHOR_EMAIL" \
			-v $(PWD):/data furio/larlib-literate:latest make pkg_docker; \
	fi
