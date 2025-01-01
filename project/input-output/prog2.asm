.386
.model flat, stdcall
option casemap :none

include masm32\include\windows.inc
include masm32\include\kernel32.inc
include masm32\include\masm32.inc
include masm32\include\user32.inc
include masm32\include\msvcrt.inc
includelib masm32\lib\kernel32.lib
includelib masm32\lib\masm32.lib
includelib masm32\lib\user32.lib
includelib masm32\lib\msvcrt.lib

.DATA
;===User Data================================================================================
	_aAAAAAA_	dw	0
	_bBBBBBB_	dw	0
	_cCCCCCC_	dw	0

	String_0	db	"Input A: ", 0
	String_1	db	"Input B: ", 0
	String_2	db	"Input C: ", 0
	String_3	db	13, 10, 0
	String_4	db	13, 10, 0
	String_5	db	13, 10, 0

;===Addition Data============================================================================
	hConsoleInput	dd	?
	hConsoleOutput	dd	?
	endBuff			db	5 dup (?)
	msg1310			db	13, 10, 0

	CharsReadNum	dd	?
	InputBuf		db	15 dup (?)
	OutMessage		db	"%hd", 0
	ResMessage		db	20 dup (?)

.CODE
start:
invoke AllocConsole
invoke GetStdHandle, STD_INPUT_HANDLE
mov hConsoleInput, eax
invoke GetStdHandle, STD_OUTPUT_HANDLE
mov hConsoleOutput, eax
	invoke WriteConsoleA, hConsoleOutput, ADDR String_0, SIZEOF String_0 - 1, 0, 0
	call Input_
	mov _aAAAAAA_, ax
	invoke WriteConsoleA, hConsoleOutput, ADDR String_1, SIZEOF String_1 - 1, 0, 0
	call Input_
	mov _bBBBBBB_, ax
	invoke WriteConsoleA, hConsoleOutput, ADDR String_2, SIZEOF String_2 - 1, 0, 0
	call Input_
	mov _cCCCCCC_, ax
	push _aAAAAAA_
	push _bBBBBBB_
	call Greate_
	pop ax
	cmp ax, 0
	je endIf2
	push _aAAAAAA_
	push _cCCCCCC_
	call Greate_
	pop ax
	cmp ax, 0
	je elseLabel1
	jmp _aBIGGER_
	jmp endIf1
elseLabel1:
	push _cCCCCCC_
	call Output_
	jmp _oUTOFI_
_aBIGGER_:
	push _aAAAAAA_
	call Output_
	jmp _oUTOFI_
endIf1:
endIf2:
	push _bBBBBBB_
	push _cCCCCCC_
	call Less_
	pop ax
	cmp ax, 0
	je elseLabel3
	push _cCCCCCC_
	call Output_
	jmp endIf3
elseLabel3:
	push _bBBBBBB_
	call Output_
endIf3:
_oUTOFI_:
	invoke WriteConsoleA, hConsoleOutput, ADDR String_3, SIZEOF String_3 - 1, 0, 0
	push _aAAAAAA_
	push _bBBBBBB_
	call Equal_
	push _aAAAAAA_
	push _cCCCCCC_
	call Equal_
	call And_
	push _bBBBBBB_
	push _cCCCCCC_
	call Equal_
	call And_
	pop ax
	cmp ax, 0
	je elseLabel4
	push word ptr 1
	call Output_
	jmp endIf4
elseLabel4:
	push word ptr 0
	call Output_
endIf4:
	invoke WriteConsoleA, hConsoleOutput, ADDR String_4, SIZEOF String_4 - 1, 0, 0
	push _aAAAAAA_
	push word ptr 0
	call Less_
	push _bBBBBBB_
	push word ptr 0
	call Less_
	call Or_
	push _cCCCCCC_
	push word ptr 0
	call Less_
	call Or_
	pop ax
	cmp ax, 0
	je elseLabel5
	push word ptr -1
	call Output_
	jmp endIf5
elseLabel5:
	push word ptr 0
	call Output_
