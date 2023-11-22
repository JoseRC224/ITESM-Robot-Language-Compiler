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
%token ROBOT PLEASE ADVANCE MOVE BLOCKS FORWARD BACKWARD LEFT RIGHT AND_THEN TURN DEGREES AND
%token END_OF_COMMAND // Para manejar el punto

%type <ival> movement_command turn_command

%%
commands: /* empty */
        | commands full_command
        ;

full_command: ROBOT command_option command_sequence END_OF_COMMAND
            | ROBOT command_option command_sequence
            ;

command_sequence: single_command
                | single_command AND_THEN command_sequence
                ;

single_command: movement_command direction { printf("MOVIMIENTO, %d\n", $1); }
              | turn_command { printf("GIRO, %d grados\n", $1); }
              ;

command_option: /* empty */
              | PLEASE
              ;

movement_command: MOVE NUMBER BLOCKS { $$ = $2; }
                | ADVANCE NUMBER BLOCKS { $$ = $2; }
                ;

direction: /* empty */
         | FORWARD
         | BACKWARD
         | LEFT
         | RIGHT
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
