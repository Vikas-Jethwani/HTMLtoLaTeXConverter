%{
    #include <iostream>
    #include <string.h>
    using namespace std;
    
    void yyerror(const char *);
    FILE *fileout;
    int yylex();
    extern FILE *yyin;
    extern char * yytext;
%}

%union{
    char* s;
}

%token      HTML_S      HTML_E      HEAD_S      HEAD_E      BODY_S      BODY_E
%token      TITLE_S     TITLE_E
%token      <s>         A_S         A_E         FONT_S      FONT_E      IMG_S       IMG_E
%token		A_HREF      A_NAME      A_TITLE     A_ATTR_E    FONT_SIZE   FONT_ATTR_E
%token      P_S         P_E         CENTER_S    CENTER_E    DIV_S       DIV_E
%token      H1_S        H1_E        H2_S        H2_E        H3_S        H3_E
%token      H4_S        H4_E        H5_S        H5_E        H6_S        H6_E
%token      U_S         U_E         BOLD_S      BOLD_E      TT_S        TT_E
%token      I_S         I_E         EM_S        EM_E        SMALL_S     SMALL_E
%token      SUB_S       SUB_E       SUP_S       SUP_E
%token      UL_S        UL_E        OL_S        OL_E        LI_S        LI_E
%token      DL_S        DL_E        DT_S        DT_E        DD_S        DD_E
%token      <s>         DATA
%start      begin

%type       <s>       Document
%type       <s>       html
%type       <s>       head
%type       <s>       body
%type       <s>       body_content
%type       <s>       a_content
%type       <s>       font_content
%type       <s>       list_content
%type       <s>       data





%%
                    /*******************************************
                                    BASIC OUTLINE
                    *******************************************/
begin               :   Document

Document            :   HTML_S html HTML_E                  { printf("Grammar mein jod diya.\n"); }
                    |                                       {;}

html                :   head body                           {
                                                                //char *temp = (char*)malloc(100);
                                                                //strcpy(temp, $1);
                                                                //strcat(temp, $2);
                                                                //$$ = temp;
                                                            }
                                                            
                    /*******************************************
                                    HEAD SECTION
                    *******************************************/

head                :   HEAD_S head_content HEAD_E          {
                                                                //char *temp = (char*)malloc(100);
                                                                //strcpy(temp, "\nfrom head\n");
                                                                //$$ = temp;
                                                            }
                    |                                       {;}
                    
head_content        :   TITLE_S data TITLE_E                {
                                                                //cout<<"\tData: "<<$2<<endl;
                                                                //delete yylval.s;
                                                            }
                    |                                       {;}

                    /*******************************************
                                    BODY SECTION
                    *******************************************/
                    
body                :   BODY_S body_content BODY_E          {
                                                                //char *temp = malloc(100);
                                                                //strcpy(temp, "\nfrom body\n");
                                                                //$$ = temp;
                                                            }
                    |                                       {;}
                    

body_content        :   body_content P_S body_content P_E data      {
                                                                        ;
                                                                    }
                                                            
body_content        :   body_content CENTER_S body_content CENTER_E data    {
                                                                                ;
                                                                            }

body_content        :   body_content H1_S body_content H1_E data    {
                                                                        ;
                                                                    }

body_content        :   body_content H2_S body_content H2_E data    {
                                                                        ;
                                                                    }
                                                                    
body_content        :   body_content H3_S body_content H3_E data    {
                                                                        ;
                                                                    }

body_content        :   body_content H4_S body_content H4_E data    {
                                                                        ;
                                                                    }

body_content        :   body_content H5_S body_content H5_E data    {
                                                                        ;
                                                                    }

body_content        :   body_content H6_S body_content H6_E data    {
                                                                        ;
                                                                    }

body_content        :   body_content DIV_S body_content DIV_E data  {
                                                                        ;
                                                                    }

body_content        :   body_content U_S body_content U_E data      {
                                                                        ;
                                                                    }

body_content        :   body_content BOLD_S body_content BOLD_E data    {
                                                                            ;
                                                                        }

body_content        :   body_content I_S body_content I_E data      {
                                                                        ;
                                                                    }

body_content        :   body_content EM_S body_content EM_E data    {
                                                                        ;
                                                                    }

body_content        :   body_content TT_S body_content TT_E data    {
                                                                        ;
                                                                    }

body_content        :   body_content SMALL_S body_content SMALL_E data  {
                                                                            ;
                                                                        }

body_content        :   body_content A_S a_content A_ATTR_E body_content A_E data         {
                                                                        ;
                                                                    }

a_content           :   a_content A_HREF                            {
                                                                        ;
                                                                    }
                    |   a_content A_NAME                            {
                                                                        ;
                                                                    }
                    |   a_content A_TITLE                           {
                                                                        ;
                                                                    }
                    |                                               {;}


body_content        :   body_content FONT_S font_content FONT_ATTR_E body_content FONT_E data    {
                                                                            ;
                                                                        }
                                                                        
font_content        :   font_content FONT_SIZE                      {
                                                                        ;
                                                                    }
                    |                                               {;}


body_content        :   body_content UL_S list_content UL_E         {
                                                                        ;
                                                                    }
                                                                    
                    |   body_content OL_S list_content OL_E         {
                                                                        ;
                                                                    }


list_content        :   list_content OL_S list_content OL_E         {
                                                                        ;
                                                                    }
                    |   list_content UL_S list_content UL_E         {
                                                                        ;
                                                                    }
                    |   list_content list                           {
                                                                        ;
                                                                    }
                    |   list                                        {
                                                                        ;
                                                                    }                                    
// Can't be empty ..                                     
list                :   LI_S body_content LI_E                      {
                                                                        ;
                                                                    }


body_content        :   body_content DL_S dict_content DL_E         {
                                                                        ;
                                                                    }


dict_content        :   dict_content term                           {
                                                                        ;
                                                                    }
                    |   term                                        {
                                                                        ;
                                                                    }                                    
// Can't be empty ..                                     
term                :   DT_S body_content DT_E DD_S body_content DD_E   {
                                                                            ;
                                                                        }



body_content        :   data                                {
                                                                //cout<<"\tData: "<<$1<<endl;
                                                                //delete yylval.s;
                                                            }

data                : DATA                                  {
                                                                cout<<"\tData: "<<$1<<endl;
                                                                delete yylval.s;
                                                            }
                    |                                       {;}
%%

int main(int argc, char *argv[]) {
    yyin = fopen(argv[1],"r");
    yyparse();
    return 0;
} 
