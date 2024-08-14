import powershell
class TypeExpression extends @type_expression
{
    string getName()
    {
        type_expression(this, result, _)
    }
    string getFullyQualifiedName()
    {
        type_expression(this, _, result)
    }
    string toString()
    {
        type_expression(this, result, _)
    }
    SourceLocation getLocation()
    {
        type_expression_location(this, result)
    }
}