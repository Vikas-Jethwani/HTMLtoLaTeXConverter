%{
    #include <iostream>
    #include <cstring>
    #include "yacc.tab.h"
    using namespace std;
    void yyerror(const char *);
%}
%option yylineno

%x A_ATTR
%x FONT_ATTR
%x IMG_ATTR

link        [a-zA-Z0-9#\.:/]

%%
"<html>"                {
                            cout<<"HTML Tag\n";
                            return HTML_S;
                        }
"</html>"               {
                            cout<<"\nHTML_E Tag\n";
                            return HTML_E;
                        }

"<head>"                {
                            cout<<"\nHEAD Tag\n";
                            return HEAD_S;
                        }
"</head>"               {
                            cout<<"HEAD_E Tag\n";
                            return HEAD_E;
                        }
                        
"<title>"               {
                            cout<<"TITLE Tag\n";
                            return TITLE_S;
                        }
"</title>"              {
                            cout<<"TITLE_E Tag\n";
                            return TITLE_E;
                        }

"<body>"                {
                            cout<<"\nBODY Tag\n";
                            return BODY_S;
                        }
"</body>"               {
                            cout<<"BODY_E Tag\n";
                            return BODY_E;
                        }

"<a "|"<a"                   {
                            cout<<"A Tag\n";
                            BEGIN(A_ATTR);
                            return A_S;
                        }

<A_ATTR>"href=\""[a-zA-Z0-9#\.:/]*"\""      {
                                                int n = strlen(yytext);
                                                string str = string(yytext).substr(5,n);
                                                n = str.length();
                                                yylval.s = new char [n+1];
                                                strcpy(yylval.s, str.c_str());
                                                yylval.s[n] = '\0';
                                                cout<<"attr, href : "<<yylval.s<<endl;
                                                return A_HREF;
                                             }

<A_ATTR>"name=\""[a-zA-Z0-9#]*"\""          {
                                                int n = strlen(yytext);
                                                string str = string(yytext).substr(5,n);
                                                n = str.length();
                                                yylval.s = new char [n+1];
                                                strcpy(yylval.s, str.c_str());
                                                yylval.s[n] = '\0';
                                                cout<<"attr, name : "<<yylval.s<<endl;
                                                return A_NAME;
                                             }
                                             
<A_ATTR>"title=\""[a-zA-Z0-9#\.:/]*"\""      {
                                                int n = strlen(yytext);
                                                string str = string(yytext).substr(6,n);
                                                n = str.length();
                                                yylval.s = new char [n+1];
                                                strcpy(yylval.s, str.c_str());
                                                yylval.s[n] = '\0';
                                                cout<<"attr, title : "<<yylval.s<<endl;
                                                return A_TITLE;
                                             }
                                             
<A_ATTR>" "             ;
                                                                                              
<A_ATTR>">"             {
                            BEGIN(INITIAL);
                        }

"</a>"                  {
                            cout<<"A_E Tag\n";
                            return A_E;
                        }
                        
"<font "|"<font"         {
                            cout<<"FONT Tag\n";
                            BEGIN(FONT_ATTR);
                            return FONT_S;
                        }

<FONT_ATTR>"size=\""[0-9]+"\""      {
                                                int n = strlen(yytext);
                                                string str = string(yytext).substr(5,n);
                                                n = str.length();
                                                yylval.s = new char [n+1];
                                                strcpy(yylval.s, str.c_str());
                                                yylval.s[n] = '\0';
                                                cout<<"font-attr, size : "<<yylval.s<<endl;
                                                return FONT_SIZE;
                                             }
                                             
<FONT_ATTR>" "              ;
                                                                                              
<FONT_ATTR>">"              {
                                BEGIN(INITIAL);
                            }

"</font>"                   {
                            cout<<"FONT_E Tag\n";
                            return FONT_E;
                            }
                            
"<p>"                   {
                            cout<<"P Tag\n";
                            return P_S;
                        }
"</p>"                  {
                            cout<<"P_E Tag\n";
                            return P_E;
                        }

"<center>"              {
                            cout<<"CENTER Tag\n";
                            return CENTER_S;
                        }
"</center>"             {
                            cout<<"CENTER_E Tag\n";
                            return CENTER_E;
                        }
                        
"<div>"                 {
                            cout<<"DIV Tag\n";
                            return DIV_S;
                        }
"</div>"                {
                            cout<<"DIV_E Tag\n";
                            return DIV_E;
                        }

"<h1>"                  {
                            cout<<"H1 Tag\n";
                            return H1_S;
                        }
"</h1>"                 {
                            cout<<"H1_E Tag\n";
                            return H1_E;
                        }
                        
"<h2>"                  {
                            cout<<"H2 Tag\n";
                            return H2_S;
                        }
"</h2>"                 {
                            cout<<"H2_E Tag\n";
                            return H2_E;
                        }
                        
"<h3>"                  {
                            cout<<"H3 Tag\n";
                            return H3_S;
                        }
"</h3>"                 {
                            cout<<"H3_E Tag\n";
                            return H3_E;
                        }

"<h4>"                  {
                            cout<<"H4 Tag\n";
                            return H4_S;
                        }
"</h4>"                 {
                            cout<<"H4_E Tag\n";
                            return H4_E;
                        }

"<h5>"                  {
                            cout<<"H5 Tag\n";
                            return H5_S;
                        }
"</h5>"                 {
                            cout<<"H5_E Tag\n";
                            return H5_E;
                        }
                        
"<h6>"                  {
                            cout<<"H6 Tag\n";
                            return H6_S;
                        }
"</h6>"                 {
                            cout<<"H6_E Tag\n";
                            return H6_E;
                        }
                        
"<u>"                   {
                            cout<<"U Tag\n";
                            return U_S;
                        }
"</u>"                  {
                            cout<<"U_E Tag\n";
                            return U_E;
                        }
                        
"<b>"                   {
                            cout<<"B Tag\n";
                            return BOLD_S;
                        }
"</b>"                  {
                            cout<<"B_E Tag\n";
                            return BOLD_E;
                        }
                        
"<strong>"              {
                            cout<<"STRONG Tag\n";
                            return BOLD_S;
                        }
"</strong>"             {
                            cout<<"STRONG_E Tag\n";
                            return BOLD_E;
                        }
                        
"<tt>"                  {
                            cout<<"TT Tag\n";
                            return TT_S;
                        }
"</tt>"                 {
                            cout<<"TT_E Tag\n";
                            return TT_E;
                        }
                        
"<i>"                   {
                            cout<<"I Tag\n";
                            return I_S;
                        }
"</i>"                  {
                            cout<<"I_E Tag\n";
                            return I_E;
                        }
                        
"<em>"                  {
                            cout<<"EM Tag\n";
                            return EM_S;
                        }
"</em>"                 {
                            cout<<"EM_E Tag\n";
                            return EM_E;
                        }
                        
                        
"<small>"               {
                            cout<<"SMALL Tag\n";
                            return SMALL_S;
                        }
"</small>"              {
                            cout<<"SMALL_E Tag\n";
                            return SMALL_E;
                        }

                       
([a-zA-Z0-9\.,'; \t]+[\n]*)+         {
                            int n = strlen(yytext);
                            yylval.s = new char [n+1];
                            strcpy(yylval.s, yytext);
                            yylval.s[n] = '\0';
                            return DATA;
                        }
.                       ;
[ \t\n]+                ;
%%

void yyerror(const char *str) {
    cerr<<"Line No: "<<yylineno<<"\t Error: "<<str<<endl;
}

int yywrap(void) {
    return 1;
}
