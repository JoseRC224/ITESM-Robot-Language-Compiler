%{
#include <stdio.h>
#include <stdlib.h>
extern int yylex();
extern char *yytext;

void yyerror(const char *s);
%}

%union {
    int ival; // Para números
}

%token <ival> NUMBER
%token ROBOT PLEASE ADVANCE MOVE BLOCKS FORWARD BACKWARD LEFT RIGHT AND_THEN TURN DEGREES THEN AND
%token END_OF_COMMAND // Para manejar el punto

%type <ival> movement_command turn_command // Añade esta línea

%%
commands: commands full_command END_OF_COMMAND
        | /* empty */
        ;

full_command: ROBOT command_option command_sequence
            ;

command_sequence: single_command
                | single_command THEN command_sequence
                ;

single_command: movement_command direction { printf("MOVIMIENTO, %d\n", $1); }
              | turn_command { printf("GIRO, %d grados\n", $1); }
              ;


command_option: PLEASE
              | /* empty */
              ;

movement_command: MOVE NUMBER BLOCKS { $$ = $2; }
                | ADVANCE NUMBER BLOCKS { $$ = $2; }
                ;

direction: FORWARD
         | BACKWARD
         | LEFT
         | RIGHT
         | /* empty */ // Permite la omisión de la dirección
         ;

turn_command: TURN NUMBER DEGREES { $$ = $2; }
            | TURN NUMBER { $$ = $2; }
            ;


%%


void yyerror(const char *s) {
    fprintf(stderr, "Error: %s en '%s'\n", s, yytext);
}


int main(void) {
    do {
        yyparse();
    } while (!feof(stdin));
    return 0;
}


