#!/bin/sh
#
# Copyright (c) Markus Kohm, 2008
#

datestr=`date +%Y/%m/%d`
versionstr=`grep '\@CheckKOMAScriptVersion{' scrkvers.dtx | sed s/.*{// | cut -d' ' -f 2- | sed 's/ *KOMA-Script.*//; s/^v//'`
if [ $# -lt 2 ]; then
    echo "Usage: ${0##*/} <date> <version> [...]" >&2
    echo "Example: ${0##*/} $datestr $versionstr" >&2
    exit 1
fi

datestr=$1
versionstr=$2
shift 2
additional="$*"
while [ "$additional" != "${additional% }" ]; do
    additional=${additional% }
done
while [ "$additional" != "${additional# }" ]; do
    additional=${additional# }
done
[ -z "$additional" ] || additional=" $additional"

if svn status | grep '^M'; then
    echo "There are still modified files!" >&2
    exit 1
fi

if ! grep 'scr@v@'"${versionstr}" scrkcomp.dtx; then
    cp -f scrkcomp.dtx scrkcomp.dtx~
    sed 's!\(\\begin{macro}{\\scr@v@last}\)!\\begin{macro}{\\scr@v@'"${versionstr}"'}\n%   \\changes{v'"${versionstr}"'}{'"${datestr}"'}{Neues Macro}\n% \1!' scrkcomp.dtx > scrkcomp.dtx.tmp
    sed '/^\\@namedef{scr@v@last}{[0-9]*} *$/{N;s!^\\@namedef{scr@v@last}{\([0-9]\)*} *\n%    \\end{macrocode}!\\@namedef{scr@v@'"${versionstr}"'}{\1}\n\0\n% \\end{macro}!}' scrkcomp.dtx.tmp > scrkcomp.dtx
    curr_checksum=`head -1 scrkcomp.dtx | grep -o '[0-9]\+'`
    new_checksum=$(( ${curr_checksum} + 1 ))
    sed 's/^\(% *\\CheckSum{\).*\(}.*\)$/\1'${new_checksum}'\2/' scrkcomp.dtx > scrkcomp.dtx.tmp
    mv scrkcomp.dtx.tmp scrkcomp.dtx
    if latex -interaction=batchmode scrkcomp.dtx; then
	rm scrkcomp.dtx~
    else
	mv -f scrkcomp.dtx scrkcomp.dtx.tmp
	mv -f scrkcomp.dtx~ scrkcomp.dtx
	echo "Error changing scrkcomp.dtx (see scrkcomp.dtx.tmp)." >&2
	exit 1
    fi
fi

sed 's!\(\\@CheckKOMAScriptVersion{\)[^}]*!\1'"${datestr} v${versionstr}${additional} KOMA-Script!" scrkvers.dtx > scrkvers.dtx.new
mv -f scrkvers.dtx.new scrkvers.dtx

echo "Do next:"
echo "  make"
echo "  svn ci scrkvers.dtx scrkcomp.dtx -m 'prepared for ${versionstr}${additional}'"
echo "  developer/scripts/addrelease.sh '${datestr}' '${versionstr}' \"$@\""
echo "(NOTE: Don't execute addrelease.sh on BETA versions.)"
echo "or:"
echo "  rm scrkvers.dtx scrkcomp.dtx;svn up scrkvers.dtx scrkcomp.dtx"
