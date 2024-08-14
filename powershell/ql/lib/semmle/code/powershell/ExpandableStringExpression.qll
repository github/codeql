import powershell

class ExpanadableStringExpression extends @expandable_string_expression instanceof Expression
{
    SourceLocation getLocation()
    {
        expandable_string_expression_location(this, result)
    }

    string toString()
    {
        result = "ExpandableStringExpression at: " + this.getLocation().toString()
    }

    int getKind()
    {
        expandable_string_expression(this, _, result, _)
    }

    int getNumExpressions()
    {
        expandable_string_expression(this, _, _, result)
    }

    Expression getExpression(int i)
    {
        expandable_string_expression_nested_expression(this, i, result)
    }

    Expression getAExpression()
    {
        result = this.getExpression(_)
    }
}