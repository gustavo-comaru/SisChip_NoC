default: programs

programs:
	gcc -o procPath process_path.c -std=c99
	gcc -o printPath print_path.c

clean:
	rm -f procPath
	rm -f printPath
