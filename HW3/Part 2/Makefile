all : sortArrays

sortArrays : part2.o
	gcc -o sortArrays part2.o -lm -pthread 

part2.o : part2.c
	gcc -c part2.c -Wall -Wextra -pedantic

clean:
	rm -f sortArrays *.o
