# ======================================================================
# Makefile
# Copyright (c) Markus Kohm, 2002-2006
#
# This file is part of the LaTeX2e KOMA-Script-Bundle
#
# This file can be redistributed and/or modified under the terms
# of the LaTeX Project Public License Version 1.0 distributed
# together with this file. See LEGAL.TXT or LEGALDE.TXT.
# ----------------------------------------------------------------------
# Makefile
# Copyright (c) Markus Kohm, 2002-2006
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
BASEDIR := ../$(BASEDIR)
TESTLOG := $(PWD)/testsuite.log
export TESTLOG

# Load variable definitions
include $(BASEDIR)Makefile.baseinit

# Setup or load .PHONY
.PHONY: testlist

-include Makefile.phony

# List of directories with the tests
# Note: There has to be exactly one tspec file at each test directory.
#       This tspec file may be empty or may contain informations about
#       generation of the Makefile for the test. See Makefile.tspec for
#       more informations about this.
testdirs = $(dir $(wildcard */*.tspec))
ifneq ($(testdirs),)
    testdirsinit := $(foreach testdir,$(testdirs),$testdir-init)
endif

# The rules
all: 	testlist
	$(SRM)   $(TESTLOG)
	$(SECHO) " # Logfile of test run at $(ISODATE)" > $(TESTLOG)
	$(SECHO) " # Note: The first column of each line indicates wether the test was" >> $(TESTLOG)
	$(SECHO) " # successfull or not.  If there is a line with something else but a space at" >> $(TESTLOG)
	$(SECHO) " # the first column, a test was not succsessfull." >> $(TESTLOG)
	$(MAKE) alltests

testinit: testlist
	$(MAKE) allinits

testlist: Makefile.phony Makefile.dep

Makefile.phony: $(testdirs)/*
	$(SECHO) '# DO NOT CHANGE THIS FILE.' > Makefile.phony
	$(SECHO) '# You may use:' >> Makefile.phony
	$(SECHO) '#   make testlist' >> Makefile.phony
	$(SECHO) '# to recreate this file.' >> Makefile.phony
	$(SECHO) >> Makefile.phony
	$(SECHO) ".PHONY: all testinit allinits alltests \\" >> Makefile.phony
ifneq ($(testdirs),)
	$(SECHO) "        $(testdirs) \\" >> Makefile.phony
	$(SECHO) "        $(testdirsinit)" >> Makefile.phony
endif
	$(SECHO) >> Makefile.phony

Makefile.dep: $(testdirs)/*
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
	$(SECHO) '       $(MAKE) -C $$(@:-init=) init' >> Makefile.dep
endif

allinits: $(testdirsinit)

alltests: $(testdirs)

# Include the dependencies if available
-include Makefile.dep
