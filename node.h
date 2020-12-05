/* P-T natural language to SQL translator
 * Christopher Prasatzakis (csd3442)
 * Manos Tzanakis (csd1746)
 * csd3442@csd.uoc.gr
 * csd1746@csd.uoc.gr
 * Data type for parse tree nodes: declarations. */

#ifndef NODE_H
#define NODE_H
typedef struct n {
	char *text;
	char *gramType;
	char *SQLType;
	struct n *lc;
	struct n *rc;
} node;

node *newNode(char *text, char *gramType, char *SQLType);
node *twoChildParent(node *parent, node *child1, node *child2);
node *oneChildParent(node *parent, node *child);
void destroyTree(node *tree);
#endif
