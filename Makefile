# ======================================================================
# Makefile
# Copyright (c) Markus Kohm, 2002-2006
#
# This file is part of the LaTeX2e KOMA-Script bundle.
#
# This work may be distributed and/or modified under the conditions of
# the LaTeX Project Public License, version 1.3b of the license.
# The latest version of this license is in
#   http://www.latex-project.org/lppl.txt
# and version 1.3b or later is part of all distributions of LaTeX 
# version 2005/12/01 or later and of this work.
#
# This work has the LPPL maintenance status "author-maintained".
#
# The Current Maintainer and author of this work is Markus Kohm.
#
# This work consists of all files listed in manifest.txt.
# ----------------------------------------------------------------------
# Makefile
# Copyright (c) Markus Kohm, 2002-2006
#
# Dieses Werk darf nach den Bedingungen der LaTeX Project Public Lizenz,
# Version 1.3b, verteilt und/oder veraendert werden.
# Die neuste Version dieser Lizenz ist
#   http://www.latex-project.org/lppl.txt
# und Version 1.3b ist Teil aller Verteilungen von LaTeX
# Version 2005/12/01 oder spaeter und dieses Werks.
#
# Dieses Werk hat den LPPL-Verwaltungs-Status "author-maintained"
# (allein durch den Autor verwaltet).
#
# Der Aktuelle Verwalter und Autor dieses Werkes ist Markus Kohm.
# 
# Dieses Werk besteht aus den in manifest.txt aufgefuehrten Dateien.
# ======================================================================

# ----------------------------------------------------------------------
# All directories with Makefiles
export BASEDIR ?= $(PWD)/
SUBDIRS = doc
# ----------------------------------------------------------------------
# Load common rules
include Makefile.baserules
# Load variable definitions
include Makefile.baseinit
# ----------------------------------------------------------------------
# Temporary folder, used to create distribution.
# Same folder with postfix "-maintain" will be used to create maintain-
# distribution.
export DISTDIR	   := $(PWD)/koma-script-$(ISODATE)
export MAINTAINDIR := $(DISTDIR)-maintain
# ----------------------------------------------------------------------

# ----------------------------------------------------------------------
# More than once used:
# Make implementation documentation
define makedvifromdtx
	if ! $(LATEX) $(NONSTOPMODE) $(DVIOUTPUT) $<; then \
	    $(RM) -v $@; \
	    exit 1; \
	fi
        oncemore=true; \
        checksum=`$(CKSUM) $(basename $<).aux`; \
        while $$oncemore; \
	do \
	    if ! $(MKINDEX) $(basename $<) \
	       || ! $(LATEX) $(NONSTOPMODE) $(DVIOUTPUT) $<; then \
	        $(RM) -v $@; \
	        exit 1; \
	    fi; \
	    $(GREP) Rerun $(basename $<).log || oncemore=false; \
	    newchecksum=`$(CKSUM) $(basename $<).aux`; \
	    [ "$$newchecksum"="$$checksum" ] || oncemore=true; \
	    checksum="$$newchecksum"; \
	done
endef
# ----------------------------------------------------------------------

# ----------------------------------------------------------------------
# List of all Makefiles
MAKE_FILES	= Makefile Makefile.baserules Makefile.baseinit
# ----------------------------------------------------------------------
# make classes, packages, etc.
INS_TEMPLATES	= scrstrip.inc \
		  scrstrop.inc

CLS_MAIN	= scrbook.cls \
		  scrreprt.cls \
		  scrartcl.cls \
		  scrlttr2.cls \
	          scrlettr.cls \
		  typearea.sty \
		  scrlfile.sty \
		  scrkbase.sty \
		  scraddr.sty \
		  scrpage.sty \
		  scrpage2.sty \
	          DIN.lco \
		  DINmtext.lco \
		  SN.lco \
	 	  SNleft.lco \
		  KOMAold.lco

CLS_MAIN_DTX    = scrbeta.dtx \
		  scrkbase.dtx \
		  scrkbib.dtx \
		  scrkcile.dtx \
		  scrkcomp.dtx \
		  scrkfloa.dtx \
		  scrkfont.dtx \
		  scrkftn.dtx \
		  scrkidx.dtx \
		  scrklang.dtx \
		  scrklco.dtx \
		  scrkliof.dtx \
		  scrklist.dtx \
		  scrkmisc.dtx \
		  scrknpap.dtx \
		  scrkpage.dtx \
		  scrkpar.dtx \
		  scrkplen.dtx \
		  scrksect.dtx \
		  scrktare.dtx \
		  scrktitl.dtx \
		  scrkvars.dtx \
		  scrkvers.dtx \
		  scrlfile.dtx \
		  scraddr.dtx \
		  scrpage.dtx \
		  scrlettr.dtx \
		  scrlogo.dtx

CLS_MAIN_DVI	= scrsource.dvi

CLS_MAIN_INS	= scrmain.ins

CLS_MAIN_SUBINS	= scrlfile.ins scraddr.ins scrlettr.ins

CLS_MAIN_SRC	= $(CLS_MAIN_DTX) $(CLS_MAIN_INS) $(CLS_MAIN_SUBINS) \
		  scrsource.tex

$(CLS_MAIN): $(CLS_MAIN_DVI) $(CLS_MAIN_INS) $(INS_TEMPLATES) $(MAKE_FILES)
	$(TEXUNPACK) $(CLS_MAIN_INS)

scrsource.dvi: scrsource.tex $(CLS_MAIN_DTX) $(MAKE_FILES) scrdoc.cls
	$(makedvifromdtx)

