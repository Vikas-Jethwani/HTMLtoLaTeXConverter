%{
    #include <stdio.h>
    #include <string.h>
    #include <stdlib.h>
    #include <iostream>
    using namespace std;
    void yyerror(const char *);
    FILE *fileout;
    FILE *yyin;
    int yylex();
    extern char * yytext;
%}

%union{
    string s;
}

%token      HTML_S      HTML_E      HEAD_S      HEAD_E      BODY_S      BODY_E
%token  <s>    A_S         A_E         FONT_S      FONT_E
%start      begin
%type       <s>       Document
%type       <s>       html
%type       <s>       head
%type       <s>       body
%type       <s>       body_content




%%
begin               :   Document

Document            :   HTML_S html HTML_E                { printf("Grammar mein jod diya\t%s", $2); }
                    |   ;

html                :   head body                       { char *temp = malloc(100);
                                                          strcpy(temp, $1);
                                                          strcat(temp, $2);
                                                          $$ = temp; }

                    |   head                            { char *temp = malloc(100);
                                                          strcpy(temp, $1);
                                                          $$ = temp; }

                    |   body                            { char *temp = malloc(100);
                                                          strcpy(temp, $1);
                                                          $$ = temp; }
                    |   ;

head                :   HEAD_S HEAD_E                     { char *temp = malloc(100);
                                                          strcpy(temp, "\nfrom head\n");
                                                          $$ = temp; }
                    |   ;

body                :   BODY_S body_content BODY_E          { char *temp = malloc(100);
                                                              strcpy(temp, "\nfrom body\n");
                                                              $$ = temp; }
                    |   ;

body_content        :   body_content A_S body_content A_E               { printf("inside a stuff %s\n", $2); }

                    |   body_content FONT_S body_content FONT_E         { printf("inside font stuff %s\n", $2); }

                    |   ;

%%

int main(int argc, char *argv[]) {
    yyin = fopen(argv[1],"r");
    yyparse();
    return 0;
} 