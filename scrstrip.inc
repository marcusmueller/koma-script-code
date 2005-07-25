% ======================================================================
% scrstrip.inc
% Copyright (c) Markus Kohm, 2002
%
% This file is part of the LaTeX2e KOMA-Script-Bundle
%
% This file can be redistributed and/or modified under the terms
% of the LaTeX Project Public License Version 1.0 distributed 
% together with this file. See LEGAL.TXT or LEGALDE.TXT.
%
% This bundle is written specialy for use at german-language. So the
% main documentation is german. There is also an english documentation,
% but this is NOT up-to-date.
% ----------------------------------------------------------------------
% scrstrip.inc
% Copyright (c) Markus Kohm, 2002
%
% Diese Datei ist Teil des LaTeX2e KOMA-Script-Pakets.
%
% Diese Datei kann nach den Regeln der LaTeX Project Public
% Licence Version 1.0, wie sie zusammen mit dieser Datei verteilt
% wird, weiterverbreitet und/oder modifiziert werden. Siehe dazu
% auch LEGAL.TXT oder LEGALDE.TXT.
%
% Dieses Paket ist fuer den deutschen Sprachraum konzipiert. Daher ist
% auch diese Anleitung komplett in Deutsch. Zwar existiert auch eine
% englische Version der Anleitung, diese hinkt der deutschen Anleitung
% jedoch fast immer hinterher.
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
