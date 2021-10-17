%skeleton "lalr1.cc" /* -*- c++ -*- */
%require "3.0"
%defines
//%define parser_class_name {sysyfParser}
%define api.parser.class {sysyfParser}

%define api.token.constructor
%define api.value.type variant
%define parse.assert

%code requires
{
#include <string>
#include "SyntaxTree.h"
class sysyfDriver;
}

// The parsing context.
%param { sysyfDriver& driver }

// Location tracking
%locations
%initial-action
{
// Initialize the initial location.
@$.begin.filename = @$.end.filename = &driver.file;
};

// Enable tracing and verbose errors (which may be wrong!)
%define parse.trace
%define parse.error verbose

// Parser needs to know about the driver:
%code
{
#include "sysyfDriver.h"
#define yylex driver.lexer.yylex
}

// Tokens:
%define api.token.prefix {TOK_}

%token END
/*********add your token here*********/
%token LT LTE GT GTE EQ NEQ 
%token NOT LOGICAND LOGICOR 
%token PLUS MINUS MULTIPLY DIVIDE MODULO
%token ASSIGN SEMICOLON
%token COMMA LPARENTHESE RPARENTHESE
%token LBRACE RBRACE
%token LBRACKET RBRACKET
%token INT FLOAT RETURN VOID
%token CONST
%token BREAK CONTINUE WHILE	IF ELSE
%token <std::string>IDENTIFIER
%token <int>INTCONST
%token <float>FLOATCONST
%token EOL COMMENT
%token BLANK 

// Use variant-based semantic values: %type and %token expect genuine types
%type <SyntaxTree::Assembly*>CompUnit
%type <SyntaxTree::PtrList<SyntaxTree::GlobalDef>>GlobalDecl
/*********add semantic value definition here*********/
%type <SyntaxTree::Type>BType
%type <SyntaxTree::PtrList<SyntaxTree::Expr>>ArrayList

%type <SyntaxTree::PtrList<SyntaxTree::VarDef>>ConstDecl
%type <SyntaxTree::PtrList<SyntaxTree::VarDef>>ConstDefList
%type <SyntaxTree::VarDef*>ConstDef

%type <SyntaxTree::PtrList<SyntaxTree::VarDef>>VarDecl
%type <SyntaxTree::PtrList<SyntaxTree::VarDef>>VarDefList
%type <SyntaxTree::VarDef*>VarDef

%type <SyntaxTree::InitVal*>InitVal
%type <SyntaxTree::InitVal*>InitValList

%type <SyntaxTree::Expr*>Exp
%type <SyntaxTree::PtrList<SyntaxTree::Expr>>ExpList
%type <SyntaxTree::PtrList<SyntaxTree::Expr>>CommaExpList

%type <SyntaxTree::FuncDef*>FuncDef
%type <SyntaxTree::PtrList<SyntaxTree::FuncParam>>FuncFParams
%type <SyntaxTree::FuncParam*>FuncFParam

%type <SyntaxTree::BlockStmt*>Block
%type <SyntaxTree::PtrList<SyntaxTree::Stmt>>BlockItemList
%type <SyntaxTree::PtrList<SyntaxTree::Stmt>>BlockItem

%type <SyntaxTree::Stmt*>Stmt
%type <SyntaxTree::Stmt*>Matchd_Stmt
%type <SyntaxTree::Stmt*>Unmatchd_Stmt


%type <SyntaxTree::Expr*>RelExp
%type <SyntaxTree::Expr*>EqExp
%type <SyntaxTree::Expr*>LAndExp
%type <SyntaxTree::Expr*>LOrExp
%type <SyntaxTree::Expr*>CondExp

%type <SyntaxTree::LVal*>LVal
%type <SyntaxTree::Literal*>Number


//根据文档可以不区分ConstInitVal 和 InitVal
//ConstInitVal 和 InitVal 区别在 ConstExp 和 Exp
//Exp→AddExp
//ConstExp→AddExp
//事实上，应该通过语义分析来检查是否可以赋值给常量


// No %destructors are needed, since memory will be reclaimed by the
// regular destructors.

// Grammar:
%start Begin
 
%%
Begin: CompUnit END 
	{
	$1->loc = @$;
	driver.root = $1;
	return 0;
	}
	;

CompUnit:CompUnit GlobalDecl
	{
		$1->global_defs.insert($1->global_defs.end(), $2.begin(), $2.end());
		$$=$1;
	} 
	| 
	GlobalDecl
	{
		$$=new SyntaxTree::Assembly();
		$$->global_defs.insert($$->global_defs.end(), $1.begin(), $1.end());
	}
	;
