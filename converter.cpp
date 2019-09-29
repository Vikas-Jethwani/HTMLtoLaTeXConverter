#include <bits/stdc++.h>
#include "ast_helper.h"
using namespace std;


                                /*******************************************
                                                Global Data
                                *******************************************/
extern int yyparse();
extern FILE *yyin;
string conv;
bool border;
int num_col;
int curr_col;


                                /*******************************************
                                                Only for Debugging
                                *******************************************/
#define deb(x) cerr<<#x<<" : "<<x<<endl;
#define deb2(x, y) cerr<<#x<<" : "<<x<<" | "<<#y<<" : "<<y<<endl;
#define debvec(vec) { cerr<<#vec<<" : "<<'\n'; for(int ii=0; ii<vec.size(); ii++) cerr<<#vec<<"["<<ii+1<<"]   :   "<<vec[ii].first<<" : "<<vec[ii].second<<'\n'; cout<<'\n'; }



                                /*******************************************
                                       Header File Function Definitions
                                *******************************************/
extern ast_node* create_node(NODE_TYPE type, string info)
{
    ast_node *temp = new ast_node;
    temp->tag = type;
    temp->text = info;
    temp->children.clear();
    //cerr<<"\n*********Debugging, Created "<<temp->tag<<endl;
    return temp;
}

extern ast_node* create_node(NODE_TYPE type)
{
    return create_node(type, "");
}


extern void add_attribute_value(ast_node* par, string attr, string val)
{
    par->attributes.push_back( {attr, val} );
}

extern void add_attributes(ast_node* par, ast_node* kid)
{
    if(kid == NULL)
        return;
    for(int i=0; i<kid->attributes.size(); i++)
        par->attributes.push_back(kid->attributes[i]);
}

extern void add_child(ast_node* par, ast_node* kid)
{
    if(kid == NULL)
        return;
    par->children.push_back(kid);
    //cerr<<"\n*********Debugging, Added "<<kid->tag<<" to "<<par->tag<<endl;
}

extern void add_child_safely(ast_node* par, ast_node* kid)
{
    if(kid == NULL)
        return;
        
    //cout<<"Parent Tag:"<<par->tag<<" | Child Tag:"<<kid->tag<<endl;
    
    if(kid->tag != multi)
        par->children.push_back(kid);
    else if(kid->tag == multi)
    {
        for(int i=0; i<kid->children.size(); i++)
            par->children.push_back(kid->children[i]);
    }    

    //cerr<<"\n*********Debugging, Added "<<kid->tag<<" to "<<par->tag<<endl;
}

// For debugging purposes ...
extern void traverse(ast_node* root)
{
    cerr<<"----------------------------------------------------\n";
    deb2(root->tag, root->text);
    debvec(root->attributes);

    if(root->children.size() == 0)  return;
    cerr<<root->tag<<"'s children :\n";

    for(int i=0; i<root->children.size(); i++)
    {
        traverse(root->children[i]);   
    }
    cerr<<root->tag<<"'s children OVER !!\n";
    cerr<<"------------------\n";
}

extern void delete_tree(ast_node* root)
{
    for(int i=0; i<root->children.size(); i++)
    {
        delete_tree(root->children[i]);   
    }
    
    delete root;
}



                                /*******************************************
                                              Mapping
                                *******************************************/

map <NODE_TYPE, string> start = {
        { HTML      , "" },
        { HEAD      , "" },
        { TITLE     , "\n\\title{" },
        { BODY      , "\\begin{document}\n\\maketitle\n" },
        { P         , "\n\\par\n" },
        { CENTER    , "\\begin{center}\n" },
        { DIV       , "\n\n" },
        { H1        , "\n\\section*{" },
        { H2        , "\n\\subsection*{" },
        { H3        , "\n\\subsubsection*{" },
        { H4        , "\n\\textbf{" },
        { H5        , "\n{\\small\\textbf{" },
        { H6        , "\n{\\scriptsize\\textbf{" },
        { U         , "\\underline{" },
        { BOLD      , "\n\\textbf{" },
        { I         , "\\textit{" },
        { EM        , "\\emph{" },
        { TT        , "\\texttt{" },
        { SUB       , "_{" },
        { SUP       , "^{" },
        { HR        , "\n\\hrulefill\n" },
        { BR        , "\\hfill \\break\n" },
        { FIG       , "\n\\begin{figure}\n" },
        { FIGC      , "\\caption{" },
        { T_CAPTION , "\\caption{" },
        { UL        , "\n\\begin{itemize}" },
        { OL        , "\n\\begin{enumerate}" },
        { LI        , "\\item " },
        { DL        , "\n\\begin{description}[style=unboxed, labelwidth=\\linewidth, font=\\sffamily\\itshape\\bfseries, listparindent=0pt, before=\\sffamily]" },
        { DT        , "\n\\item[" },
        { DD        , "]\n" },
    };
    
