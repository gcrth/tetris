.386
.model flat, stdcall
option casemap :none
;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
; Include 文件定义
;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
include		include/windows.inc
include		include/user32.inc
includelib	user32.lib
include		include/kernel32.inc
includelib	kernel32.lib
include		include/msvcrt.inc	
includelib	msvcrt.lib
include		include/Gdi32.inc
includelib	Gdi32.lib

;sprintf		proto	C :dword, :dword, :vararg
;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
; Equ 等值定义
;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
ICO_MAIN	equ	100
IDC_MAIN	equ	100
IDC_MOVE	equ	101

IDB_BACK1	equ	100
IDB_BACK2	equ	103
IDB_BACK3	equ	106
IDB_BACK4	equ	109
IDB_BACK5	equ	112

IDB_END		equ 124

ID_TIMER	equ	1
IDM_EXIT	equ	104

BLOCK_SIZE	equ 30
BLOCK_NUM_X equ 15
BLOCK_NUM_Y equ 20
BLOCK_NUM	equ 300;BLOCK_NUM_X*BLOCK_NUM_Y
WIN_SIZE_X	equ 15*30;BLOCK_NUM_X*BLOCK_SIZE
WIN_SIZE_Y	equ 20*30;BLOCK_NUM_Y*BLOCK_SIZE

DOWN_SPEED	equ 3
;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
; 数据结构
;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

Tetris struct
kind		db	?
direction	db	?
centerPosX	dd	?
centerPosY	dd	?
canChange	db	1
Tetris ends	


;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
; 数据段
;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
		.data
hInstance	dd		?
hWinMain	dd		?
hCursorMove	dd		?	;Cursor when move
hCursorMain	dd		?	;Cursor when normal
hMenu		dd		?

hBmpBack	dd		?
hDcBack		dd		?
hBmpClock	dd		?
hDcClock	dd		?

dwNowBack	dd		?
;dwNowCircle	dd		?

isMoving	db		1
isEnd		db		0

;lastTime	SYSTEMTIME <>

blockList		db 1000 DUP(0)
blockListTemp	db 1000 DUP(0)

te		Tetris <>
error	dd ?
hBmpBackMap dd ?
		.const

szClassName	db	'Tetris',0
szMenuExit	db	'退出(&X)...',0

;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
; 代码段
;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
		.code
;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
_CreateFrontPic	proc
		;local	@stTime:SYSTEMTIME
		local	idx,posX,posY,posX_,posY_
		pushad
		invoke	BitBlt,hDcClock,0,0,WIN_SIZE_X,WIN_SIZE_Y,hDcBack,0,0,SRCCOPY
		.if isEnd

		.else
