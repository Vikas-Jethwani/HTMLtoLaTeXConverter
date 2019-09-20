%{
    #include <stdio.h>
    #include <stdlib.h>
    #include <string.h>
    #include "yacc.tab.h"
    void yyerror(const char *);
%}
%option yylineno

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

"<a "[^>]+">"           {
                            printf("A Tag\n");
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

                                // href
                                if(!attr_open && (tag_details[i] == 'h' || tag_details[i] == 'H'))
                                {
                                    attr[a++]='h'; attr[a++]='\"';
                                    attr_open = 1;
                                    i += 5; // manually skipping over ' ref=" '
                                    continue;
                                }
                                // name
                                if(!attr_open && (tag_details[i] == 'n' || tag_details[i] == 'N'))
                                {
                                    attr[a++]='n'; attr[a++]='\"';
                                    attr_open = 1;
                                    i += 5; // manually skipping over ' ame=" '
                                    continue;
                                }
                                // title
                                if(!attr_open && (tag_details[i] == 't' || tag_details[i] == 'T'))
                                {
                                    attr[a++]='t'; attr[a++]='\"';
                                    attr_open = 1;
                                    i += 6; // manually skipping over ' itle=" '
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
                            return A_S;
                        }

"</a>"                  {
                            printf("A_E Tag\n");
                            return A_E;
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
