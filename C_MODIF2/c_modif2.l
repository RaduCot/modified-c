%{
#include <stdlib.h>
#include "c_modif2.h"
#include "c_modif2.tab.h"

void yyerror(char *);
%}

%{
    /* Helper function to convert string to float */
float strToFloat(char *str) {
    char *endptr;
    double value = strtod(str, &endptr);
    if (endptr == str) {
        fprintf(stderr, "Invalid float number: %s\n", str);
        exit(1);
    }
    return value;
}
%}


%%
[a-z] { 
 yylval.sIndex = *yytext - 'a';
 return VARIABLE;
 }
[A-Z] { 
 yylval.sIndex = *yytext - 'A';
 return VARIABLE;
 }  
0 {
 yylval.iValue = atoi(yytext);
 return INTEGER;
 } 
[1-9][0-9]* {
 yylval.iValue = atoi(yytext);
 return INTEGER;
 }
0[0-7]* {
    yylval.iValue = strtol(yytext, NULL, 8);
    return INTEGER;
}
0[xX][0-9a-fA-F]+ {
    yylval.iValue = strtol(yytext, NULL, 16);
    return INTEGER;
}
[1-9][0-9]*[uU]? {
    yylval.iValue = atoi(yytext);
    return INTEGER;
}
[1-9][0-9]*[lL] {
    yylval.iValue = atol(yytext);
    return INTEGER;
}
[1-9][0-9]*[uU][lL] {
    yylval.iValue = strtoul(yytext, NULL, 10);
    return INTEGER;
}
[1-9][0-9]*\.[0-9]+([eE][-+]?[0-9]+)? {
    yylval.fValue = atof(yytext);
    return FLOAT;
}
[1-9][0-9]*([eE][-+]?[0-9]+)? {
    yylval.fValue = atof(yytext);
    return FLOAT;
}
[0-9]+"."[0-9]* {
    yylval.fValue = strToFloat(yytext);
    return FLOAT;
}
[-()<>=+*/;{}:.,%] {
 return *yytext;
 }
"++" {
    return INCREMENT;
}
"--" {
    return DECREMENT;
}
"+=" {
    return ADD_ASSIGN;
}
"-=" {
    return SUB_ASSIGN;
}
"*=" {
    return MUL_ASSIGN;
}
"/=" {
    return DIV_ASSIGN;
}
">=" return GE;
"<=" return LE;
"==" return EQ;
"!=" return NE;
"do" return DO;
"while" return WHILE;
"if" return IF;
"else" return ELSE;
"switch" return SWITCH;
"case" return CASE;
"default" return DEFAULT;
"break" return BREAK;
"writeln" return WRITELN;
"//".* ; /* ignore single-line comments */
"/*"    {
          int c;
          while ((c = input()) != EOF) {
            if (c == '*' && (c = input()) == '/')
              break;
          }
        } /* ignore multi-line comments */
[ \t\n]+ ; /* ignore whitespace */
. yyerror("Unknown character");
%%
int yywrap(void) {
 return 1;
}