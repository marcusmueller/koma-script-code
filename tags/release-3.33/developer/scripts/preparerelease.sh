#!/usr/bin/env bash
#
# Copyright (c) Markus Kohm, 2006-2014
#
# This file prepares KOMA-Script for release.
#
# This file is not part of KOMA-Script bundle. You are not allowed
# to redistribute or modify this file!
#

prgname=$0
step=$1
shift

error() {
    while [ $# -gt 0 ]; do
	echo "$prgname: $1" >&2
	shift
    done
    exit 1
}

stepone() {
    [ $# -ne 0 ] && error "unexpected parameter \`$1'!"
    developer/scripts/genchangelog.pl . \
	|| error "ChangeLog generation failed!"
    ! [ -f doc/ChangeLog.svn ] \
	|| mv doc/ChangeLog.svn doc/ChangeLog.bak \
	|| error "ChangeLog generation failed!"
    mv doc/ChangeLog.tmp doc/ChangeLog.svn && \
	cat doc/ChangeLog.svn ChangeLog.cvs > ChangeLog || \
	error "ChangeLog generation failed!"
    exit 0
}

steptwo() {
    [ $# -ne 1 ] && error "exactly one parameter expected!"
    pushd $1
    base=`dirs +1`
    version=`grep 'CheckKOMAScriptVersion{' scrkernel-version.dtx | grep -o '2.*KOMA'`
    version=${version% KOMA}

    for ins in *.ins *.inc *.dtx; do
	sed -e 's/{trace,/{/g;s/\(\\let\\ifbeta=\\if\)true/\1false/' -i $ins
    done

    grep '% ======================================================================' -A 10000 manifest.txt > manifest.tmp
    sed -e 's|\(CONTENTS OF THE KOMA-SCRIPT \)DEVELOPERS ONLY VERSION|\1RELEASE '"$version"'|' \
	manifest.tmp > manifest.txt
    rm manifest.tmp

    head -n 2 INSTALL.txt > INSTALL.tmp
    tail -n +6 INSTALL.txt >> INSTALL.tmp
    mv INSTALL.tmp INSTALL.txt

    head -n 2 INSTALLD.txt > INSTALLD.tmp
    tail -n +7 INSTALLD.txt >> INSTALLD.tmp
    mv INSTALLD.tmp INSTALLD.txt

    versionpostfix=${version#* * }
    year=`date '+%Y'`

    cat > README <<EOF

KOMA-Script $version
Copyright (c) Markus Kohm <komascript(at)gmx.info>, 1994-${year}

This material is subject to the LaTeX Project Public License. See
lppl.txt (english) or lppl-de.txt (german) for the details of that
license.

--------------------------------------------------------------------
EOF
    [ "$versionpostfix" = "$version" ] || cat >> README <<EOF

NOTE: These files are for beta testers and developers only.

      YOU SHOULD ONLY TEST BUT NOT USE THEM!!!

--------------------------------------------------------------------
EOF

    cat >> README <<EOF

KOMA-Script is a versatile bundle of LaTeX2e document classes and
packages.  It aims to be a replacement to the standard LaTeX2e
classes.  KOMA-Script does not stop with the features known from the
standard classes, but it extends the possibilities in order to
provide the user an almost complete working environment.

--------------------------------------------------------------------

For installation see INSTALL.txt (english) or INSTALLD.txt
(german, UTF-8).

--------------------------------------------------------------------

Classes and Packages:

EOF

    popd
    exit 0
}

stepthree() {
    [ $# -ne 1 ] && error "exactly one parameter expected!"
    pushd $1

    for f in $( ls README.in/README.* ); do
	name=${f#README.in/README.}
	rm testversion.* versiontest.sh
	if [[ $name =~ \.cls$ ]]; then
	    # Version test for class
	    cat > testversion.tex <<EOF
\\documentclass{${name%.cls}}
\\makeatletter
\\newwrite\\versionfile
\\immediate\\openout\\versionfile versiontest.sh
\\def\\writeversion#1 KOMA-Script#2\\@nil{%
  \\immediate\\write\\versionfile {fileversion='#1'}%
}
\\expandafter\\expandafter\\expandafter\\writeversion\\csname ver@${name}\endcsname KOMA-Script\\@nil
\\immediate\\closeout\\versionfile
\\@@end\\end
\\makeatother
\\begin{document}\\end{document}
EOF
	else
	    # Version test for package
	    cat > testversion.tex <<EOF
\\documentclass{minimal}
\\makeatletter
\\immediate\\newwrite\\versionfile
\\immediate\\openout\\versionfile versiontest.sh
\\def\\writeversion#1 KOMA-Script#2\\@nil{%
  \\immediate\\write\\versionfile {fileversion='#1'^^J}%
}
\\def\\@pr@videpackage[#1]{%
  \\typeout{>>> TRACE #1: to \\the\\versionfile<<<}%
  \\writeversion#1 KOMA-Script\\@nil
  \\csname endinput\\endcsname
}
\\usepackage{${name%.sty}}
\\immediate\\closeout\\versionfile
\\makeatother
\\begin{document}\\end{document}
EOF
	fi
	pdflatex -draftmode -interaction=batchmode testversion.tex \
	    || error "Cannot determine version of ${name}."
	chmod a+x versiontest.sh
	. ./versiontest.sh
	rm testversion.* versiontest.sh
	echo '==============================================================================' >> README
	sed -e 's#^\(Version:\s*\).*$#\1'"${fileversion}"'#' $f >> README
    done
    echo '==============================================================================' >> README

    popd
    exit 0
}

stepfinal() {
    [ $# -ne 1 ] && error "exactly one parameter expected!"
    pushd $1
    base=`dirs +1`
    version=`grep 'CheckKOMAScriptVersion{' scrkernel-version.dtx | grep -o '2.*KOMA'`
    version=${version% KOMA}

    versionpostfix=${version#* * }
    year=`date '+%Y'`

    [ "$versionpostfix" = "$version" ] || \
	error "Cannot prepare for KOMA-Script $version." \
	      "You should change scrkernel-version.dtx before release."

    popd
    exit 0
}

case $step in
    1)  stepone "$@"
	;;
    2)  steptwo "$@"
	;;
    3)  stepthree "$@"
	;;
    final)
	stepfinal "$@"
	;;
    *)
	error "unknown preparation level!"
	;;
esac
