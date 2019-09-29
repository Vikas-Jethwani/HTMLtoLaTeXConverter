%{
    #include <iostream>
    #include <string.h>
    #include "ast_helper.h"     // Contains Tree related functions , Node Structure and Enums
    using namespace std;

    void yyerror(const char *);
    int yylex();
    extern FILE *yyin;
    extern char * yytext;
%}

%union {
    char* s;
    struct ast_node* node;
}

                    /*******************************************
                                        TOKENS
                    *******************************************/
%token      HTML_S      HTML_E      HEAD_S      HEAD_E      BODY_S      BODY_E
%token      TITLE_S     TITLE_E     

%token      A_S         A_E         FONT_S      FONT_E      IMG_S       IMG_E
%token		A_HREF      A_NAME      A_TITLE     A_ATTR_E    FONT_SIZE   FONT_ATTR_E

%token      FIG_S       FIG_E       FIGC_S      FIGC_E      IMG_SRC     IMG_WIDTH   IMG_HEIGHT
%token      TABLE_S     TABLE_E     TAB_BORDER  TAB_ATTR_E  CAPTION_S   CAPTION_E
%token      TR_S        TR_E        TH_S        TH_E        TD_S        TD_E

%token      P_S         P_E         CENTER_S    CENTER_E    DIV_S       DIV_E
%token      H1_S        H1_E        H2_S        H2_E        H3_S        H3_E
%token      H4_S        H4_E        H5_S        H5_E        H6_S        H6_E

%token      U_S         U_E         BOLD_S      BOLD_E      TT_S        TT_E
%token      I_S         I_E         EM_S        EM_E        SMALL_S     SMALL_E
%token      SUB_S       SUB_E       SUP_S       SUP_E

%token      UL_S        UL_E        OL_S        OL_E        LI_S        LI_E
%token      DL_S        DL_E        DT_S        DT_E        DD_S        DD_E
%token      BR_S        HR_S

%token      <s>         DATA        GREEK_S

                    /*******************************************
                                      PRODUCTIONS
                    *******************************************/
%start      begin
%type       <node>      Document
%type       <node>      html
%type       <node>      head
%type       <node>      body

%type       <node>      head_content
%type       <node>      body_content

%type       <node>      a_attributes
%type       <node>      font_attributes
%type       <node>      img_attributes
%type       <node>      fig_content
%type       <node>      fig_caption

%type       <node>      table_attributes
%type       <node>      table_content
%type       <node>      caption
%type       <node>      first_row
%type       <node>      first_row_data
%type       <node>      rest_rows
%type       <node>      rest_row_data

%type       <node>      list_content
%type       <node>      list

%type       <node>      dict_content
%type       <node>      term

%type       <node>      data




%%
                    /*******************************************
                    ********************************************
                                    BASIC OUTLINE
                    ********************************************
                    *******************************************/
begin               :   Document                            {
                                                                create_LaTeX($1);
                                                                delete_tree($1);
                                                            }

Document            :   HTML_S html HTML_E                  {
                                                                $$ = create_node(HTML);
                                                                add_child_safely($$, $2);
                                                                //traverse($$);
                                                            }
                    |                                       {   $$ = NULL;  }

html                :   head body                           {
                                                                $$ = create_node(multi);
                                                                add_child($$, $1);
                                                                add_child($$, $2);
                                                            }
                                                            
                    /*******************************************
                    ********************************************
                                    HEAD SECTION
                    ********************************************
                    *******************************************/

head                :   HEAD_S head_content HEAD_E          {
                                                                $$ = create_node(HEAD);
                                                                add_child($$, $2);
                                                            }
                    |                                       {   $$ = NULL;  }
                    
head_content        :   TITLE_S data TITLE_E                {
                                                                $$ = create_node(TITLE);
                                                                add_child($$, $2);
                                                            }
                    |                                       {   $$ = NULL;  }

                    /*******************************************
                    ********************************************
                                    BODY SECTION
                    ********************************************
                    *******************************************/
                    
body                :   BODY_S body_content BODY_E          {
                                                                $$ = create_node(BODY);
                                                                add_child_safely($$, $2);
                                                            }
                    |                                       {   $$ = NULL;  }
                    

                    /*******************************************
                                    Common Tags
                    *******************************************/
