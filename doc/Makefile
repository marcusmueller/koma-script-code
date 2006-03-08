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
# version 2005/12/01 and of this work.
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
# Version 1.3b.
# Die neuste Version dieser Lizenz ist
#   http://www.latex-project.org/lppl.txt
# und Version 1.3b ist Teil aller Verteilungen von LaTeX
# Version 2005/12/01 und dieses Werks.
#
# Dieses Werk hat den LPPL-Verwaltungs-Status "author-maintained"
# (allein durch den Autor verwaltet).
#
# Der Aktuelle Verwalter und Autor dieses Werkes ist Markus Kohm.
# 
# Dieses Werk besteht aus den in manifest.txt aufgefuehrten Dateien.
# ======================================================================

# ----------------------------------------------------------------------
# Directory with basics
BASEDIR	?= $(PWD)/../
export BASEDIR

# ----------------------------------------------------------------------
# All directories with Makefiles
SUBDIRS = german english

# ----------------------------------------------------------------------
# Default rules
.PHONY:	default clean default_local install_local \
	uninstall_local clean_local dist_local \
	distclean_local maintainclean_local

# Recursive make function
ifdef SUBDIRS
define make_recursive
	for dir in $(SUBDIRS); \
	do \
	    $(MAKE) -C $$dir $@ || exit $$?; \
	done
endef
else
define make_recursive
endef
endif

default: default_local

clean:	 clean_local

# Load variable definitions
include $(BASEDIR)Makefile.baseinit
include Makefile.latexinit

# Temporary folder, used to create distribution.
# Same folder with postfix "-maintain" will be used to create maintain-
# distribution.
ifdef DISTDIR
export DISTDIR := $(DISTDIR)/doc
endif
ifdef MAINTAINDIR
export MAINTAINDIR := $(MAINTAINDIR)/doc
endif
# ----------------------------------------------------------------------

# ----------------------------------------------------------------------
# List of all Makefiles
MAKE_FILES	= Makefile Makefile.latexinit Makefile.guide

# ----------------------------------------------------------------------
MISC_SRC	= $(MAKE_FILES)

DOC_SRC		= scrguide.cls scrguide.ist \
	          guide.tex guide.bib plength.dtx

DIST_SRC	= $(MISC_SRC) $(DOC_SRC)

DIST_FILES	= $(DIST_SRC)

MAINTAIN_FILES	= $(DIST_FILES)
# ----------------------------------------------------------------------

# ----------------------------------------------------------------------
# local rules
default_local:
	$(make_recursive)

install_local:
	$(make_recursive)

uninstall_local:
	$(make_recursive)

clean_local:
	$(make_recursive)

dist_local:
	-$(RMDIR) $(DISTDIR)
	$(MKDIR) $(DISTDIR)
	$(CP) $(DIST_FILES) $(DISTDIR)
	$(make_recursive)

maintain_local:
	-$(RMDIR) $(MAINTAINDIR)
	$(MKDIR) $(MAINTAINDIR)
	$(CP) $(MAINTAIN_FILES) $(MAINTAINDIR)
	$(make_recursive)

distclean_local:
	$(make_recursive)

maintainclean_local:
	$(make_recursive)

edit:
	$(EDITOR) guide.tex
