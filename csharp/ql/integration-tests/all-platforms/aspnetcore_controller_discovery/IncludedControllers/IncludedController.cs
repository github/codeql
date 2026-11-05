namespace IncludedControllers;

public class IncludedController
{
    public void Action(string input) => _ = GetType().Name + input;
}