body_content        :   body_content P_S body_content P_E data              {
                                                                                ast_node *temp = create_node(P);
                                                                                add_child_safely(temp, $3);
                                                                                
                                                                                $$ = create_node(multi);
                                                                                add_child_safely($$, $1);
                                                                                add_child($$, temp);
                                                                                add_child_safely($$, $5);
                                                                            }
                                                            
body_content        :   body_content CENTER_S body_content CENTER_E data    {
                                                                                ast_node *temp = create_node(CENTER);
                                                                                add_child_safely(temp, $3);
                                                                        
                                                                                $$ = create_node(multi);
                                                                                add_child_safely($$, $1);
                                                                                add_child($$, temp);
                                                                                add_child_safely($$, $5);
                                                                            }

body_content        :   body_content H1_S body_content H1_E data            {
                                                                                ast_node *temp = create_node(H1);
                                                                                add_child_safely(temp, $3);
                                                                        
                                                                                $$ = create_node(multi);
                                                                                add_child_safely($$, $1);
                                                                                add_child($$, temp);
                                                                                add_child_safely($$, $5);
                                                                            }

body_content        :   body_content H2_S body_content H2_E data            {
                                                                                ast_node *temp = create_node(H2);
                                                                                add_child_safely(temp, $3);
                                                                        
                                                                                $$ = create_node(multi);
                                                                                add_child_safely($$, $1);
                                                                                add_child($$, temp);
                                                                                add_child_safely($$, $5);
                                                                            }
                                                                    
body_content        :   body_content H3_S body_content H3_E data            {
                                                                                ast_node *temp = create_node(H3);
                                                                                add_child_safely(temp, $3);
                                                                        
                                                                                $$ = create_node(multi);
                                                                                add_child_safely($$, $1);
                                                                                add_child($$, temp);
                                                                                add_child_safely($$, $5);
                                                                            }

body_content        :   body_content H4_S body_content H4_E data            {
                                                                                ast_node *temp = create_node(H4);
                                                                                add_child_safely(temp, $3);
                                                                        
                                                                                $$ = create_node(multi);
                                                                                add_child_safely($$, $1);
                                                                                add_child($$, temp);
                                                                                add_child_safely($$, $5);
                                                                            }

body_content        :   body_content H5_S body_content H5_E data            {
                                                                                ast_node *temp = create_node(H5);
                                                                                add_child_safely(temp, $3);
                                                                        
                                                                                $$ = create_node(multi);
                                                                                add_child_safely($$, $1);
                                                                                add_child($$, temp);
                                                                                add_child_safely($$, $5);
                                                                            }

body_content        :   body_content H6_S body_content H6_E data            {
                                                                                ast_node *temp = create_node(H6);
                                                                                add_child_safely(temp, $3);
                                                                        
                                                                                $$ = create_node(multi);
                                                                                add_child_safely($$, $1);
                                                                                add_child($$, temp);
                                                                                add_child_safely($$, $5);
                                                                            }

body_content        :   body_content DIV_S body_content DIV_E data          {
                                                                                ast_node *temp = create_node(DIV);
                                                                                add_child_safely(temp, $3);
                                                                        
                                                                                $$ = create_node(multi);
                                                                                add_child_safely($$, $1);
                                                                                add_child($$, temp);
                                                                                add_child_safely($$, $5);
                                                                            }

body_content        :   body_content U_S body_content U_E data              {
                                                                                ast_node *temp = create_node(U);
                                                                                add_child_safely(temp, $3);
                                                                        
                                                                                $$ = create_node(multi);
                                                                                add_child_safely($$, $1);
                                                                                add_child($$, temp);
                                                                                add_child_safely($$, $5);
                                                                            }

body_content        :   body_content BOLD_S body_content BOLD_E data        {
                                                                                ast_node *temp = create_node(BOLD);
                                                                                add_child_safely(temp, $3);
                                                                        
                                                                                $$ = create_node(multi);
                                                                                add_child_safely($$, $1);
                                                                                add_child($$, temp);
                                                                                add_child_safely($$, $5);
                                                                            }

body_content        :   body_content I_S body_content I_E data              {
                                                                                ast_node *temp = create_node(I);
                                                                                add_child_safely(temp, $3);
                                                                        
                                                                                $$ = create_node(multi);
                                                                                add_child_safely($$, $1);
                                                                                add_child($$, temp);
                                                                                add_child_safely($$, $5);
                                                                            }

