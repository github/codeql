public class ConventionOnlyController
{
    public void Action(string input) => _ = GetType().Name + input;
}