;********************************************************************
			invoke  CreateSolidBrush,76EE00h
			invoke	SelectObject,hDcClock,eax
			invoke	DeleteObject,eax
			invoke	CreatePen,PS_SOLID,3,0
			invoke	SelectObject,hDcClock,eax
			invoke	DeleteObject,eax
			;invoke	Rectangle,hDcClock,50,50,80,80

			.if te.kind==0
				.if te.direction==0
					mov eax,te.centerPosX
					mov ebx,te.centerPosY
					;sub eax,BLOCK_SIZE
					sub ebx,BLOCK_SIZE
					mov posX,eax
					mov posY,ebx
					add eax,BLOCK_SIZE
					mov posX_,eax
					add ebx,BLOCK_SIZE
					mov posY_,ebx
					invoke	Rectangle,hDcClock,posX,posY,posX_,posY_
					;add posX,BLOCK_SIZE
					add posY,BLOCK_SIZE
					mov eax,posX
					mov ebx,posY
					add eax,BLOCK_SIZE
					mov posX_,eax
					add ebx,BLOCK_SIZE
					mov posY_,ebx
					invoke	Rectangle,hDcClock,posX,posY,posX_,posY_
					;add posX,BLOCK_SIZE
					add posY,BLOCK_SIZE
					mov eax,posX
					mov ebx,posY
					add eax,BLOCK_SIZE
					mov posX_,eax
					add ebx,BLOCK_SIZE
					mov posY_,ebx
					invoke	Rectangle,hDcClock,posX,posY,posX_,posY_
					;add posX,BLOCK_SIZE
					add posY,BLOCK_SIZE
					mov eax,posX
					mov ebx,posY
					add eax,BLOCK_SIZE
					mov posX_,eax
					add ebx,BLOCK_SIZE
					mov posY_,ebx
					invoke	Rectangle,hDcClock,posX,posY,posX_,posY_
				.elseif	te.direction==1
					mov eax,te.centerPosX
					mov ebx,te.centerPosY
					sub eax,BLOCK_SIZE
					;sub ebx,BLOCK_SIZE
					mov posX,eax
					mov posY,ebx
					add eax,BLOCK_SIZE
					mov posX_,eax
					add ebx,BLOCK_SIZE
					mov posY_,ebx
					invoke	Rectangle,hDcClock,posX,posY,posX_,posY_
					add posX,BLOCK_SIZE
					;add posY,BLOCK_SIZE
					mov eax,posX
					mov ebx,posY
					add eax,BLOCK_SIZE
					mov posX_,eax
					add ebx,BLOCK_SIZE
					mov posY_,ebx
					invoke	Rectangle,hDcClock,posX,posY,posX_,posY_
					add posX,BLOCK_SIZE
					;add posY,BLOCK_SIZE
					mov eax,posX
					mov ebx,posY
					add eax,BLOCK_SIZE
					mov posX_,eax
					add ebx,BLOCK_SIZE
					mov posY_,ebx
					invoke	Rectangle,hDcClock,posX,posY,posX_,posY_
					add posX,BLOCK_SIZE
					;add posY,BLOCK_SIZE
					mov eax,posX
					mov ebx,posY
					add eax,BLOCK_SIZE
					mov posX_,eax
					add ebx,BLOCK_SIZE
					mov posY_,ebx
					invoke	Rectangle,hDcClock,posX,posY,posX_,posY_
				.endif	
			;形状1
			.elseif te.kind == 1
			;1;
			;2;
			;3;;4;;5;
				.if te.direction == 0
					mov eax,te.centerPosX
					mov ebx,te.centerPosY
					mov posX_,eax
					mov posY_,ebx
					sub eax,BLOCK_SIZE
					sub ebx,BLOCK_SIZE
					mov posX,eax
					mov posY,ebx				
					invoke	Rectangle,hDcClock,posX,posY,posX_,posY_
					add posY,BLOCK_SIZE
					add posY_,BLOCK_SIZE
					invoke	Rectangle,hDcClock,posX,posY,posX_,posY_
					add posY,BLOCK_SIZE
					add posY_,BLOCK_SIZE
					invoke	Rectangle,hDcClock,posX,posY,posX_,posY_
					add posX,BLOCK_SIZE
					add posX_,BLOCK_SIZE
					invoke	Rectangle,hDcClock,posX,posY,posX_,posY_
					add posX,BLOCK_SIZE
					add posX_,BLOCK_SIZE
					invoke	Rectangle,hDcClock,posX,posY,posX_,posY_
				;3;;2;;1;
				;4;
				;5;
				.elseif te.direction == 1
					mov eax,te.centerPosX
					mov ebx,te.centerPosY
					add eax,BLOCK_SIZE
					sub ebx,BLOCK_SIZE
					mov posX,eax
					mov posY,ebx
					add eax,BLOCK_SIZE
					add ebx,BLOCK_SIZE
					mov posX_,eax
					mov posY_,ebx
					invoke	Rectangle,hDcClock,posX,posY,posX_,posY_
					sub posX,BLOCK_SIZE
					sub posX_,BLOCK_SIZE
					invoke	Rectangle,hDcClock,posX,posY,posX_,posY_
					sub posX,BLOCK_SIZE
					sub posX_,BLOCK_SIZE
					invoke	Rectangle,hDcClock,posX,posY,posX_,posY_
					add posY,BLOCK_SIZE
					add posY_,BLOCK_SIZE
					invoke	Rectangle,hDcClock,posX,posY,posX_,posY_
					add posY,BLOCK_SIZE
					add posY_,BLOCK_SIZE
					invoke	Rectangle,hDcClock,posX,posY,posX_,posY_
				;1;;2;;3;
					  ;4;
					  ;5;
				.elseif te.direction == 2
					mov eax,te.centerPosX
					mov ebx,te.centerPosY
					mov posX_,eax
					mov posY_,ebx
					sub eax,BLOCK_SIZE
					sub ebx,BLOCK_SIZE
					mov posX,eax
					mov posY,ebx
					invoke	Rectangle,hDcClock,posX,posY,posX_,posY_
					add posX,BLOCK_SIZE
					add posX_,BLOCK_SIZE
					invoke	Rectangle,hDcClock,posX,posY,posX_,posY_
					add posX,BLOCK_SIZE
					add posX_,BLOCK_SIZE
					invoke	Rectangle,hDcClock,posX,posY,posX_,posY_
					add posY,BLOCK_SIZE
					add posY_,BLOCK_SIZE
					invoke	Rectangle,hDcClock,posX,posY,posX_,posY_
					add posY,BLOCK_SIZE
					add posY_,BLOCK_SIZE
					invoke	Rectangle,hDcClock,posX,posY,posX_,posY_
					  ;1;
					  ;2;
				;5;;4;;3;
				.elseif te.direction == 3
					mov eax,te.centerPosX
					mov ebx,te.centerPosY
					add eax,BLOCK_SIZE
					sub ebx,BLOCK_SIZE
					mov posX,eax
					mov posY,ebx
					add eax,BLOCK_SIZE
					add ebx,BLOCK_SIZE
					mov posX_,eax
					mov posY_,ebx
					invoke	Rectangle,hDcClock,posX,posY,posX_,posY_
					add posY,BLOCK_SIZE
					add posY_,BLOCK_SIZE
					invoke	Rectangle,hDcClock,posX,posY,posX_,posY_
					add posY,BLOCK_SIZE
					add posY_,BLOCK_SIZE
					invoke	Rectangle,hDcClock,posX,posY,posX_,posY_
					sub posX,BLOCK_SIZE
					sub posX_,BLOCK_SIZE
					invoke	Rectangle,hDcClock,posX,posY,posX_,posY_
					sub posX,BLOCK_SIZE
					sub posX_,BLOCK_SIZE
					invoke	Rectangle,hDcClock,posX,posY,posX_,posY_
				.endif
			.elseif te.kind == 2
			;1;
			;2;;3;;4;
				  ;5;
				.if te.direction == 0
					mov eax,te.centerPosX
					mov ebx,te.centerPosY
					mov posX_,eax
					mov posY_,ebx
					sub eax,BLOCK_SIZE
					sub ebx,BLOCK_SIZE
					mov posX,eax
					mov posY,ebx
					invoke	Rectangle,hDcClock,posX,posY,posX_,posY_
					add posY,BLOCK_SIZE
					add posY_,BLOCK_SIZE
					invoke	Rectangle,hDcClock,posX,posY,posX_,posY_
					add posX,BLOCK_SIZE
					add posX_,BLOCK_SIZE
					invoke	Rectangle,hDcClock,posX,posY,posX_,posY_
					add posX,BLOCK_SIZE
					add posX_,BLOCK_SIZE
					invoke	Rectangle,hDcClock,posX,posY,posX_,posY_
					add posY,BLOCK_SIZE
					add posY_,BLOCK_SIZE
					invoke	Rectangle,hDcClock,posX,posY,posX_,posY_
				   ;2;;1;
				   ;3;
				;5;;4;
				.elseif te.direction == 1
					mov eax,te.centerPosX
					mov ebx,te.centerPosY
					add eax,BLOCK_SIZE
					sub ebx,BLOCK_SIZE
					mov posX,eax
					mov posY,ebx
					add eax,BLOCK_SIZE
					add ebx,BLOCK_SIZE
					mov posX_,eax
					mov posY_,ebx
					invoke	Rectangle,hDcClock,posX,posY,posX_,posY_
					sub posX,BLOCK_SIZE
					sub posX_,BLOCK_SIZE
					invoke	Rectangle,hDcClock,posX,posY,posX_,posY_
					add posY,BLOCK_SIZE
					add posY_,BLOCK_SIZE
					invoke	Rectangle,hDcClock,posX,posY,posX_,posY_
					add posY,BLOCK_SIZE
					add posY_,BLOCK_SIZE
					invoke	Rectangle,hDcClock,posX,posY,posX_,posY_
					sub posX,BLOCK_SIZE
					sub posX_,BLOCK_SIZE
					invoke	Rectangle,hDcClock,posX,posY,posX_,posY_
				.endif

			;形状4
			;posX，Y左下，posX_.posY_右上
			.elseif te.kind == 3
				  ;5;
				;1;2;3;4;
				.if te.direction == 0 
					mov eax,te.centerPosX
					mov ebx,te.centerPosY
					sub eax,BLOCK_SIZE
					sub ebx,BLOCK_SIZE
					mov posX_,eax
					mov posY_,ebx
					sub eax,BLOCK_SIZE
					add ebx,BLOCK_SIZE
					mov posX,eax
					mov posY,ebx
					invoke  Rectangle,hDcClock,posX,posY,posX_,posY_
					add posX,BLOCK_SIZE
					add posX_,BLOCK_SIZE
					invoke  Rectangle,hDcClock,posX,posY,posX_,posY_
					add posX,BLOCK_SIZE
					add posX_,BLOCK_SIZE
					invoke Rectangle,hDcClock,posX,posY,posX_,posY_
					add posX,BLOCK_SIZE
					add posX_,BLOCK_SIZE
					invoke Rectangle,hDcClock,posX,posY,posX_,posY_
					sub posX,BLOCK_SIZE
					sub posX,BLOCK_SIZE
					sub posY,BLOCK_SIZE
					sub posX_,BLOCK_SIZE
					sub posX_,BLOCK_SIZE
					sub posY_,BLOCK_SIZE
					invoke Rectangle,hDcClock,posX,posY,posX_,posY_
				;1;
				;2;5;
				;3;
				;4;
				.elseif te.direction == 1
					mov eax,te.centerPosX
					mov ebx,te.centerPosY
					sub eax,BLOCK_SIZE
					sub ebx,BLOCK_SIZE
					mov posX,eax
					mov posY,ebx
					add eax,BLOCK_SIZE
					sub ebx,BLOCK_SIZE
					mov posX_,eax
					mov posY_,ebx
					invoke Rectangle,hDcClock,posX,posY,posX_,posY_
					add posY,BLOCK_SIZE
					add posY_,BLOCK_SIZE
					invoke Rectangle,hDcClock,posX,posY,posX_,posY_
					add posY,BLOCK_SIZE
					add posY_,BLOCK_SIZE
					invoke Rectangle,hDcClock,posX,posY,posX_,posY_
					add posY,BLOCK_SIZE
					add posY_,BLOCK_SIZE
					invoke Rectangle,hDcClock,posX,posY,posX_,posY_
					sub posY,BLOCK_SIZE
					sub posY,BLOCK_SIZE
					add posX,BLOCK_SIZE
					sub posY_,BLOCK_SIZE
					sub posY_,BLOCK_SIZE
					add posX_,BLOCK_SIZE
					invoke Rectangle,hDcClock,posX,posY,posX_,posY_
				;1;2;3;4;
					;5;
				.elseif te.direction == 2
					mov eax,te.centerPosX
					mov ebx,te.centerPosY
					sub eax,BLOCK_SIZE
					sub ebx,BLOCK_SIZE
					mov posX_,eax
					mov posY_,ebx
					sub eax,BLOCK_SIZE
					add ebx,BLOCK_SIZE
					mov posX,eax
					mov posY,ebx
					invoke Rectangle,hDcClock,posX,posY,posX_,posY_
					add posX,BLOCK_SIZE
					add posX_,BLOCK_SIZE
					invoke Rectangle,hDcClock,posX,posY,posX_,posY_
					add posX,BLOCK_SIZE
					add posX_,BLOCK_SIZE
					invoke Rectangle,hDcClock,posX,posY,posX_,posY_
					add posX,BLOCK_SIZE
					add posX_,BLOCK_SIZE
					invoke Rectangle,hDcClock,posX,posY,posX_,posY_
					sub posX,BLOCK_SIZE
					add posY,BLOCK_SIZE
					sub posX_,BLOCK_SIZE
					add posY_,BLOCK_SIZE
					invoke Rectangle,hDcClock,posX,posY,posX_,posY_			
				   ;2;
				   ;3;
				 ;1;4;
				   ;5;
				.elseif te.direction == 3
					mov eax,te.centerPosX
					mov ebx,te.centerPosY
					mov posX_,eax
					mov posY_,ebx
					sub eax,BLOCK_SIZE
					add ebx,BLOCK_SIZE
					mov posX,eax
					mov posY,ebx
					invoke Rectangle,hDcClock,posX,posY,posX_,posY_
					add posX,BLOCK_SIZE
					sub posY,BLOCK_SIZE
					sub posY,BLOCK_SIZE
					add posX_,BLOCK_SIZE
					sub posY_,BLOCK_SIZE
					sub posY_,BLOCK_SIZE
					invoke Rectangle,hDcClock,posX,posY,posX_,posY_
					add posY,BLOCK_SIZE
					add posY_,BLOCK_SIZE
					invoke Rectangle,hDcClock,posX,posY,posX_,posY_
					add posY,BLOCK_SIZE
					add posY_,BLOCK_SIZE
					invoke Rectangle,hDcClock,posX,posY,posX_,posY_
					add posY,BLOCK_SIZE
					add posY_,BLOCK_SIZE
					invoke Rectangle,hDcClock,posX,posY,posX_,posY_
				.endif	
			;形状5
			;posX，Y左下，posX_.posY_右上
			.elseif te.kind == 4
				  ;1;
				;2;3;4;
				  ;5;
				mov eax,te.centerPosX
				mov ebx,te.centerPosY
				add ebx,BLOCK_SIZE
				mov posX,eax
				mov posY,ebx
				add eax,BLOCK_SIZE
				sub ebx,BLOCK_SIZE
				mov posX_,eax
				mov posY_,ebx
				invoke Rectangle,hDcClock,posX,posY,posX_,posY_
				mov eax,posX_
				sub eax,BLOCK_SIZE
				add ebx,BLOCK_SIZE
				mov posX_,eax
				mov posY_,ebx
				sub posX,BLOCK_SIZE
				add posY,BLOCK_SIZE
				invoke Rectangle,hDcClock,posX,posY,posX_,posY_
				add posX,BLOCK_SIZE
				add posX_,BLOCK_SIZE
				invoke Rectangle,hDcClock,posX,posY,posX_,posY_
				add posX,BLOCK_SIZE
				add posX_,BLOCK_SIZE
				invoke Rectangle,hDcClock,posX,posY,posX_,posY_
				mov eax,posX_
				sub eax,BLOCK_SIZE
				add ebx,BLOCK_SIZE
				mov posX_,eax
				mov posY_,ebx
				sub posX,BLOCK_SIZE
				add posY,BLOCK_SIZE
				invoke Rectangle,hDcClock,posX,posY,posX_,posY_		
			.endif

;********************************************************************
			invoke	GetStockObject,NULL_PEN
			invoke	SelectObject,hDcClock,eax
			invoke	DeleteObject,eax


		.endif

		popad
		ret

_CreateFrontPic	endp
;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
_ClearBackBlock proc
	mov esi,offset blockListTemp
	mov edi,offset blockList
	mov ecx,BLOCK_NUM
	rep movsb
	ret
_ClearBackBlock endp
;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>


_CreateBackGround	proc
			local	@hDc;,@hBmpBack
			local	idx,posX,posY,posX_,posY_
;********************************************************************
; 建立需要的临时对象
;********************************************************************
		invoke	GetDC,hWinMain
		mov	@hDc,eax
		invoke	CreateCompatibleDC,@hDc
		mov	hDcBack,eax
		invoke	CreateCompatibleDC,@hDc
		mov	hDcClock,eax
		invoke	CreateCompatibleBitmap,@hDc,WIN_SIZE_X,WIN_SIZE_Y
		mov	hBmpBack,eax
		invoke	CreateCompatibleBitmap,@hDc,WIN_SIZE_X,WIN_SIZE_Y
		mov	hBmpClock,eax
		invoke	ReleaseDC,hWinMain,@hDc

		invoke	LoadBitmap,hInstance,dwNowBack
		mov	hBmpBackMap,eax
		
		invoke GetLastError
		mov error,eax

		invoke	SelectObject,hDcBack,hBmpBack
		invoke	SelectObject,hDcClock,hBmpClock
		
;********************************************************************
; 以背景图片填充
;********************************************************************
		invoke	CreatePatternBrush,hBmpBackMap
		push	eax
		invoke	SelectObject,hDcBack,eax
		invoke	PatBlt,hDcBack,0,0,WIN_SIZE_X,WIN_SIZE_Y,PATCOPY
		pop	eax
		invoke	DeleteObject,eax