body_content        :   body_content EM_S body_content EM_E data            {
                                                                                ast_node *temp = create_node(EM);
                                                                                add_child_safely(temp, $3);
                                                                        
                                                                                $$ = create_node(multi);
                                                                                add_child_safely($$, $1);
                                                                                add_child($$, temp);
                                                                                add_child_safely($$, $5);
                                                                            }

body_content        :   body_content TT_S body_content TT_E data            {
                                                                                ast_node *temp = create_node(TT);
                                                                                add_child_safely(temp, $3);
                                                                        
                                                                                $$ = create_node(multi);
                                                                                add_child_safely($$, $1);
                                                                                add_child($$, temp);
                                                                                add_child_safely($$, $5);
                                                                            }

body_content        :   body_content SMALL_S body_content SMALL_E data      {
                                                                                ast_node *temp = create_node(SMALL);
                                                                                add_child_safely(temp, $3);
                                                                        
                                                                                $$ = create_node(multi);
                                                                                add_child_safely($$, $1);
                                                                                add_child($$, temp);
                                                                                add_child_safely($$, $5);
                                                                            }
 
body_content        :   body_content SUB_S body_content SUB_E data          {
                                                                                ast_node *temp = create_node(SUB);
                                                                                add_child_safely(temp, $3);
                                                                        
                                                                                $$ = create_node(multi);
                                                                                add_child_safely($$, $1);
                                                                                add_child($$, temp);
                                                                                add_child_safely($$, $5);
                                                                            }
                                                                    
body_content        :   body_content SUP_S body_content SUP_E data          {
                                                                                ast_node *temp = create_node(SUP);
                                                                                add_child_safely(temp, $3);
                                                                        
                                                                                $$ = create_node(multi);
                                                                                add_child_safely($$, $1);
                                                                                add_child($$, temp);
                                                                                add_child_safely($$, $5);
                                                                            }

body_content        :   body_content HR_S data                              {
                                                                                ast_node *temp = create_node(HR);
                                                                        
                                                                                $$ = create_node(multi);
                                                                                add_child_safely($$, $1);
                                                                                add_child($$, temp);
                                                                                add_child_safely($$, $3);
                                                                            }

body_content        :   body_content BR_S data                              {
                                                                                ast_node *temp = create_node(BR);
                                                                        
                                                                                $$ = create_node(multi);
                                                                                add_child_safely($$, $1);
                                                                                add_child($$, temp);
                                                                                add_child_safely($$, $3);
                                                                            }
                                                                    
body_content        :   body_content GREEK_S data                           {
                                                                                ast_node *temp = create_node(GREEK, string($2));
                                                                        
                                                                                $$ = create_node(multi);
                                                                                add_child_safely($$, $1);
                                                                                add_child($$, temp);
                                                                                add_child_safely($$, $3);
                                                                            }


                    /*******************************************
                                      Anchor Tag
                    *******************************************/

body_content        :   body_content A_S a_attributes A_ATTR_E body_content A_E data    {
                                                                                            ast_node *temp = create_node(A);
                                                                                            add_child_safely(temp, $5);
                                                                                            add_attributes(temp, $3);
                                                                                    
                                                                                            $$ = create_node(multi);
                                                                                            add_child_safely($$, $1);
                                                                                            add_child($$, temp);
                                                                                            add_child_safely($$, $7);
                                                                                        }

a_attributes        :   a_attributes A_HREF                         {
                                                                        $$ = create_node(attributes);
                                                                        add_attributes($$, $1);
                                                                        add_attribute_value($$, "href", string(yylval.s));
                                                                    }
                    |   a_attributes A_NAME                         {
                                                                        $$ = create_node(attributes);
                                                                        add_attributes($$, $1);
                                                                        //add_attribute_value($$, "name", string(yylval.s));
                                                                    }
                    |   a_attributes A_TITLE                        {
                                                                        $$ = create_node(attributes);
                                                                        add_attributes($$, $1);
                                                                        //add_attribute_value($$, "title", string(yylval.s));
                                                                    }
                    |                                               {   $$ = NULL;  }

                    /*******************************************
                                    Font Tag
                    *******************************************/
body_content        :   body_content FONT_S font_attributes FONT_ATTR_E body_content FONT_E data    {
                                                                                                        ast_node *temp = create_node(FONT);
                                                                                                        add_child_safely(temp, $5);
                                                                                                        add_attributes(temp, $3);
                                                                                                
                                                                                                        $$ = create_node(multi);
                                                                                                        add_child_safely($$, $1);
                                                                                                        add_child($$, temp);
                                                                                                        add_child_safely($$, $7);
                                                                                                    }
                                                                        
