# ======================================================================
# Makefile
# Copyright (c) Markus Kohm, 2002-2005
#
# This file is part of the LaTeX2e KOMA-Script-Bundle
#
# This file can be redistributed and/or modified under the terms
# of the LaTeX Project Public License Version 1.0 distributed
# together with this file. See LEGAL.TXT or LEGALDE.TXT.
# ----------------------------------------------------------------------
# Makefile
# Copyright (c) Markus Kohm, 2002-2005
#
# Diese Datei ist Teil des LaTeX2e KOMA-Script-Pakets.
#
# Diese Datei kann nach den Regeln der LaTeX Project Public
# Licence Version 1.0, wie sie zusammen mit dieser Datei verteilt
# wird, weiterverbreitet und/oder modifiziert werden. Siehe dazu
# auch LEGAL.TXT oder LEGALDE.TXT.
# ======================================================================

# ----------------------------------------------------------------------
# All directories with Makefiles
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
		  typearea.sty \
		  scrlfile.sty \
		  scrkbase.sty

CLS_MAIN_DTX    = scrbeta.dtx \
		  scrkbase.dtx \
		  scrkbib.dtx \
		  scrkfloa.dtx \
		  scrkfont.dtx \
		  scrkftn.dtx \
		  scrkidx.dtx \
		  scrklang.dtx \
		  scrkliof.dtx \
		  scrklist.dtx \
		  scrkmisc.dtx \
		  scrkpage.dtx \
		  scrkpar.dtx \
		  scrksect.dtx \
		  scrktare.dtx \
		  scrktitl.dtx \
		  scrkvers.dtx \
		  scrlfile.dtx \
		  scrlogo.dtx

CLS_MAIN_DVI	= scrsource.dvi

CLS_MAIN_INS	= scrmain.ins

CLS_MAIN_SUBINS	= scrlfile.ins

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
