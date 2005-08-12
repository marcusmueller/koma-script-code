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
# Directory with basics
BASEDIR	= ../

# ----------------------------------------------------------------------
# All directories with Makefiles
SUBDIRS = german

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
