%{
    #include <iostream>
    #include <cstring>
    #include "yacc.tab.h"
    using namespace std;
    void find_Attr(int);
    void yyerror(const char *);
%}
%option yylineno
%option caseless

%x A_ATTR
%x FONT_ATTR
%x IMG_ATTR
%x TAB_ATTR

basic           [a-zA-Z0-9]
all             ({basic}|{punc}|{special_punc})*
doctype         <!DOCTYPE[^>[]*(\[[^]]*\])?>
punc            [_@$%=<>!-#&;<>/{}'`~]
special_punc    [\\\.\:\^\*\+\(\)\[\]]
whitespace      [ \t\n]
comment         <!--({basic}|{whitespace}|{punc}|{special_punc}|"\"")*?-->
greek           &({basic})+;

%%

{doctype}               {;}
{comment}               {
                            cout<<"COMMENT\n";
                            //cout<<'\t'<<yytext<<" - "<<"Comments\n";
                        }
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

"<a "|"<a"              {
                            cout<<"A Tag\n";
                            BEGIN(A_ATTR);
                            return A_S;
                        }

<A_ATTR>"href="['\"]{all}['\"]             {
                                                find_Attr(6);
                                                cout<<"attr, href : "<<yylval.s<<endl;
                                                return A_HREF;
                                            }


<A_ATTR>"name="['\"]{all}['\"]      {
                                                find_Attr(6);
                                                cout<<"attr, name : "<<yylval.s<<endl;
                                                return A_NAME;
                                            }

                                             
<A_ATTR>"title="['\"]{all}['\"] {
                                                find_Attr(7);
                                                cout<<"attr, title : "<<yylval.s<<endl;
                                                return A_TITLE;
                                             }
                                             
<A_ATTR>" "             ;
                                                                                              
<A_ATTR>">"             {
                            BEGIN(INITIAL);
                            cout<<"A_ATTR_E Tag\n";
                            return A_ATTR_E;
                        }

"</a>"                  {
                            cout<<"A_E Tag\n";
                            return A_E;
                        }
                        
"<font "|"<font"        {
                            cout<<"FONT Tag\n";
                            BEGIN(FONT_ATTR);
                            return FONT_S;
                        }

<FONT_ATTR>"size="['\"][0-9]+['\"]      {
                                                find_Attr(6);
                                                cout<<"font-attr, size : "<<yylval.s<<endl;
                                                return FONT_SIZE;
                                             }
                                             
<FONT_ATTR>" "              ;
                                                                                              
<FONT_ATTR>">"          {
                            BEGIN(INITIAL);
                            cout<<"FONT_ATTR_E Tag\n";
                            return FONT_ATTR_E;
                        }

"</font>"               {
                            cout<<"FONT_E Tag\n";
                            return FONT_E;
                        }

"<img "|"<img"        {
                            cout<<"IMG Tag\n";
                            BEGIN(IMG_ATTR);
                            return IMG_S;
                        }

<IMG_ATTR>"src="['\"]{all}['\"] {
                                            find_Attr(5);
                                            cout<<"img-attr, src : "<<yylval.s<<endl;
                                            return IMG_SRC;
                                        }
                                        
<IMG_ATTR>"width="['\"][0-9]+['\"]  {
                                    find_Attr(7);
                                    cout<<"img-attr, width : "<<yylval.s<<endl;
                                    return IMG_WIDTH;
                                }

<IMG_ATTR>"height="['\"][0-9]+['\"] {
                                    find_Attr(8);
                                    cout<<"img-attr, height : "<<yylval.s<<endl;
                                    return IMG_HEIGHT;
                                }
                                             
<IMG_ATTR>" "           ;
                                                                                              
<IMG_ATTR>(">"|"/>")    {
                            BEGIN(INITIAL);
                            cout<<"IMG_E Tag\n";
                            return IMG_E;
                        }


"<table "|"<table"      {
                            cout<<"TABLE Tag\n";
                            BEGIN(TAB_ATTR);
                            return TABLE_S;
                        }

<TAB_ATTR>"border="['\"][0-9]+['\"]     {
                                        find_Attr(8);
                                        cout<<"table-attr, border : "<<yylval.s<<endl;
                                        return TAB_BORDER;
                                    }
                                             
<TAB_ATTR>" "           ;

<TAB_ATTR>">"           {
                            BEGIN(INITIAL);
                            cout<<"TAB_ATTR_E Tag\n";
                            return TAB_ATTR_E;
                        }
                        
"</table>"              {
                            cout<<"TABLE_E Tag\n";
                            return TABLE_E;
                        }
                        

"<caption>"             {
                            cout<<"CAPTION Tag\n";
                            return CAPTION_S;
                        }
"</caption>"            {
                            cout<<"CAPTION_E Tag\n";
                            return CAPTION_E;
                        }
                        
"<tr>"                  {
                            cout<<"TR Tag\n";
                            return TR_S;
                        }
"</tr>"                 {
                            cout<<"TR_E Tag\n";
                            return TR_E;
                        }
                        
"<th>"                  {
                            cout<<"TH Tag\n";
                            return TH_S;
                        }
"</th>"                 {
                            cout<<"TH_E Tag\n";
                            return TH_E;
                        }
                        
"<td>"                  {
                            cout<<"TD Tag\n";
                            return TD_S;
                        }
"</td>"                 {
                            cout<<"TD_E Tag\n";
                            return TD_E;
                        }
                        
"<figure>"              {
                            cout<<"FIG Tag\n";
                            return FIG_S;
                        }
"</figure>"             {
                            cout<<"FIG_E Tag\n";
                            return FIG_E;
                        }

"<figcaption>"          {
                            cout<<"FIGC Tag\n";
                            return FIGC_S;
                        }
"</figcaption>"         {
                            cout<<"FIGC_E Tag\n";
                            return FIGC_E;
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

"<sub>"                 {
                            cout<<"SUB Tag\n";
                            return SUB_S;
                        }
"</sub>"                {
                            cout<<"SUB_E Tag\n";
                            return SUB_E;
                        }

"<sup>"                 {
                            cout<<"SUP Tag\n";
                            return SUP_S;
                        }
"</sup>"                {
                            cout<<"SUP_E Tag\n";
                            return SUP_E;
                        }

                        
"<ul>"                  {
                            cout<<"UL Tag\n";
                            return UL_S;
                        }
"</ul>"                 {
                            cout<<"UL_E Tag\n";
                            return UL_E;
                        }
                        
"<ol>"                  {
                            cout<<"OL Tag\n";
                            return OL_S;
                        }
"</ol>"                 {
                            cout<<"OL_E Tag\n";
                            return OL_E;
                        }

"<li>"                  {
                            cout<<"LI Tag\n";
                            return LI_S;
                        }
"</li>"                 {
                            cout<<"LI_E Tag\n";
                            return LI_E;
                        }

"<dl>"                  {
                            cout<<"DL Tag\n";
                            return DL_S;
                        }
"</dl>"                 {
                            cout<<"DL_E Tag\n";
                            return DL_E;
                        }

"<dt>"                  {
                            cout<<"DT Tag\n";
                            return DT_S;
                        }
"</dt>"                 {
                            cout<<"DT_E Tag\n";
                            return DT_E;
                        }

"<dd>"                  {
                            cout<<"DD Tag\n";
                            return DD_S;
                        }
"</dd>"                 {
                            cout<<"DD_E Tag\n";
                            return DD_E;
                        }

"<br>"|"<br />"|"<br/>"                  {
                            cout<<"BR Tag\n";
                            return BR_S;
                        }

[ \t\n]+                {
                            cout<<"Trimmed"<<endl;
                        }
{greek}                 {
                            cout<<"GREEK\n";
                            int n = strlen(yytext);
                            yylval.s = new char [n+1];
                            strcpy(yylval.s, yytext);
                            yylval.s[n] = '\0';
                            return GREEK;
                        }
([a-zA-Z0-9\.,'; \t\?=]+[\n]*)+         {
                                            int n = strlen(yytext);
                                            yylval.s = new char [n+1];
                                            strcpy(yylval.s, yytext);
                                            yylval.s[n] = '\0';
                                            return DATA;
                                        }
.                       ;
%%

void find_Attr(int st)
{
    int n = strlen(yytext);
    string str = (string(yytext).substr(st,n-st-1));
    n = str.length();
    yylval.s = new char [n+1];
    strcpy(yylval.s, str.c_str());
    yylval.s[n] = '\0';
}

void yyerror(const char *str) {
    cerr<<"Line No: "<<yylineno<<"\t Error: "<<str<<endl;
}

int yywrap(void) {
    return 1;
}