map <NODE_TYPE, string> finish = {
        { HTML      , "" },
        { HEAD      , "" },
        { TITLE     , "}\n\\author{Vikas Jethwani}\n" },
        { BODY      , "\n\n\\end{document}\n" },
        { P         , "\n" },
        { CENTER    , "\\end{center}\n" },
        { H1        , "}\n" },
        { H2        , "}\n" },
        { H3        , "}\n" },
        { H4        , "}\n" },
        { H5        , "}}\n" },
        { H6        , "}}\n" },
        { DIV       , "\n" },
        { U         , "}" },
        { BOLD      , "}" },
        { I         , "}" },
        { EM        , "}" },
        { TT        , "}" },
        { SUB       , "}" },
        { SUP       , "}" },
        { HR        , "" },
        { BR        , "" },
        { FIG       , "\n\\end{figure}\n" },
        { FIGC      , "}" },
        { T_CAPTION , "}\n" },
        { UL        , "\\end{itemize}\n" },
        { OL        , "\\end{enumerate}\n" },
        { LI        , "" },
        { DL        , "\\end{description}\n" },
        { DT        , "\n" },
        { DD        , "" },
    
};

                                /*******************************************
                                               New Helper Functions
                                *******************************************/

void conv_greek(ast_node* root)
{
    string val = root->text; 
    if(val == "&Alpha;")
        val = "A";
    else if(val == "&Beta;")
        val = "B";
    else
    {
        val[0] = '\\';
        val = val.substr(0,val.length()-1);
    }
    val += "\\ ";
    
    conv += val;

}

void conv_a(ast_node* root)
{
    string link = "";
    if(root->attributes.size() != 0)
        link = root->attributes[0].second;
    
    conv += "\\href{" + link + "}{";
    
    for(int i=0; i<root->children.size(); i++)
        create_LaTeX(root->children[i]);
        
    conv += "}";
}

void conv_font(ast_node* root, int size=3)
{
    string latex_sizes[7] = {"tiny ", "scriptsize ", "normalsize ", "large ", "Large ", "LARGE ", "HUGE " };
    if(root->attributes.size() != 0)
        size = stoi(root->attributes[0].second);
    
    if(size > 7) size=7;
    if(size < 1) size=1;
    size--;     //0-based indexing
    

    conv += "{\\" + latex_sizes[size] ;
    
    for(int i=0; i<root->children.size(); i++)
        create_LaTeX(root->children[i]);
        
    conv += "}";
}

void conv_img(ast_node* root)
{
    string src="", h="", w="" ;
    
    for(int i=0; i<root->attributes.size(); i++)
    {
        if(root->attributes[i].first == "src")
        {
            src = root->attributes[i].second;
        }
        else if(root->attributes[i].first == "width")
        {
            w = root->attributes[i].second;
        }
        else if(root->attributes[i].first == "height")
        {
            h = root->attributes[i].second;
        }
    }
    
    conv += "\n\\includegraphics" ;
    
    if(h=="" && w!="")
    {
        conv += "[width=" + w + "px]";    
    }
    if(h!="" && w=="")
    {
        conv += "[height=" + h + "px]";   
    }
    if(h!="" && w!="")
    {
        conv += "[height=" + h + "px, width=" + w + "px]";    
    }
    
    conv += "{" + src + "}\n";
}

