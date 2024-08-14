import powershell

class ArrayLiteral extends @array_literal instanceof Expression
{
    SourceLocation getLocation()
    {
        array_literal_location(this, result)
    }

    Expression getElement(int index)
    {
        array_literal_element(this, index, result)
    }

    Expression getAnElement()
    {
        array_literal_element(this, _, result)
    }

    string toString(){
        result = "ArrayLiteral at: " + this.getLocation().toString()
    }
}