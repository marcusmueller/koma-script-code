#
# Makefile to generate the obsolete packages and distributions
#

DTX_FILES = scrlettr.dtx scrpage-obsolete.dtx
INS_FILES = scrlettr.ins scrpage-obsolete.dtx

DOC_FILES = scrlettr.pdf scrpage.pdf

SOURCE_FILES = $(DTX_FILES) $(INS_FILES) README

LATEX_FILES = scrlettr.cls scrpage.sty

DIST_FILES = $(DTX_FILES) $(INS_FILES) $(DOC_FILES) $(LATEX_FILES)
CTAN_FILES = $(DTX_FILES) $(INS_FILES) $(DOC_FILES)

all: $(DIST_FILES)

scrlettr.pdf: scrlettr.dtx
	pdflatex -draftmode -interaction=batchmode $<
	mkindex scrlettr
	pdflatex -interaction=batchmode $<

scrpage.pdf: scrpage-obsolete.dtx
	pdflatex -draftmode -interaction=batchmode $<
	mkindex scrpage
	pdflatex -interaction=batchmode $<
	mv -f scrpage-obsolete.pdf scrpage.pdf

scrlettr.cls: scrlettr.pdf scrlettr.ins
	tex scrlettr.ins

scrpage.sty: scrpage-obsolete.dtx
	tex scrpage-obsolete.dtx

clean:
	rm -f $(DOC_FILES) $(LATEX_FILES) \
	      *.aux *.dvi *.cls *.idx *.log *.toc *.glo *.gls *.ilg *.ind
	rm -rf texmf koma-script-obsolete-????-??-??

dist:   $(DIST_FILES)
	mkdir koma-script-obsolete-$(shell date -I)
	cp -f $(CTAN_FILES) koma-script-obsolete-$(shell date -I)

	mkdir -p texmf/tex/latex/koma-script-obsolete/
	cp $(LATEX_FILES) texmf/tex/latex/koma-script-obsolete/
	mkdir -p texmf/doc/latex/koma-script-obsolete/
	cp $(DOC_FILES) README texmf/doc/latex/koma-script-obsolete/
	mkdir -p texmf/source/latex/koma-script-obsolete/
	cp $(SOURCE_FILES) texmf/source/latex/koma-script-obsolete/

	zip -r koma-script-$(shell date -I).tds.zip texmf

	zip -r koma-script-obsolete-$(shell date -I)-ctan.zip \
	    koma-script-obsolete-$(shell date -I) \
	    koma-script-$(shell date -I).tds.zip

	rm -f koma-script-$(shell date -I).tds.zip
	rm -r texmf koma-script-obsolete-$(shell date -I)

help:
	@echo "all:   generate all files"
	@echo "clean: remove all generated files and the temporary files and folders"
	@echo "dist:  generate a CTAN distribution of KOMA-Script obsolete"
