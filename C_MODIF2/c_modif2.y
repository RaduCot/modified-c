%{
#include <stdio.h>
#include <stdlib.h>
#include <stdarg.h>
#include "c_modif2.h"

/* prototypes */
nodeType *opr(int oper, int nops, ...);
nodeType *id(int i);
nodeType *con(float value);
void freeNode(nodeType *p);
int ex(nodeType *p);
int yylex(void);
void yyerror(const char *s);

float sym[52]; /* symbol table */
%}

%union {
 int iValue; /* integer value */
 float fValue; /* float value */
 char sIndex; /* symbol table index */
 nodeType *nPtr; /* node pointer */
}

%token <iValue> INTEGER
%token <fValue> FLOAT /* New token */
%token <sIndex> VARIABLE
%token DO WHILE IF WRITELN INCREMENT DECREMENT ADD_ASSIGN SUB_ASSIGN MUL_ASSIGN DIV_ASSIGN
%token SWITCH BREAK CASE DEFAULT

%nonassoc IFX
%nonassoc ELSE
%left GE LE EQ NE '>' '<'
%left '+' '-'
%left '*' '/'
%left '%'
%nonassoc UMINUS
%nonassoc INCREMENT DECREMENT ADD_ASSIGN SUB_ASSIGN MUL_ASSIGN DIV_ASSIGN
%type <nPtr> stmt stmt_list expr case_list case

%%

program:
 function { exit(0); }
;

function:
 function stmt { ex($2); freeNode($2); }
 | /* NULL */
;

stmt:
 ';' { $$ = opr(';', 2, NULL, NULL); }
 | expr ';' { $$ = $1; }
 | WRITELN expr ';' { $$ = opr(WRITELN, 1, $2); }
 | VARIABLE '=' expr ';' { $$ = opr('=', 2, id($1), $3); }
 | VARIABLE '=' expr ',' { $$ = opr('=', 2, id($1), $3); }
 | WHILE '(' expr ')' stmt { $$ = opr(WHILE, 2, $3, $5); }
 | IF '(' expr ')' stmt %prec IFX { $$ = opr(IF, 2, $3, $5); }
 | IF '(' expr ')' stmt ELSE stmt { $$ = opr(IF, 3, $3, $5, $7); }
 | DO stmt WHILE '(' expr ')' ';' { $$ = opr(DO, 2, $2, $5); }
 | '{' stmt_list '}' { $$ = $2; }
 | SWITCH '(' expr ')' '{' case_list '}' { $$ = opr(SWITCH, 2, $3, $6); }
;

stmt_list:
 stmt { $$ = $1; }
 | stmt_list stmt { $$ = opr(';', 2, $1, $2); }
;

case_list:
  case { $$ = $1; }
  | case_list case { $$ = opr(';', 2, $1, $2); }
  ;

case:
  CASE expr ':' stmt_list BREAK ';' { $$ = opr(CASE, 2, $2, $4); }
  | DEFAULT ':' stmt_list BREAK ';' { $$ = opr(DEFAULT, 1, $3); }
  | DEFAULT ':' stmt_list { $$ = opr(DEFAULT, 1, $3); }
  | CASE expr ':' BREAK ';' { $$ = opr(CASE, 1, $2); }
  | DEFAULT ':' BREAK ';' { $$ = opr(DEFAULT, 0); }
  ;

