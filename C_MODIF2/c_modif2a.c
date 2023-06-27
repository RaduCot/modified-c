#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <math.h>
#include "c_modif2.h"
#include "c_modif2.tab.h"

/*
c_modif2.l
cd proiect/C_MODIF2
compile_a() { bison -dv c_modif2.y; flex -o c_modif2.yy.c c_modif2.l; gcc -o c_modif2a.exe c_modif2.tab.c c_modif2.yy.c c_modif2a.c -lm -lfl; }
run_a() { ./c_modif2a.exe input_G3.txt output_inter.txt; }

Checklist:
Add support for uppercase identifiers - Done!
Add support for single-line comments and multi-line comments - Done!
Add support for floating point numbers - Done!
Add support for C operators (postfix and prefix) - Done!
Add support for switch-case statements, do-while loops - Done!
Add support for writeln - Done!
Add support for octal (prefix 0), hexadecimal (prefix 0x and 0X), unsigned (postfix u and U), long (postfix l and L), unsigned long (postfix ul and UL)  - Done!
*/

FILE *outputFile;

float switchValue = 0;
float caseValue = 0;

float ex(nodeType *p)
{
    if (!p)
        return 0;

    switch (p->type)
    {
    case typeCon:
        // fprintf(outputFile, "Constant: %d\n", p->con.value);
        return p->con.value;

    case typeId:
        // fprintf(outputFile, "Identifier: %c\n", 'a' + p->id.i);
        return sym[p->id.i];

    case typeOper:
        switch (p->opr.oper)
        {

        case SWITCH:
        {
            switchValue = ex(p->opr.op[0]);
            caseValue = ex(p->opr.op[1]);
            return 0;
        }
        case CASE:
        {
            caseValue = ex(p->opr.op[0]);
            if (caseValue == switchValue)
            {
                return ex(p->opr.op[1]);
            }
            else
            {
                return 0;
            }
        }
        case DEFAULT:
        {
            return ex(p->opr.op[0]);
        }
        case BREAK:
        {
            return 0;
        }
        case WHILE:
            // fprintf(outputFile, "While\n");
            while (ex(p->opr.op[0]))
                ex(p->opr.op[1]);
            return 0;

        case DO:
        {
            // fprintf(outputFile, "Do\n");
            do
                ex(p->opr.op[0]);
            while (ex(p->opr.op[1]));
            return 0;
        }
        case IF:
        {
            // fprintf(outputFile, "If\n");
            if (ex(p->opr.op[0]))
            {
                // fprintf(outputFile, "True\n");
                ex(p->opr.op[1]);
            }
            else if (p->opr.nops > 2)
            {
                // fprintf(outputFile, "False\n");
                ex(p->opr.op[2]);
            }
            return 0;
        }
        case WRITELN:
        {
            float result = ex(p->opr.op[0]);
            if (result - floor(result) == 0)
            {
                fprintf(outputFile, "%.0f\n", floor(result));
            }
            else
            {
                fprintf(outputFile, "%.3f\n", result);
            }
            return 0;
        }
        case INCREMENT:
        {
            int index = p->opr.op[0]->id.i;
            sym[index]++;
            return sym[index];
        }
        case DECREMENT:
        {
            int index = p->opr.op[0]->id.i;
            sym[index]--;
            return sym[index];
        }
        case ADD_ASSIGN:
        {
            int index = p->opr.op[0]->id.i;
            sym[index] += ex(p->opr.op[1]);
            return sym[index];
        }
        case SUB_ASSIGN:
        {
            int index = p->opr.op[0]->id.i;
            sym[index] -= ex(p->opr.op[1]);
            return sym[index];
        }
        case MUL_ASSIGN:
        {
            int index = p->opr.op[0]->id.i;
            sym[index] *= ex(p->opr.op[1]);
            return sym[index];
        }
        case DIV_ASSIGN:
        {
            int index = p->opr.op[0]->id.i;
            sym[index] /= ex(p->opr.op[1]);
            return sym[index];
        }
        case ';':
        {
            ex(p->opr.op[0]);
            return ex(p->opr.op[1]);
        }

        case ',':
        {
            ex(p->opr.op[0]);
            return ex(p->opr.op[1]);
        }

        case '=':
        {
            // fprintf(outputFile, "Assignment\n");
            return sym[p->opr.op[0]->id.i] = ex(p->opr.op[1]);
        }
        case UMINUS:
        {
            // fprintf(outputFile, "Unary Minus\n");
            return -ex(p->opr.op[0]);
        }
        case '+':
        {
            // fprintf(outputFile, "Addition\n");
            return ex(p->opr.op[0]) + ex(p->opr.op[1]);
        }
        case '-':
        {
            // fprintf(outputFile, "Subtraction\n");
            return ex(p->opr.op[0]) - ex(p->opr.op[1]);
        }
        case '*':
        {
            // fprintf(outputFile, "Multiplication\n");
            return ex(p->opr.op[0]) * ex(p->opr.op[1]);
        }
        case '/':
        {
            // fprintf(outputFile, "Division\n");
            return ex(p->opr.op[0]) / ex(p->opr.op[1]);
        }
        case '%':
        {
            // fprintf(outputFile, "Division\n");
            return (int)ex(p->opr.op[0]) % (int)ex(p->opr.op[1]);
        }
        case '<':
        {
            // fprintf(outputFile, "Less Than\n");
            return ex(p->opr.op[0]) < ex(p->opr.op[1]);
        }
        case '>':
        {
            // fprintf(outputFile, "Greater Than\n");
            return ex(p->opr.op[0]) > ex(p->opr.op[1]);
        }
        case GE:
        {
            // fprintf(outputFile, "Greater Than or Equal\n");
            return ex(p->opr.op[0]) >= ex(p->opr.op[1]);
        }
        case LE:
        {
            // fprintf(outputFile, "Less Than or Equal\n");
            return ex(p->opr.op[0]) <= ex(p->opr.op[1]);
        }
        case NE:
        {
            // fprintf(outputFile, "Not Equal\n");
            return ex(p->opr.op[0]) != ex(p->opr.op[1]);
        }
        case EQ:
        {
            // fprintf(outputFile, "Equal\n");
            return ex(p->opr.op[0]) == ex(p->opr.op[1]);
        }
        }
    }

    return 0;
}