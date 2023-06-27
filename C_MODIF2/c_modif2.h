typedef enum
{
    typeCon,
    typeId,
    typeOper
} nodeEnum;
/* constante */
typedef struct
{
    float value; /* valoarea constantei */
} conNodeType;
/* identificatori */
typedef struct
{
    int i; /* indice in tabela de simboluri */
} idNodeType;
/* operatori */
typedef struct
{
    int oper;                  /* operator */
    int nops;                  /* nr. operanzi */
    struct nodeTypeTag *op[1]; /* operanzi */
} oprNodeType;
typedef struct nodeTypeTag
{
    nodeEnum type; /* tipul nodului */
    union
    {
        conNodeType con; /* constante */
        idNodeType id;   /* identificatori */
        oprNodeType opr; /* operatori */
    };
} nodeType;
extern float sym[52]; /* tabela de simboluri */