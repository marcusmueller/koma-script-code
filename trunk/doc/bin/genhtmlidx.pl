#! /usr/bin/perl -w
eval 'exec perl -S $0 ${1+"$@"}'
    if 0; #$running_under_some_shell

# ======================================================================
# genhtmlidx.pl
# Copyright (c) Markus Kohm, 2002-2005
#
# This file is part of the LaTeX2e KOMA-Script-Bundle
#
# This file can be redistributed and/or modified under the terms
# of the LaTeX Project Public License Version 1.0 distributed
# together with this file. See LEGAL.TXT or LEGALDE.TXT.
#
# This bundle is written specialy for use at german-language. So the
# main documentation is german. There is also a english documentation,
# but this is NOT up-to-date.
# ----------------------------------------------------------------------
# genindex.pl
# Copyright (c) Markus Kohm, 2002-2005
#
# Diese Datei ist Teil des LaTeX2e KOMA-Script-Pakets.
#
# Diese Datei kann nach den Regeln der LaTeX Project Public
# Licence Version 1.0, wie sie zusammen mit dieser Datei verteilt
# wird, weiterverbreitet und/oder modifiziert werden. Siehe dazu
# auch LEGAL.TXT oder LEGALDE.TXT.
#
# Dieses Paket ist fuer den deutschen Sprachraum konzipiert. Daher ist
# auch diese Anleitung komplett in Deutsch. Zwar existiert auch eine
# englische Version der Anleitung, diese hinkt der deutschen Anleitung
# jedoch fast immer hinterher.
# ======================================================================
# This perl script generates a html file with an index using the
# \newlabel entries at the aux files.
#
# Usage: genhtmlidx.pl <aux-file> ...
# ----------------------------------------------------------------------
# Dieses perl-Script erzeugt aus den \newlabel-Eintraegen der 
# aux-Dateien eine html-Datei mit einer Art Index.
#
# Verwendung: genhtmlidx.pl <aux-file> ...
# ======================================================================

use strict;

my $auxfile;
my @option;
my @macro;
my @environment;
my @plength;
my @variable;
my @pagestyle;
my @counter;
my @floatstyle;

my $baselink;
my $htmlhead;
my $htmlend;
my %titles;

my $setup="";
open SETUP,"<htmlsetup" || die "Cannot open htmlsetup!\n";
while (<SETUP>) {
    $setup .= $_;
}
close SETUP;
eval $setup;

while ( $auxfile=shift ) {
    open AUX,"<$auxfile" or die "Cannot read $auxfile!\n";
    while (<AUX>) {
	my $line=$_;
	if ( /^\\newlabel{desc:[^}]+}{{[^}]*}{([^}]*)}{[^}]*}{([^}]*)}/ ) {
	    my $anchor=$2;
	    my $page=$1;
	    my $entry;
	    if ( $anchor =~ /^([^.]+)\.([^.]+)\.([^.]+)$/ ) {
		$entry = "$3.$page.$1.$2";
		if ( "$2" eq "option" ) {
		    push @option,$entry;
		} elsif ( "$2" eq "macro" ) {
		    push @macro,$entry;
		} elsif ( "$2" eq "environment" ) {
		    push @environment,$entry;
		} elsif ( "$2" eq "plength" ) {
		    push @plength,$entry;
		} elsif ( "$2" eq "variable" ) {
		    push @variable,$entry;
		} elsif ( "$2" eq "pagestyle" ) {
		    push @pagestyle,$entry;
		} elsif ( "$2" eq "counter" ) {
		    push @counter,$entry;
		} elsif ( "$2" eq "floatstyle" ) {
		    push @floatstyle,$entry;
		} else {
		    print STDERR "Unknown type $2!\n";
		}
	    }
	}
    }
    close AUX;
}

sub process {
    my $group=shift;
    my $prefix=shift;
    my $arrayref=shift;
    my @entries=sort { $a cmp $b } @$arrayref;
    my $entry="";
    if ( @entries > 0 ) {
	print "<h2><a name=\"$group\">$titles{$group}</a></h2>\n";
	print "<ul>\n";
	map {
	    $_ =~ /^([^.]+)\.([^.]+)\.([^.]+)\.([^.]+)$/;
	    if ( $entry ne $1 ) {
		print "</li>\n" if ( $entry ne "" );
		$entry=$1;
		print "<li><a name=\"$4.$entry\"></a><a href=\"\#$4.$entry\">$prefix$entry</a> --&gt; ";
	    } else {
		print ", ";
	    }
	    print "<a href=\"$baselink\#$3.$4.$1\">$2</a>";
	} @entries;
	print "</li>\n" if ( $entry ne "" );
	print "</ul>\n";
    }
}

print $htmlhead;

print "<ul>\n";
print "<li><a href=\"#option\">$titles{option}</a></li>" if ( @option );
print "<li><a href=\"#macro\">$titles{macro}</a></li>" if ( @macro );
print "<li><a href=\"#environment\">$titles{environment}</a></li>" if ( @environment );
print "<li><a href=\"#plength\">$titles{plength}</a></li>" if ( @plength );
print "<li><a href=\"#variable\">$titles{variable}</a></li>" if ( @variable );
print "<li><a href=\"#pagestyle\">$titles{pagestyle}</a></li>" if ( @pagestyle );
print "<li><a href=\"#counter\">$titles{counter}</a></li>" if ( @counter );
print "<li><a href=\"#floatstyle\">$titles{floatstyle}</a></li>" if ( @floatstyle );
print "</ul>\n";

process "option","",\@option;
process "macro","\\",\@macro;
process "environment","",\@environment;
process "plength","",\@plength;
process "variable","",\@variable;
process "pagestyle","",\@pagestyle;
process "counter","",\@counter;
process "floatstyle","",\@floatstyle;
print $htmlend;
