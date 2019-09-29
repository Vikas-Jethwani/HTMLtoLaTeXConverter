#include <iostream>
#include <vector>
#include <string>
using namespace std;


                                /*******************************************
                                                Structures
                                *******************************************/
enum NODE_TYPE {HTML, HEAD, TITLE, BODY, P, CENTER, H1, H2, H3, H4, H5, H6, DIV, U, BOLD, I, EM, TT, SMALL, SUB, SUP, HR, BR, GREEK, A, 
                FONT, IMG, FIG, FIGC, TABLE, T_CAPTION, TR, TH, TD, UL, OL, LI, DL, DT, DD, data, multi, attributes};

struct ast_node
{
    NODE_TYPE tag;
    string text;
    vector<pair< string, string > > attributes;
    vector<ast_node *> children;
};



                                /*******************************************
                                                    Functions
                                *******************************************/
ast_node* create_node(NODE_TYPE, string);

ast_node* create_node(NODE_TYPE);


void add_attribute_value(ast_node*, string, string);

void add_attributes(ast_node*, ast_node*);

void add_child(ast_node*, ast_node*);

void add_child_safely(ast_node*, ast_node*);


void traverse(ast_node*);

void delete_tree(ast_node*);


void create_LaTeX(ast_node*);
