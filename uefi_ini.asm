include 'uefi_struct.asm'

align37 16
; Инициализация приложения. Функция должна вызываться первой
init:
	clc

	or	rdx, rdx
	jz	.badout

	mov r8, EFI_SYSTEM_TABLE_SIGNATUREQ

	cmp	qword [rdx], r8
	je	@f

.badout:

	xor	rcx, rcx
	xor	rdx, rdx
	stc

@@:		
	mov	[efi_handler], rcx		; ImageHandle
	mov	[efi_ptr],     rdx  	; pointer to SystemTable		EFI_SYSTEM_TABLE
	mov	rdx,		  [rdx + EFI_SYSTEM_TABLE.BootServices]
	mov	[BootServices], rdx

	RET

align37Must 64
; В RDX передать адрес выводимой строки
; mov  rdx, BootStartString
; call Console.Write
Console:
.ResetInput:

	mov  rbx, [efi_ptr]
	mov  rbx, [rbx + EFI_SYSTEM_TABLE.ConIn]
	mov  rcx, rbx
	mov  rbx, [rbx + SIMPLE_INPUT_INTERFACE.Reset]

	call uefi

	RET

align37Must 16
.Write:

	mov  rbx, [efi_ptr]
	mov  rbx, [rbx + EFI_SYSTEM_TABLE.ConOut]
	mov  rcx, rbx
	mov  rbx, [rbx + SIMPLE_TEXT_OUTPUT_INTERFACE.OutputString]

	call uefi

	RET

align37Must 16
; while ((Status = ST->ConIn->ReadKeyStroke(ST->ConIn, &Key)) == EFI_NOT_READY);
.WaitForKey:

	call Console.ResetInput

	mov  rbx, [efi_ptr]
	mov  rbx, [rbx + EFI_SYSTEM_TABLE.ConIn]
	lea  rdx, [rbx + SIMPLE_INPUT_INTERFACE.WaitForKey]
	mov  rcx, 1

	test rdx, rdx
	jz	 .error_WaitForKey

	sub  rsp, 16
	mov  r8,  rsp

	mov  rbx, [BootServices]
	mov  rbx, [rbx + EFI_BOOT_SERVICES_TABLE.WaitForEvent]

	; 243/173 страница
	call uefi

	add  rsp, 16

	cmp  rax, 0 ; EFI_SUCCESS
	je	 .success

	mov rdx, 0x8000000000000002
	cmp rax, rdx	; EFI_INVALID_PARAMETER
	je  .invalidParameter

	mov rdx, 0x8000000000000003
	cmp rax, rdx ; EFI_UNSUPPORTED
	je  .unsupported

	mov  rdx, unknownstr
	call Console.Write
	RET

.unsupported:

	mov  rdx, unsupportedstr
	call Console.Write
	RET

.invalidParameter:

	mov  rdx, ipstr
	call Console.Write
	RET

align37Must 16
.success:
	mov  rdx, successstr
	call Console.Write

	; Сбрасываем полученное нажатие клавиши, а то оно дальше будет использовано
	call Console.ResetInput

	RET

.error_WaitForKey:
	mov  rdx, unsupportedstr
	call Console.Write

	RET

align37Must 16
successstr du 'success', 13, 10, 0
align37Must 16
ipstr du 'invalid parameter', 13, 10, 0
align37Must 16
unknownstr du 'unknown error code', 13, 10, 0
align37Must 16
unsupportedstr du 'unsupported', 13, 10, 0

align37Must 64
DisableWatchdogTimer:

	mov  rbx, [BootServices]
	mov  rbx, [rbx + EFI_BOOT_SERVICES_TABLE.SetWatchdogTimer]

	xor  rcx, rax
	xor  rdx, rdx
	xor  r8,  r8
	xor  r9,  r9

	call uefi

	RET


align37Must 64
; В rbx адрес того, что вызываем
; Calling convention на странице 104/33
; Параметры в RCX, RDX, R8 and R9
; Адрес вершины стека должен быть выровнен на кратный 16-ти
uefi:
	; Direction flag in EFLAGs is clear
	cld

	mov [efi_rsp], rsp

	; Выравнивание стека на адрес, кратный 16-ти
	and  rsp,       0xFFFFFFFFFFFFFFF0
	; Не знаю зачем. Похоже, это место для хранения регистровых параметров в стеке :)
	sub  rsp, 4*8
	call rbx

	mov rsp, [efi_rsp]
	RET

align37Must 16
saveRegisters:

	pop  rax

	push RBX
	push RBP
	push RDI
	push RSI
	push R12
	push R13
	push R14
	push R15

	push rax

	RET

align37Must 16
loadRegisters:

	pop  rax

	pop  R15
	pop  R14
	pop  R13
	pop  R12
	pop  RSI
	pop  RDI
	pop  RBP
	pop  RBX
	
	push rax

	RET
