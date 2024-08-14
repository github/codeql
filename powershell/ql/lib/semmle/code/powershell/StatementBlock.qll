import powershell

class StatementBlock extends @statement_block instanceof Ast
{
    SourceLocation getLocation()
    {
        statement_block_location(this, result)
    }

    int getNumStatements()
    {
        statement_block(this, result, _)
    }

    int getNumTraps()
    {
        statement_block(this, _, result)
    }

    Statement getStatement(int index)
    {
        statement_block_statement(this, index, result)
    }

    Statement getAStatement()
    {
        result = this.getStatement(_)
    }

    TrapStatement getTrapStatement(int index)
    {
        statement_block_trap(this, index, result)
    }

    TrapStatement getATrapStatement()
    {
        result = this.getTrapStatement(_)
    }

    string toString(){
        result = "StatementBlock at: " + this.getLocation().toString()
    }
}