#!/bin/sh
# ======================================================================
# pdfselect.sh
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
# pdfselect.sh
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

error() {
    echo $2 >&2
    exit $1
}

pnum=0
while [ $# -gt 0 ]; do
    if [ $pnum -eq 0 ]; then
	pagelist=$1
    elif [ $pnum -eq 1 ]; then
	srcpdf=$1
    elif [ $pnum -eq 2 ]; then
	dstpdf=$1
    else
	error 2 "$0: unexpected parameter \`$1'!"
    fi
    pnum=$((++pnum))
    shift
done

[ $pnum -eq 3 ] || error 2 "$0: missing parameter!"

if [ "$pagelist" == "-" ]; then
    cp $srcpdf $dstpdf || \
	error 2 "${srcpdf}: Cannot select pages $pagelist!\n"
else
# use absolut pages and ':' instead of '-' for ranges
    newpagelist=`echo ${pagelist} | sed -e 's/-$/-end/;s/-,/-end,/g;s/^-/1-/g;s/,-/,1-/g;s/,/ /g'`

    [ -z "$newpagelist" ] && error 2 "$0: Cannot create page list!\n"
    
    pdftk ${srcpdf} cat ${newpagelist} output $dstpdf ||\
	error 2 "${srcpdf}: Cannot select pages $pagelist!\n"
fi