font_attributes     :   FONT_SIZE                                   {
                                                                        $$ = create_node(attributes);
                                                                        add_attribute_value($$, "size", string(yylval.s));
                                                                    }
                    |                                               {   $$ = NULL;  }

                    /*******************************************
                                    Image Tag
                    *******************************************/
body_content        :   body_content FIG_S fig_content FIG_E data       {   
                                                                            ast_node *temp = create_node(FIG);
                                                                            add_child_safely(temp, $3);
                                                                    
                                                                            $$ = create_node(multi);
                                                                            add_child_safely($$, $1);
                                                                            add_child($$, temp);
                                                                            add_child_safely($$, $5);
                                                                        }

fig_content         :   fig_caption IMG_S img_attributes IMG_E data     {
                                                                            ast_node *temp = create_node(IMG);
                                                                            add_attributes(temp, $3);
                                                                    
                                                                            $$ = create_node(multi);
                                                                            add_child($$, $1);
                                                                            add_child($$, temp);
                                                                            add_child_safely($$, $5);
                                                                        }

fig_caption         :   FIGC_S data FIGC_E                              {
                                                                            $$ = create_node(FIGC);
                                                                            add_child_safely($$, $2);
                                                                        }
                    |                                                   {   $$ = NULL;  }     
                    

body_content        :   body_content IMG_S img_attributes IMG_E data    {
                                                                            ast_node *temp = create_node(IMG);
                                                                            add_attributes(temp, $3);
                                                                    
                                                                            $$ = create_node(multi);
                                                                            add_child_safely($$, $1);
                                                                            add_child($$, temp);
                                                                            add_child_safely($$, $5);
                                                                        }

img_attributes      :   img_attributes IMG_SRC                          {
                                                                            $$ = create_node(attributes);
                                                                            add_attributes($$, $1);
                                                                            add_attribute_value($$, "src", string(yylval.s));
                                                                        }
                    |   img_attributes IMG_WIDTH                        {
                                                                            $$ = create_node(attributes);
                                                                            add_attributes($$, $1);
                                                                            add_attribute_value($$, "width", string(yylval.s));
                                                                        }
                    |   img_attributes IMG_HEIGHT                       {
                                                                            $$ = create_node(attributes);
                                                                            add_attributes($$, $1);
                                                                            add_attribute_value($$, "height", string(yylval.s));
                                                                        }
                    |                                                   {   $$ = NULL;  }


                    /*******************************************
                                    Table Tag
                    *******************************************/
body_content        :   body_content TABLE_S table_attributes TAB_ATTR_E table_content TABLE_E data     {
                                                                                                            ast_node *temp = create_node(TABLE);
                                                                                                            add_child_safely(temp, $5);
                                                                                                            add_attributes(temp, $3);
                                                                                                    
                                                                                                            $$ = create_node(multi);
                                                                                                            add_child_safely($$, $1);
                                                                                                            add_child($$, temp);
                                                                                                            add_child_safely($$, $7);
                                                                                                        }


table_attributes    :   TAB_BORDER                                  {
                                                                        $$ = create_node(attributes);
                                                                        add_attribute_value($$, "border", string(yylval.s));
                                                                    }
                    |                                               {   $$ = NULL;  }
                    
table_content       :   caption first_row rest_rows                 {
                                                                        $$ = create_node(multi);
                                                                        add_child($$, $1);
                                                                        add_child($$, $2);
                                                                        add_child_safely($$, $3);
                                                                    }
                    |   caption first_row                           {
                                                                        $$ = create_node(multi);
                                                                        add_child($$, $1);
                                                                        add_child($$, $2);
                                                                    }
                    |   caption rest_rows                           {
                                                                        $$ = create_node(multi);
                                                                        add_child($$, $1);
                                                                        add_child_safely($$, $2);
                                                                    }                              
                    |   caption                                     {   $$ = $1;    }


caption             :   CAPTION_S body_content CAPTION_E            {
                                                                        $$ = create_node(T_CAPTION);
                                                                        add_child_safely($$, $2);
                                                                    }
                    |                                               {   $$ = NULL;  }

first_row           :   TR_S first_row_data TR_E                    {
                                                                        $$ = create_node(TR);
                                                                        add_child_safely($$, $2);
                                                                    }


