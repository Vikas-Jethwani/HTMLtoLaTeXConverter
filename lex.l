%{
    #include <stdlib.h>
    #include "yacc.tab.h"
    void yyerror(const char *);
%}
%option yylineno

%%
"<html>"                {
                            printf("HTML Tag\n");
                            return HTML;
                        }

"</html>"               {
                            printf("HTML_C Tag\n");
                            return HTML_C;
                        }

"<head>"                {
                            printf("HEAD Tag\n");
                            return HEAD;
                        }

"</head>"               {
                            printf("HEAD_C Tag\n");
                            return HEAD_C;
                        }

"<body>"                {
                            printf("BODY Tag\n");
                            return BODY;
                        }

"</body>"               {
                            printf("BODY_C Tag\n");
                            return BODY_C;
                        }

.                       ; // printf("%s\n",  yytext);
\n                      ;
%%

void yyerror(const char *str) {
    fprintf(stderr,"Error | Line: %d\n%s\n", yylineno, str);
}

int yywrap(void) {
    return 1;
}
