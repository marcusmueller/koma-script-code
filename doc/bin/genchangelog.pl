#! /usr/bin/perl -w
eval 'exec perl -S $0 ${1+"$@"}'
    if 0; #$running_under_some_shell

# ======================================================================
# genchangelog.pl
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
# genchangelog.pl
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
# This perl scripts generates a ChangeLog.svn using `svn log'.
#
# Usage: genchangelog.pl <basedir>
# ----------------------------------------------------------------------
# Dieses perl-Script erzeugt mit Hilfe von `svn log' ein ChangeLog.svn.
#
# Verwendung: genindex.pl <ind-Datei>
# ======================================================================

use strict;
use File::Find();
use File::Spec;
use POSIX qw(strftime);

my $linelengthlimit=78;
my $revrangeopt="";
my @allinfo;
my $basedir=shift;
my $ChangeLogFile=File::Spec->rel2abs(File::Spec->catfile($basedir,
							  "doc",
							  "ChangeLog.svn"));
my $NewChangeLogFile=File::Spec->rel2abs(File::Spec->catfile($basedir,
							     "doc",
							     "ChangeLog.tmp"));
my $firstrev=0;

sub printtext($);

checkchangelog();

File::Find::find({wanted => \&wanted, no_chdir => 1}, $basedir);

@allinfo = sort {
    $b->[0] <=> $a->[0]
} @allinfo;

open NCH,">$NewChangeLogFile"
    or die "Cannot create $NewChangeLogFile";

my $lastrev=0;
my $text;
my $linelength;

map {
    my @info = @$_;
    if ( $lastrev != $info[0] ) {
	$lastrev=$info[0];
	printtext(*NCH);
	$text=$info[5];
	print NCH "r$info[0] $info[2] $info[1]:\n\n";
	print NCH "\t* $info[4]";
	$linelength = 10 + length($info[4]);
    } else {
	if ( $linelength + 2 + length($info[4]) > $linelengthlimit - 2 ) {
	    print NCH ",\n";
	    print NCH "\t$info[4]";
	    $linelength = 8 + length($info[4]);
	} else {
	    print NCH ", $info[4]";
	    $linelength += 2 + length($info[4]);
	}
    }
} @allinfo;
printtext(*NCH);

close NCH;

exit;

sub printtext($) {
    my $out=shift;
    if ( $text ) {
	my @pars;
	print $out ":";
	$linelength += 1;
	map {
	    my $line = $_;
	    chomp($line);
	    if ( $linelength == 0 ) {
		print $out "\t  ";
		$linelength = 10;
	    }
	    if ( $linelength + length($line) + 1 <= $linelengthlimit ) {
		print $out " $line\n";
		$linelength = 0;
	    } else {
		my $indent;
		$line =~ /^( *)(.*)\z/;
		$indent=$1;
		$line=$2;
		if ( $indent ne "" ) {
		    print $out "\n";
		    $linelength=0;
		}
		map {
		    $linelength += length($_) + 1;
		    if ( $linelength <= $linelengthlimit ) {
			print $out " $_";
		    } else {
			$linelength = length($_) + length($indent) + 10;
			print $out "\n\t  $indent$_";
		    }
		} split / /,$line;
		print $out "\n";
	    }
	} split /\n/,$text;
	print $out "\n";
    }
}

sub checkchangelog {
    if ( open IN,'<',$ChangeLogFile ) {
	my $stop = 0;
	while ( $stop == 0 ) {
	    $_ = <IN>;
	    $stop = ! defined( $_ ) || ! /^\s*\z/;
	};
	if ( defined( $_ ) and 
	     /^r([0-9]+)\s+([12][0-9][0-9][0-9]-[012][0-9]-[0123][0-9]\s[012][0-9]:[012345][0-9]:[012345][0-9]\s\+[012][0-9][012345][0-9])/ ) {
	    my $startrev=$1;
	    $startrev += 1;
	    $revrangeopt="-r'$startrev:HEAD'";
	} else {
	    print STDERR "Warning: Syntax error at $ChangeLogFile!\n";
	}
	close IN;
    } else {
	print STDERR "Warning: Cannot read $ChangeLogFile.\n";
    }
}

sub wanted {
    my ($dev,$ino,$mode,$nlink,$uid,$gid) = lstat($_);
    my $output;
    my $newrev = 0;
    my $data;
    my @info;
    my $text = "";
    
    if ( $File::Find::name =~ /\/(auto|\.svn)(\/|\z)/ or
	$File::Find::name =~ /(\.(tmp|log|aux|toc|lof|lot|ind|idx|ilg|glo|chn|out|bbl|blg)|~)\z/ ) {
	return;
    }

    $output=`svn log $revrangeopt $File::Find::name`;

    open IN,'<',\$output
	or die "Cannot read output for $File::Find::name!\n";
    while ( $data = <IN> ) {
	chomp $data;
	if ( $data =~ /^\-+\z/ ) {
	    $newrev=1;
	    if ( @info ) {
		push @info,"$text\n";
		$text="";
		push @allinfo,[@info];
		@info = ();
	    }
	} elsif ( $newrev == 1 ) {
	    @info=split /\s*\|\s*/,$data;
	    $info[0] =~ s/^r//;
	    $info[2] =~ s/\s\(.*//;
	    my $name=$File::Find::name;
	    if ( length($name) > length($basedir) ) {
		$name=substr($name,length($basedir)+1);
	    } else {
		$name="./";
	    }
	    push @info,$name;
	    $newrev=2;
	} elsif ( $newrev == 2 ) {
	    $newrev=3;
	} elsif ( $newrev == 3 ) {
	    if ( $data =~ /^s+/ or $data eq "" ) {
		$text .= "\n$data";
	    } else {
		if ( $text eq "" ) {
		    $text = $data;
		} else {
		    $text .= " $data";
		}
	    }
	}
    }
#   This will never happen:
#    if ( @info ) {
#	print @info;
#	push @allinfo,\@info;
#    }
    close IN;
}

# end of file
