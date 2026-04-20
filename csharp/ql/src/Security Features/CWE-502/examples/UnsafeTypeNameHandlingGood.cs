using Newtonsoft.Json;
public class ExampleClass
{
    public JsonSerializerSettings Settings { get; }
    public ExampleClass()
    {
        Settings = new JsonSerializerSettings(); // GOOD: The default value of Settings.TypeNameHandling is TypeNameHandling.None.
    }
}
