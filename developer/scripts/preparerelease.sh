#! /bin/sh
#
# Copyright (c) Markus Kohm, 2006
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
    developer/scripts/genchangelog.pl . && \
	mv doc/ChangeLog.svn doc/ChangeLog.bak && \
	mv doc/ChangeLog.tmp doc/ChangeLog.svn && \
	cat doc/ChangeLog.svn ChangeLog.cvs > ChangeLog || \
	error "ChangeLog generation failed!"
    exit 0
}

steptwo() {
    [ $# -ne 1 ] && error "exactly one parameter expected!"
    pushd $1
    base=`dirs +1`
    version=`grep 'CheckKOMAScriptVersion{' scrkvers.dtx | grep -o '2.*KOMA'`
    version=${version% KOMA}

    for ins in *.ins; do
	sed -e 's/{trace,/{/g' -i $ins
    done
    sed -e 's/\(\\let\\ifbeta=\\if\)true/\1false/' -i scrstrip.inc

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
    [ "$versionpostfix" = "$version" ] || \
	error "Cannot prepare for KOMA-Script $version!" \
	      "You should change scrkvers.dtx before release!"

    popd
    exit 0
}

case $step in
    1)  stepone "$@"
	;;
    2)  steptwo "$@"
	;;
    *)
	error "unknown preparation level!"
	;;
esac
