all: treeFormatter.y ccclex.l node.c SQLToken.c algorithms.c main.c
	bison --yacc --defines --output=treeFormatter.c treeFormatter.y
	flex --outfile=ccclex.c ccclex.l
	gcc -g ccclex.c treeFormatter.c node.c SQLToken.c algorithms.c main.c -o ccc.exe

clean:
	rm -f ccclex.c
	rm -f treeFormatter.c
	rm -f treeFormatter.h
	rm -f ccc.exe
