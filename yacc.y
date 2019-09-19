%{
    #include <stdio.h>
    #include <string.h>
    #include <stdlib.h>
    void yyerror(const char *);
    FILE *fileout;
    FILE *yyin;
    int yylex();
    extern char * yytext;
%}

%union{
    char *s;
}

%token      HTML  HTML_C  HEAD  HEAD_C  BODY  BODY_C
%start      begin
%type       <s>       Document
%type       <s>       html
%type       <s>       head
%type       <s>       body


%%
begin               :   Document

Document            :   HTML html HTML_C                { printf("Grammar mein jod diya\t%s", $2); }
                        ;

html                :   head body                       { char *temp = malloc(100);
                                                          strcpy(temp, $1);
                                                          strcat(temp, $2);
                                                          $$ = temp; }

                      | head                            { char *temp = malloc(100);
                                                          strcpy(temp, $1);
                                                          $$ = temp; }

                      | body                            { char *temp = malloc(100);
                                                          strcpy(temp, $1);
                                                          $$ = temp; }
                        ;

head                :   HEAD HEAD_C                     { char *temp = malloc(100);
                                                          strcpy(temp, "\nfrom head\n");
                                                          $$ = temp; }
                        ;

body                :   BODY BODY_C                     { char *temp = malloc(100);
                                                          strcpy(temp, "\nfrom body\n");
                                                          $$ = temp; }
                        ;

%%

int main(int argc, char *argv[]) {
    yyin = fopen(argv[1],"r");
    yyparse();
    return 0;
} 