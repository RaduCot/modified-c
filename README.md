# Description
Program written in Bison, Flex and C that simulates the capabilities of a C-like language.  
Project done for Formal and Translating Languages class at ACIEE UGAL  

# Functionality
The program takes as input parameters the names of the input and output files.  
It analyzes the contents of the input file and outputs the results of the instructions. It can also generate a binary tree representation of the logic.  

It supports float and int, dec and hex variables. It can interpret almost all C operators and instructions.  
## Example
Input file:  
```
a=20;
b=30/2, c=8*9;
writeln a;
writeln b;
writeln c;
D=90u;
writeln D;

a=045;
writeln a;	//37
a=0xA5;
writeln a;	//165, nu 167!
a=0Xa5;
writeln a;	//165, nu 167!

//coment pe o linie

/* coment pe mai multe
linii
de testat!!!
*/

a=67u;
b=7U;
writeln b-a;
writeln a+b;
a=67l;
b=-7L;
writeln a+b;
a=67ul;
b=7UL;
writeln a+b;

a=5;
a++;
writeln a;

a=5;
--a;
writeln a;

a=5;
b=a++;
writeln a;
writeln b;

a=5;
b=++a;
writeln a;
writeln b;

A=-89.7;
B=5.6E-1;
writeln A*B;

A=6;
A/=2;
writeln A;

A=6;
A*=2;
writeln A;

a=5;
b=2*5;

while(a>0){
a=a-1;
writeln a;}

a=10, b=20;
while (a>=0){
	a=a-2;
	b=b-4;
	writeln a;
	writeln b;
}

a=100;
writeln a;
{a=20; a=a-100; writeln a;
}

a=10; b=2;
do{
	writeln a;
	a--;
} //typo, lipseste inchiderea acoladei
while (a>=0);


a=3;
switch (a) {
	case 1: break;
	case 2: break;
	case 3:
		writeln a;
		break;
}

a=4;
//typo, defalut in loc de default
switch (a) {
	case 1: break;
	case 2: break;
	case 3: break;
	default:
		writeln a;
		break;
}
```  
Outputs:
```
20
15
72
90
37
165
165
-60
74
60
74
6
4
6
6
6
6
-50.232
3
12
4
3
2
1
0
8
16
6
12
4
8
2
4
0
0
-2
-4
100
-80
10
9
8
7
6
5
4
3
2
1
0
3
4
```  
The binary tree:
```


Graph 0:

     [=]
      |
   |-----|
   |     |
 id(A) c(20)


Graph 1:

       [=]
        |
   |-------|
   |       |
 id(B)    [/]
           |
         |----|
         |    |
       c(30) c(2)


Graph 2:

       [=]
        |
   |-------|
   |       |
 id(C)    [*]
           |
        |----|
        |    |
       c(8) c(9)


Graph 3:

 writeln
    |
   |-
   |
 id(A)


Graph 4:

 writeln
    |
   |-
   |
 id(B)


Graph 5:

 writeln
    |
   |-
   |
 id(C)


Graph 6:

     [=]
      |
   |-----|
   |     |
 id(D) c(90)


Graph 7:

 writeln
    |
   |-
   |
 id(D)


Graph 8:

     [=]
      |
   |-----|
   |     |
 id(A) c(37)


Graph 9:

 writeln
    |
   |-
   |
 id(A)


Graph 10:

     [=]
      |
   |-----|
   |     |
 id(A) c(165)


Graph 11:

 writeln
    |
   |-
   |
 id(A)


Graph 12:

     [=]
      |
   |-----|
   |     |
 id(A) c(165)


Graph 13:

 writeln
    |
   |-
   |
 id(A)


Graph 14:

     [=]
      |
   |-----|
   |     |
 id(A) c(67)


Graph 15:

    [=]
     |
   |----|
   |    |
 id(B) c(7)


Graph 16:

   writeln
      |
      |
      |
     [-]
      |
   |-----|
   |     |
 id(B) id(A)


Graph 17:

   writeln
      |
      |
      |
     [+]
      |
   |-----|
   |     |
 id(A) id(B)


Graph 18:

     [=]
      |
   |-----|
   |     |
 id(A) c(67)


Graph 19:

      [=]
       |
   |------|
   |      |
 id(B) [UMINUS]
          |
        |--
        |
       c(7)


Graph 20:

   writeln
      |
      |
      |
     [+]
      |
   |-----|
   |     |
 id(A) id(B)


Graph 21:

     [=]
      |
   |-----|
   |     |
 id(A) c(67)


Graph 22:

    [=]
     |
   |----|
   |    |
 id(B) c(7)


Graph 23:

   writeln
      |
      |
      |
     [+]
      |
   |-----|
   |     |
 id(A) id(B)


Graph 24:

    [=]
     |
   |----|
   |    |
 id(A) c(5)


Graph 25:

 [++]
   |
   |
   |
 id(A)


Graph 26:

 writeln
    |
   |-
   |
 id(A)


Graph 27:

    [=]
     |
   |----|
   |    |
 id(A) c(5)


Graph 28:

 [--]
   |
   |
   |
 id(A)


Graph 29:

 writeln
    |
   |-
   |
 id(A)


Graph 30:

    [=]
     |
   |----|
   |    |
 id(A) c(5)


Graph 31:

     [=]
      |
   |-----|
   |     |
 id(B) [++]
         |
         |
         |
       id(A)


Graph 32:

 writeln
    |
   |-
   |
 id(A)


Graph 33:

 writeln
    |
   |-
   |
 id(B)


Graph 34:

    [=]
     |
   |----|
   |    |
 id(A) c(5)


Graph 35:

     [=]
      |
   |-----|
   |     |
 id(B) [++]
         |
         |
         |
       id(A)


Graph 36:

 writeln
    |
   |-
   |
 id(A)


Graph 37:

 writeln
    |
   |-
   |
 id(B)


Graph 38:

       [=]
        |
   |-------|
   |       |
 id(A) [UMINUS]
           |
           |
           |
       c(89.700)


Graph 39:

      [=]
       |
   |------|
   |      |
 id(B) c(0.560)


Graph 40:

   writeln
      |
      |
      |
     [*]
      |
   |-----|
   |     |
 id(A) id(B)


Graph 41:

    [=]
     |
   |----|
   |    |
 id(A) c(6)


Graph 42:

    [/=]
     |
   |----|
   |    |
 id(A) c(2)


Graph 43:

 writeln
    |
   |-
   |
 id(A)


Graph 44:

    [=]
     |
   |----|
   |    |
 id(A) c(6)


Graph 45:

    [*=]
     |
   |----|
   |    |
 id(A) c(2)


Graph 46:

 writeln
    |
   |-
   |
 id(A)


Graph 47:

    [=]
     |
   |----|
   |    |
 id(A) c(5)


Graph 48:

       [=]
        |
   |-------|
   |       |
 id(B)    [*]
           |
        |----|
        |    |
       c(2) c(5)


Graph 49:

                while
                  |
     |-----------------|
     |                 |
    [>]               [;]
     |                 |
   |----|          |------------|
   |    |          |            |
 id(A) c(0)       [=]        writeln
                   |            |
              |-------|        |-
              |       |        |
            id(A)    [-]     id(A)
                      |
                    |----|
                    |    |
                  id(A) c(1)


Graph 50:

     [=]
      |
   |-----|
   |     |
 id(A) c(10)


Graph 51:

     [=]
      |
   |-----|
   |     |
 id(B) c(20)


Graph 52:

                            while
                              |
     |------------------------------|
     |                              |
    [>=]                           [;]
     |                              |
   |----|                       |------------------------|
   |    |                       |                        |
 id(A) c(0)                    [;]                    writeln
                                |                        |
                            |--------------------|      |-
                            |                    |      |
                           [;]                writeln id(B)
                            |                    |
                   |----------------|           |-
                   |                |           |
                  [=]              [=]        id(A)
                   |                |
              |-------|        |-------|
              |       |        |       |
            id(A)    [-]     id(B)    [-]
                      |                |
                    |----|           |----|
                    |    |           |    |
                  id(A) c(2)       id(B) c(4)


Graph 53:

     [=]
      |
   |-----|
   |     |
 id(A) c(100)


Graph 54:

 writeln
    |
   |-
   |
 id(A)


Graph 55:

                  [;]
                   |
               |-------------------|
               |                   |
              [;]               writeln
               |                   |
      |--------------|            |-
      |              |            |
     [=]            [=]         id(A)
      |              |
   |-----|     |--------|
   |     |     |        |
 id(A) c(20) id(A)     [-]
                        |
                     |-----|
                     |     |
                   id(A) c(100)


Graph 56:

     [=]
      |
   |-----|
   |     |
 id(A) c(10)


Graph 57:

    [=]
     |
   |----|
   |    |
 id(B) c(2)


Graph 58:

         do-while
            |
       |-----------|
       |           |
      [;]         [>=]
       |           |
    |------|     |----|
    |      |     |    |
 writeln [--]  id(A) c(0)
    |      |
   |-      |
   |       |
 id(A)   id(A)


Graph 59:

    [=]
     |
   |----|
   |    |
 id(A) c(3)


Graph 60:

            switch
              |
   |-------------|
   |             |
 id(A)          [;]
                 |
           |----------|
           |          |
          [;]        case
           |          |
        |----|    |------|
        |    |    |      |
       case case c(3) writeln
        |    |           |
        |    |          |-
        |    |          |
       c(1) c(2)      id(A)


Graph 61:

    [=]
     |
   |----|
   |    |
 id(A) c(4)


Graph 62:

            switch
              |
   |-------------|
   |             |
 id(A)          [;]
                 |
             |-----------|
             |           |
            [;]       default
             |           |
           |------|      |
           |      |      |
          [;]    case writeln
           |      |      |
        |----|    |     |-
        |    |    |     |
       case case c(3) id(A)
        |    |
        |    |
        |    |
       c(1) c(2)
```