/*********add other semantic symbol definition here*********/
GlobalDecl:ConstDecl
	{
		$$=SyntaxTree::PtrList<SyntaxTree::GlobalDef>();
    	$$.insert($$.end(), $1.begin(), $1.end());
	}
	| 
	VarDecl
	{
		$$=SyntaxTree::PtrList<SyntaxTree::GlobalDef>();
		$$.insert($$.end(), $1.begin(), $1.end());
	}
	| 
	FuncDef
	{
		$$=SyntaxTree::PtrList<SyntaxTree::GlobalDef>();
		$$.push_back(SyntaxTree::Ptr<SyntaxTree::GlobalDef>($1));
	}
	;

ConstDecl:CONST BType ConstDefList SEMICOLON
	{
		$$=$3;
		for (auto &node : $$) 
		{
			node->btype = $2;
		}
	}
	;

ConstDefList:ConstDefList COMMA ConstDef
	{
		$1.push_back(SyntaxTree::Ptr<SyntaxTree::VarDef>($3));
		$$=$1;
	}
	| 
	ConstDef
	{
		$$=SyntaxTree::PtrList<SyntaxTree::VarDef>();
		$$.push_back(SyntaxTree::Ptr<SyntaxTree::VarDef>($1));
	}
	;

ConstDef:IDENTIFIER ArrayList ASSIGN InitVal
	{
		$$=new SyntaxTree::VarDef();
		$$->is_constant = true;
		$$->is_inited = true;
		$$->name=$1;
		$$->array_length = $2;
		$$->initializers = SyntaxTree::Ptr<SyntaxTree::InitVal>($4);
		$$->loc = @$;
	}
	|
	IDENTIFIER ASSIGN InitVal
	{
		$$=new SyntaxTree::VarDef();
		$$->is_constant = true;
		$$->is_inited = true;
		$$->name=$1;
		$$->initializers = SyntaxTree::Ptr<SyntaxTree::InitVal>($3);
		$$->loc = @$;
	}
	;

BType:INT
	{
		$$=SyntaxTree::Type::INT;
	}
	|
	FLOAT
	{
		$$=SyntaxTree::Type::FLOAT;
	}
	;

ArrayList:ArrayList LBRACKET Exp RBRACKET
	{
		$1.push_back(SyntaxTree::Ptr<SyntaxTree::Expr>($3));
		$$=$1;
	}
	|
	LBRACKET Exp RBRACKET
	{
		$$=SyntaxTree::PtrList<SyntaxTree::Expr>();
		$$.push_back(SyntaxTree::Ptr<SyntaxTree::Expr>($2));
	}
	;


VarDecl:BType VarDefList SEMICOLON
	{
		$$=$2;
		for (auto &node : $$) 
		{
			node->btype = $1;
		}
	}
	;

VarDefList:VarDefList COMMA VarDef
	{
		$1.push_back(SyntaxTree::Ptr<SyntaxTree::VarDef>($3));
		$$=$1;
	}
	| 
	VarDef
	{
		$$=SyntaxTree::PtrList<SyntaxTree::VarDef>();
		$$.push_back(SyntaxTree::Ptr<SyntaxTree::VarDef>($1));
	}
	;
	
VarDef:IDENTIFIER ArrayList ASSIGN InitVal
	{
		$$=new SyntaxTree::VarDef();
		$$->is_constant = false;
		$$->is_inited = true;
		$$->name=$1;
		$$->array_length = $2;
		$$->initializers = SyntaxTree::Ptr<SyntaxTree::InitVal>($4);
		$$->loc = @$;
	}
	|
	IDENTIFIER ASSIGN InitVal
	{
		$$=new SyntaxTree::VarDef();
		$$->is_constant = false;
		$$->is_inited = true;
		$$->name=$1;

		$$->initializers = SyntaxTree::Ptr<SyntaxTree::InitVal>($3);
		$$->loc = @$;
	}
	|
	IDENTIFIER ArrayList{
		$$=new SyntaxTree::VarDef();
		$$->is_constant = false;
		$$->is_inited = false;
		$$->name = $1;
		$$->array_length = $2;
		$$->loc = @$;
	}
	|
	IDENTIFIER
	{
		$$=new SyntaxTree::VarDef();
		$$->is_constant = false;
		$$->is_inited = false;
		$$->name=$1;

		$$->loc = @$;
	}
	;