;********************************************************************
; 画底层格子
;********************************************************************
		.if isEnd == 0
		invoke  CreateSolidBrush,76EE00h
		invoke	SelectObject,hDcBack,eax
		invoke	DeleteObject,eax
		invoke	CreatePen,PS_SOLID,3,0
		invoke	SelectObject,hDcBack,eax
		invoke	DeleteObject,eax
		
		;mov blockList[1],1
		;mov blockList[2],1

		mov idx,0
		.while idx<BLOCK_NUM_X*BLOCK_NUM_Y
			mov eax,idx
			.if blockList[eax]==1
				xor edx,edx
				mov ebx,BLOCK_NUM_X
				div ebx

				mov ebx,BLOCK_SIZE
				push edx
				inc eax
				mul ebx
				mov posY,eax
				sub eax,ebx
				mov posY_,eax

				pop eax
				mul ebx
				mov posX,eax
				add eax,ebx
				mov posX_,eax
				invoke	Rectangle,hDcBack,posX,posY,posX_,posY_
			.endif	
			inc idx
		.endw	
		
		.endif
		invoke	DeleteObject,hBmpBackMap

		ret

_CreateBackGround	endp
;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
_DeleteBackGround	proc

		invoke	DeleteDC,hDcBack
		invoke	DeleteDC,hDcClock
		invoke	DeleteObject,hBmpBack
		invoke	DeleteObject,hBmpClock
		ret

_DeleteBackGround	endp
;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
_NewTe		proc
	local	@stTime:SYSTEMTIME
	local	randNum
	invoke	GetLocalTime,addr @stTime
	movzx	eax,@stTime.wSecond
	;mov eax,0
	invoke  crt_srand,eax
	invoke  crt_rand
	mov randNum,eax

	mov ebx,5
	mov eax,randNum
	xor edx,edx
	div ebx

	.if edx == 0
		mov te.kind,0
		mov te.direction,0
		mov te.centerPosX,120
		mov te.centerPosY,30
		mov te.canChange,1
	.elseif edx == 1
		mov te.kind,1
		mov te.direction,0
		mov te.centerPosX,270
		mov te.centerPosY,30
		mov te.canChange,1
	.elseif edx == 2
		mov te.kind,2
		mov te.direction,0
		mov te.centerPosX,120
		mov te.centerPosY,30
		mov te.canChange,1
	.elseif edx == 3
		mov te.kind,3
		mov te.direction,0
		mov te.centerPosX,270
		mov te.centerPosY,30
		mov te.canChange,1
	.elseif edx == 4
		mov te.kind,4
		mov te.direction,0
		mov te.centerPosX,120
		mov te.centerPosY,30
		mov te.canChange,1
	.endif	
	ret
_NewTe		endp	
;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
_Init		proc
		;local	@hBmpBack,@hBmpCircle
;********************************************************************
; for debug
;********************************************************************
		invoke _NewTe

;********************************************************************
; 初始化菜单
;********************************************************************
		invoke	CreatePopupMenu
		mov	hMenu,eax
		invoke	AppendMenu,hMenu,0,IDM_EXIT,offset szMenuExit
;********************************************************************
; 设置圆形窗口并设置“总在最前面”
;********************************************************************
		;invoke	SetWindowPos,hWinMain,HWND_TOPMOST,0,0,0,0,	SWP_NOMOVE or SWP_NOSIZE
;********************************************************************
; 建立背景
;********************************************************************
		mov	dwNowBack,IDB_BACK1

		
		
		invoke	SetTimer,hWinMain,ID_TIMER,20,NULL
		invoke	_CreateBackGround
		invoke	_CreateFrontPic
		ret

_Init		endp
;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
_Quit		proc

		invoke	KillTimer,hWinMain,ID_TIMER
		invoke	DestroyWindow,hWinMain
		invoke	PostQuitMessage,NULL
		invoke	_DeleteBackGround
		invoke	DestroyMenu,hMenu
		ret

