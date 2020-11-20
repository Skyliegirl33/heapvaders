Heapvaders:
	haxe -hl code/output.c -cp src -lib heaps -lib hlsdl -lib random -main Game
	gcc -o HeapsTest code/output.c -Icode/ sdl.hdll ui.hdll fmt.hdll openal.hdll ui.hdll uv.hdll -lhl -lSDL2 -lm -lopenal -lGL

