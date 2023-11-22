%{
#include <stdio.h>
#include <stdlib.h>
extern int yylex();
extern char *yytext;
void yyerror(const char *s);

FILE *asm_file;  // Archivo para escribir las instrucciones
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

single_command: movement_command direction { fprintf(asm_file, "MOV,%d\n", $1); }
              | turn_command { fprintf(asm_file, "TURN,%d\n", $1); }
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
    FILE *file = fopen("sentences.txt", "r");
    if (file == NULL) {
        perror("Error al abrir el archivo");
        return 1;
    } else {
        printf("Archivo abierto correctamente.\n");
    }

    // Redirige la entrada de Lex a este archivo
    extern FILE *yyin;
    yyin = file;

    asm_file = fopen("instructions.asm", "w");
    if (asm_file == NULL) {
        perror("Error al crear el archivo .asm");
        fclose(file);
        return 1;
    }

    yyparse();

    fclose(file);
    fclose(asm_file);
    return 0;
}
