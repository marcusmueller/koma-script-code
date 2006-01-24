#!/bin/sh
# ======================================================================
# pdfselect.sh
# Copyright (c) Markus Kohm, 2002-2006
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
# pdfselect.sh
# Copyright (c) Markus Kohm, 2002-2006
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
