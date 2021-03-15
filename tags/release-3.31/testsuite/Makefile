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
# Directory with basics
BASEDIR ?= $(PWD)/../
TESTLOG = $(BASEDIR)testsuite/testsuite.log
BINDIR = $(BASEDIR)testsuite/bin
export TESTLOG BASEDIR BINDIR

# Load variable definitions
include $(BASEDIR)Makefile.baseinit

# Setup or load .PHONY
.PHONY: testlist clean_local maintainclean_local testtest testinit

-include Makefile.phony

# List of directories with the tests
# Note: There has to be exactly one tspec file at each test directory.
#       This tspec file may be empty or may contain informations about
#       generation of the Makefile for the test. See Makefile.tspec for
#       more informations about this.
testdirs := $(patsubst %/,%,$(dir $(wildcard */*.tspec)))
ifneq ($(testdirs),)
    testdirsinit := $(foreach testdir,$(testdirs),$(testdir)-init)
endif

define make_recursive
	for dir in $(testdirs); do \
	    $(MAKE) -C $$dir $@ || exit $$?; \
	done
endef

# The rules
all: 	testinit testtest

testtest: testlist
	$(SRM)   $(TESTLOG)
	$(SECHO) " # Logfile of test run at $(ISODATE)" > $(TESTLOG)
	$(SECHO) " # Note: The first column of each line indicates wether the test was" >> $(TESTLOG)
	$(SECHO) " # successfull or not.  If there is a line with something else but a space at" >> $(TESTLOG)
	$(SECHO) " # the first column, a test was not succsessfull." >> $(TESTLOG)
	$(MAKE) alltests

clean_local: testlist
	$(MAKE) clean

clean:
	$(RM) testsuite.log
	$(make_recursive)

maintainclean_local: testlist
	$(MAKE) allclean

allclean:
	$(RM) Makefile.dep Makefile.phony
	$(make_recursive)

testinit: testlist
	$(MAKE) allinits

testlist: Makefile.phony Makefile.dep

Makefile.phony:
	$(SECHO) '# DO NOT CHANGE THIS FILE.' > Makefile.phony
	$(SECHO) '# You may use:' >> Makefile.phony
	$(SECHO) '#   make testlist' >> Makefile.phony
	$(SECHO) '# to recreate this file.' >> Makefile.phony
	$(SECHO) >> Makefile.phony
	$(SECHO) ".PHONY: all testtest testinit allinits alltests clean_local maintainclean_local \\" >> Makefile.phony
	$(SECHO) "        clean allclean \\" >> Makefile.phony
ifneq ($(testdirs),)
	$(SECHO) "        $(testdirs) \\" >> Makefile.phony
	$(SECHO) "        $(testdirsinit)" >> Makefile.phony
endif
	$(SECHO) >> Makefile.phony

Makefile.dep:
	$(SECHO) '# DO NOT CHANGE THIS FILE.' > Makefile.dep
	$(SECHO) '# You may use:' >> Makefile.dep
	$(SECHO) '#   make testlist' >> Makefile.dep
	$(SECHO) '# to recreate this file.' >> Makefile.dep
	$(SECHO) >> Makefile.dep
ifneq ($(testdirs),)
	$(SECHO) "$(testdirs):" >> Makefile.dep
	$(SECHO) '	$(MAKE) -C $$@ test' >> Makefile.dep
	$(SECHO) >> Makefile.dep
	$(SECHO) "$(testdirsinit):" >> Makefile.dep
	$(SECHO) '	$(MAKE) -C $$(@:-init=) init' >> Makefile.dep
endif

allinits: $(testdirsinit)

alltests: $(testdirs)

# Include the dependencies if available
-include Makefile.dep
