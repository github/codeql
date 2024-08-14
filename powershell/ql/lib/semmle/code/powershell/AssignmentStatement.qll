import powershell

class AssignmentStatement extends @assignment_statement instanceof Statement
{
    SourceLocation getLocation()
    {
        assignment_statement_location(this, result)
    }

    int getKind()
    {
        assignment_statement(this, result, _, _)
    }

    Expression getLeftHandSide()
    {
        assignment_statement(this, _, result, _)
    }

    Statement getRightHandSide()
    {
        assignment_statement(this, _, _, result)
    }

    string toString(){
        result = "AssignmentStatement at: " + this.getLocation().toString()
    }
}