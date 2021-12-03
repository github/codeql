using System;
using System.Linq.Expressions;
using System.IO;
using System.Runtime.Serialization.Formatters.Binary;

class DeserializedDelegate
{
    delegate int D();

    public static void M(FileStream fs)
    {
        var formatter = new BinaryFormatter();
        // BAD
        var a = (Func<int>)formatter.Deserialize(fs);
        // BAD
        var b = (Expression<Func<int>>)formatter.Deserialize(fs);
        // BAD
        var c = (D)formatter.Deserialize(fs);
        // GOOD
        var d = (int)formatter.Deserialize(fs);
    }
}
