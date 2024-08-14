import powershell

class NamedBlock extends @named_block instanceof Ast
{
    string toString()
    {
        none()
    }

    SourceLocation getLocation()
    {
        named_block_location(this, result)
    }

    int getNumStatements()
    {
        named_block(this, result, _)
    }

    int getNumTraps()
    {
        named_block(this, _, result)
    }

    Statement getStatement(int i)
    {
        named_block_statement(this, i, result)
    }

    Statement getAStatement()
    {
        result = this.getStatement(_)
    }

    TrapStatement getTrap(int i)
    {
        named_block_trap(this, i, result)
    }

    TrapStatement getATrap()
    {
        result = this.getTrap(_)
    }
}