; Pablo Breuer
; CS3140 Assignment 3
; Print hex equivalent of entered ASCII
; January 17, 2017
; Compile: nasm -f elf32 -g assign3_part1.asm -o assign3_part1.o
; Link: ld -m elf_i386 assign3_part1 -o assign3_part1

BITS 32

SYS_READ equ 3
SYS_WRITE equ 4
SYS_EXIT equ 1
STDIN equ 0
STDOUT equ 1
SPACE equ 0x20
LF equ 0xA

global _start

section .text

_start:

	mov	edx,len		;length of message
	mov	ecx, buff	;p_buff
	mov	ebx, STDIN	;fd
	mov	eax, SYS_READ	;read system call
	int	0x80

	cmp	eax,0		;bytes read = 0, then exit
	je	exit

	cld			;clear the direction flag
	mov	esi, buff

loop_top:
	xor	eax, eax	;clear eax
	lodsb			;mov byte at esi to al, repeat

	test	eax, eax	;check to see if eax = 0
	jz	exit		;

	push	eax		;store byte read in

	shr	al, 4		;first hex char
	lea	ecx, [hex+eax]	;uses eax as array index
	call	output

	mov	eax, [esp]	;second hex char
	and	al, 0xf
	lea	ecx, [hex+eax]	;uses eax as array index
	call	output

	push	SPACE		;print space
	mov	ecx, esp
		call output

	pop	eax		;pop char off stack
	cmp	al, LF		;compare to LF
	je	exit
	jmp	loop_top

output:
	mov	eax, SYS_WRITE
	mov	ebx, STDOUT	;output to STDOUT
	mov	edx, 1		;output one char
	int 	0x80
	ret

exit:
	mov ebx, 0		; exit code 0
	mov eax, SYS_EXIT	;
	int 0x80

section .data
buff	times 201 	db 0	;200 character buff plus CR
len 	equ $ - buff
hex	db '0','1','2','3','4','5','6','7','8','9','a','b','c','d','e','f'