scrdoc.cls: scrdoc.dtx
	$(SSYMLINK) scrdoc.dtx scrdoc.cls

# ----------------------------------------------------------------------
CLS_FILES	= scrdoc.cls $(CLS_MAIN)

CLS_DVIS	= $(CLS_MAIN_DVI)

CLS_SRC		= $(CLS_MAIN_SRC)

NODIST_GENERATED = $(CLS_DVIS) $(CLS_FILES)

GENERATED	= $(NODIST_GENERATED)

MISC_SRC	= $(INS_TEMPLATES) $(MAKE_FILES) \
                  scrdoc.dtx ChangeLog ChangeLog.2

DIST_SRC	= $(MISC_SRC) $(CLS_SRC)

DIST_FILES	= $(DIST_SRC)

MAINTAIN_SRC    = $(DIST_SRC) template.sh missing.dtx .cvsignore

MAINTAIN_FILES  = $(MAINTAIN_SRC)
# ----------------------------------------------------------------------

# ----------------------------------------------------------------------
# local rules
default_local: test_baseinit $(CLS_FILES)

install_local: test_baseinit $(DIST_SRC) $(CLS_FILES)
	@if ! $(MKDIR) $(INSTALLSRCDIR) || ! $(MKDIR) $(INSTALLCLSDIR); then \
	    echo '--------------------------------------------------'; \
	    echo '| Cannot install to' $(INSTALLSRCDIR) or $(INSTALLCLSDIR)!; \
	    echo '| You should try:'; \
	    echo '|     su -c "make install"'; \
	    echo '--------------------------------------------------'; \
	    exit 1; \
	fi
	$(INSTALL) $(DIST_SRC) $(INSTALLSRCDIR)
	$(INSTALL) $(CLS_FILES) $(INSTALLCLSDIR)
	$(SECHO) ------------------------------------------------------------
	$(SECHO) Installed files at $(INSTALLSRCDIR):
	$(SECHO) $(DIST_SRC)
	$(SECHO) ------------------------------------------------------------
	$(SECHO) Installed files at $(INSTALLCLSDIR):
	$(SECHO) $(CLS_FILES)
	$(SECHO) ------------------------------------------------------------

uninstall_local:
	@if [ -d $(INSTALLSRCDIR) ]; then \
	    $(RM) -v $(foreach file,$(DIST_SRC),$(INSTALLSRCDIR)/$(file)); \
	    if [ ls $(INSTALLSRCDIR) > /dev/null 2>&1; then \
	        $(RMDIR) -v $(INSTALLSRCDIR); \
	    else \
	        echo "$(INSTALLSRCDIR) not empty!"; \
	    fi; \
	else \
	    echo "$(INSTALLSRCDIR) not found --> nothing to uninstall!"; \
	fi
	@if [ -d $(INSTALLCLSDIR) ]; then \
	    $(RM) -v $(foreach file,$(CLS_FILES),$(INSTALLCLSDIR)/$(file)); \
	    if ls $(INSTALLCLSDIR) > /dev/null 2>&1; then \
	        $(RMDIR) -v $(INSTALLCLSDIR); \
	    else \
	        echo "$(INSTALLCLSDIR) not empty!"; \
	    fi; \
	else \
	    echo "$(INSTALLCLSDIR) not found --> nothing to uninstall!"; \
	fi

clean_local:
	$(SRM) *~ $(CLEANEXTS)

distclean_local: clean_local
	$(SRM) $(NODIST_GENERATED)

maintainclean_local: clean_local
	$(SRM) $(GENERATED)

dist_prior:
	-$(RMDIR) $(DISTDIR)
	$(MKDIR) $(DISTDIR)

dist_local:
	$(CP) $(DIST_FILES) $(DISTDIR)

dist_post:
	$(TARGZ) $(DISTDIR).tar.gz $(notdir $(DISTDIR))
	$(RMDIR) $(DISTDIR)
	$(LL) $(notdir $(DISTDIR)).tar.gz

dist-bz2_post:
	$(STARBZ) $(DISTDIR).tar.bz2 $(notdir $(DISTDIR))
	$(SRMDIR) $(DISTDIR)
	$(SLL) $(notdir $(DISTDIR)).tar.bz2

dist-zip_post:
	$(SZIP) $(DISTDIR).zip $(notdir $(DISTDIR))
	$(SRMDIR) $(DISTDIR)
	$(SLL) $(notdir $(DISTDIR)).zip

maintain_prior:
	-$(RMDIR) $(MAINTAINDIR)
	$(MKDIR) $(MAINTAINDISTDIR)

maintain_local:
	$(CP) $(MAINTAIN_FILES) $(MAINTAINDIR)

maintain_post:
	$(TARGZ) $(MAINTAINDIR).tar.gz $(notdir $(MAINTAINDIR))
	$(RMDIR) $(MAINTAINDIR)
	$(LL) $(notdir $(MAINTAINDIR)).tar.gz

maintain-bz2_post:
	$(STARBZ) $(MAINTAINDIR).tar.bz2 $(notdir $(MAINTAINDIR))
	$(SRMDIR) $(MAINTAINDIR)
	$(SLL) $(notdir $(MAINTAINDIR)).tar.bz2

maintain-zip_post:
	$(SZIP) $(MAINTAINDIR).zip $(notdir $(MAINTAINDIR))
	$(SRMDIR) $(MAINTAINDIR)
	$(SLL) $(notdir $(MAINTAINDIR)).zip
# ----------------------------------------------------------------------
