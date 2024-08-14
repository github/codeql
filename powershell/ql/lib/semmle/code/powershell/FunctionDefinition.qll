import powershell

class FunctionDefinition extends @function_definition instanceof Statement
{
    string toString()
    {
        result = "FunctionDefinition at: " + this.getLocation().toString()
    }

    SourceLocation getLocation()
    {
        function_definition_location(this, result)
    }

    string getName()
    {
        function_definition(this, _, result, _, _)
    }

    ScriptBlock getBody()
    {
        function_definition(this, _, result, _, _)
    }

    boolean getIsFilter()
    {
        function_definition(this, _, _, result, _)
    }

    boolean getIsWorkflow()
    {
        function_definition(this, _, _, _, result)
    }
}