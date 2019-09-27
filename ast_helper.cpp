#include <iostream>
//#include <bits/stdc++.h>
#include <vector>
#include <string>
using namespace std;

#define deb(x) cerr<<#x<<" : "<<x<<endl;
#define deb2(x, y) cerr<<#x<<" : "<<x<<" | "<<#y<<" : "<<y<<endl;
#define debvec(vec) { cerr<<#vec<<" : "<<'\n'; for(int ii=0; ii<vec.size(); ii++) cerr<<#vec<<"["<<ii+1<<"]   :   "<<vec[ii].first<<" : "<<vec[ii].second<<'\n'; cout<<'\n'; }


struct ast_node
{
    string tag;
    string text;
    vector< pair<string, string> > attributes;
    vector<ast_node *> children;
};


ast_node* create_node(string type, string info="")
{
    ast_node *temp = new ast_node;
    temp->tag = type;
    temp->text = info;
    temp->children.clear();
    //cerr<<"\n*********Debugging, Created "<<temp->tag<<endl;
    return temp;
}


void add_child(ast_node* par, ast_node* kid)
{
    if(kid == NULL)
        return;
    par->children.push_back(kid);
    //cerr<<"\n*********Debugging, Added "<<kid->tag<<" to "<<par->tag<<endl;
}


void add_child_safely(ast_node* par, ast_node* kid)
{
    if(kid == NULL)
        return;
        
    //cout<<"Parent Tag:"<<par->tag<<" | Child Tag:"<<kid->tag<<endl;
    
    if(kid->tag != "multi")
        par->children.push_back(kid);
    else if(kid->tag == "multi")
    {
        for(int i=0; i<kid->children.size(); i++)
            par->children.push_back(kid->children[i]);
    }
    
    
        /*
        if(kid->tag == "data")
            par->children.push_back(kid);
        else if(kid->tag == "multi")
        {
            for(int i=0; i<kid->children.size(); i++)
                par->children.push_back(kid->children[i]);
        }
        else if(kid->children.size() == 0)
        {
            par->children.push_back(kid);
        }
        else
            cout<<"===============ERROR, INVALID CALL=============\n"<<"Parent Tag:"<<par->tag<<" | Child Tag:"<<kid->tag<<endl;
        */
       
    //cerr<<"\n*********Debugging, Added "<<kid->tag<<" to "<<par->tag<<endl;
}


void add_attributes(ast_node* par, ast_node* kid)
{
    if(kid == NULL)
        return;
    for(int i=0; i<kid->attributes.size(); i++)
        par->attributes.push_back(kid->attributes[i]);
}

void add_attribute_value(ast_node* par, string attr, string val)
{
    par->attributes.push_back( {attr, val} );
}

void delete_tree(ast_node* root)
{
    for(int i=0; i<root->children.size(); i++)
    {
        delete_tree(root->children[i]);   
    }
    
    delete root;
}


void traverse(ast_node* root)
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


/*
int main()
{
    ast_node *lol = new ast_node;
    lol->tag="hello";
    cout<<lol->tag<<endl;
    
    for(int i=0; i<10; i++)
    {
        ast_node *child = new ast_node;
        child->tag="child";
        lol->children.push_back(child);   
    }
    
    for(int i=0; i<10; i++)
    {
            cout<<lol->children[i]->tag<<endl;
    }
    
    



    delete lol;
    return 0;
}*/
