#!/usr/bin/env texlua

--[[
  Build script for the KOMA-Script project
  Copyright (C) 2021 Markus Kohm

  This file is part of the build system of KOMA-Script.

  It may be distributed and/or modified under the conditions of the
  LaTeX Project Public License (LPPL), either version 1.3c of this
  license or (at your option) any later version.  The latest version
  of this license is in the file

    https://www.latex-project.org/lppl.txt

  Note: This l3build script is currently not suitable to build
        KOMA-Script distributions or the KOMA-Script guides.  However,
	it can be used to unpack KOMA-Script.  The main purpose is
	to work with the test suite.

  You should neither use this file to generate the distribution
  nor copy it to the distribution!
]]

-- Bundle and modules

module      = "koma-script"

unpackfiles = { "scrmain.ins" }

sourcefiles = { "*.dtx", "*.ins", "*.inc", "scrdocstrip.tex" }

unpacksuppfiles = { "manifest.txt" }

-- Find and run build system

kpse.set_program_name("kpsewhich")
if not release_date then
  dofile(kpse.lookup("l3build.lua"))
end
