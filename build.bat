rem cd Set path to this
fasm\FASM.EXE main.asm
copy main.efi iso\EFI\BOOT\BOOTx64.efi
mkisofs\mkisofs.exe -o main.iso iso
