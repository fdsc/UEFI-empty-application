format PE64 dll EFI

; align37Must вызывать не об€зательно. Ёто чисто по приколу

stack 65536*2
entry EntryPoint

section '.text' code readable executable

include 'uefi_ini.asm'

align37Must 16

; RCX, RDX, R8 and R9
EntryPoint:

	; —охран€ем регистры, которые должны сохранить по calling convention,
	; если будем передавать управление назад в UEFI (если мы не загружаем ќ—)
	call saveRegisters

	call init
	jc	 error

	;uefi_call_wrapper ConOut, OutputString, ConOut, BootString
	mov  rdx, BootStartString
	call Console.Write

	; ”бираем 5-тиминутный таймер, который вернЄт управление UEFI
	call DisableWatchdogTimer

	mov  rdx, PressAnyKey
	call Console.Write

	call Console.WaitForKey

	;mov rcx, 100
	;call halt

	; ¬осстанавливаем регисры, которые должны восстановить
	call loadRegisters
	xor rax, rax
	RET

error:
	call loadRegisters
	mov rax, 0x8000000000000000

	RET

align37Must 16
; rcx - количество циклов ожидани€
halt:
	HLT
	loop halt
	RET

align37Must 512


include 'main_data.asm'