InitVal:Exp
	{
		$$ = new SyntaxTree::InitVal();
		$$->isExp = true;
		$$->elementList = SyntaxTree::PtrList<SyntaxTree::InitVal>();
		$$->expr = SyntaxTree::Ptr<SyntaxTree::Expr>($1);
		$$->loc = @$;
	}
	|
	LBRACE InitValList RBRACE
	{$$ = $2;}
	|
	LBRACE RBRACE
	{
		$$ = new SyntaxTree::InitVal();
		$$->isExp = false;
		$$->elementList = SyntaxTree::PtrList<SyntaxTree::InitVal>();

		$$->loc = @$;
	}
	;
InitValList:InitValList COMMA InitVal
	{
		$1->elementList.push_back(SyntaxTree::Ptr<SyntaxTree::InitVal>($3));
    	$$ = $1;
	}
	|
	InitVal
	{
		$$=new SyntaxTree::InitVal();
		$$->elementList.push_back(SyntaxTree::Ptr<SyntaxTree::InitVal>($1));
	}
  	;

%left PLUS MINUS;
%left MULTIPLY DIVIDE MODULO;
%precedence UPLUS UMINUS UNOT;
Exp:PLUS Exp %prec UPLUS
	{
		auto temp = new SyntaxTree::UnaryExpr();
		temp->op = SyntaxTree::UnaryOp::PLUS;
		temp->rhs = SyntaxTree::Ptr<SyntaxTree::Expr>($2);
		$$ = temp;
		$$->loc = @$;
  	}
	|
	MINUS Exp %prec UMINUS
	{
		auto temp = new SyntaxTree::UnaryExpr();
		temp->op = SyntaxTree::UnaryOp::MINUS;
		temp->rhs = SyntaxTree::Ptr<SyntaxTree::Expr>($2);
		$$ = temp;
		$$->loc = @$;
	}
	|
	NOT Exp %prec UNOT
	{
		auto temp = new SyntaxTree::UnaryCondExpr();
		temp->op = SyntaxTree::UnaryCondOp::NOT;
		temp->rhs = SyntaxTree::Ptr<SyntaxTree::Expr>($2);
		$$ = temp;
		$$->loc = @$;
	}
	|
	Exp PLUS Exp
	{
		auto temp = new SyntaxTree::BinaryExpr();
		temp->op = SyntaxTree::BinOp::PLUS;
		temp->lhs = SyntaxTree::Ptr<SyntaxTree::Expr>($1);
		temp->rhs = SyntaxTree::Ptr<SyntaxTree::Expr>($3);
		$$ = temp;
		$$->loc = @$;
	}
	|
	Exp MINUS Exp
	{
		auto temp = new SyntaxTree::BinaryExpr();
		temp->op = SyntaxTree::BinOp::MINUS;
		temp->lhs = SyntaxTree::Ptr<SyntaxTree::Expr>($1);
		temp->rhs = SyntaxTree::Ptr<SyntaxTree::Expr>($3);
		$$ = temp;
		$$->loc = @$;
	}
	|
	Exp MULTIPLY Exp
	{
		auto temp = new SyntaxTree::BinaryExpr();
		temp->op = SyntaxTree::BinOp::MULTIPLY;
		temp->lhs = SyntaxTree::Ptr<SyntaxTree::Expr>($1);
		temp->rhs = SyntaxTree::Ptr<SyntaxTree::Expr>($3);
		$$ = temp;
		$$->loc = @$;
	}
	|
	Exp DIVIDE Exp{
		auto temp = new SyntaxTree::BinaryExpr();
		temp->op = SyntaxTree::BinOp::DIVIDE;
		temp->lhs = SyntaxTree::Ptr<SyntaxTree::Expr>($1);
		temp->rhs = SyntaxTree::Ptr<SyntaxTree::Expr>($3);
		$$ = temp;
		$$->loc = @$;
	}
	|
	Exp MODULO Exp
	{
		auto temp = new SyntaxTree::BinaryExpr();
		temp->op = SyntaxTree::BinOp::MODULO;
		temp->lhs = SyntaxTree::Ptr<SyntaxTree::Expr>($1);
		temp->rhs = SyntaxTree::Ptr<SyntaxTree::Expr>($3);
		$$ = temp;
		$$->loc = @$;
  	}
	| 
	IDENTIFIER LPARENTHESE ExpList RPARENTHESE
	{
		auto temp = new SyntaxTree::FuncCallStmt();
		temp->name = $1;
		temp->params = $3;
		$$ = temp;
		$$->loc = @$;
	}
	|
	LPARENTHESE Exp RPARENTHESE
	{$$ = $2;}
	|
	LVal
	{$$ = $1;}
	|
	Number{$$ = $1;}
	;

