import codeql.actions.ast.internal.Ast

int getAnExpressionLength() { result = any(ExpressionImpl e).toString().length() }

select max(getAnExpressionLength())