first_row_data      :   first_row_data TH_S body_content TH_E       {
                                                                        ast_node *temp = create_node(TH);
                                                                        add_child_safely(temp, $3);
                                                                
                                                                        $$ = create_node(multi);
                                                                        add_child_safely($$, $1);
                                                                        add_child($$, temp);
                                                                    }
                    |   TH_S body_content TH_E                      {
                                                                        $$ = create_node(TH);
                                                                        add_child_safely($$, $2);
                                                                    }


rest_rows           :   rest_rows TR_S rest_row_data TR_E           {
                                                                        ast_node *temp = create_node(TR);
                                                                        add_child_safely(temp, $3);
                                                                
                                                                        $$ = create_node(multi);
                                                                        add_child_safely($$, $1);
                                                                        add_child($$, temp);
                                                                    }
                    |   TR_S rest_row_data TR_E                     {
                                                                        $$ = create_node(TR);
                                                                        add_child_safely($$, $2);
                                                                    }

rest_row_data       :   rest_row_data TD_S body_content TD_E        {
                                                                        ast_node *temp = create_node(TD);
                                                                        add_child_safely(temp, $3);
                                                                
                                                                        $$ = create_node(multi);
                                                                        add_child_safely($$, $1);
                                                                        add_child($$, temp);
                                                                    }
                    |                                               {   $$ = NULL;  }
                    
                    
                    /*******************************************
                                    List Tags
                    *******************************************/

body_content        :   body_content UL_S list_content UL_E         {
                                                                        ast_node *temp = create_node(UL);
                                                                        add_child_safely(temp, $3);
                                                                
                                                                        $$ = create_node(multi);
                                                                        add_child_safely($$, $1);
                                                                        add_child($$, temp);
                                                                    }
                                                                    
                    |   body_content OL_S list_content OL_E         {
                                                                        ast_node *temp = create_node(OL);
                                                                        add_child_safely(temp, $3);
                                                                
                                                                        $$ = create_node(multi);
                                                                        add_child_safely($$, $1);
                                                                        add_child($$, temp);
                                                                    }


list_content        :   list_content UL_S list_content UL_E         {
                                                                        ast_node *temp = create_node(UL);
                                                                        add_child_safely(temp, $3);
                                                                
                                                                        $$ = create_node(multi);
                                                                        add_child_safely($$, $1);
                                                                        add_child($$, temp);
                                                                    }
                    |   list_content OL_S list_content OL_E         {
                                                                        ast_node *temp = create_node(OL);
                                                                        add_child_safely(temp, $3);
                                                                
                                                                        $$ = create_node(multi);
                                                                        add_child_safely($$, $1);
                                                                        add_child($$, temp);
                                                                    }
                    |   list_content list                           {
                                                                        $$ = create_node(multi);
                                                                        add_child_safely($$, $1);
                                                                        add_child($$, $2);
                                                                    }
                    |   list                                        {   $$ = $1;    }                                    

// Can't be empty, So...                                     
list                :   LI_S body_content LI_E                      {
                                                                        $$ = create_node(LI);
                                                                        add_child_safely($$, $2);
                                                                    }

                    /*******************************************
                                 Dictionary Tags
                    *******************************************/
body_content        :   body_content DL_S dict_content DL_E             {
                                                                            ast_node *temp = create_node(DL);
                                                                            add_child_safely(temp, $3);
                                                                    
                                                                            $$ = create_node(multi);
                                                                            add_child_safely($$, $1);
                                                                            add_child($$, temp);
                                                                        }
dict_content        :   dict_content term                               {
                                                                            $$ = create_node(multi);
                                                                            add_child_safely($$, $1);
                                                                            add_child($$, $2);
                                                                        }
                    |   term                                            {   $$ = $1;    }                                

// Can't be empty, So...                                     
term                :   DT_S body_content DT_E DD_S body_content DD_E   {
                                                                            ast_node *temp = create_node(DD);
                                                                            add_child_safely(temp, $5);
                                                                            
                                                                            $$ = create_node(DT);
                                                                            add_child_safely($$, $2);
                                                                            add_child($$, temp);
                                                                        }


                    /*******************************************
                                    Text / Data
                    *******************************************/

body_content        :   data                                            {   $$ = $1;    }

data                :   DATA                                            {
                                                                            $$ = create_node(data, string($1));
                                                                        }
                    |                                                   {   $$ = NULL;  }
%%

/*  -------------------------------------------------- END ---------------------------------------------------*/