_Quit		endp
;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
_Down		proc
	local	blockNo
	local	hitFlag1,hitFlag2,hitFlag3,hitFlag4
	local	newTe
	local	idx,flag
	mov newTe,0

	mov eax, te.centerPosY
	xor edx,edx
	mov ebx,BLOCK_SIZE
	div ebx
	mov blockNo, eax
	
	.if edx == 0
		;mov eax,edx
		xor edx,edx
		mov ebx,BLOCK_NUM_X
		mul ebx
		mov blockNo,eax
		mov eax,te.centerPosX
		xor edx,edx
		mov ebx,BLOCK_SIZE
		div ebx
		add blockNo,eax
				
		.if te.kind == 0
			mov eax,blockNo
			add eax,BLOCK_NUM_X
			add eax,BLOCK_NUM_X
			add eax,BLOCK_NUM_X
			.if blockList[eax] == 1 || eax >= BLOCK_NUM
				mov hitFlag1,1
			.else
				mov hitFlag1,0
			.endif	

			mov hitFlag2,0
			mov eax,blockNo
			add eax,BLOCK_NUM_X
			sub eax,1
			.if blockList[eax] == 1 || eax >= BLOCK_NUM
				mov hitFlag2,1
			.endif
			inc eax
			.if blockList[eax] == 1 || eax >= BLOCK_NUM
				mov hitFlag2,1
			.endif
			inc eax
			.if blockList[eax] == 1 || eax >= BLOCK_NUM
				mov hitFlag2,1
			.endif
			inc eax
			.if blockList[eax] == 1 || eax >= BLOCK_NUM
				mov hitFlag2,1
			.endif

			.if te.direction == 0
				.if hitFlag1 == 1
					mov eax,blockNo
					sub eax,BLOCK_NUM_X
					mov blockList[eax],1
					add eax,BLOCK_NUM_X
					mov blockList[eax],1
					add eax,BLOCK_NUM_X
					mov blockList[eax],1
					add eax,BLOCK_NUM_X
					mov blockList[eax],1
					mov newTe,1
				.else
					add te.centerPosY,DOWN_SPEED
					.if hitFlag2 == 1
						mov te.canChange,0
					.else
						mov te.canChange,1
					.endif	
				.endif	
			.else
				.if hitFlag2 == 1
					mov eax,blockNo
					sub eax,1
					mov blockList[eax],1
					add eax,1
					mov blockList[eax],1
					add eax,1
					mov blockList[eax],1
					add eax,1
					mov blockList[eax],1
					mov newTe,1
				.else
					add te.centerPosY,DOWN_SPEED
					.if hitFlag1 == 1
						mov te.canChange,0
					.else
						mov te.canChange,1
					.endif	
				.endif	
			.endif	
		;形状1
		.elseif te.kind == 1
			mov hitFlag1,0
			mov eax,blockNo
			add eax,BLOCK_NUM_X
			add eax,BLOCK_NUM_X
			sub eax,1
			.if blockList[eax] == 1 || eax >= BLOCK_NUM
				mov hitFlag1,1
			.endif
			inc eax
			.if blockList[eax] == 1 || eax >= BLOCK_NUM
				mov hitFlag1,1
			.endif
			inc eax
			.if blockList[eax] == 1 || eax >= BLOCK_NUM
				mov hitFlag1,1
			.endif

			mov hitFlag2,0
			mov eax,blockNo
			.if blockList[eax] == 1 || eax >= BLOCK_NUM
				mov hitFlag2,1
			.endif
			inc eax
			.if blockList[eax] == 1 || eax >= BLOCK_NUM
				mov hitFlag2,1
			.endif
			add eax,BLOCK_NUM_X
			add eax,BLOCK_NUM_X
			sub eax,1
			sub eax,1
			.if blockList[eax] == 1 || eax >= BLOCK_NUM
				mov hitFlag2,1
			.endif

			mov hitFlag3,0
			mov eax,blockNo
			.if blockList[eax] == 1 || eax >= BLOCK_NUM
				mov hitFlag3,1
			.endif
			sub eax,1
			.if blockList[eax] == 1 || eax >= BLOCK_NUM
				mov hitFlag3,1
			.endif
			add eax,BLOCK_NUM_X
			add eax,BLOCK_NUM_X
			inc eax
			inc eax
			.if blockList[eax] == 1 || eax >= BLOCK_NUM
				mov hitFlag3,1
			.endif

			mov hitFlag4,0
			mov eax,blockNo
			add eax,BLOCK_NUM_X
			add eax,BLOCK_NUM_X
			sub eax,1
			.if blockList[eax] == 1 || eax >= BLOCK_NUM
				mov hitFlag4,1
			.endif
			inc eax
			.if blockList[eax] == 1 || eax >= BLOCK_NUM
				mov hitFlag4,1
			.endif
			inc eax
			.if blockList[eax] == 1 || eax >= BLOCK_NUM
				mov hitFlag4,1
			.endif

			.if te.direction == 0
				.if hitFlag1 == 1
					mov eax,blockNo
					sub eax,BLOCK_NUM_X
					sub eax,1
					mov blockList[eax],1
					add eax,BLOCK_NUM_X
					mov blockList[eax],1
					add eax,BLOCK_NUM_X
					mov blockList[eax],1
					add eax,1
					mov blockList[eax],1
					add eax,1
					mov blockList[eax],1
					mov newTe,1
				.else
					add te.centerPosY,DOWN_SPEED
					mov te.canChange,1
					.if hitFlag2 == 1
						mov te.canChange,0
					.endif		
				.endif
			.elseif te.direction == 1
				.if hitFlag2 == 1
					mov eax,blockNo
					sub eax,BLOCK_NUM_X
					sub eax,1
					mov blockList[eax],1
					inc eax
					mov blockList[eax],1
					inc eax
					mov blockList[eax],1
					add eax,BLOCK_NUM_X
					sub eax,1
					sub eax,1
					mov blockList[eax],1
					add eax,BLOCK_NUM_X
					mov blockList[eax],1
					mov newTe,1
				.else
					add te.centerPosY,DOWN_SPEED
					mov te.canChange,1
					.if hitFlag3 == 1
						mov te.canChange,0
					.endif
				.endif
			.elseif te.direction == 2
				.if hitFlag3 == 1
					mov eax,blockNo
					sub eax,BLOCK_NUM_X
					sub eax,1
					mov blockList[eax],1
					inc eax
					mov blockList[eax],1
					inc eax
					mov blockList[eax],1
					add eax,BLOCK_NUM_X
					mov blockList[eax],1
					add eax,BLOCK_NUM_X
					mov blockList[eax],1
					mov newTe,1
				.else
					add te.centerPosY,DOWN_SPEED
					mov te.canChange,1
					.if hitFlag4 == 1
						mov te.canChange,0
					.endif
				.endif
			.elseif te.direction == 3
				.if hitFlag4 == 1
					mov eax,blockNo
					sub eax,BLOCK_NUM_X
					inc eax
					mov blockList[eax],1
					add eax,BLOCK_NUM_X
					mov blockList[eax],1
					add eax,BLOCK_NUM_X
					mov blockList[eax],1
					sub eax,1
					mov blockList[eax],1
					sub eax,1
					mov blockList[eax],1
					mov newTe,1
				.else
					add te.centerPosY,DOWN_SPEED
					mov te.canChange,1
					.if hitFlag1 == 1
						mov te.canChange,0
					.endif
				.endif
			.endif
		;形状2
		.elseif te.kind == 2
			mov hitFlag1,0
			mov eax,blockNo 	
			add eax,BLOCK_NUM_X
			sub eax,1
			.if blockList[eax] == 1 || eax >= BLOCK_NUM
				mov hitFlag1,1
			.endif
			inc eax
			.if blockList[eax] == 1 || eax >= BLOCK_NUM
				mov hitFlag1,1
			.endif
			add eax,BLOCK_NUM_X
			inc eax
			.if blockList[eax] == 1 || eax >= BLOCK_NUM
				mov hitFlag1,1
			.endif
			mov hitFlag2,0
			mov eax,blockNo 
			inc eax
			.if blockList[eax] == 1 || eax >= BLOCK_NUM
				mov hitFlag2,1
			.endif
			add eax,BLOCK_NUM_X
			add eax,BLOCK_NUM_X
			sub eax,1
			.if blockList[eax] == 1 || eax >= BLOCK_NUM
				mov hitFlag2,1
			.endif
			sub eax,1
			.if blockList[eax] == 1 || eax >= BLOCK_NUM
				mov hitFlag2,1
			.endif

			.if te.direction == 0
				.if hitFlag1 == 1
					mov eax,blockNo
					sub eax,1
					sub eax,BLOCK_NUM_X
					mov blockList[eax],1
					add eax,BLOCK_NUM_X
					mov blockList[eax],1
					inc eax
					mov blockList[eax],1
					inc eax
					mov blockList[eax],1
					add eax,BLOCK_NUM_X
					mov blockList[eax],1
					mov newTe,1
				.else
					add te.centerPosY,DOWN_SPEED
					mov te.canChange,1
					.if hitFlag2 == 1
						mov te.canChange,0
					.endif
				.endif
			.elseif te.direction == 1
				.if hitFlag2 == 1
					mov eax,blockNo
					sub eax,BLOCK_NUM_X
					inc eax
					mov blockList[eax],1
					sub eax,1
					mov blockList[eax],1
					add eax,BLOCK_NUM_X
					mov blockList[eax],1
					add eax,BLOCK_NUM_X
					mov blockList[eax],1
					sub eax,1
					mov blockList[eax],1
					mov newTe,1
				.else
					add te.centerPosY,DOWN_SPEED
					mov te.canChange,1
					.if hitFlag1 == 1
						mov te.canChange,0
					.endif
				.endif
			.endif
		;形状3
		.elseif te.kind == 3
			mov hitFlag1,0
			mov eax,blockNo 	
			sub eax,1
			sub eax,1
			.if blockList[eax] == 1 || eax >= BLOCK_NUM
				mov hitFlag1,1
			.endif
			inc eax
			.if blockList[eax] == 1 || eax >= BLOCK_NUM
				mov hitFlag1,1
			.endif
			inc eax
			.if blockList[eax] == 1 || eax >= BLOCK_NUM
				mov hitFlag1,1
			.endif
			inc eax
			.if blockList[eax] == 1 || eax >= BLOCK_NUM
				mov hitFlag1,1
			.endif
			mov hitFlag2,0
			mov eax,blockNo 	
			.if blockList[eax] == 1 || eax >= BLOCK_NUM
				mov hitFlag2,1
			.endif
			sub eax,1
			add eax,BLOCK_NUM_X
			add eax,BLOCK_NUM_X
			.if blockList[eax] == 1 || eax >= BLOCK_NUM
				mov hitFlag2,1
			.endif
			mov hitFlag3,0
			mov eax,blockNo 
			sub eax,1
			sub eax,1
			.if blockList[eax] == 1 || eax >= BLOCK_NUM
				mov hitFlag3,1
			.endif
			inc eax
			.if blockList[eax] == 1 || eax >= BLOCK_NUM
				mov hitFlag3,1
			.endif
			inc eax
			inc eax
			.if blockList[eax] == 1 || eax >= BLOCK_NUM
				mov hitFlag3,1
			.endif
			add eax,BLOCK_NUM_X
			sub eax,1
			.if blockList[eax] == 1 || eax >= BLOCK_NUM
				mov hitFlag3,1
			.endif
			mov hitFlag4,0
			mov eax,blockNo 
			add eax,BLOCK_NUM_X
			sub eax,1
			.if blockList[eax] == 1 || eax >= BLOCK_NUM
				mov hitFlag4,1
			.endif
			inc eax
			add eax,BLOCK_NUM_X
			.if blockList[eax] == 1 || eax >= BLOCK_NUM
				mov hitFlag4,1
			.endif
			.if te.direction == 0
				.if hitFlag1 == 1
					mov eax,blockNo
					sub eax,1
					sub eax,BLOCK_NUM_X
					sub eax,BLOCK_NUM_X
					mov blockList[eax],1
					add eax,BLOCK_NUM_X
					mov blockList[eax],1
					sub eax,1
					mov blockList[eax],1
					add eax,1
					add eax,1
					mov blockList[eax],1
					add eax,1
					mov blockList[eax],1
					mov newTe,1
				.else
					add te.centerPosY,DOWN_SPEED
					mov te.canChange,1
					.if hitFlag2 == 1
						mov te.canChange,0
					.endif		
				.endif	
			.elseif te.direction == 1
				.if hitFlag2 == 1
					mov eax,blockNo
					sub eax,BLOCK_NUM_X
					mov blockList[eax],1
					sub eax,1
					mov blockList[eax],1
					sub eax,BLOCK_NUM_X
					mov blockList[eax],1
					add eax,BLOCK_NUM_X
					add eax,BLOCK_NUM_X
					mov blockList[eax],1
					add eax,BLOCK_NUM_X
					mov blockList[eax],1
					mov newTe,1
				.else
					add te.centerPosY,DOWN_SPEED
					mov te.canChange,1
					.if hitFlag3 == 1
						mov te.canChange,0
					.endif
				.endif
			.elseif te.direction == 2
				.if hitFlag3 == 1
					mov eax,blockNo
					sub eax,1
					sub eax,BLOCK_NUM_X
					mov blockList[eax],1
					sub eax,1
					mov blockList[eax],1
					inc eax
					inc eax
					mov blockList[eax],1
					inc eax
					mov blockList[eax],1
					add eax,BLOCK_NUM_X
					sub eax,1
					mov blockList[eax],1
					mov newTe,1					
				.else
					add te.centerPosY,DOWN_SPEED
					mov te.canChange,1
					.if hitFlag4 ==1
						mov te.canChange,0
					.endif 
				.endif				
			.elseif te.direction == 3
				.if hitFlag4 == 1
					mov eax,blockNo
					sub eax,BLOCK_NUM_X
					mov blockList[eax],1
					sub eax,BLOCK_NUM_X
					mov blockList[eax],1
					sub eax,1
					add eax,BLOCK_NUM_X
					add eax,BLOCK_NUM_X
					mov blockList[eax],1
					inc eax
					mov blockList[eax],1
					add eax,BLOCK_NUM_X
					mov blockList[eax],1
					mov newTe,1

				.else
					add te.centerPosY,DOWN_SPEED
					;add te.centerPosY,DOWN_SPEED
					mov te.canChange,1
					.if hitFlag1 == 1
						mov te.canChange,0
					.endif
				.endif
			.endif
		;形状4
		.elseif te.kind == 4
			mov hitFlag1,0
			mov eax,blockNo 
			add eax,BLOCK_NUM_X
			add eax,BLOCK_NUM_X
			sub eax,1
			.if blockList[eax] == 1 || eax >= BLOCK_NUM
				mov hitFlag1,1
			.endif		
			inc eax
			inc eax
			.if blockList[eax] == 1 || eax >= BLOCK_NUM
				mov hitFlag1,1
			.endif
			add eax,BLOCK_NUM_X
			sub eax,1
			.if blockList[eax] == 1 || eax >= BLOCK_NUM
				mov hitFlag1,1
			.endif
			.if hitFlag1 == 1
				mov eax,blockNo
				mov blockList[eax],1
				add eax,BLOCK_NUM_X
				sub eax,1
				mov blockList[eax],1
				inc eax
				mov blockList[eax],1
				inc eax
				mov blockList[eax],1
				add eax,BLOCK_NUM_X
				sub eax,1
				mov blockList[eax],1
				mov newTe,1
			.else
				add te.centerPosY,DOWN_SPEED
			.endif	
		.endif
	.else	
		add te.centerPosY,DOWN_SPEED
	.endif	

	.if newTe == 1
		mov idx,0
		.while idx< BLOCK_NUM_Y
			mov flag,0
			mov eax,idx
			mov ebx,BLOCK_NUM_X
			mul ebx
			xor ecx,ecx
			.while ecx<BLOCK_NUM_X
				.if blockList[eax][ecx] == 0
					mov flag,1
				.endif	
				inc ecx
			.endw
			.if flag==0
				;<<<<<<<<<<<<<<<<<<<<<<<<<<
				mov ecx,eax
				std
				lea edi, blockList[eax+BLOCK_NUM_X-1]
				lea esi, blockList[eax-1]
				rep movsb
				cld
				mov ecx,BLOCK_NUM_X
				lea edi,blockList
				lea esi,blockListTemp
				rep movsb
				;<<<<<<<<<<<<<<<<<<<<<<<<<<
			.endif	
			inc idx
		.endw
		invoke	_DeleteBackGround
		invoke	_CreateBackGround
		invoke _NewTe
	.endif	

	;add te.centerPosY,DOWN_SPEED
	ret
_Down		endp	
;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
_ProcWinMain	proc	uses ebx edi esi hWnd,uMsg,wParam,lParam
		local	@stPS:PAINTSTRUCT
		local	@hDC
		local	@stPos:POINT
		local	posX,posY
		local	flag,hitflag1,hitflag2,hitflag3,hitflag4
		local	blockNo
		mov	eax,uMsg
