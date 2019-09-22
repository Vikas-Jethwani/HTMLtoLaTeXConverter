bison -d -v yacc.y
flex lex.l
g++ lex.yy.c yacc.tab.c -o output
./output input.html
