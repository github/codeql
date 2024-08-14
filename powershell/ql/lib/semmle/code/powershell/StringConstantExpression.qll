import powershell
class StringConstantExpression extends @string_constant_expression instanceof BaseConstantExpression
{
    StringLiteral getValue()
    {
        string_constant_expression(this, result)
    }
    /** Get the full string literal with all its parts concatenated */
    string toString()
    {
        result = getValue().toString()
    }
    SourceLocation getLocation(){
        string_constant_expression_location(this, result)
    }
}