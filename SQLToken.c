/* P-T natural language to SQL translator
 * Christopher Prasatzakis (csd3442)
 * Manos Tzanakis (csd1746)
 * csd3442@csd.uoc.gr
 * csd1746@csd.uoc.gr
 * Data type for SQL token list: definitions. */

#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "SQLToken.h"

/* Macro used to determine whenever two strings have the same value. */
#define ISSTRING(a, b) (strcmp(a, b) == 0)

/* Create a new token. */
SQLToken *newToken(char *token) {
	SQLToken *t = (SQLToken *) malloc(sizeof(SQLToken));
	
	if (!t) {
		fprintf(stderr, "Cannot allocate memory for SQL token! Aborting...\n");
		exit(1);
	}
	
	t->token = strdup(token);
	t->next = NULL;
	
	return t;
}

/* Add new token to a list. */
void addToken(SQLToken *list, SQLToken *token) {
	SQLToken *lst = list;
	
	if ((!list) || (!token)) return;
	
	while (lst->next) {
		lst = lst->next;
	}
	
	lst->next = token;
}

/* Given a SQL token list, print the generated SQL query. */
void printQuery(SQLToken *list) {
	SQLToken *lst = list;
	int function = 0;
	
	if (!list) return;
	
	while (lst) {
		/* Ignore "START" tokens (used as fillers). */
		if (!ISSTRING(lst->token, "START")) {
			/* Ignore tokens with "NOTHING" value. */
			if (ISSTRING(lst->token, "NOTHING")) {
				lst = lst->next;
				
				continue;
			}
			
			/* For closed parentheses, semicolons and commas, print token without any spaces. */
			if (lst->next) {
				if (ISSTRING(lst->next->token, ")") || ISSTRING(lst->next->token, ";") || ISSTRING(lst->next->token, ",")) {
					printf("%s", lst->token);
					lst = lst->next;
					continue;
				}
			}
			
			if (ISSTRING(lst->token, "(") || ISSTRING(lst->token, ";"))
				/* For open parentheses and semicolons, print without spaces. */
				printf("%s", lst->token);
			else if (ISSTRING(lst->token, "AVG") || ISSTRING(lst->token, "SUM") || ISSTRING(lst->token, "COUNT") 
				|| ISSTRING(lst->token, "MIN") || ISSTRING(lst->token, "MAX")) {
					/* For tokens denoting functions, set function flag to 1 and print without spaces. */
					function = 1;
					printf("%s", lst->token);
				}
			else
				/* If we don't have a function, print with a space, or,
			     * if we have, print token in parentheses and a space. */
				if (!function) printf("%s ", lst->token);
				else {
					printf("(%s) ", lst->token);
					function = 0;
				}
		}
		
		lst = lst->next;
	}
}

/* Destroy a list (free it from memory). */
void destroyList(SQLToken *list) {
	if (!list) return;
	
	destroyList(list->next);
	
	free(list);
}