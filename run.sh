bison -d yacc.y
flex lex.l
g++ -std=c++14 converter.cpp lex.yy.c yacc.tab.c
./a.out $1 $2
