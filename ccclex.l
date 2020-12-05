/* P-T natural language to SQL translator
 * Christopher Prasatzakis (csd3442)
 * Manos Tzanakis (csd1746)
 * csd3442@csd.uoc.gr
 * csd1746@csd.uoc.gr
 * Lexical analyzer. */

%option case-insensitive

%{
#include "node.h"
#include "treeFormatter.h"

#include <stdio.h>
#include <string.h>
#include <stdlib.h>
#include <assert.h>
#define namespace std;
#pragma G++ diagnostic ignored "-Wwrite-strings"

int tokens=0;
int line=0;

/* Temporary buffer for holding string and date values. */
char tempBuffer[128];

%}

/* Punctuation marks. */
left_parenthes		\(
right_parenthes		\)
comma		\,
colon		\:
dot		\.
qmark		\?

/* Operators. Note that some have aliases (ON). */
plus			"+"
minus			"-"
multi			"*"
div				"/"
mod				"%"
equal			"is"
equalP			"are"
notEqual		"is not"
notEqualP		"are not"
greater			"greater than"
less			"less than"
greater2		"is greater than"
less2			"is less than"
greater2P		"are greater than"
less2P			"are less than"
greater_equal	"greater or equal to"
less_equal		"lesser or equal to"
greater_equal2	"is greater or equal to"
less_equal2		"is lesser or equal to"
greater_equal2P	"are greater or equal to"
less_equal2P	"are lesser or equal to"

/* SQL functions (FN). */
avg				"average"
sum				"sum"
count			"count"

/* Quantifiers (QN). */
all				"all"
any				"any"
each			"each"

/* Logic operations (LN). */
and				"and"
or				"or"
not				"not"

/* Words denoting SELECTs (SN). */
show			"show"
get				"get"
retrieve		"retrieve"
return			"return"

/* Numerical constants (VN) */
num			[0-9]+
rnum		[0-9]+"."[0-9]+

/* Dates (VN) */
date		[0-9][0-9][0-9][0-9]\-[0-1][1-9]\-[0-3][1-9]

/* Identifiers (VN) */
id 		[0-9]*[a-zA-Z_0-9][a-z_0-9]*

/* Others */
white_spaces		[\t' '\r\0]*
new_line		"\n"

/* Min and Max. (FN) */
min			"minimum"
max			"maximum"

/* Anything else. */
other			.

/* For this case study, we have defined the schema
 * of the CCC database from CS-360 (Winter Semester 2016-17).
 * Note that some columns are common on more than one entities (e.g DEBT). 
 * Everything below is treated as a name node (NN). */
trans			"TRANSACTION"["S"]*
privateci		"CLIENT"["S"]*
company			"COMPANY"["IES"]*
merchant		"MERCHANT"["S"]*
employee		"EMPLOYEE"["S"]*

/* TRANSACTION */
tid				"TRANSACTION ID"["S"]*
clientname		"CLIENT NAME"["S"]*
rcvtype			"RECEPTION TYPE"["S"]*
mid				"MERCHANT ID"["S"]*
tdate			"TRANSACTION DATE"["S"]*
ttype			"TRANSACTION TYPE"["S"]*
tsum			"TRANSACTION SUM"["S"]*

/* PRIVATECI */
name			"CLIENT ID"["S"]*
accnum			"ACCOUNT NUMBER"["S"]*
exdt			"EXPIRATION DATE"["S"]*
credit			"CREDIT"["S"]*
debt			"DEBT"["S"]*
balance 		"BALANCE"["S"]*

/* COMPANY */
cid				"COMPANY ID"["S"]*

/* MERCHANT */
comm			"COMMISSION"["S"]*
ttlprof			"TOTAL PROFIT"["S"]*

/* EMPLOYEE */
eid				"EMPLOYEE ID"["S"]*

%option noyywrap
%option yylineno

/* Rules for all of the tokens defined above. */

%%

{avg}			{ yylval.stringValue = strdup("AVG"); return FN; }
{sum}			{ yylval.stringValue = strdup("SUM"); return FN; }
{count}			{ yylval.stringValue = strdup("COUNT"); return FN; }

{all}			{ yylval.stringValue = strdup("*"); return QN; }
{any}			{ yylval.stringValue = strdup("*"); return QN; }
{each}			{ yylval.stringValue = strdup("*"); return QN; }

{and}			{ yylval.stringValue = strdup("AND"); return LN; }
{or}			{ yylval.stringValue = strdup("OR"); return LN; }
{not}			{ yylval.stringValue = strdup("NOT"); return LN; }

{show}			{ yylval.stringValue = strdup(yytext); return SN; }
{get}			{ yylval.stringValue = strdup(yytext); return SN; }
{retrieve}			{ yylval.stringValue = strdup(yytext); return SN; }
{return}			{ yylval.stringValue = strdup(yytext); return SN; }

