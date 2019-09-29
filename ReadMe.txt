Steps to run:
1. bison -d yacc.y
2. flex lex.l
3. g++ -std=c++14 converter.cpp lex.yy.c yacc.tab.c
4. "a.exe input.html output.tex"
   "./a.out input.html output.tex"          (for linux)
5. texliveonfly output.tex  (can also use 'pdflatex', need to press enter repeatedly to ignore warnings) (for linux)
6. evince output.pdf                        (for linux)
sh run.sh input.html output.tex             (for linux)


(Final Project Submission)
sh run.sh report.html out.tex
