% ======================================================================
% scrstrip.inc
% Copyright (c) Markus Kohm, 2002-2006
%
% This file is part of the LaTeX2e KOMA-Script bundle.
%
% This work may be distributed and/or modified under the conditions of
% the LaTeX Project Public License, version 1.3b of the license.
% The latest version of this license is in
%   http://www.latex-project.org/lppl.txt
% and version 1.3b or later is part of all distributions of LaTeX 
% version 2005/12/01 and of this work.
%
% This work has the LPPL maintenance status "author-maintained".
%
% The Current Maintainer and author of this work is Markus Kohm.
%
% This work consists of all files listed in manifest.txt.
% ----------------------------------------------------------------------
% scrstrip.inc
% Copyright (c) Markus Kohm, 2002-2006
%
% Dieses Werk darf nach den Bedingungen der LaTeX Project Public Lizenz,
% Version 1.3b.
% Die neuste Version dieser Lizenz ist
%   http://www.latex-project.org/lppl.txt
% und Version 1.3b ist Teil aller Verteilungen von LaTeX
% Version 2005/12/01 und dieses Werks.
%
% Dieses Werk hat den LPPL-Verwaltungs-Status "author-maintained"
% (allein durch den Autor verwaltet).
%
% Der Aktuelle Verwalter und Autor dieses Werkes ist Markus Kohm.
% 
% Dieses Werk besteht aus den in manifest.txt aufgefuehrten Dateien.
% ======================================================================
%
% This file will be included at startup of every KOMA-Script 
% docstrip batch file.
%

% ---------- start of docstrip -----------------------------------------

\let\ifbeta=\iftrue

\ifToplevel{\ifx\generate\undefined
    \Msg{************************************************************}
    \Msg{*}
    \Msg{* This installation requires docstrip version 2.3c or}
    \Msg{* later, but an old version of docstrip has been input.}
    \Msg{* You have to update docstrip and maybe LaTeX first!}
    \Msg{*}
    \Msg{************************************************************}
    \errhelp{Install a new version of docstrip.}
    \errmessage{Old docstrip in input path}
    \batchmode
    \csname @@end\endcsname
  \fi
  \Msg{************************************************************}
  \Msg{*}
  \Msg{* KOMA-Script}
  \Msg{* a versatile LaTeX2e bundle}
  \Msg{*}
  \Msg{* This is `\batchfile', a batchfile to unpack some or all}
  \Msg{* parts of KOMA-Script. See `liesmich.txt' (german) or}
  \Msg{* `readme.txt' (english) for additional information.}
  \Msg{*}
  \Msg{* If some - maybe old - files of KOMA-Script are already}
  \Msg{* installed, you will be ask, if it is allowed to overwrite}
  \Msg{* them. Answering `yes' doesn't mean, that `\batchfile'}
  \Msg{* WILL overwrite such files. It means only, that}
  \Msg{* `\batchfile' or installation MAY overwrite them.}
  \Msg{*}
  \Msg{************************************************************}
}

% ---------- some docstrip switchs -------------------------------------

\keepsilent
\askforoverwritetrue
\ifx\askonceonly\undefined\else\askonceonly\fi

% ---------- defining preambles ----------------------------------------

\preamble

Copyright (c) 1994-2002
Markus Kohm and any individual authors listed elsewhere in this file.

This file was generated from file(s) of the KOMA-Script bundle.
---------------------------------------------------------------

It may be distributed under the conditions of the 
LaTeX Project Public License in the version distributed together
with KOMA-Script, see file `LEGAL.TXT' or `LEGALDE.TXT'.

This file may only be distributed together with a copy of the
KOMA-Script bundle.  You may however distribute the 
KOMA-Script bundle without all such generated files.  See also
`LEGAL.TXT' or `LEGALDE.TXT' for additional information.

The list of files belonging to KOMA-Script distribution is given in
the file `liesmich.txt' and the file `readme.txt'.  See also
`LEGAL.TXT' or `LEGALDE.TXT' for additional information.

If this file is a beta version, you are not allowed to distribute it.

English and German manuals are part of KOMA-Script bundle. 
----------------------------------------------------------

See `liesmich.txt' or `readme.txt'.

The KOMA-Script bundle (but maybe not this file) was based upon the
LaTeX2.09 Script family created by Frank Neukam 1993 and the LaTeX2e
standard classes created by The LaTeX3 Project 1994-1996.

\endpreamble

\endinput

%%% Local Variables:
%%% mode: latex
%%% mode: font-lock
%%% TeX-master: f
%%% End:
