%{
#include "robot.tab.h"
#include <stdlib.h>
%}

%%

[0-9]+ { yylval.ival = atoi(yytext); return NUMBER; }
"Robot," { return ROBOT; }
"por favor" { return PLEASE; }
"avanza" { return ADVANCE; }
"muévete" { return MOVE; }
"bloques" { return BLOCKS; }
"hacia adelante" { return FORWARD; }
"hacia atrás" { return BACKWARD; }
"hacia la izquierda" { return LEFT; }
"hacia la derecha" { return RIGHT; }
"izquierda" { return LEFT; }
"derecha" { return RIGHT; }
"y luego" { return AND_THEN; }
"gira" { return TURN; }
"grados" { return DEGREES; }
"." { return END_OF_COMMAND; }

"," ; /* Ignora las comas */

[ \t\n]+ ; /* Ignora espacios en blanco y saltos de línea */
. { return yytext[0]; } /* Cualquier otro carácter */

%%