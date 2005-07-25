#! /bin/sh
#
# Copyright (c) Markus Kohm, 2002
#
# This file generates a template for german part of KOMA-Script.
#
# This file is not part of KOMA-Script bundle. You are not allowed
# to redistribute or modify this file!
#

version() {
    echo `basename $0`' v1.0a'
    echo 'Copyright (c) Markus Kohm, 2002'
}

usage() {
    echo 'usage '`basename $0`' [Options] [filename]'
}

error() {
    echo "$2" >&2
    usage >&2
    echo 'try "'`basename $0`' -h" for help' >&2
    exit $1
}

help() {
    version
    echo
    usage
    echo '
Options:
 -d     generates .dtx template file (default)
 -e     generates english template file
 -g     generates german template file (default)
 -h     shows this information and exit
 -i     generates .ins template file
 -v     shows version information and exit
 -V VERSION
        sets fileversion of the generated file to VERSION (default: '$fileversion')

'`basename $0`' generates a template file, which may be used as KOMA-Script part.
If filename has no extension ".dtx" will be used. If no filename is was given
"template.dtx" will be used.
'
}

generate() {
if ! $insfile; then
    echo '% \CheckSum{0}'
    echo '% \iffalse meta-comment'
fi
cat <<EOF
% ======================================================================
EOF
echo '% '"$1"
echo '% Copyright (c) Markus Kohm, '`date +\%Y`
cat <<EOF
%
% This file is part of the LaTeX2e KOMA-Script-Bundle
%
% This file can be redistributed and/or modified under the terms
% of the LaTeX Project Public License Version 1.0 distributed 
% together with this file. See LEGAL.TXT or LEGALDE.TXT.
% ----------------------------------------------------------------------
EOF
echo '% '"$1"
echo '% Copyright (c) Markus Kohm, '`date +\%Y`
cat <<EOF
%
% Diese Datei ist Teil des LaTeX2e KOMA-Script-Pakets.
%
% Diese Datei kann nach den Regeln der LaTeX Project Public
% Licence Version 1.0, wie sie zusammen mit dieser Datei verteilt
% wird, weiterverbreitet und/oder modifiziert werden. Siehe dazu
% auch LEGAL.TXT oder LEGALDE.TXT.
% ======================================================================
EOF
if $insfile; then
    cat <<EOF

% ---------- start of docstrip process ---------------------------------
EOF
    echo '\def\batchfile{'$1'}'
    cat <<EOF

% ---------- KOMA-Script default docstrip declarations -----------------

\input docstrip.tex
\@@input scrstrip.inc

% ---------- File generation -------------------------------------------

\generate{\usepreamble\defaultpreamble
  \file{CHANGETHIS.sty}{%
    \ifbeta\from{scrbeta.dtx}{class,package,lcofile,ONLYONEOFTHIS}\fi
    \from{$2.dtx}{options}%
    \from{$2.dtx}{main}%
    \from{scrlogo.dtx}{logo}%
  }%
}

% ---------- end of docstrip process -----------------------------------

\def\idocfiles{}
\@@input scrstrop.inc

EOF
else
    cat <<EOF
% \fi
% \iffalse
EOF
    echo '%%% From File: '"$1"
    cat <<EOF
%<*driver>
% \fi
EOF
    echo '\ProvidesFile{'"$1"'}['`date +\%Y/\%m/\%d`' v'$fileversion' KOMA-Script (TEMPLATE)]'
    cat <<EOF
% \iffalse
\documentclass{scrdoc}
EOF
    if $english; then
        echo '\usepackage[german,english]{babel}'
    else
        echo '\usepackage[english,german]{babel}'
        echo '\usepackage[latin1]{inputenc}'
    fi
    cat <<EOF
\CodelineIndex
\RecordChanges
EOF
    echo '\GetFileInfo{'"$1"'}'
    cat <<EOF
\title{\KOMAScript{} \partname\ \texttt{\filename}%
EOF
  if $english; then
cat <<EOF
  \footnote{This is version \fileversion\ of file \texttt{\filename}.}}
EOF
  else
cat <<EOF
  \footnote{Dies ist Version \fileversion\ von Datei \texttt{\filename}.}}
EOF
  fi
cat <<EOF
\date{\filedate}
\author{Markus Kohm}

\begin{document}
  \maketitle
  \tableofcontents
  \DocInput{\filename}
\end{document}
%</driver>
% \fi
%
EOF
    if $english; then
        echo '% \selectlanguage{english}'
    else
        echo '% \selectlanguage{german}'
    fi
    echo '%'
    echo '% \changes{v'$fileversion'}{'`date +\%Y/\%m/\%d`'}{%'
    if $english; then
        echo '%   first version after splitting \textsf{scrclass.dtx}}'
    else
        echo '%   erste Version aus der Aufteilung von \textsf{scrclass.dtx}}'
    fi
    cat <<EOF
%
% \section{TEMPLATE}
%
% ADD SOME DESCRIPTIONS HERE
%
% \StopEventually{\PrintIndex\PrintChanges}
%
% \iffalse
%<*option>
% \fi
%
% \subsection{Option}
% ADD IMPLEMENTATION HERE
%
%
% \iffalse
%</option>
%<*body>
% \fi
%
% \subsection{Body}
% ADD IMPLEMENTATION HERE
%
%
% \iffalse
%</body>
% \fi
%
% \Finale
%
EOF
fi
cat <<EOF
\endinput
%
EOF
echo '% end of file `'"$1'"
cat <<EOF
%%% Local Variables:
%%% mode: latex
%%% mode: font-lock
%%% TeX-master: t
%%% End:
EOF
}

english=false
insfile=false
fileversion=3.0

while getopts 'deghivV:' option;do
    case $option in
        \?) error 1 "";;
        d)  insfile=false;;
        e)  english=true;;
        g)  english=false;;
        h)  help; exit 0;;
        i)  insfile=true;;
        V)  fileversion=${OPTARG};;
        v)  version; exit 0;;
    esac
done

if [ $OPTIND -lt $# ]; then
    error 1 "too much arguments"
else
    OPTIND=$(( OPTIND - 1 ))
    shift $OPTIND
    filename=${1:-"template.dtx"}
    basefilename=${filename%.*}
    if $insfile; then
        filename="$basefilename.ins"
    else
        filename="$basefilename.dtx"
    fi
fi

if [ -f $filename ]; then
    echo $filename' already exists. You have to remove it first using e.g.' >&2
    echo '  rm '$filename >&2
    exit 1
else
    generate $filename $basefilename > $filename
fi
