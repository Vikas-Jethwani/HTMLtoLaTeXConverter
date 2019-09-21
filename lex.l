%{
    #include <stdio.h>
    #include <stdlib.h>
    #include <string.h>
    #include <iostream>
    using namespace std;
    #include "yacc.tab.h"
    void yyerror(const char *);
%}
%option yylineno
spac             [ ]+
punc             (\.|\,|\!|\?%-)
word             ({punc}|[a-zA-Z0-9])+
number           [0-9]+

%x A_TAG
%x FONT_TAG
%x IMG_TAG

%%
"<html>"                {
                            printf("HTML Tag\n");
                            return HTML_S;
                        }

"</html>"               {
                            printf("HTML_E Tag\n");
                            return HTML_E;
                        }

"<head>"                {
                            printf("HEAD Tag\n");
                            return HEAD_S;
                        }

"</head>"               {
                            printf("HEAD_E Tag\n");
                            return HEAD_E;
                        }

"<body>"                {
                            printf("BODY Tag\n");
                            return BODY_S;
                        }

"</body>"               {
                            printf("BODY_E Tag\n");
                            return BODY_E;
                        }

"<a "                   {
                            printf("A Tag\n");
                            BEGIN(A_TAG);
                            //return A_S;
                        }

<A_TAG>"href=\""[a-zA-Z0-9#]*"\""    {
                                int n = strlen(yytext);
                                string str = string(yytext);
                                yylval.s = str.substr(5,n);
                                cout<<yylval.s<<endl;
                                
                                //return A_HREF;
                            }


"</a>"                  {
                            printf("A_E Tag\n");
                            BEGIN(INITIAL);
                            //return A_E;
                        }

"<font "[^>]+">"        {
                            printf("FONT Tag\n");
                            int n = strlen(yytext);
                            char *tag_details = yytext; int i=1;
                            char *attr = malloc(200); int a=0;
                            int still_tag=1, attr_open=0;

                            for(; i<n-1; i++)
                            {
                                if(tag_details[i] == '\'')
                                    tag_details[i] = '\"';
                                
                                if(tag_details[i] == ' ')
                                {
                                    still_tag = 0;
                                    continue;
                                }
                                if(still_tag)
                                    continue;

                                // src
                                if(!attr_open && (tag_details[i] == 's' || tag_details[i] == 'S'))
                                {
                                    attr[a++]='s'; attr[a++]='\"';
                                    attr_open = 1;
                                    i += 5; // manually skipping over ' ize=" '
                                    continue;
                                }
                                else
                                {
                                    ;// MAKE CASE TO HANDLE UNKNOWN ATTRIBUTES
                                }

                                // attribute value ends
                                if(attr_open && tag_details[i] == '\"')
                                {
                                    attr[a++] = '\"';
                                    attr_open = 0;
                                    continue;
                                }
                                // Actual attribute value
                                attr[a++] = tag_details[i];
                            }
                            attr[a] = '\0';

                            //printf("Attr : %s\n", attr);
                            yylval.s = malloc(sizeof(attr));
                            strcpy(yylval.s, attr);
                            return FONT_S;
                        }

"</font>"               {
                            printf("FONT_E Tag\n");
                            return FONT_E;
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
