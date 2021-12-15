using System;
using System.IO;
using System.Runtime.Serialization.Formatters.Binary;

class Bad
{
    public static int InvokeSerialized(FileStream fs)
    {
        var formatter = new BinaryFormatter();
        // BAD
        var f = (Func<int>)formatter.Deserialize(fs);
        return f();
    }
}
