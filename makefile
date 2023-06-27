inter:
	bison -dv c_modif1.y
	flex -o c_modif1.yy.c c_modif1.l
	gcc -o c_modif1a.exe c_modif1.tab.c c_modif1.yy.c c_modif1a.c -lm -lfl
	./c_modif1a.exe input_G3.txt output_inter.txt

graph:
	bison -dv c_modif1.y
	flex -o c_modif1.yy.c c_modif1.l
	gcc -o c_modif1b.exe c_modif1.tab.c c_modif1.yy.c c_modif1b.c -lm -lfl
	./c_modif1b.exe input_G3.txt output_graph.txt