/* P-T natural language to SQL translator
 * Christopher Prasatzakis (csd3442)
 * Manos Tzanakis (csd1746)
 * csd3442@csd.uoc.gr
 * csd1746@csd.uoc.gr
 * Assisting tree algorithms: declarations. */

#ifndef ALGORITHMS_H
#define ALGORITHMS_H
#include "node.h"
#include "SQLToken.h"

void printParseTree(node *root, int tabs);
void inOrder(node *root, SQLToken *tokenList);
void preOrder(node *root, SQLToken *tokenList);
void insertImplicitNodes(node *root);
#endif