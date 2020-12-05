/* P-T natural language to SQL translator
 * Christopher Prasatzakis (csd3442)
 * Manos Tzanakis (csd1746)
 * csd3442@csd.uoc.gr
 * csd1746@csd.uoc.gr
 * Data type for SQL token list: declarations. */

#ifndef SQLTOKEN_H
#define SQLTOKEN_H
typedef struct s {
	char *token;
	struct s *next;
} SQLToken;

SQLToken *newToken(char *);
void addToken(SQLToken *, SQLToken *);
void printQuery(SQLToken *);
void destroyList(SQLToken *);
#endif