;********************************************************************
		.if	eax ==	WM_TIMER
			invoke	_Down
			invoke	_CreateFrontPic
			invoke	InvalidateRect,hWnd,NULL,FALSE
;********************************************************************
		.elseif	eax ==	WM_PAINT
			invoke	BeginPaint,hWnd,addr @stPS
			mov	@hDC,eax

			mov	eax,@stPS.rcPaint.right
			sub	eax,@stPS.rcPaint.left
			mov	ecx,@stPS.rcPaint.bottom
			sub	ecx,@stPS.rcPaint.top

			invoke	BitBlt,@hDC,@stPS.rcPaint.left,@stPS.rcPaint.top,eax,ecx,\
				hDcClock,@stPS.rcPaint.left,@stPS.rcPaint.top,SRCCOPY
			invoke	EndPaint,hWnd,addr @stPS
;********************************************************************
		.elseif	eax ==	WM_CREATE
			mov	eax,hWnd
			mov	hWinMain,eax
			invoke	_Init
;********************************************************************
		.elseif	eax == WM_KEYDOWN
			mov eax,wParam
			.if eax == VK_Q
				call	_Quit
				xor	eax,eax
				ret
			.elseif	eax == VK_R
				.if isEnd == 1
					mov isEnd,0
					mov dwNowBack,IDB_BACK1
					invoke	SetTimer,hWinMain,ID_TIMER,20,NULL
					invoke _NewTe
					invoke	_CreateBackGround
					invoke	_CreateFrontPic
					invoke	InvalidateRect,hWnd,NULL,FALSE
				.else
					;temp
					mov isEnd,1
					mov dwNowBack,IDB_END
					invoke	KillTimer,hWinMain,ID_TIMER
					invoke	_CreateBackGround
					invoke	_CreateFrontPic
					invoke	InvalidateRect,hWnd,NULL,FALSE
					invoke _ClearBackBlock
					;tempend
				.endif
			.elseif	eax == VK_C
				add dwNowBack,3
				.if dwNowBack == IDB_BACK5+3
					mov dwNowBack,IDB_BACK1
				.endif
				invoke	_CreateBackGround
				invoke	_CreateFrontPic
				invoke	InvalidateRect,hWnd,NULL,FALSE
			.elseif	eax == VK_P
				.if isMoving == 1
					mov isMoving ,0
					invoke	KillTimer,hWinMain,ID_TIMER
				.elseif	
					mov isMoving,1
					invoke	SetTimer,hWinMain,ID_TIMER,20,NULL
				.endif	
			;W键
			.elseif	eax == VK_W;change direction
				mov eax,te.centerPosY
				xor edx,edx
				mov ebx,BLOCK_SIZE
				div ebx
				xor edx,edx
				mov ebx,BLOCK_NUM_X
				mul ebx 
				mov blockNo,eax
				mov eax,te.centerPosX
				xor edx,edx
				mov ebx,BLOCK_SIZE
				div ebx
				add blockNo,eax	
				mov hitflag1,0
				.if te.canChange == 1
					.if te.kind ==0
						.if te.direction==0
							.if te.centerPosX >= BLOCK_SIZE && te.centerPosX <= BLOCK_NUM_X*BLOCK_SIZE-3*BLOCK_SIZE
								mov te.direction,1
							.endif	
						.elseif	 te.direction==1
							mov te.direction,0
						.endif	
					;形状1
					.elseif te.kind == 1
						.if te.direction == 0
							mov eax,blockNo
							sub eax,BLOCK_NUM_X
							.if blockList[eax] == 1
								mov hitflag1,1
							.endif
							inc eax
							.if blockList[eax] == 1
								mov hitflag1,1
							.endif
							.if hitflag1 == 0
								mov te.direction,1
							.endif
						.elseif te.direction == 1
							mov eax,blockNo
							inc eax
							.if blockList[eax] == 1
								mov hitflag1,1
							.endif
							add eax,BLOCK_NUM_X
							.if blockList[eax] == 1
								mov hitflag1,1
							.endif
							.if hitflag1 == 0
								mov te.direction,2
							.endif
						.elseif te.direction == 2
							mov eax,blockNo
							add eax,BLOCK_NUM_X
							.if blockList[eax] == 1
								mov hitflag1,1
							.endif
							sub eax,1
							.if blockList[eax] == 1
								mov hitflag1,1
							.endif
							.if hitflag1 == 0
								mov te.direction,3
							.endif
						.elseif te.direction == 3
							mov eax,blockNo
							sub eax,1
							.if blockList[eax] == 1
								mov hitflag1,1
							.endif
							sub eax,BLOCK_NUM_X
							.if blockList[eax] == 1
								mov hitflag1,1
							.endif
							.if hitflag1 == 0
								mov te.direction,0
							.endif
						.endif	
					;形状2
					.elseif te.kind == 2
						.if te.direction == 0
							mov eax,blockNo
							sub eax,BLOCK_NUM_X
							.if blockList[eax] == 1
								mov hitflag1,1
							.endif
							inc eax
							.if blockList[eax] == 1
								mov hitflag1,1
							.endif
							add eax,BLOCK_NUM_X
							add eax,BLOCK_NUM_X
							sub eax,1
							.if blockList[eax] == 1
								mov hitflag1,1
							.endif
							sub eax,1
							.if blockList[eax] == 1
								mov hitflag1,1
							.endif
							.if hitflag1 == 0
								mov te.direction,1
							.endif
						.elseif te.direction == 1
							mov eax,blockNo
							sub eax,1
							sub eax,BLOCK_NUM_X
							.if blockList[eax] == 1
								mov hitflag1,1
							.endif
							add eax,BLOCK_NUM_X
							.if blockList[eax] == 1
								mov hitflag1,1
							.endif
							inc eax
							inc eax
							.if blockList[eax] == 1
								mov hitflag1,1
							.endif
							add eax,BLOCK_NUM_X
							.if blockList[eax] == 1
								mov hitflag1,1
							.endif
							.if hitflag1 == 0
								mov te.direction,0
							.endif
						.endif
					;形状3
					.elseif te.kind == 3
						.if te.direction == 0
							mov eax,blockNo						
							sub eax,1
							.if blockList[eax] == 1
								mov hitflag1,1
							.endif
							add eax,BLOCK_NUM_X
							.if blockList[eax] == 1
								mov hitflag1,1
							.endif
							.if hitflag1 == 0
								mov te.direction,1
							.endif
						.elseif te.direction == 1
							.if te.centerPosX >= 2*BLOCK_SIZE && te.centerPosX <= BLOCK_NUM_X*BLOCK_SIZE-2*BLOCK_SIZE
								mov eax,blockNo
								.if blockList[eax] == 1
									mov hitflag1,1
								.endif		
								add eax,1
								sub eax,BLOCK_NUM_X
								.if blockList[eax] == 1
									mov hitflag1,1
								.endif	
								sub eax,3
								.if blockList[eax] == 1
									mov hitflag1,1
								.endif	
								.if hitflag1 == 0
									mov te.direction,2
								.endif
							.endif
						.elseif te.direction == 2
							mov eax,blockNo
							sub eax,1
							.if blockList[eax] == 1
								mov hitflag1,1
							.endif
							inc eax
							add eax,BLOCK_NUM_X
							.if blockList[eax] == 1
								mov hitflag1,1
							.endif
							sub eax,BLOCK_NUM_X
							sub eax,BLOCK_NUM_X
							sub eax,BLOCK_NUM_X
							.if blockList[eax] == 1
								mov hitflag1,1
							.endif
							.if hitflag1 == 0 
								mov te.direction,3
							.endif
						.elseif te.direction == 3
							.if te.centerPosX >= 2*BLOCK_SIZE && te.centerPosX <= BLOCK_NUM_X*BLOCK_SIZE-2*BLOCK_SIZE
								mov eax,blockNo
								inc eax
								sub eax,BLOCK_NUM_X
								.if blockList[eax] == 1
									mov hitflag1,1
								.endif	
								sub eax,2
								.if blockList[eax] == 1
									mov hitflag1,1
								.endif	
								sub eax,1
								.if blockList[eax] == 1
									mov hitflag1,1
								.endif	
								inc eax
								sub eax,BLOCK_NUM_X
								.if blockList[eax] == 1
									mov hitflag1,1
								.endif	
								.if hitflag1 == 0
									mov te.direction,0
								.endif
							.endif
						.endif
					.endif	
				.endif	
			;A键
			.elseif	eax == VK_A		
				mov eax,te.centerPosY
				xor edx,edx
				mov ebx,BLOCK_SIZE
				div ebx
				mov blockNo, eax
				mov flag,edx
				xor edx,edx
				mov ebx,BLOCK_NUM_X
				mul ebx
				mov blockNo,eax
				mov eax,te.centerPosX
				xor edx,edx
				mov ebx,BLOCK_SIZE
				div ebx
				add blockNo,eax	
				mov hitflag1,0
				mov hitflag2,0
				.if te.kind == 0
					.if te.direction == 0
						.if te.centerPosX >= BLOCK_SIZE
							mov hitflag1,0
							mov eax, te.centerPosY
							xor edx,edx
							mov ebx,BLOCK_SIZE
							div ebx
							push edx

							;mov eax,edx
							xor edx,edx
							mov ebx,BLOCK_NUM_X
							mul ebx
							mov blockNo,eax
							mov eax,te.centerPosX
							xor edx,edx
							mov ebx,BLOCK_SIZE
							div ebx
							add eax,blockNo

							dec eax

							mov blockNo, eax
							sub eax,BLOCK_NUM_X
							.if blockList[eax]==1
								mov hitflag1,1
							.endif	
							add eax,BLOCK_NUM_X
							.if blockList[eax]==1
								mov hitflag1,1
							.endif	
							add eax,BLOCK_NUM_X
							.if blockList[eax]==1
								mov hitflag1,1
							.endif
							add eax,BLOCK_NUM_X
							.if blockList[eax]==1
								mov hitflag1,1
							.endif
							pop edx
							.if edx != 0
								add eax,BLOCK_NUM_X
								.if blockList[eax]==1
									mov hitflag1,1
								.endif
							.endif	

							.if hitflag1==0
								sub te.centerPosX,BLOCK_SIZE
							.endif	
						.endif	
					.elseif	
						.if te.centerPosX >= 2*BLOCK_SIZE
							mov hitflag1,0
							mov eax, te.centerPosY
							xor edx,edx
							mov ebx,BLOCK_SIZE
							div ebx
							push edx

							;mov eax,edx
							xor edx,edx
							mov ebx,BLOCK_NUM_X
							mul ebx
							mov blockNo,eax
							mov eax,te.centerPosX
							xor edx,edx
							mov ebx,BLOCK_SIZE
							div ebx
							add eax,blockNo

							dec eax

							mov blockNo, eax
							sub eax,1
							.if blockList[eax]==1
								mov hitflag1,1
							.endif	
							add eax,1
							.if blockList[eax]==1
								mov hitflag1,1
							.endif	
							add eax,1
							.if blockList[eax]==1
								mov hitflag1,1
							.endif
							add eax,1
							.if blockList[eax]==1
								mov hitflag1,1
							.endif
							pop edx
							.if edx != 0
								mov eax,blockNo
								add eax,BLOCK_NUM_X
								sub eax,1
								.if blockList[eax]==1
									mov hitflag1,1
								.endif	
								add eax,1
								.if blockList[eax]==1
									mov hitflag1,1
								.endif	
								add eax,1
								.if blockList[eax]==1
									mov hitflag1,1
								.endif
								add eax,1
								.if blockList[eax]==1
									mov hitflag1,1
								.endif								
							.endif
							.if hitflag1==0
								sub te.centerPosX,BLOCK_SIZE
							.endif
						.endif
					.endif	
				;形状1
				.elseif te.kind == 1
					.if te.direction == 0
						.if te.centerPosX >= 2*BLOCK_SIZE
							mov eax,blockNo
							sub eax,BLOCK_SIZE
							sub eax,2
							.if blockList[eax] == 1
								mov hitflag1,1
							.endif
							add eax,BLOCK_NUM_X
							.if blockList[eax] == 1
								mov hitflag1,1
							.endif
							add eax,BLOCK_NUM_X
							.if blockList[eax] == 1
								mov hitflag1,1
							.endif
							add eax,BLOCK_NUM_X
							.if blockList[eax] == 1
								mov hitflag2,1
							.endif
							inc eax
							.if blockList[eax] == 1
								mov hitflag2,1
							.endif
							inc eax
							.if blockList[eax] == 1
								mov hitflag2,1
							.endif
							.if flag == 0
								.if hitflag1 == 0
									sub te.centerPosX,BLOCK_SIZE
								.endif
							.else
								.if hitflag1 == 0 && hitflag2 == 0
									sub te.centerPosX,BLOCK_SIZE
								.endif
							.endif
						.endif
					.elseif te.direction == 1
						.if te.centerPosX >= 2*BLOCK_SIZE
							mov eax,blockNo
							sub eax,BLOCK_NUM_X
							sub eax,2
							.if blockList[eax] == 1
								mov hitflag1,1
							.endif
							add eax,BLOCK_NUM_X
							.if blockList[eax] == 1
								mov hitflag1,1
							.endif
							add eax,2
							.if blockList[eax] == 1
								mov hitflag2,1
							.endif
							add eax,BLOCK_NUM_X
							sub eax,2
							.if blockList[eax] == 1
								mov hitflag1,1
							.endif
							add eax,BLOCK_NUM_X
							.if blockList[eax] == 1
								mov hitflag2,1
							.endif
							.if flag == 0
								.if hitflag1 == 0
									sub te.centerPosX,BLOCK_SIZE
								.endif
							.else
								.if hitflag1 == 0 && hitflag2 == 0
									sub te.centerPosX,BLOCK_SIZE
								.endif
							.endif
						.endif
					.elseif te.direction == 2
						.if te.centerPosX >= 2*BLOCK_SIZE
							mov eax,blockNo
							sub eax,BLOCK_NUM_X
							sub eax,2
							.if blockList[eax] == 1
								mov hitflag1,1
							.endif
							add eax,BLOCK_NUM_X
							.if blockList[eax] == 1
								mov hitflag2,1
							.endif
							inc eax
							.if blockList[eax] == 1
								mov hitflag2,1
							.endif
							inc eax
							.if blockList[eax] == 1
								mov hitflag1,1
							.endif
							add eax,BLOCK_NUM_X
							.if blockList[eax] == 1
								mov hitflag1,1
							.endif
							add eax,BLOCK_NUM_X
							.if blockList[eax] == 1
								mov hitflag2,1
							.endif
							.if flag == 0
								.if hitflag1 == 0
									sub te.centerPosX,BLOCK_SIZE
								.endif
							.else
								.if hitflag1 == 0 && hitflag2 == 0
									sub te.centerPosX,BLOCK_SIZE
								.endif
							.endif
						.endif
					.elseif te.direction == 3
						.if te.centerPosX >= 2*BLOCK_SIZE
							mov eax,blockNo
							sub eax,BLOCK_NUM_X
							.if blockList[eax] == 1
								mov hitflag1,1
							.endif
							add eax,BLOCK_NUM_X
							.if blockList[eax] == 1
								mov hitflag1,1
							.endif
							add eax,BLOCK_NUM_X
							sub eax,2
							.if blockList[eax] == 1
								mov hitflag1,1
							.endif
							add eax,BLOCK_NUM_X
							.if blockList[eax] == 1
								mov hitflag2,1
							.endif
							inc eax
							.if blockList[eax] == 1
								mov hitflag2,1
							.endif
							inc eax
							.if blockList[eax] == 1
								mov hitflag2,1
							.endif
							sub te.centerPosX,BLOCK_SIZE
						.endif
					.endif
				;形状2
				.elseif te.kind == 2
					.if te.direction == 0
						.if te.centerPosX >= 2*BLOCK_SIZE
							mov eax,blockNo
							sub eax,BLOCK_NUM_X
							sub eax,2
							.if blockList[eax] == 1
								mov hitflag1,1
							.endif
							add eax,BLOCK_NUM_X
							.if blockList[eax] == 1
								mov hitflag1,1
							.endif
							add eax,BLOCK_NUM_X
							.if blockList[eax] == 1
								mov hitflag2,1
							.endif
							inc eax
							.if blockList[eax] == 1
								mov hitflag2,1
							.endif
							inc eax
							.if blockList[eax] == 1
								mov hitflag1,1
							.endif
							add eax,BLOCK_NUM_X
							.if blockList[eax] == 1
								mov hitflag2,1
							.endif
							.if flag == 0
								.if hitflag1 == 0
									sub te.centerPosX,BLOCK_SIZE
								.endif
							.else
								.if hitflag1 == 0 && hitflag2 == 0
									sub te.centerPosX,BLOCK_SIZE
								.endif
							.endif
						.endif
					.elseif te.direction == 1
						.if te.centerPosX >= 2*BLOCK_SIZE
							mov eax,blockNo
							sub eax,BLOCK_NUM_X
							sub eax,1
							.if blockList[eax] == 1
								mov hitflag1,1
							.endif
							add eax,BLOCK_NUM_X
							.if blockList[eax] == 1
								mov hitflag1,1
							.endif
							add eax,BLOCK_NUM_X
							sub eax,1
							.if blockList[eax] == 1
								mov hitflag1,1
							.endif
							add eax,BLOCK_NUM_X
							.if blockList[eax] == 1
								mov hitflag2,1
							.endif
							inc eax
							.if blockList[eax] == 1
								mov hitflag2,1
							.endif
							.if flag == 0
								.if hitflag1 == 0
									sub te.centerPosX,BLOCK_SIZE
								.endif
							.else
								.if hitflag1 == 0 && hitflag2 == 0
									sub te.centerPosX,BLOCK_SIZE
								.endif
							.endif
						.endif
					.endif
				;形状3
				.elseif te.kind == 3
					.if te.direction == 0
						.if te.centerPosX >= 3*BLOCK_SIZE
							mov eax,blockNo
							sub eax,2
							sub eax,BLOCK_NUM_X
							sub eax,BLOCK_NUM_X
							.if blockList[eax] == 1
								mov hitflag1,1
							.endif
							add eax,BLOCK_NUM_X
							sub eax,1
							.if blockList[eax] == 1
								mov hitflag1,1
							.endif
							add eax,BLOCK_NUM_X
							.if blockList[eax] == 1
								mov hitflag2,1
							.endif
							.if flag == 0
								.if hitflag1 == 0
									sub te.centerPosX,BLOCK_SIZE
								.endif
							.else
								.if hitflag1 == 0 && hitflag2 == 0
									sub te.centerPosX,BLOCK_SIZE
								.endif
							.endif
						.endif
					.elseif te.direction == 1
						.if te.centerPosX >= 2*BLOCK_SIZE
							mov eax,blockNo
							sub eax,2
							sub eax,BLOCK_NUM_X
							sub eax,BLOCK_NUM_X
							.if blockList[eax] == 1
								mov hitflag1,1
							.endif
							add eax,BLOCK_NUM_X
							.if blockList[eax] == 1
								mov hitflag1,1
							.endif
							add eax,BLOCK_NUM_X
							.if blockList[eax] == 1
								mov hitflag1,1
							.endif
							add eax,BLOCK_NUM_X
							.if blockList[eax] == 1
								mov hitflag1,1
							.endif
							add eax,BLOCK_NUM_X
							.if blockList[eax] == 1
								mov hitflag2,1
							.endif
							.if flag == 0
								.if hitflag1 == 0
									sub te.centerPosX,BLOCK_SIZE
								.endif
							.else
								.if hitflag1 == 0 && hitflag2 == 0
									sub te.centerPosX,BLOCK_SIZE
								.endif
							.endif
						.endif
					.elseif te.direction == 2
						.if te.centerPosX >= 3*BLOCK_SIZE
							mov eax,blockNo
							sub eax,1
							.if blockList[eax] == 1
								mov hitflag1,1
							.endif
							sub eax,2
							sub eax,BLOCK_NUM_X
							.if blockList[eax] == 1
								mov hitflag1,1
							.endif
							add eax,BLOCK_NUM_X
							.if blockList[eax] == 1
								mov hitflag2,1
							.endif
							add eax,BLOCK_NUM_X
							add eax,2
							.if blockList[eax] == 1
								mov hitflag2,1
							.endif
							.if flag == 0
								.if hitflag1 == 0
									sub te.centerPosX,BLOCK_SIZE
								.endif
							.else
								.if hitflag1 == 0 && hitflag2 == 0
									sub te.centerPosX,BLOCK_SIZE
								.endif
							.endif
						.endif
					.elseif te.direction == 3
						.if te.centerPosX >= 2*BLOCK_SIZE
							mov eax,blockNo
							sub eax,1
							sub eax,BLOCK_NUM_X
							sub eax,BLOCK_NUM_X
							.if blockList[eax] == 1
								mov hitflag1,1
							.endif
							add eax,BLOCK_NUM_X
							.if blockList[eax] == 1
								mov hitflag1,1
							.endif							
							add eax,BLOCK_NUM_X
							sub eax,1
							.if blockList[eax] == 1
								mov hitflag1,1
							.endif
							add eax,1
							add eax,BLOCK_NUM_X
							.if blockList[eax] == 1
								mov hitflag1,1
							.endif
							sub eax,1
							.if blockList[eax] == 1
								mov hitflag2,1
							.endif
							add eax,1
							add eax,BLOCK_NUM_X
							.if blockList[eax] == 1
								mov hitflag2,1
							.endif
							.if flag == 0
								.if hitflag1 == 0
									sub te.centerPosX,BLOCK_SIZE
								.endif
							.else
								.if hitflag1 == 0 && hitflag2 == 0
									sub te.centerPosX,BLOCK_SIZE
								.endif
							.endif
						.endif
					.endif
				;形状4
				.elseif te.kind == 4
					.if te.centerPosX >= 2*BLOCK_SIZE
						mov eax,blockNo
						sub eax,1
						.if blockList[eax] == 1
							mov hitflag1,1
						.endif
						sub eax,1
						add eax,BLOCK_NUM_X
						.if blockList[eax] == 1
							mov hitflag1,1
						.endif
						add eax,1
						add eax,BLOCK_NUM_X
						.if blockList[eax] == 1
							mov hitflag1,1
						.endif
						sub eax,1
						.if blockList[eax] == 1
							mov hitflag2,1
						.endif
						inc eax
						add eax,BLOCK_NUM_X
						.if blockList[eax] == 1
							mov hitflag2,1
						.endif
						.if flag == 0
							.if hitflag1 == 0
								sub te.centerPosX,BLOCK_SIZE
							.endif
						.else
							.if hitflag1 == 0 && hitflag2 == 0
								sub te.centerPosX,BLOCK_SIZE
							.endif
						.endif
					.endif
				.endif			
			.elseif	eax == VK_S			
			;D键	
			.elseif	eax == VK_D
				mov eax,te.centerPosY
				xor edx,edx
				mov ebx,BLOCK_SIZE
				div ebx
				mov blockNo, eax
				mov flag,edx
				xor edx,edx
				mov ebx,BLOCK_NUM_X
				mul ebx
				mov blockNo,eax
				mov eax,te.centerPosX
				xor edx,edx
				mov ebx,BLOCK_SIZE
				div ebx
				add blockNo,eax	
				mov hitflag1,0
				mov hitflag2,0
				.if te.kind == 0
					.if te.direction == 0
						.if te.centerPosX <= BLOCK_NUM_X*BLOCK_SIZE-2*BLOCK_SIZE
							mov hitflag1,0
							mov eax, te.centerPosY
							xor edx,edx
							mov ebx,BLOCK_SIZE
							div ebx
							push edx

							;mov eax,edx
							xor edx,edx
							mov ebx,BLOCK_NUM_X
							mul ebx
							mov blockNo,eax
							mov eax,te.centerPosX
							xor edx,edx
							mov ebx,BLOCK_SIZE
							div ebx
							add eax,blockNo

							inc eax

							mov blockNo, eax
							sub eax,BLOCK_NUM_X
							.if blockList[eax]==1
								mov hitflag1,1
							.endif	
							add eax,BLOCK_NUM_X
							.if blockList[eax]==1
								mov hitflag1,1
							.endif	
							add eax,BLOCK_NUM_X
							.if blockList[eax]==1
								mov hitflag1,1
							.endif
							add eax,BLOCK_NUM_X
							.if blockList[eax]==1
								mov hitflag1,1
							.endif
							pop edx
							.if edx != 0
								add eax,BLOCK_NUM_X
								.if blockList[eax]==1
									mov hitflag1,1
								.endif
							.endif	

							.if hitflag1==0
								add te.centerPosX,BLOCK_SIZE
							.endif	
						.endif	
					.elseif	
						.if te.centerPosX <= BLOCK_NUM_X*BLOCK_SIZE-4*BLOCK_SIZE
							mov hitflag1,0
							mov eax, te.centerPosY
							xor edx,edx
							mov ebx,BLOCK_SIZE
							div ebx
							push edx

							;mov eax,edx
							xor edx,edx
							mov ebx,BLOCK_NUM_X
							mul ebx
							mov blockNo,eax
							mov eax,te.centerPosX
							xor edx,edx
							mov ebx,BLOCK_SIZE
							div ebx
							add eax,blockNo

							inc eax

							mov blockNo, eax
							sub eax,1
							.if blockList[eax]==1
								mov hitflag1,1
							.endif	
							add eax,1
							.if blockList[eax]==1
								mov hitflag1,1
							.endif	
							add eax,1
							.if blockList[eax]==1
								mov hitflag1,1
							.endif
							add eax,1
							.if blockList[eax]==1
								mov hitflag1,1
							.endif
							pop edx
							.if edx != 0
								mov eax,blockNo
								add eax,BLOCK_NUM_X
								sub eax,1
								.if blockList[eax]==1
									mov hitflag1,1
								.endif	
								add eax,1
								.if blockList[eax]==1
									mov hitflag1,1
								.endif	
								add eax,1
								.if blockList[eax]==1
									mov hitflag1,1
								.endif
								add eax,1
								.if blockList[eax]==1
									mov hitflag1,1
								.endif								
							.endif
							.if hitflag1==0
								add te.centerPosX,BLOCK_SIZE
							.endif
						.endif
					.endif	
				;形状1
				.elseif te.kind == 1
					.if te.direction == 0
						.if te.centerPosX <= BLOCK_NUM_X*BLOCK_SIZE-3*BLOCK_SIZE
							mov eax,blockNo
							sub eax,BLOCK_NUM_X
							.if blockList[eax]==1
								mov hitflag1,1
							.endif
							add eax,BLOCK_NUM_X
							.if blockList[eax]==1
								mov hitflag1,1
							.endif
							add eax,BLOCK_NUM_X
							add eax,2
							.if blockList[eax]==1
								mov hitflag1,1
							.endif
							add eax,BLOCK_NUM_X
							.if blockList[eax]==1
								mov hitflag2,1
							.endif
							sub eax,1
							.if blockList[eax]==1
								mov hitflag2,1
							.endif
							sub eax,1
							.if blockList[eax]==1
								mov hitflag2,1
							.endif
							.if flag == 0
								.if hitflag1 == 0
									add te.centerPosX,BLOCK_SIZE
								.endif
							.else
								.if hitflag1 == 0 && hitflag2 == 0
									add te.centerPosX,BLOCK_SIZE
								.endif
							.endif
						.endif						
					.elseif te.direction == 1
						.if te.centerPosX <= BLOCK_NUM_X*BLOCK_SIZE-3*BLOCK_SIZE
							mov eax,blockNo
							sub eax,BLOCK_NUM_X
							add eax,2
							.if blockList[eax]==1
								mov hitflag1,1
							.endif
							add eax,BLOCK_NUM_X
							.if blockList[eax]==1
								mov hitflag2,1
							.endif
							sub eax,1
							.if blockList[eax]==1
								mov hitflag2,1
							.endif
							sub eax,1
							.if blockList[eax]==1
								mov hitflag1,1
							.endif
							add eax,BLOCK_NUM_X
							.if blockList[eax]==1
								mov hitflag1,1
							.endif
							add eax,BLOCK_NUM_X
							.if blockList[eax]==1
								mov hitflag2,1
							.endif
							.if flag == 0
								.if hitflag1 == 0
									add te.centerPosX,BLOCK_SIZE
								.endif
							.else
								.if hitflag1 == 0 && hitflag2 == 0
									add te.centerPosX,BLOCK_SIZE
								.endif
							.endif
						.endif
					.elseif te.direction == 2
						.if te.centerPosX <= BLOCK_NUM_X*BLOCK_SIZE-3*BLOCK_SIZE
							mov eax,blockNo
							.if blockList[eax]==1
								mov hitflag2,1
							.endif
							sub eax,BLOCK_NUM_X
							add eax,2
							.if blockList[eax]==1
								mov hitflag1,1
							.endif
							add eax,BLOCK_NUM_X
							.if blockList[eax]==1
								mov hitflag1,1
							.endif
							add eax,BLOCK_NUM_X
							.if blockList[eax]==1
								mov hitflag1,1
							.endif
							add eax,BLOCK_NUM_X
							.if blockList[eax]==1
								mov hitflag2,1
							.endif
							.if flag == 0
								.if hitflag1 == 0
									add te.centerPosX,BLOCK_SIZE
								.endif
							.else
								.if hitflag1 == 0 && hitflag2 == 0
									add te.centerPosX,BLOCK_SIZE
								.endif
							.endif
						.endif
					.elseif te.direction == 3
						.if te.centerPosX <= BLOCK_NUM_X*BLOCK_SIZE-3*BLOCK_SIZE
							mov eax,blockNo
							sub eax,BLOCK_NUM_X
							add eax,2
							.if blockList[eax]==1
								mov hitflag1,1
							.endif
							add eax,BLOCK_NUM_X
							.if blockList[eax]==1
								mov hitflag1,1
							.endif
							add eax,BLOCK_NUM_X
							.if blockList[eax]==1
								mov hitflag1,1
							.endif
							add eax,BLOCK_NUM_X
							.if blockList[eax]==1
								mov hitflag2,1
							.endif
							sub eax,1
							.if blockList[eax]==1
								mov hitflag2,1
							.endif
							sub eax,1
							.if blockList[eax]==1
								mov hitflag2,1
							.endif
							.if flag == 0
								.if hitflag1 == 0
									add te.centerPosX,BLOCK_SIZE
								.endif
							.else
								.if hitflag1 == 0 && hitflag2 == 0
									add te.centerPosX,BLOCK_SIZE
								.endif
							.endif
						.endif
					.endif
				;形状2
				.elseif te.kind == 2
					.if te.direction == 0
						.if te.centerPosX <= BLOCK_NUM_X*BLOCK_SIZE-3*BLOCK_SIZE
							mov eax,blockNo
							sub eax,BLOCK_NUM_X
							.if blockList[eax]==1
								mov hitflag1,1
							.endif
							add eax,BLOCK_NUM_X
							add eax,2
							.if blockList[eax]==1
								mov hitflag1,1
							.endif
							add eax,BLOCK_NUM_X
							.if blockList[eax]==1
								mov hitflag1,1
							.endif
							sub eax,2
							.if blockList[eax]==1
								mov hitflag2,1
							.endif
							add eax,BLOCK_NUM_X
							add eax,2
							.if blockList[eax]==1
								mov hitflag2,1
							.endif
							.if flag == 0
								.if hitflag1 == 0
									add te.centerPosX,BLOCK_SIZE
								.endif
							.else
								.if hitflag1 == 0 && hitflag2 == 0
									add te.centerPosX,BLOCK_SIZE
								.endif
							.endif
						.endif		
					.elseif te.direction == 1
						.if te.centerPosX <= BLOCK_NUM_X*BLOCK_SIZE-3*BLOCK_SIZE
							mov eax,blockNo
							sub eax,BLOCK_NUM_X
							add eax,2
							.if blockList[eax]==1
								mov hitflag1,1
							.endif
							add eax,BLOCK_NUM_X
							.if blockList[eax]==1
								mov hitflag2,1
							.endif
							sub eax,1
							.if blockList[eax]==1
								mov hitflag1,1
							.endif
							add eax,BLOCK_NUM_X
							.if blockList[eax]==1
								mov hitflag1,1
							.endif
							add eax,BLOCK_NUM_X
							.if blockList[eax]==1
								mov hitflag2,1
							.endif
							sub eax,1
							.if blockList[eax]==1
								mov hitflag2,1
							.endif
							.if flag == 0
								.if hitflag1 == 0
									add te.centerPosX,BLOCK_SIZE
								.endif
							.else
								.if hitflag1 == 0 && hitflag2 == 0
									add te.centerPosX,BLOCK_SIZE
								.endif
							.endif
						.endif
					.endif
				;形状3
				.elseif te.kind == 3
					.if te.direction == 0
						.if te.centerPosX <= BLOCK_NUM_X*BLOCK_SIZE-3*BLOCK_SIZE
							mov eax,blockNo
							sub eax,BLOCK_NUM_X
							sub eax,BLOCK_NUM_X
							.if blockList[eax]==1
								mov hitflag1,1
							.endif
							add eax,BLOCK_NUM_X
							add eax,2
							.if blockList[eax]==1
								mov hitflag1,1
							.endif	
							add eax,BLOCK_NUM_X
							.if blockList[eax]==1
								mov hitflag2,1
							.endif	
							.if flag == 0
								.if hitflag1 == 0
									add te.centerPosX,BLOCK_SIZE
								.endif
							.else
								.if hitflag1 == 0 && hitflag2 == 0
									add te.centerPosX,BLOCK_SIZE
								.endif
							.endif
						.endif						
					.elseif te.direction == 1
						.if te.centerPosX <= BLOCK_NUM_X*BLOCK_SIZE-2*BLOCK_SIZE
							mov eax,blockNo
							sub eax,BLOCK_NUM_X
							sub eax,BLOCK_NUM_X
							.if blockList[eax]==1
								mov hitflag1,1
							.endif
							inc eax
							add eax,BLOCK_NUM_X
							.if blockList[eax]==1
								mov hitflag1,1
							.endif
							sub eax,1
							add eax,BLOCK_NUM_X
							.if blockList[eax]==1
								mov hitflag1,1
							.endif
							add eax,BLOCK_NUM_X
							.if blockList[eax]==1
								mov hitflag1,1
							.endif
							add eax,BLOCK_NUM_X
							.if blockList[eax]==1
								mov hitflag2,1
							.endif
							sub eax,BLOCK_NUM_X
							sub eax,BLOCK_NUM_X
							inc eax
							.if blockList[eax]==1
								mov hitflag2,1
							.endif
							.if flag == 0
								.if hitflag1 == 0
									add te.centerPosX,BLOCK_SIZE
								.endif
							.else
								.if hitflag1 == 0 && hitflag2 == 0
									add te.centerPosX,BLOCK_SIZE
								.endif
							.endif
						.endif
					.elseif te.direction == 2
						.if te.centerPosX <= BLOCK_NUM_X*BLOCK_SIZE-3*BLOCK_SIZE
							mov eax,blockNo
							add eax,2
							sub eax,BLOCK_NUM_X
							.if blockList[eax]==1
								mov hitflag1,1
							.endif
							sub eax,1
							add eax,BLOCK_NUM_X
							.if blockList[eax]==1
								mov hitflag1,1
							.endif
							inc eax
							.if blockList[eax]==1
								mov hitflag2,1
							.endif
							sub eax,1
							add eax,BLOCK_NUM_X
							.if blockList[eax]==1
								mov hitflag2,1
							.endif
							.if flag == 0
								.if hitflag1 == 0
									add te.centerPosX,BLOCK_SIZE
								.endif
							.else
								.if hitflag1 == 0 && hitflag2 == 0
									add te.centerPosX,BLOCK_SIZE
								.endif
							.endif
						.endif
					.elseif te.direction == 3
						.if te.centerPosX <= BLOCK_NUM_X*BLOCK_SIZE-2*BLOCK_SIZE
							mov eax,blockNo
							inc eax
							sub eax,BLOCK_NUM_X
							sub eax,BLOCK_NUM_X
							.if blockList[eax]==1
								mov hitflag1,1
							.endif
							add eax,BLOCK_NUM_X
							.if blockList[eax]==1
								mov hitflag1,1
							.endif
							add eax,BLOCK_NUM_X
							.if blockList[eax]==1
								mov hitflag1,1
							.endif
							add eax,BLOCK_NUM_X
							.if blockList[eax]==1
								mov hitflag1,1
							.endif
							add eax,BLOCK_NUM_X
							.if blockList[eax]==1
								mov hitflag2,1
							.endif
							.if flag == 0
								.if hitflag1 == 0
									add te.centerPosX,BLOCK_SIZE
								.endif
							.else
								.if hitflag1 == 0 && hitflag2 == 0
									add te.centerPosX,BLOCK_SIZE
								.endif
							.endif
						.endif
					.endif
				;形状4
				.elseif te.kind == 4
					.if te.centerPosX <= BLOCK_NUM_X*BLOCK_SIZE - 3*BLOCK_SIZE
						mov eax,blockNo	
						inc eax
						.if blockList[eax]==1
							mov hitflag1,1
						.endif
						inc eax
						add eax,BLOCK_NUM_X
						.if blockList[eax]==1
							mov hitflag1,1
						.endif
						sub eax,1
						add eax,BLOCK_NUM_X
						.if blockList[eax]==1
							mov hitflag1,1
						.endif
						inc eax
						.if blockList[eax]==1
							mov hitflag2,1
						.endif
						sub eax,1
						add eax,BLOCK_NUM_X
						.if blockList[eax]==1
							mov hitflag2,1
						.endif
						.if flag == 0
							.if hitflag1 == 0
								add te.centerPosX,BLOCK_SIZE
							.endif
						.else
							.if hitflag1 == 0 && hitflag2 == 0
								add te.centerPosX,BLOCK_SIZE
							.endif
						.endif
					.endif
				.endif
			.endif	
		.elseif	eax ==	WM_COMMAND
			mov	eax,wParam
			.if ax ==	IDM_EXIT
				call	_Quit
				xor	eax,eax
				ret
			.endif
			invoke	_DeleteBackGround
			invoke	_CreateBackGround
			invoke	_CreateFrontPic
			invoke	InvalidateRect,hWnd,NULL,FALSE