endIf5:
	invoke WriteConsoleA, hConsoleOutput, ADDR String_5, SIZEOF String_5 - 1, 0, 0
	push _aAAAAAA_
	push _bBBBBBB_
	push _cCCCCCC_
	call Add_
	call Less_
	call Not_
	pop ax
	cmp ax, 0
	je elseLabel6
	push word ptr 10
	call Output_
	jmp endIf6
elseLabel6:
	push word ptr 0
	call Output_
endIf6:
exit_label:
invoke WriteConsoleA, hConsoleOutput, ADDR msg1310, SIZEOF msg1310 - 1, 0, 0
invoke ReadConsoleA, hConsoleInput, ADDR endBuff, 5, 0, 0
invoke ExitProcess, 0


;===Procedure Add============================================================================
Add_ PROC
	mov ax, [esp + 6]
	add ax, [esp + 4]
	mov [esp + 6], ax
	pop ecx
	pop ax
	push ecx
	ret
Add_ ENDP
;============================================================================================


;===Procedure And============================================================================
And_ PROC
	pushf
	pop cx

	mov ax, [esp + 6]
	cmp ax, 0
	jnz and_t1
	jz and_false
and_t1:
	mov ax, [esp + 4]
	cmp ax, 0
	jnz and_true
and_false:
	mov ax, 0
	jmp and_fin
and_true:
	mov ax, 1
and_fin:
	push cx
	popf

	mov [esp + 6], ax
	pop ecx
	pop ax
	push ecx
	ret
And_ ENDP
;============================================================================================


;===Procedure Equal==========================================================================
Equal_ PROC
	pushf
	pop cx

	mov ax, [esp + 6]
	cmp ax, [esp + 4]
	jne equal_false
	mov ax, 1
	jmp equal_fin
equal_false:
	mov ax, 0
equal_fin:
	push cx
	popf

	mov [esp + 6], ax
	pop ecx
	pop ax
	push ecx
	ret
Equal_ ENDP
;============================================================================================


;===Procedure Greate=========================================================================
Greate_ PROC
	pushf
	pop cx

	mov ax, [esp + 6]
	cmp ax, [esp + 4]
	jle greate_false
	mov ax, 1
	jmp greate_fin
greate_false:
	mov ax, 0
greate_fin:
	push cx
	popf

	mov [esp + 6], ax
	pop ecx
	pop ax
	push ecx
	ret
Greate_ ENDP
;============================================================================================


;===Procedure Input==========================================================================
Input_ PROC
	invoke ReadConsoleA, hConsoleInput, ADDR InputBuf, 13, ADDR CharsReadNum, 0
	invoke crt_atoi, ADDR InputBuf
	ret
Input_ ENDP
;============================================================================================


;===Procedure Less===========================================================================
Less_ PROC
	pushf
	pop cx

	mov ax, [esp + 6]
	cmp ax, [esp + 4]
	jge less_false
	mov ax, 1
	jmp less_fin
less_false:
	mov ax, 0
less_fin:
	push cx
	popf

	mov [esp + 6], ax
	pop ecx
	pop ax
	push ecx
	ret
Less_ ENDP
;============================================================================================


;===Procedure Not============================================================================
Not_ PROC
	pushf
	pop cx

	mov ax, [esp + 4]
	cmp ax, 0
	jnz not_false
not_t1:
	mov ax, 1
	jmp not_fin
not_false:
	mov ax, 0
not_fin:
	push cx
	popf

	mov [esp + 4], ax
	ret
Not_ ENDP
;============================================================================================


;===Procedure Or=============================================================================
Or_ PROC
	pushf
	pop cx

	mov ax, [esp + 6]
	cmp ax, 0
	jnz or_true
	jz or_t1
or_t1:
	mov ax, [esp + 4]
	cmp ax, 0
	jnz or_true
or_false:
	mov ax, 0
	jmp or_fin
or_true:
	mov ax, 1
or_fin:
	push cx
	popf

	mov [esp + 6], ax
	pop ecx
	pop ax
	push ecx
	ret
Or_ ENDP
;============================================================================================


;===Procedure Output=========================================================================
Output_ PROC value: word
	invoke wsprintf, ADDR ResMessage, ADDR OutMessage, value
	invoke WriteConsoleA, hConsoleOutput, ADDR ResMessage, eax, 0, 0
	ret 2
Output_ ENDP
;============================================================================================
end start