ExpList:CommaExpList Exp
	{
	$1.push_back(SyntaxTree::Ptr<SyntaxTree::Expr>($2));
	$$ = $1;
	}
	|
	%empty
	{
	$$ = SyntaxTree::PtrList<SyntaxTree::Expr>();
	}
	;

CommaExpList:CommaExpList Exp COMMA
	{
	$1.push_back(SyntaxTree::Ptr<SyntaxTree::Expr>($2));
	$$ = $1;
	}
	|
	%empty
	{
	$$ = SyntaxTree::PtrList<SyntaxTree::Expr>();
	}
	;

FuncDef:BType IDENTIFIER LPARENTHESE FuncFParams RPARENTHESE Block
	{
		$$ = new SyntaxTree::FuncDef();
		$$->ret_type = $1;
		$$->name = $2;
		auto tempt = new SyntaxTree::FuncFParamList();
		tempt->params = $4;
		$$->param_list = SyntaxTree::Ptr<SyntaxTree::FuncFParamList>(tempt);
		$$->body = SyntaxTree::Ptr<SyntaxTree::BlockStmt>($6);
		$$->loc = @$;
  	}
	|
	VOID IDENTIFIER LPARENTHESE FuncFParams RPARENTHESE Block
	{
		$$ = new SyntaxTree::FuncDef();
		$$->ret_type = SyntaxTree::Type::VOID;
		$$->name = $2;
		auto tempt = new SyntaxTree::FuncFParamList();
		tempt->params = $4;
		$$->param_list = SyntaxTree::Ptr<SyntaxTree::FuncFParamList>(tempt);
		$$->body = SyntaxTree::Ptr<SyntaxTree::BlockStmt>($6);
		$$->loc = @$;
	}
	;

FuncFParams: FuncFParams COMMA FuncFParam
	{
		$1.push_back(SyntaxTree::Ptr<SyntaxTree::FuncParam>($3));
		$$ = $1;
	}
	|
	FuncFParam
	{
		$$ = SyntaxTree::PtrList<SyntaxTree::FuncParam>();
		$$.push_back(SyntaxTree::Ptr<SyntaxTree::FuncParam>($1));
	}
	|
	%empty{$$ = SyntaxTree::PtrList<SyntaxTree::FuncParam>();}
	;

FuncFParam:BType IDENTIFIER
	{
		$$ = new SyntaxTree::FuncParam();
		$$->param_type = $1;
		$$->name = $2;

		$$->loc = @$;
	}
	|
	BType IDENTIFIER LBRACKET RBRACKET
	{
		$$ = new SyntaxTree::FuncParam();
		$$->param_type = $1;
		$$->name = $2;
		$$->array_index.insert($$->array_index.begin(),NULL);
		$$->loc = @$;
	} 
	|
	BType IDENTIFIER LBRACKET RBRACKET ArrayList
	{
		$$ = new SyntaxTree::FuncParam();
		$$->param_type = $1;
		$$->name = $2;
		$$->array_index = $5;
		$$->array_index.insert($$->array_index.begin(),NULL);
		$$->loc = @$;
	}
	|
	BType IDENTIFIER ArrayList
	{
		$$ = new SyntaxTree::FuncParam();
		$$->param_type = $1;
		$$->name = $2;
		$$->array_index = $3;
		$$->loc = @$;
	}
	;



Block:LBRACE BlockItemList RBRACE
	{
		$$ = new SyntaxTree::BlockStmt();
		$$->body = $2;
		$$->loc = @$;
	}
	;

BlockItemList: BlockItemList BlockItem 
	{
		$1.insert($1.end(), $2.begin(), $2.end());
		$$ = $1;
	}
	|
	%empty
	{
		$$ = SyntaxTree::PtrList<SyntaxTree::Stmt>();
	}
	;

BlockItem:VarDecl
	{
		$$ = SyntaxTree::PtrList<SyntaxTree::Stmt>();
		$$.insert($$.end(), $1.begin(), $1.end());
	}
	|
	ConstDecl
	{
		$$ = SyntaxTree::PtrList<SyntaxTree::Stmt>();
		$$.insert($$.end(), $1.begin(), $1.end());
	}
	|
	Stmt
	{
		$$ = SyntaxTree::PtrList<SyntaxTree::Stmt>();
		$$.push_back(SyntaxTree::Ptr<SyntaxTree::Stmt>($1));
	}
	;