{plus}					{ yylval.stringValue = strdup(yytext); return ON; }
{minus}					{ yylval.stringValue = strdup(yytext); return ON; }
{multi}					{ yylval.stringValue = strdup(yytext); return ON; }
{div}					{ yylval.stringValue = strdup(yytext); return ON; }
{mod}					{ yylval.stringValue = strdup(yytext); return ON; }
{equal}					{ yylval.stringValue = strdup("="); return ON; }
{equalP}					{ yylval.stringValue = strdup("="); return ON; }
{notEqual}				{ yylval.stringValue = strdup("<>"); return ON; }
{notEqualP}				{ yylval.stringValue = strdup("<>"); return ON; }
{greater}				{ yylval.stringValue = strdup(">"); return ON; }
{less}					{ yylval.stringValue = strdup("<"); return ON; }
{greater2}				{ yylval.stringValue = strdup(">"); return ON; }
{less2}					{ yylval.stringValue = strdup("<"); return ON; }
{greater2P}				{ yylval.stringValue = strdup(">"); return ON; }
{less2P}					{ yylval.stringValue = strdup("<"); return ON; }
{greater_equal}			{ yylval.stringValue = strdup(">="); return ON; }
{less_equal}			{ yylval.stringValue = strdup("<="); return ON; }
{greater_equal2}			{ yylval.stringValue = strdup(">="); return ON; }
{less_equal2}			{ yylval.stringValue = strdup("<="); return ON; }
{greater_equal2P}			{ yylval.stringValue = strdup(">="); return ON; }
{less_equal2P}			{ yylval.stringValue = strdup("<="); return ON; }

{trans}					{ yylval.stringValue = strdup("TRANSACTION"); return NN; }
{privateci}				{ yylval.stringValue = strdup("PRIVATECI"); return NN; }
{company}				{ yylval.stringValue = strdup("COMPANY"); return NN; }
{merchant}				{ yylval.stringValue = strdup("MERCHANT"); return NN; }
{employee}				{ yylval.stringValue = strdup("EMPLOYEE"); return NN; }

{tid}					{ yylval.stringValue = strdup("TID"); return NN; }
{clientname}			{ yylval.stringValue = strdup("CLIENTNAME"); return NN; }
{rcvtype}				{ yylval.stringValue = strdup("RCVTYPE"); return NN; }
{mid}					{ yylval.stringValue = strdup("MID"); return NN; }
{tdate}					{ yylval.stringValue = strdup("TDT"); return NN; }
{ttype}					{ yylval.stringValue = strdup("TTYPE"); return NN; }
{tsum}					{ yylval.stringValue = strdup("TSUM"); return NN; }

{name}					{ yylval.stringValue = strdup("NAME"); return NN; }
{accnum}				{ yylval.stringValue = strdup("ACCNUM"); return NN; }
{exdt}					{ yylval.stringValue = strdup("EXDT"); return NN; }
{credit}				{ yylval.stringValue = strdup("CREDIT"); return NN; }
{debt}					{ yylval.stringValue = strdup("DEBT"); return NN; }
{balance}				{ yylval.stringValue = strdup("BALANCE"); return NN; }

{cid}					{ yylval.stringValue = strdup("CID"); return NN; }

{comm}					{ yylval.stringValue = strdup("COMM"); return NN; }
{ttlprof}				{ yylval.stringValue = strdup("TTLPROF"); return NN; }

{eid}					{ yylval.stringValue = strdup("EID"); return NN; }

{min}					{ yylval.stringValue = strdup("MIN"); return FN; }
{max}					{ yylval.stringValue = strdup("MAX"); return FN; }

{num} 			{ yylval.stringValue = strdup(yytext); return VN; } /* ISWS KAI AYTA. Na allax8oun gia hmeromhnies. */
{rnum}			{ yylval.stringValue = strdup(yytext); return VN; }

{date}			{  	/* Dates are special string cases, so they need some more processing. */

				memset(tempBuffer, 0, 128); 

				int i = 0;
				
				tempBuffer[0] = '\'';
				
				while (i < strlen(yytext)) {
					tempBuffer[i + 1] = yytext[i];
					i++;
				}
				
				i++;
				
				tempBuffer[i] = '\'';
				
				yylval.stringValue = strdup(tempBuffer); 
				
				memset(tempBuffer, 0, 128); 
				
				return VN;  }
				
{white_spaces}		{ /* White spaces and parentheses are ignored. */ }
{left_parenthes}	{}
{right_parenthes} 	{}

{new_line}		{line++;}

{id}		{ 	/* IDs are strings and need special processing. */
				
				memset(tempBuffer, 0, 128); 

				int i = 0;
				
				tempBuffer[0] = '\'';
				
				while (i < strlen(yytext)) {
					tempBuffer[i + 1] = yytext[i];
					i++;
				}
				
				i++;
				
				tempBuffer[i] = '\'';
				
				yylval.stringValue = strdup(tempBuffer); 
				
				memset(tempBuffer, 0, 128); 
				
				return VN; 
			}

{other}			{ /* Anything that does not match is ignored. */ }


	
%%
