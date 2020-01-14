# UEFI empty application

English

A simple example of a UEFI application that does nothing (print a string and wait for a key press; disable watchdog timer)

build.bat contains sample commands for build

For make an USB live flash drive:

0. Build the project with FASM https://flatassembler.net
1. Format the flash in FAT32
2. Copy files from iso to the root of flash

Do not copy iso folder. In root have EFI folder
For load from USB enable in BIOS the UEFI load and disable secure boot (trust boot)

For make an iso image for VirtualBox machine

0. 0 and 1 similarly as for USB
1. Search in Internet mkisofs.exe https://code.google.com/archive/p/mkisofs-md5/downloads
2. Make an iso image (build.bat makes main.iso)

For boot with VirtualBox, set the memory 48 Mb or more and set EFI to enabled

------------------------------------------------------------------------------------------------------------------------------
Russian

Простой пример UEFI-приложения, которое ничего не делает. Просто печатает на экран строку, ждёт нажатия на клавишу, выключает сторожевой таймер UEFI.

build.bat содержит примерные команды для сборки

Для создания загрузочной флешки:

0. Скомпилируйте проект с FASM https://flatassembler.net
1. Отформатируйте устройство в FAT32
2. Скопируйте файлы из папки iso в корень флешки

В корне флешки должна быть папка EFI, не iso.
Для загрузки с USB включите в биосе загрузку UEFI и отключите secure boot (trust boot)


Чтобы сделать iso-образ для загрузки с помощью виртуальной машины VirtualBox

0. 0 и 1 аналогично
1. Найдите в интернете mkisofs.exe https://code.google.com/archive/p/mkisofs-md5/downloads
2. Сформируйте iso-образ (build.bat создаёт файл main.iso)


Для загрузки из VirtualBox установите объём памяти на 48 Мб или более и включите EFI
