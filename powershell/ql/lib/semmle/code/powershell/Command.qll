import powershell

class Command extends @command instanceof CommandBase
{
    string toString() {none()}

    SourceLocation getLocation()
    {
        command_location(this, result)
    }

    string getName()
    {
        command(this, result, _, _, _)
    }

    int getKind()
    {
        command(this, _, result, _, _)
    }

    int getNumElements()
    {
        command(this, _, _, result, _)
    }

    int getNumRedirection()
    {
        command(this, _, _, _, result)
    }

    CommandElement getElement(int i)
    {
        command_command_element(this, i, result)
    }

    Redirection getRedirection(int i)
    {
        command_redirection(this, i, result)
    }

    CommandElement getAnElement()
    {
        result = this.getElement(_)
    }

    Redirection getARedirection()
    {
        result = this.getRedirection(_)
    }
}