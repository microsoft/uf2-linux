CFLAGS =  -std=c99 -W -Wall 
SRC = main.c fat.c

all:
	arm-linux-gnueabihf-gcc -Os -s $(CFLAGS) $(SRC) -o uf2d

x86:
	gcc -DX86=1 -g $(CFLAGS) $(SRC) -o uf2d86