expr:
 INTEGER { $$ = con($1); }
 | FLOAT { $$ = con($1); } /* New rule for float literals */
 | VARIABLE { $$ = id($1); }
 | '-' expr %prec UMINUS { $$ = opr(UMINUS, 1, $2); }
 | expr '+' expr { $$ = opr('+', 2, $1, $3); }
 | expr '-' expr { $$ = opr('-', 2, $1, $3); }
 | expr '*' expr { $$ = opr('*', 2, $1, $3); }
 | expr '/' expr { $$ = opr('/', 2, $1, $3); }
 | expr '%' expr { $$ = opr('%', 2, $1, $3); } /* Rule for modulo */
 | expr '<' expr { $$ = opr('<', 2, $1, $3); }
 | expr '>' expr { $$ = opr('>', 2, $1, $3); }
 | expr GE expr { $$ = opr(GE, 2, $1, $3); }
 | expr LE expr { $$ = opr(LE, 2, $1, $3); }
 | expr NE expr { $$ = opr(NE, 2, $1, $3); }
 | expr EQ expr { $$ = opr(EQ, 2, $1, $3); }
 | expr INCREMENT { $$ = opr(INCREMENT, 1, $1); }  /* Rule for prefix increment */
 | expr DECREMENT { $$ = opr(DECREMENT, 1, $1); }  /* Rule for prefix decrement */
 | INCREMENT expr { $$ = opr(INCREMENT, 1, $2); }  /* Rule for postfix increment */
 | DECREMENT expr { $$ = opr(DECREMENT, 1, $2); }  /* Rule for postfix decrement */
 | expr ADD_ASSIGN expr { $$ = opr(ADD_ASSIGN, 2, $1, $3); }
 | expr SUB_ASSIGN expr { $$ = opr(SUB_ASSIGN, 2, $1, $3); }
 | expr MUL_ASSIGN expr { $$ = opr(MUL_ASSIGN, 2, $1, $3); }
 | expr DIV_ASSIGN expr { $$ = opr(DIV_ASSIGN, 2, $1, $3); }
 | '(' expr ')' { $$ = $2; }
;

%%

nodeType *con(float value) {
    nodeType *p;
    if ((p = malloc(sizeof(nodeType))) == NULL)
        yyerror("out of memory");

    p->type = typeCon;
    p->con.value = value;
    return p;
}

nodeType *id(int i) {
 nodeType *p;
 /* allocate node */
 if ((p = malloc(sizeof(nodeType))) == NULL)
 yyerror("out of memory");
 /* copy information */
 p->type = typeId;
 p->id.i = i;
 return p;
}

nodeType *opr(int oper, int nops, ...) {
    va_list ap;
    nodeType *p;
    int i;
    /* allocate node, extending op array */
    if ((p = malloc(sizeof(nodeType) + (nops-1) * sizeof(nodeType *))) == NULL)
        yyerror("out of memory");
    /* copy information */
    p->type = typeOper;
    p->opr.oper = oper;
    p->opr.nops = nops;
    va_start(ap, nops);
    for (i = 0; i < nops; i++)
        p->opr.op[i] = va_arg(ap, nodeType*);
    va_end(ap);
    return p;
}


void freeNode(nodeType *p) {
 int i;
 if (!p) return;
 if (p->type == typeOper) {
 for (i = 0; i < p->opr.nops; i++)
 freeNode(p->opr.op[i]);
 }
 free(p);
}

void yyerror(const char *s){
fprintf(stderr, "error: %s\n", s);
}

extern FILE *yyin;
extern FILE *yyout;
extern FILE *outputFile;

int main(int argc, char **argv) {
    FILE *inputFile;

    // Check if input and output file arguments were provided
    if (argc != 3) {
        printf("Usage: %s input_file output_file\n", argv[0]);
        return 1;
    }

    // Open input file
    inputFile = fopen(argv[1], "r");
    if (!inputFile) {
        printf("Cannot open input file: %s\n", argv[1]);
        return 1;
    }

    // Open output file
    outputFile = fopen(argv[2], "w");
    if (!outputFile) {
        printf("Cannot open output file: %s\n", argv[2]);
        fclose(inputFile);
        return 1;
    }

    // Set input and output streams for flex and bison
    yyin = inputFile;
    yyout = outputFile;

    // Parse the input file
    yyparse();

    // Close input and output files
    fclose(inputFile);
    fclose(outputFile);

    return 0;
}
