@echo off
\masm32\bin\rc /v rsrc.rc
\masm32\bin\cvtres /machine:ix86 rsrc.res
\MASM32\BIN\ml /c /coff extract.asm
\MASM32\BIN\link /subsystem:windows /MERGE:.rdata=.text > nul /SECTION:.text,ERWX extract.obj rsrc.obj
del *.res
del *.obj
