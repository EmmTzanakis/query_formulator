/* P-T natural language to SQL translator
 * Christopher Prasatzakis (csd3442)
 * Manos Tzanakis (csd1746)
 * csd3442@csd.uoc.gr
 * csd1746@csd.uoc.gr
 * Syntax analyzer. */

%{
	#include "node.h"
	
	#include <stdio.h>
	#include <string.h>

	/* Macro used to determine whenever two strings have the same value. */
	#define ISSTRING(A, B) (strcmp(A, B) == 0)

	/* Lex functions and pointers. */
	extern char *yytext;
	int yyerror(char *message);
	int yylex(void);

	/* Pointer used to hold the generated parse tree. */
	node *parseTree = NULL;
%}

/* Union used to define types used by yacc. */
%union {
	node *nodeType;
	char *stringValue;
}

%start Q

/* Token type definition .*/
%token <stringValue>	ON
%token <stringValue>	FN
%token <stringValue>	NN
%token <stringValue>	VN
%token <stringValue>	QN
%token <stringValue>	SN
%token <stringValue>	MIN
%token <stringValue>	MAX
%token <stringValue>	LN

/* Rule type defitnition. */
%type <nodeType>	SClause
%type <nodeType>	ComplexCondition
%type <nodeType>	leftSubtree
%type <nodeType>	rightSubtree
%type <nodeType>	GNP
%type <nodeType>	NP
%type <nodeType>	Condition

%%

/* The grammar is a modified version of the parse tree grammar found in:
 * Constructing an Interactive Natural Language Interface for Relational Databases,
 * Fei Li, Uni. of Michigan, Ann Arbor and H. V. Jagadish, Uni. of Michigan, Ann Arbor */

Q:			SClause ComplexCondition { parseTree = twoChildParent(newNode("ROOT", "ROOT", "NO_TYPE"), $1, $2); }
			| SClause { parseTree = oneChildParent(newNode("ROOT", "ROOT", "NO_TYPE"), $1); }
 			;

SClause:		SN GNP { $$ = oneChildParent(newNode($1, "SN", "SELECT"), $2); }
       			;

ComplexCondition:	ON leftSubtree rightSubtree { $$ = twoChildParent(newNode($1, "ON", $1), $2, $3); }
			;


leftSubtree:		GNP { $$ = $1; puts("leftSubtree"); }
	   		;

rightSubtree:		GNP { $$ = $1; puts("rightSubtree"); }
	    		| NN VN { $$ = oneChildParent(newNode($1, "NN", $1), newNode($2, "VN", $2)); }
			| MIN { $$ = newNode($1, "MIN", "MIN"); puts("rightSubtree3"); }
			| MAX { $$ = newNode($1, "MAX", "MAX"); puts("rightSubtree4"); }
			;

GNP:			FN GNP { $$ = oneChildParent(newNode($1, "FN", $1), $2); }
   			| NP { $$ = $1; }
			;

/* Note how this rule inserts implicit "COMMA" nodes in the case of multiple columns. */
			
NP:			NN NN Condition { $$ = twoChildParent(newNode($1, "NN", $1), newNode($2, "NN", $2), $3); }
			| QN NN Condition { $$ = twoChildParent(newNode($1, "QN", "*"), newNode($2, "NN", $2), $3); }
			| NN NP { $$ = oneChildParent(newNode($1, "NN", $1), oneChildParent(newNode(",", "COMMA", ","), $2)); }
			| NN LN NP { $$ = oneChildParent(newNode($1, "NN", $1), oneChildParent(newNode(",", "COMMA", ","), $3)); }
  			;
			
/* And note how this one inserts "NOTHING" nodes in case of empty conditions. */

Condition:		NN VN { $$ = oneChildParent(newNode($1, "NN", $1), newNode($2, "VN", $2)); }
	 		| NN ON VN { $$ = oneChildParent(newNode($1, "NN", $1), oneChildParent(newNode($2, "ON", $2), newNode($3, "VN", $3))); }
			| Condition LN Condition { $$ = twoChildParent(newNode($2, "LN", $2), $1, $3); }
			| LN Condition { $$ = oneChildParent(newNode($1, "LN", $1), $2); }
			| { $$ = newNode("NOTHING", "NO_TYPE", "NOTHING"); }
			;

%%

/* Redefinition of the yyerror() function from Lex. */
int yyerror(char *message) {
	fprintf(stderr, "%s: before token %s:\n", message, yytext);
	fprintf(stderr, "INVALID INPUT\n");
}
