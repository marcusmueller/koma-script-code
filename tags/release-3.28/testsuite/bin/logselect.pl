#! /usr/bin/perl -w
eval 'exec perl -S $0 ${1+"$@"}'
    if 0; #$running_under_some_shell

# ======================================================================
# logselect.pl
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
# logselect.pl
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
# This perl scripts selects all marked parts of the TeX log file.
# Marks are lines:
# [START COMPARE MARKER]
# [END COMPARE MARKER]
#
# Usage: logselect.pl <input-log-file> <output-log-file>
# ----------------------------------------------------------------------
# Dieses perl-Script nimmt all markierten Teile einer TeX-Log-Datei.
# Marken für die Markierung sind die Zeilen:
# [START COMPARE MARKER]
# [END COMPARE MARKER]
#
# Verwendung: logselect.pl <Eingabe-Log-Datei> <Ausgabe-Log-Datei>
# ======================================================================

use strict;

my $loginput=shift 
    or die "missing input log file!\n";
my $logoutput=shift
    or die "missing output log file!\n";
my $write;

if ( $loginput ne "-" ) {
    open STDIN,"<$loginput"
	or die "cannot open $loginput for input!\n";
}

if ( $logoutput ne "-" ) {
    open STDOUT,">$logoutput"
	or die "cannot create $logoutput!\n";
}

while ( <STDIN> ) {
    if ( $write ) {
	print $_
	    or die "errir writing $logoutput!\n";
	$write=0 if ( $_ eq "[END COMPARE MARKER]\n" );
    } else {
	if ( $_ eq "[START COMPARE MARKER]\n" ) {
	    $write = 1;
	    print $_
		or die "error writing $logoutput!\n";
	}
    }
}

close STDIN;

print "[END COMPARE MARKER]\n" if ( $write );

close STDOUT
    or die "error writing $logoutput!\n";

exit 0
