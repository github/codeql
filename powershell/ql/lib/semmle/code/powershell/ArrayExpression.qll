import powershell

class ArrayExpression extends @array_expression instanceof Expression
{
    SourceLocation getLocation()
    {
        array_expression_location(this, result)
    }

    StatementBlock getStatementBlock()
    {
        array_expression(this, result)
    }

    string toString(){
        result = "ArrayExpression at: " + this.getLocation().toString()
    }
}