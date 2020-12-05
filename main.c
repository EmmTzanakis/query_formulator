/* P-T natural language to SQL translator
 * Christopher Prasatzakis (csd3442)
 * Manos Tzanakis (csd1746)
 * csd3442@csd.uoc.gr
 * csd1746@csd.uoc.gr
 * Main function for translator system. */

#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "node.h"
#include "treeFormatter.h"
#include "SQLToken.h"
#include "algorithms.h"

/* Those functions and pointers are used by yacc in order to create
 * the initial parse tree. */
extern int yyparse(void);
extern FILE *yyin;
extern node *parseTree;

/* Main function */
int main(int argc, char **argv) {
	/* Create SQL query token list. */
	SQLToken *tokenList = newToken("START");
	
	/* Open input file. */
	if (argc == 2) {
		yyin = fopen(argv[1], "r");

		if (!(yyin)) {
			fprintf(stderr, "Cannot open file %s.\n", argv[1]);
			exit(1);
		}
	} else {
		yyin = stdin;
	}

	/* Create parse tree from input file. */
	yyparse();
	
	/* Insert implicit nodes, populate SQL token list and destroy tree. */
	insertImplicitNodes(parseTree);
	preOrder(parseTree, tokenList);
	destroyTree(parseTree);
	
	/* Add ; token to SQL token list and print query. */
	addToken(tokenList, newToken(";"));
	printQuery(tokenList);
	destroyList(tokenList);

	return 0;
}