void conv_table(ast_node* root)
{
    border = false; num_col = 0;
    bool caption=false;
    
    if(root->attributes.size() != 0)
        border = stoi(root->attributes[0].second);
    
    int num_child_of_table = root->children.size();
    if(root->children[num_child_of_table - 1]->tag == TR)
    {
        num_col = (root->children[num_child_of_table - 1])->children.size();
    }
    if(root->children[0]->tag == T_CAPTION)
    {
        caption = true;
    }
    

    conv += "\n\\begin{table}[h!]\n\\centering\n";
    
    if(caption)
    {
        create_LaTeX(root->children[0]);
    }
    
    conv += "\\begin{tabular}{";
    
    for(int i=0; i<num_col; i++)
    {
        if(border)  conv += "|";
        else        conv += " ";
        conv += "c";
    }
    if(border)  conv += "|}\n\\hline\n";
    else conv += "}\n";
    
    for(int i=0; i<root->children.size(); i++)
    {
        if(caption && i==0) continue;
        create_LaTeX(root->children[i]);
    }
    
    conv += "\n\\end{tabular}\n\\end{table}\n\n";
    
    border=false;
}


void findAndReplaceAll(string & data, string toSearch, string replaceStr)
{
    // Get the first occurrence
    size_t pos = data.find(toSearch);
    // Repeat till end is reached
    while( pos != std::string::npos)
    {
        // Replace this occurrence of Sub String
        data.replace(pos, toSearch.size(), replaceStr);
        // Get the next occurrence from the current position
        pos = data.find(toSearch, pos + replaceStr.size());
    }
}

void fix_latex_chars(string & data)
{
    vector< pair< string, string > > mapping_latex = {
                                                        {"\\", "\\textbackslash\\ "},
                                                        {"{", "\\{"},
                                                        {"}", "\\}"},
                                                        {"_", "\\_"},
                                                        {"^", "\\hat{}\\ "},
                                                        {"@", "@\\ "},
                                                        {"$", "\\$\\ "},
                                                        {"%", "\\%"},
                                                        {"~", "\\sim"},
                                                        {"#", "\\#"},
                                                        {"&", "\\&"}
                                                     };
    for(int i=0; i<mapping_latex.size(); i++)
    {
        findAndReplaceAll(data, mapping_latex[i].first, mapping_latex[i].second);
    }
}

extern void create_LaTeX(ast_node* root)
{
    if(root == NULL)
        return;
    
    if(root->tag == data)
    {
        fix_latex_chars(root->text);
        conv += root->text;
        return;
    }
    else if(root->tag == GREEK)
    {
        conv_greek(root);
        return;
    }
    else if(root->tag == A)
    {
        conv_a(root);
        return;
    }
    else if(root->tag == FONT)
    {
        conv_font(root);
        return;
    }
    else if(root->tag == SMALL)
    {
        conv_font(root, 2);
        return;
    }
    else if(root->tag == IMG)
    {
        conv_img(root);
        return;
    }
    else if(root->tag == TABLE)
    {
        conv_table(root);
        return;
    }
    else if(root->tag == TABLE)
    {
        conv_table(root);
        return;
    }
    else if(root->tag == TABLE)
    {
        conv_table(root);
        return;
    }
    else if(root->tag == TR)
    {
        curr_col = 0;
        for(int i=0; i<root->children.size(); i++)
            create_LaTeX(root->children[i]);
        if(border)
            conv += "\\hline\n";
        return;
    }
    else if(root->tag == TH || root->tag == TD)
    {
        curr_col++;
        for(int i=0; i<root->children.size(); i++)
            create_LaTeX(root->children[i]);
        if(curr_col == num_col)
            conv += " \\\\\n";
        else
            conv += " & ";
        
        return;
    }
    
    
    conv += start[root->tag];
    
    for(int i=0; i<root->children.size(); i++)
        create_LaTeX(root->children[i]);

    conv += finish[root->tag];   
}



int main(int argc, char *argv[]) {
    yyin = fopen(argv[1], "r");
    
    conv = "\\documentclass{article}\n";
    conv += "\\usepackage{hyperref}\n";
    conv += "\\usepackage{comment}\n";
    conv += "\\usepackage[utf8]{inputenc}\n";
    conv += "\\usepackage[T1]{fontenc}\n";
    conv += "\\usepackage{enumitem}\n";
    conv += "\\usepackage{graphicx}\n";
    
    yyparse();
    
    ofstream fout;
    fout.open(argv[2], ios::out | ios::trunc );
    fout << conv ;
    return 0;
}
