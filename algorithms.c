/* P-T natural language to SQL translator
 * Christopher Prasatzakis (csd3442)
 * Manos Tzanakis (csd1746)
 * csd3442@csd.uoc.gr
 * csd1746@csd.uoc.gr
 * Assisting tree algorithms: definitions. */

#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "algorithms.h"

/* Macro used to check whenever two strings have the
 * same value. */
#define ISSTRING(A, B) (strcmp(A, B) == 0)

/* Diagnostic function that prints the parse tree.
 * (not used in final program) */
void printParseTree(node *root, int tabs) {
	int i;

	if (!root) return;
	if (tabs < 0) return;

	for (i = 0; i < tabs; i++) {
		putchar(' ');
	}

	printf("{%s, %s, %s}\n", root->text, root->gramType, root->SQLType);

	if (root->rc) printParseTree(root->rc, tabs + 1);
	if (root->lc) printParseTree(root->lc, tabs + 1);
}

/* Traverse the parse tree in-order and populate the SQL token
 * list accordingly. */
void inOrder(node *root, SQLToken *tokenList) {
	int parentheses = 0;
	
	if (root->lc) inOrder(root->lc, tokenList);
	
	if (strcmp(root->SQLType, "NO_TYPE") && !ISSTRING(root->text, "PARENTHESES"))
		addToken(tokenList, newToken(root->SQLType));
	
	/* If we find ourselves in a node implicating parentheses, open parentheses. */
	if (ISSTRING(root->text, "PARENTHESES")) {
		parentheses = 1;
		addToken(tokenList, newToken("("));
	}
	
	if (root->rc) inOrder(root->rc, tokenList);
	
	/* If we are in a leaf node and parentheses are open, close them. */
	if (parentheses) {
		parentheses = 0;
		addToken(tokenList, newToken(")"));
	}
}

/* Same as above, only that it's a pre-order traversal. */
void preOrder(node *root, SQLToken *tokenList) {
	int parentheses = 0;
	
	/* There is a little difference here.
	 * If we find ourselves in a note denoting parentheses,
	 * and the left child is a "WHERE" node (Condtion),
	 * perform an in-order traversal of this sub-tree. */
	if (ISSTRING(root->text, "PARENTHESES") && ISSTRING(root->lc->text, "WHERE")) {
		inOrder(root, tokenList);
		return;
	}
	
	if (strcmp(root->SQLType, "NO_TYPE") && !ISSTRING(root->text, "PARENTHESES"))
		addToken(tokenList, newToken(root->SQLType));
	
	if (ISSTRING(root->text, "PARENTHESES") && !ISSTRING(root->lc->text, "WHERE")) {
		parentheses = 1;
		addToken(tokenList, newToken("("));
	}
	
	if (root->lc) preOrder(root->lc, tokenList);
	if (root->rc) preOrder(root->rc, tokenList);
	
	if (parentheses) {
		parentheses = 0;
		addToken(tokenList, newToken(")"));
	}
}

/* Algorithm that inserts implicit nodes in a valid parse tree. */
void insertImplicitNodes(node *root) {
	if (!root) return;
	node *implicit1, *implicit2;
	
	/* If we find ourselves in a comma node
	 * (implicit node inserted by yacc),
	 * ignore it. */
	if (ISSTRING(root->gramType, "COMMA")) {
		insertImplicitNodes(root->rc);
		return;
	}
	
	/* Implicit nodes are inserted as children of NN and QN type nodes
	 * right after nodes that imply SELECT clauses. */
	if (ISSTRING(root->gramType, "NN") || ISSTRING(root->gramType, "QN")) {
		if (ISSTRING(root->rc->gramType, "COMMA")) {
			insertImplicitNodes(root->rc);
			return;
		}
		
		/* If the query has no condition (SELECT NN, NN, NN, NN, ... FROM NN;),
		 * insert only a "FROM" implicit node on the current's left child. */
		if (ISSTRING(root->rc->gramType, "NO_TYPE") && ISSTRING(root->lc->gramType, "NN")) {
			implicit1 = oneChildParent(newNode("FROM", "IMPLICIT", "FROM"), root->lc);
			root->lc = implicit1;
			
			return;
		}
		
		/* In any other case, insert a "FROM" node on the left child and "PARENTHESES" and
		 * "WHERE" nodes on the right child. */
		if (ISSTRING(root->lc->gramType, "NN") && (ISSTRING(root->rc->gramType, "NN") || ISSTRING(root->rc->gramType, "LN"))) {
			implicit1 = oneChildParent(newNode("FROM", "IMPLICIT", "FROM"), root->lc);
			implicit2 = twoChildParent(newNode("PARENTHESES", "IMPLICIT", "PARENTHESES"), newNode("WHERE", "IMPLICIT", "WHERE"), root->rc);
			
			root->lc = implicit1;
			root->rc = implicit2;
			
			return;
		}
	}
	
	/* The tree is traversed post-order. */
	insertImplicitNodes(root->rc);
	insertImplicitNodes(root->lc);
}