Stmt:Matchd_Stmt{$$ = $1;}
	|
	Unmatchd_Stmt{$$ = $1;};

Matchd_Stmt:LVal ASSIGN Exp SEMICOLON
	{
		auto temp = new SyntaxTree::AssignStmt();
		temp->target = SyntaxTree::Ptr<SyntaxTree::LVal>($1);
		temp->value = SyntaxTree::Ptr<SyntaxTree::Expr>($3);
		$$ = temp;
		$$->loc = @$;
	}
	|
	Exp SEMICOLON
	{
		auto temp = new SyntaxTree::ExprStmt();
		temp->exp = SyntaxTree::Ptr<SyntaxTree::Expr>($1);
		$$ = temp;
		$$->loc = @$;
	}
	|
	RETURN SEMICOLON
	{
		auto temp = new SyntaxTree::ReturnStmt();
		temp->ret = NULL;
		$$ = temp;
		$$->loc = @$;
	}
	|
	RETURN Exp SEMICOLON
	{
		auto temp = new SyntaxTree::ReturnStmt();
		temp->ret = SyntaxTree::Ptr<SyntaxTree::Expr>($2);
		$$ = temp;
		$$->loc = @$;
	}
	|
	Block{$$ = $1;}
	|
	SEMICOLON
	{
		$$ = new SyntaxTree::EmptyStmt();
		$$->loc = @$;
	}
	|
	WHILE LPARENTHESE CondExp RPARENTHESE Matchd_Stmt
	{
		auto temp = new SyntaxTree::WhileStmt();
		temp->cond_exp = SyntaxTree::Ptr<SyntaxTree::Expr>($3);
		temp->statement = SyntaxTree::Ptr<SyntaxTree::Stmt>($5);
		$$ = temp;
		$$->loc = @$;
	}
	|
	IF LPARENTHESE CondExp RPARENTHESE Matchd_Stmt ELSE Matchd_Stmt
	{
		auto temp = new SyntaxTree::IfStmt();
		temp->cond_exp = SyntaxTree::Ptr<SyntaxTree::Expr>($3);
		temp->if_statement = SyntaxTree::Ptr<SyntaxTree::Stmt>($5);
		temp->else_statement = SyntaxTree::Ptr<SyntaxTree::Stmt>($7);
		$$ = temp;
		$$->loc = @$;
	}
	|
	BREAK SEMICOLON
	{
 		$$ = new SyntaxTree::BreakStmt();
		$$->loc = @$;
	}
	|
	CONTINUE SEMICOLON 
	{
		$$ = new SyntaxTree::ContinueStmt();
		$$->loc = @$;
	}
	;	

Unmatchd_Stmt:IF LPARENTHESE CondExp RPARENTHESE Stmt 
	{
		auto temp = new SyntaxTree::IfStmt();
		temp->cond_exp = SyntaxTree::Ptr<SyntaxTree::Expr>($3);
		temp->if_statement = SyntaxTree::Ptr<SyntaxTree::Stmt>($5);
		temp->else_statement = NULL;
		$$ = temp;
		$$->loc = @$;
	}
	|
	IF LPARENTHESE CondExp RPARENTHESE Matchd_Stmt ELSE Unmatchd_Stmt
	{
		auto temp = new SyntaxTree::IfStmt();
		temp->cond_exp = SyntaxTree::Ptr<SyntaxTree::Expr>($3);
		temp->if_statement = SyntaxTree::Ptr<SyntaxTree::Stmt>($5);
		temp->else_statement = SyntaxTree::Ptr<SyntaxTree::Stmt>($7);
		$$ = temp;
		$$->loc = @$;
	}
	|
	WHILE LPARENTHESE CondExp RPARENTHESE Unmatchd_Stmt
	{
		auto temp = new SyntaxTree::WhileStmt();
		temp->cond_exp = SyntaxTree::Ptr<SyntaxTree::Expr>($3);
		temp->statement = SyntaxTree::Ptr<SyntaxTree::Stmt>($5);
		$$ = temp;
		$$->loc = @$;
	}
	;

LVal:IDENTIFIER ArrayList
	{
		$$ = new SyntaxTree::LVal();
		$$->name = $1;
		$$->array_index = $2;
		$$->loc = @$;
	}
	|
	IDENTIFIER
	{
		$$ = new SyntaxTree::LVal();
		$$->name = $1;

		$$->loc = @$;
	}
	;

RelExp:RelExp LT Exp
	{
		auto temp = new SyntaxTree::BinaryCondExpr();
		temp->op = SyntaxTree::BinaryCondOp::LT;
		temp->lhs = SyntaxTree::Ptr<SyntaxTree::Expr>($1);
		temp->rhs = SyntaxTree::Ptr<SyntaxTree::Expr>($3);
		$$ = temp;
		$$->loc = @$;
	}
	|
	RelExp LTE Exp
	{
		auto temp = new SyntaxTree::BinaryCondExpr();
		temp->op = SyntaxTree::BinaryCondOp::LTE;
		temp->lhs = SyntaxTree::Ptr<SyntaxTree::Expr>($1);
		temp->rhs = SyntaxTree::Ptr<SyntaxTree::Expr>($3);
		$$ = temp;
		$$->loc = @$;
	}
	|
	RelExp GT Exp
	{
		auto temp = new SyntaxTree::BinaryCondExpr();
		temp->op = SyntaxTree::BinaryCondOp::GT;
		temp->lhs = SyntaxTree::Ptr<SyntaxTree::Expr>($1);
		temp->rhs = SyntaxTree::Ptr<SyntaxTree::Expr>($3);
		$$ = temp;
		$$->loc = @$;
	}
	|
	RelExp GTE Exp
	{
		auto temp = new SyntaxTree::BinaryCondExpr();
		temp->op = SyntaxTree::BinaryCondOp::GTE;
		temp->lhs = SyntaxTree::Ptr<SyntaxTree::Expr>($1);
		temp->rhs = SyntaxTree::Ptr<SyntaxTree::Expr>($3);
		$$ = temp;
		$$->loc = @$;
	}
	|Exp {$$ = $1;}
	;

EqExp:EqExp EQ RelExp
	{
		auto temp = new SyntaxTree::BinaryCondExpr();
		temp->op = SyntaxTree::BinaryCondOp::EQ;
		temp->lhs = SyntaxTree::Ptr<SyntaxTree::Expr>($1);
		temp->rhs = SyntaxTree::Ptr<SyntaxTree::Expr>($3);
		$$ = temp;
		$$->loc = @$;
	}
 	|
	EqExp NEQ RelExp
	{
		auto temp = new SyntaxTree::BinaryCondExpr();
		temp->op = SyntaxTree::BinaryCondOp::NEQ;
		temp->lhs = SyntaxTree::Ptr<SyntaxTree::Expr>($1);
		temp->rhs = SyntaxTree::Ptr<SyntaxTree::Expr>($3);
		$$ = temp;
		$$->loc = @$;
	}
	|RelExp {$$ = $1;}
	;

LAndExp:LAndExp LOGICAND EqExp 
	{
		auto temp = new SyntaxTree::BinaryCondExpr();
		temp->op = SyntaxTree::BinaryCondOp::LAND;
		temp->lhs = SyntaxTree::Ptr<SyntaxTree::Expr>($1);
		temp->rhs = SyntaxTree::Ptr<SyntaxTree::Expr>($3);
		$$ = temp;
		$$->loc = @$;
	}
	|EqExp{$$ = $1;}
	;

LOrExp:LOrExp LOGICOR LAndExp 
	{
		auto temp = new SyntaxTree::BinaryCondExpr();
		temp->op = SyntaxTree::BinaryCondOp::LOR;
		temp->lhs = SyntaxTree::Ptr<SyntaxTree::Expr>($1);
		temp->rhs = SyntaxTree::Ptr<SyntaxTree::Expr>($3);
		$$ = temp;
		$$->loc = @$;
 	}
	|LAndExp{$$ = $1;}
	;

CondExp:LOrExp{$$ = $1;}
	;

Number:INTCONST 
	{
	$$ = new SyntaxTree::Literal();
	$$->literal_type = SyntaxTree::Type::INT;
	$$->int_const = $1;
	$$->loc = @$;
	}
	|
	FLOATCONST
	{
		$$ = new SyntaxTree::Literal();
		$$->literal_type = SyntaxTree::Type::FLOAT;
		$$->float_const = $1;
		$$->loc = @$;
	}
	;


%%

// Register errors to the driver:
void yy::sysyfParser::error (const location_type& l,const std::string& m)
{
	driver.error(l, m);
}
