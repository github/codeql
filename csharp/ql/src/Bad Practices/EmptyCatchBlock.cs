class EmptyCatchBlock
{
    public static void Main(string[] args)
    {
        // ...
        try
        {
            SecurityManager.dropPrivileges();
        }
        catch (PrivilegeDropFailedException e)
        {

        }
        // ...
    }
}