;********************************************************************
		.elseif	eax ==	WM_CLOSE
			call	_Quit
;********************************************************************
; 按下右键时弹出一个POPUP菜单
;********************************************************************
		.elseif eax == WM_RBUTTONDOWN
			invoke	GetCursorPos,addr @stPos
			invoke	TrackPopupMenu,hMenu,TPM_LEFTALIGN,@stPos.x,@stPos.y,NULL,hWnd,NULL
;********************************************************************
; 由于没有标题栏，下面代码用于按下左键时移动窗口
; UpdateWindow：即时刷新，否则要等到放开鼠标时窗口才会重画
;********************************************************************
		.elseif eax ==	WM_LBUTTONDOWN
			invoke	SetCursor,hCursorMove
			invoke	UpdateWindow,hWnd
			invoke	ReleaseCapture
			invoke	SendMessage,hWnd,WM_NCLBUTTONDOWN,HTCAPTION,0
			invoke	SetCursor,hCursorMain
;********************************************************************
		.else
			invoke	DefWindowProc,hWnd,uMsg,wParam,lParam
			ret
		.endif
;********************************************************************
		xor	eax,eax
		ret

_ProcWinMain	endp
;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
_WinMain	proc
		local	@stWndClass:WNDCLASSEX
		local	@stMsg:MSG

		invoke	GetModuleHandle,NULL
		mov	hInstance,eax
		invoke	LoadCursor,hInstance,IDC_MOVE
		mov	hCursorMove,eax
		invoke	LoadCursor,hInstance,IDC_MAIN
		mov	hCursorMain,eax
