rm a.out
rm *.*~
bison -d -v yacc.y
flex lex.l
g++ -std=c++14 lex.yy.c yacc.tab.c
./a.out input.html
