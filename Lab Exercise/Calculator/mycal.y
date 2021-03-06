%{
	#include "mycal.h"
	#include <string.h>
	#include <stdlib.h>
	#include <stdio.h>
%}
%union {
	double dval;
	struct symtab *symp;
	}

%token <symp> NAME
%token <dval> NUMBER
%left '-' '+'
%left '*' '/'
%nonassoc UNIMOS
%type <dval> expr;
%%

stmt_list :	stmt '\n'
     |	stmt_list stmt '\n'
	;
stmt :	NAME '=' expr { 
                        $1->value = $3;
                        }
     |	expr {
                printf(" =\t%g\n",$1);
            }
	;
expr :	expr '+' expr	{
                            $$ = $1 + $3;
                        }
	|expr '-' expr	{
                        $$ = $1 - $3;
                    }
	|expr '*' expr	{
                        $$ = $1 * $3;
                    }
	|expr '/' expr	{
				        if($3 == 0) {	
                            yyerror();
				        }
				        else {	
                            $$ = $1 / $3;
                        }
			        }
	|'-' expr  %prec UNIMOS	{
                                $$ = -$2;
                            }
	|'(' expr ')'	{
                        $$ = $2;
                    }
	|NUMBER	{   
                $$ = $1;
            }
	|NAME	{
                $$ = $1->value;
            }
	;
%%
struct symtab *symlook(char* s){
	struct symtab*	sp;
	for( sp = symtab; sp <&symtab[NSYMS]; sp++) {
		if(sp->name && !strcmp(sp->name,s)) {
			return sp;
        }
		if(!sp->name) {
			sp->name=strdup(s);
			return sp;
		}
	}
    yyerror();
}
int yyerror() {
	printf("\nInvalid\n");
	exit(0);
}
main() {
	system("clear");
	printf("\nThis program evaluate an expression \n\n");
	printf("\nEnter Expression  \n");
	yyparse();
}
