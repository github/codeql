public class FallbackOnlyController
{
    public void Index(string input) => _ = GetType().Name + input;
}
