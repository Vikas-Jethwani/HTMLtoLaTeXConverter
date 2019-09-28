rm a.out
rm *.*~
bison -d -v yacc.y
flex lex.l
g++ -std=c++14 converter.cpp lex.yy.c yacc.tab.c 
./a.out input.html
texliveonfly Vikas.tex
evince Vikas.pdf