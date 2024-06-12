%{
#include "tiger_parser.tab.hh"
#include "../utils/errors.hh"
%}

%option noyywrap

DIGIT      [0-9]
NON_ZERO_DIGIT [1-9]

%%

[0-9]+ {
    long val = strtol(yytext, NULL, 10);
    if (val > TIGER_INT_MAX || val < 0) {
        utils::error(yylloc, "integer out of range");
    } else if (yytext[0] == '0' && strlen(yytext) > 1) {
        utils::error(yylloc, "leading zeros are not allowed");
    } else {
        yylval.intVal = val;
        return INT;
    }
}

"if"    { return IF; }
"then"  { return THEN; }
"else"  { return ELSE; }

%%

int yywrap(void) {
    return 1;
}
