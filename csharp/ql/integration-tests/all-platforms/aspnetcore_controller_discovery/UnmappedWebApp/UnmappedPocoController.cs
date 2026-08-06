public class UnmappedPocoController
{
    public void Action(string input) => _ = GetType().Name + input;
}