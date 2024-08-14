import powershell

class TernaryExpression extends @ternary_expression instanceof Expression
{
    string toString() {none()}

    SourceLocation getLocation()
    {
        ternary_expression_location(this, result)
    }

    Expression getCondition()
    {
        ternary_expression(this, result, _, _)
    }

    Expression getIfFalse()
    {
        ternary_expression(this, _, result, _)
    }

    Expression getIfTrue()
    {
        ternary_expression(this, _, _, result)
    }
}