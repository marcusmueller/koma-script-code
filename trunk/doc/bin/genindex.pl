#! /usr/bin/perl -w
eval 'exec perl -S $0 ${1+"$@"}'
    if 0; #$running_under_some_shell

# ======================================================================
# genindex.pl 
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
# This perl scripts splits the index of scrguide or scrguien into
# several files, each with one index section.
#
# Usage: genindex.pl <ind-file>
#
# If <ind-file> has no extension ``.ind'', this extension will be added.
# ----------------------------------------------------------------------
# Dieses perl Script spaltet den Index des scrguide in mehrere getrennte
# Dateien auf, von denen jede jeweils einen Index-Abschnitt enthält.
#
# Verwendung: genindex.pl <ind-Datei>
#
# Wenn die <ind-Datei> ohne Endung ".ind" angegeben wird, so wird diese
# Endung automatisch angehängt. 
# ======================================================================

use strict;
use Fcntl;

my $indexinput = $ARGV[0];
my $indexbase;
my $line;
my $entry = "";
my %indfile;

$indexinput = "$indexinput.ind" if ( ! ( $indexinput =~ /^.*\.ind\z/ ) );
$indexbase = $1 if $indexinput =~ /^(.*)\.ind/;

print "Generate multiindex for $indexinput\n";

# pass 1: search for and open destination index files
open (IDX, "<$indexinput") ||
    die "Cannot open $indexinput for reading\n";
print "Search for index:\n";
while ( <IDX> ) {
    if ( /\\UseIndex *\{([^\}]*)\}/ ) {
	my $file;
	if ( !$indfile{"$1"} ) {
	    print "  Open new index $indexbase-$1.ind\n";
	    open ( $file, ">$indexbase-$1.ind" ) ||
		die "Cannot open $indexbase-$1.ind for writing\n";
	    $indfile{"$1"} = $file;
	}
    }
}
# we must have a general index
if ( !$indfile{"gen"} ) {
    print "  Open new index $indexbase-gen.ind\n" ;
    open ( $indfile{"gen"}, ">indexbase-gen.ind" ) ||
	die "Cannot open $indexbase-gen.ind for writing\n";
}

# pass 2: copy to destination index files
seek (IDX, 0, 0) ||
    die "Cannot rewind $indexinput\n";
print "Copy entries:\n";
# step 1: copy to every index file until first \indexsectione
while ( defined( ( $line = <IDX> ) )
	&& ( ! ( $line =~ /^( *\\indexsection *\{)/ ) ) )  {
    printtoallind( "$line" );
    $line = "";
}
# copy also \indexsection-line
printtoallind( "$line" );

# step 2: read complete \indexsection, \indexspace, \item, \subitem or
# \subsubitem and process it (= copy it to destination index files)
while ( $line = <IDX> ) {
    if ( $line =~ /^ *((\\indexsection|\\end) *\{|\\indexspace)/ ) {
	processentry( "$entry" );
	$entry = "";
	printtoallind( "$line" );
    } elsif ( $line =~ /^ *\\(sub(sub)?)?item +/ ) {
	processentry( "$entry" );
	$entry = $line;
    } else {
	$entry = "$entry$line";
    }
}

close (IDX);
closeallind ();

# post optimization of all destination index files
print "Optimize every index:\n";
optimizeallind ();

exit;

# close all destination index files
sub closeallind {
    my $name;
    my $file;
    while (($name,$file) = each %indfile) {
	print "  Close $indexbase-$name.ind\n" ;
	close ($file);
	$indfile{"$name"}=0;
    }
}

# optimize all destination index files
sub optimizeallind {
    my $name;
    my $file;
    while (($name,$file) = each %indfile) {
	print "  $indexbase-$name.ind\n";
	optimizeind( "$name" );
    }
}

# print arg 1 to all destination index files
sub printtoallind {
    my $line = shift;
    my $name;
    my $file;
    while (($name,$file) = each %indfile) {
	print ($file $line);
    }
}

# process an index entry (copy it to valid destination index files)
sub processentry {
    my $line = shift;
    my $file = $indfile{"gen"};
    if ( $line =~ /\\UseIndex *\{([^\}]*)\} *(.*)/ ) {
	$file = $indfile{"$1"};
	print ($file $line);
    } else {
	print ($file $line);
    }
}

# optimize an index files (remove \indexsection without \item)
sub optimizeind {
    my $idx = shift;
    my $interstuff = "";
    my $line;
    
    open (IN, "<$indexbase-$idx.ind" ) ||
	die "Cannot open $indexbase-$idx.ind for reading";
    open (OUT, ">$indexbase-$idx.new" ) ||
	die "Cannot open $indexbase-$idx.new for writing";

    while ( $line=<IN> ) {
	if ( $line =~ /^ *\\indexspace/ ) {
	    $interstuff = "\n$line";
	} elsif ( ( $line =~ /^ *\\indexsection *\{/ ) ||
		  ( $line =~ /^$/ ) ) {
	    $interstuff = "$interstuff$line";
	} else {
	    print (OUT $interstuff) if ( !( $interstuff =~ /^$/ ) 
			&& !( $line =~ /^ *\\end\{theindex\}/ ) );
	    $interstuff = "";
	    print (OUT $line);
	}
    }

    close (OUT);
    close (IN);
    unlink "$indexbase-$idx.ind" ||
	die "Cannot delete $indexbase-$idx.ind";
    rename "$indexbase-$idx.new", "$indexbase-$idx.ind" ||
	die "Cannot rename $indexbase-$idx.new to §indexbase-$idx.ind";
}
