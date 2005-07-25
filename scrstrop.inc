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
% This file will be included at end of every KOMA-Script 
% docstrip batch file.
%

% ---------- end of docstrip -----------------------------------------

\ifToplevel{%
  \Msg{************************************************************}
  \Msg{*}
  \Msg{* KOMA-Script}
  \Msg{* a versatile LaTeX2e bundle}
  \Msg{*}
  \ifbeta
    \Msg{* THIS IS A BETA VERSION. YOU SHOULD NOT INSTALL OR USE IT!}
    \Msg{* THERE MAY BE A LOT OF BUGS AT THIS VERSION!}
    \Msg{* PLEASE INSTALL THE RELEASE YOU CAN FIND AT CTAN!}
  \else
    \Msg{* To finish the installation you have to move some}
    \Msg{* files into a directory searched by TeX.}
    \Msg{* See INSTALL.TXT (english) or INSTALLD.TXT (german)}
    \Msg{* for additional information.}
    \Msg{*}
    \ifx\idocfiles\empty\else
      \Msg{* You may also produce the implementation documentation,}
      \Msg{* but you don't need. To produce it, run file(s)}
      \Msg{* \idocfiles}
      \Msg{* through LaTeX after finishing the installation.}
      \Msg{*}
    \fi
    \Msg{* You will find the manual reading `readme.txt' (English),}
    \Msg{* `liesmich.txt' (German) or `koma-script.pdf'.}
    \Msg{*}
    \Msg{* Happy TeXing}
  \fi
  \Msg{*}
  \Msg{************************************************************}
}

\endinput

%%% Local Variables:
%%% mode: latex
%%% mode: font-lock
%%% TeX-master: f
%%% End:
