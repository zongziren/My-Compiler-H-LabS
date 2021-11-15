#include "SyntaxTreeChecker.h"

using namespace SyntaxTree;

void SyntaxTreeChecker::visit(Assembly &node)
{
    enter_scope();
    for (auto def : node.global_defs)
    {
        def->accept(*this);
    }
    exit_scope();
}

void SyntaxTreeChecker::visit(FuncDef &node)
{
    auto lt = this->typedicts.back().find(node.name);
    if (lt != this->typedicts.back().end())
    {
        err.error(node.loc, "FuncDuplicated " + node.name + "()");
        exit(int(ErrorType::FuncDuplicated));
    }
    this->typedicts.back().insert(std::pair<std::string, SyntaxTree::Type>(node.name, node.ret_type));
    this->funcdicts.insert(std::pair<std::string, SyntaxTree::FuncFParamList>(node.name, *node.param_list));
    enter_scope();
    node.param_list->accept(*this);
    auto a = typedicts.back();
    this->funcdef_flag = 1;
    node.body->accept(*this);
    exit_scope();
}

void SyntaxTreeChecker::visit(BinaryExpr &node)
{
    node.lhs->accept(*this);
    bool lhs_int = this->Expr_int;
    node.rhs->accept(*this);
    bool rhs_int = this->Expr_int;
    if (node.op == SyntaxTree::BinOp::MODULO)
    {
        if (!lhs_int || !rhs_int)
        {
            err.error(node.loc, "Operands of modulo should be integers.");
            exit(int(ErrorType::Modulo));
        }
    }
    this->Expr_int = lhs_int & rhs_int;
}

void SyntaxTreeChecker::visit(UnaryExpr &node)
{
    node.rhs->accept(*this);
}

void SyntaxTreeChecker::visit(LVal &node)
{

    for (auto i = this->typedicts.end() - 1;; i--)
    {
        auto l_it = (*i).find(node.name);
        if (l_it != (*i).end())
        {
            this->Expr_int = (l_it->second == Type::INT);
            break;
        }
        if (i == this->typedicts.begin())
        {
            err.error(node.loc, "Unkonw variable " + node.name);
            exit(int(ErrorType::VarUnknown));
        }
    }
}

void SyntaxTreeChecker::visit(Literal &node)
{
    this->Expr_int = (node.literal_type == SyntaxTree::Type::INT);
}

void SyntaxTreeChecker::visit(ReturnStmt &node)
{
    node.ret->accept(*this);
}

void SyntaxTreeChecker::visit(VarDef &node)
{
    if (node.is_inited)
    {
        node.initializers->accept(*this);
    }
    auto lt = this->typedicts.back().find(node.name);
    if (lt != this->typedicts.back().end())
    {
        err.error(node.loc, "VarDuplicated" + node.name);
        exit(int(ErrorType::VarDuplicated));
    }
    this->typedicts.back().insert(std::pair<std::string, SyntaxTree::Type>(node.name, node.btype));
}

void SyntaxTreeChecker::visit(AssignStmt &node)
{
    node.target->accept(*this);
    node.value->accept(*this);
}
void SyntaxTreeChecker::visit(FuncCallStmt &node)
{
    for (auto i = this->typedicts.end() - 1;; i--)
    {
        auto l_it = (*i).find(node.name);
        if (l_it != (*i).end())
            break;
        if (i == this->typedicts.begin())
        {
            err.error(node.loc, "Unkonw func " + node.name + "()");
            exit(int(ErrorType::FuncUnknown));
        }
    }

    auto l_it = this->funcdicts.find(node.name);
    if (node.params.size() != l_it->second.params.size())
    {
        err.error(node.loc, "FuncParams wrong size " + node.name + "()");
        exit(int(ErrorType::FuncParams));
    }
    int i = 0;
    for (auto parm : l_it->second.params)
    {
        node.params[i]->accept(*this);
        if (parm->param_type == SyntaxTree::Type::INT && !this->Expr_int)
        {
            err.error(node.loc, "FuncParams wrong " + node.name + "()");
            exit(int(ErrorType::FuncParams));
        }
        if (parm->param_type == SyntaxTree::Type::FLOAT && this->Expr_int)
        {
            err.error(node.loc, "FuncParams wrong " + node.name + "()");
            exit(int(ErrorType::FuncParams));
        }
        i++;
    }

    for (auto i = this->typedicts.end() - 1;; i--)
    {
        auto l_it = (*i).find(node.name);
        if (l_it != (*i).end())
        {
            this->Expr_int = (l_it->second == Type::INT);
            break;
        }
    }
}

void SyntaxTreeChecker::visit(BlockStmt &node)
{
    if (this->funcdef_flag != 1)
    {
        enter_scope();
        for (auto stmt : node.body)
        {
            stmt->accept(*this);
        }
        exit_scope();
    }
    else
    {
        funcdef_flag = 0;
        for (auto stmt : node.body)
        {
            stmt->accept(*this);
        }
    }
}
void SyntaxTreeChecker::visit(EmptyStmt &node) {}
void SyntaxTreeChecker::visit(SyntaxTree::ExprStmt &node)
{
    node.exp->accept(*this);
}
void SyntaxTreeChecker::visit(SyntaxTree::FuncParam &node)
{
    auto lt = this->typedicts.back().find(node.name);
    if (lt != this->typedicts.back().end())
    {
        err.error(node.loc, "VarDuplicated" + node.name);
        exit(int(ErrorType::VarDuplicated));
    }
    this->typedicts.back().insert(std::pair<std::string, SyntaxTree::Type>(node.name, node.param_type));
}
void SyntaxTreeChecker::visit(SyntaxTree::FuncFParamList &node)
{
    for (auto parm : node.params)
    {
        parm->accept(*this);
    }
}
void SyntaxTreeChecker::visit(SyntaxTree::BinaryCondExpr &node)
{
    node.lhs->accept(*this);
    node.rhs->accept(*this);
}
void SyntaxTreeChecker::visit(SyntaxTree::UnaryCondExpr &node)
{
    node.rhs->accept(*this);
}
void SyntaxTreeChecker::visit(SyntaxTree::IfStmt &node)
{

    enter_scope();
    node.cond_exp->accept(*this);
    node.if_statement->accept(*this);
    exit_scope();
    if (node.else_statement)
    {
        enter_scope();
        node.else_statement->accept(*this);
        exit_scope();
    }
}
void SyntaxTreeChecker::visit(SyntaxTree::WhileStmt &node)
{
    node.cond_exp->accept(*this);
    enter_scope();
    node.statement->accept(*this);
    exit_scope();
}
void SyntaxTreeChecker::visit(SyntaxTree::BreakStmt &node)
{
}
void SyntaxTreeChecker::visit(SyntaxTree::ContinueStmt &node)
{
}

void SyntaxTreeChecker::visit(SyntaxTree::InitVal &node)
{
    if (node.isExp)
    {
        node.expr->accept(*this);
    }
    else
    {
        for (auto element : node.elementList)
        {
            element->accept(*this);
        }
    }
}