using Newtonsoft.Json;
public class ExampleClass
{
    public JsonSerializerSettings Settings { get; }
    public ExampleClass()
    {
        Settings = new JsonSerializerSettings();
        Settings.TypeNameHandling = TypeNameHandling.All; // BAD
    }
}
