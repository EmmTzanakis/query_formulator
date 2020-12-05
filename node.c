/* P-T natural language to SQL translator
 * Christopher Prasatzakis (csd3442)
 * Manos Tzanakis (csd1746)
 * csd3442@csd.uoc.gr
 * csd1746@csd.uoc.gr
 * Data type for parse tree nodes: definitions. */

#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "node.h"

/* Static function used for printing error messages
 * and exiting with a given code. */
static void error(char *message, int code) {
	fprintf(stderr, "FATAL: %s\n", message);
	exit(code);
}

/* Create a new tree node. */
node *newNode(char *text, char *gramType, char *SQLType) {
	node *n = (node *) malloc(sizeof(node));

	if ((!text) || (!gramType)) return NULL;

	if (!n) error("Cannot allocate memory for node!", 1);

	n->text = strdup(text);
	n->gramType = strdup(gramType);
	n->SQLType = strdup(SQLType);

	n->lc = n->rc = NULL;

	return n;
}

/* Give a node two children. */
node *twoChildParent(node *parent, node *child1, node *child2) {
	node *n = parent;

	if ((!parent) || (!child1) || (!child2)) return NULL;

	n->lc = child1;
	n->rc = child2;

	return n;
}

/* Give a node one child (right child). */
node *oneChildParent(node *parent, node *child) {
	node *n = parent;

	if ((!parent) || (!child)) return NULL;

	n->lc = NULL;
	n->rc = child;

	return n;
}

/* Destroy a given parse tree (free from memory). */
void destroyTree(node *tree) {
	if (!tree) return;

	destroyTree(tree->lc);
	destroyTree(tree->rc);

	free(tree);

	return;
}
