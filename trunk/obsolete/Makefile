#
# Makefile to generate the obsolete packages and distributions
#

DTX_FILES = scrlettr.dtx scrpage-obsolete.dtx
INS_FILES = scrlettr.ins scrpage-obsolete.dtx

DOC_FILES = scrlettr.pdf scrpage.pdf

SOURCE_FILES = $(DTX_FILES) $(INS_FILES) README

LATEX_FILES = scrlettr.cls scrpage.sty

DIST_FILES = $(SOURCE_FILES) $(DOC_FILES) $(LATEX_FILES)
CTAN_FILES = $(SOURCE_FILES) $(DOC_FILES)

LC_ALL = C
RELEASE     = $(shell LC_ALL=C svn info -R . | grep '^Last Changed Rev:' | cut -d' ' -f 4 | sort -nu | tail -1 )
RELEASEDATE = $(shell LC_ALL=C svn info -R . | grep '^Last Changed Date:' | sort -u | tail -1 | cut -b20-29)

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

dist-ctan: $(DIST_FILES)
	mkdir koma-script-obsolete-$(shell date -I)
	cp -f $(CTAN_FILES) koma-script-obsolete-$(shell date -I)
	zip -r koma-script-obsolete-$(shell date -I)-ctan.zip \
	    koma-script-obsolete-$(shell date -I)
	rm -r texmf koma-script-obsolete-$(shell date -I)

dist-tds: $(DIST_FILES)
	mkdir -p texmf/tex/latex/koma-script-obsolete/
	cp $(LATEX_FILES) texmf/tex/latex/koma-script-obsolete/
	mkdir -p texmf/doc/latex/koma-script-obsolete/
	cp $(DOC_FILES) texmf/doc/latex/koma-script-obsolete/
	mkdir -p texmf/source/latex/koma-script-obsolete/
	cp $(SOURCE_FILES) texmf/source/latex/koma-script-obsolete/
	sed -e "s|VERSION WILL BE REPLACED WHILE RELEASE PROCESS|$(RELEASEDATE) r$(RELEASE)|" README > texmf/doc/latex/koma-script-obsolete/README
	cp texmf/doc/latex/koma-script-obsolete/README \
	   texmf/source/latex/koma-script-obsolete/README
	cd texmf && \
	zip -r ../koma-script-obsolete-$(RELEASEDATE).tds.zip .
	rm -r texmf

help:
	@echo "all:       generate all files"
	@echo "clean:     remove all generated files and the temporary files and folders"
	@echo "dist-ctan: generate a CTAN distribution of KOMA-Script obsolete"
	@echo "dist-tds:  generate the TDS distribution of KOMA-Script obsolete"