;********************************************************************
; 注册窗口类
;********************************************************************
		invoke	RtlZeroMemory,addr @stWndClass,sizeof @stWndClass
		invoke	LoadIcon,hInstance,ICO_MAIN
		mov	@stWndClass.hIcon,eax
		mov	@stWndClass.hIconSm,eax
		push	hCursorMain
		pop	@stWndClass.hCursor
		push	hInstance
		pop	@stWndClass.hInstance
		mov	@stWndClass.cbSize,sizeof WNDCLASSEX
		mov	@stWndClass.style,CS_HREDRAW or CS_VREDRAW
		mov	@stWndClass.lpfnWndProc,offset _ProcWinMain
		mov	@stWndClass.hbrBackground,COLOR_WINDOW + 1
		mov	@stWndClass.lpszClassName,offset szClassName
		invoke	RegisterClassEx,addr @stWndClass
;********************************************************************
; 建立并显示窗口
;********************************************************************
		invoke	CreateWindowEx,NULL,\
			offset szClassName,offset szClassName,\
			WS_POPUP or WS_SYSMENU,\
			100,100,WIN_SIZE_X,WIN_SIZE_Y,\
			NULL,NULL,hInstance,NULL
		mov	hWinMain,eax
		invoke	ShowWindow,hWinMain,SW_SHOWNORMAL
		invoke	UpdateWindow,hWinMain
;********************************************************************
; 消息循环
;********************************************************************
		.while	TRUE
			invoke	GetMessage,addr @stMsg,NULL,0,0
			.break	.if eax	== 0
			invoke	TranslateMessage,addr @stMsg
			invoke	DispatchMessage,addr @stMsg
		.endw
		ret

_WinMain	endp
;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
start:
		call	_WinMain
		invoke	ExitProcess,NULL
;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
		end	start
