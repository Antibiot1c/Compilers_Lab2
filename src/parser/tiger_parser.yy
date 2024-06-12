%{
#include "ast/nodes.hh"
%}

%token <int> INT "integer"
%token IF THEN ELSE
%left '|'
%left '&'
%left '<' '>' LE GE EQ NE
%left '+' '-'
%left '*' '/'
%left UMINUS
%nonassoc FUNCTION VAR TYPE DO OF ASSIGN

%type <expr> expr intExpr ifThenElseExpr

%%

intExpr:
    INT {
        $$ = new ast::IntegerLiteral($1, @$);
    }
;

ifThenElseExpr:
    IF expr THEN expr ELSE expr {
        $$ = new ast::IfThenElse($2, $4, $6, @$);
    }
    | IF expr THEN expr {
        $$ = new ast::IfThenElse($2, $4, new ast::Sequence(new std::vector<ast::Expr*>(), @$), @$);
    }
;

expr:
    ...
    | intExpr {
        $$ = $1;
    }
    | ifThenElseExpr {
        $$ = $1;
    }
    | expr '+' expr {
        $$ = new ast::BinaryOperator(ast::BinaryOperator::PLUS, $1, $3, @$);
    }
    | expr '-' expr {
        $$ = new ast::BinaryOperator(ast::BinaryOperator::MINUS, $1, $3, @$);
    }
    | expr '*' expr {
        $$ = new ast::BinaryOperator(ast::BinaryOperator::MUL, $1, $3, @$);
    }
    | expr '/' expr {
        $$ = new ast::BinaryOperator(ast::BinaryOperator::DIV, $1, $3, @$);
    }
    | expr '|' expr {
        $$ = new ast::IfThenElse($1, new ast::IfThenElse($3, new ast::IntegerLiteral(1, @$), new ast::IntegerLiteral(0, @$), @$), new ast::IntegerLiteral(0, @$), @$);
    }
    ...
;
