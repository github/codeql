using System;
using System.Runtime.Serialization;

[Serializable]
public class Test1
{
    public string f;

    public Test1(string v)
    {
        if (v == "valid")
        {
            f = v;  // GOOD
        }
    }

    [OnDeserializing]
    public void Deserialize()
    {
        f = GetString();  // BAD, non-constant and non-object creation expr
    }

    string GetString() { throw null; }
}

[Serializable]
public class Test2
{
    public string f;

    public Test2(string v)
    {
        if (v == "valid")
        {
            f = v;  // GOOD
        }
    }

    [OnDeserializing]
    public void Deserialize()
    {
        var v = $"invalid";
        f = v;  // BAD: False negative

        if (v == "valid")
        {
            f = v;  // GOOD
        }
    }
}

[Serializable]
public class Test3
{
    public string f;

    public Test3(string v)
    {
        if (v == "valid")
        {
            f = v;  // GOOD
        }
    }

    [OnDeserializing]
    public void Deserialize()
    {
        var v = $"invalid";
        f = v;  // GOOD: False negative
        Assign(v);
    }

    private void Assign(string v)
    {
        f = v;  // GOOD: False negative

        if (v == "valid")
        {
            f = v;  // GOOD
        }
    }
}

[Serializable]
public class Test4
{
    public string f;

    public Test4(string v)
    {
        if (v == "valid")
        {
            f = v;  // GOOD
        }
    }

    [OnDeserializing]
    public void Deserialize()
    {
        var v = $"invalid";
        if (v == "valid")
            Assign(v);
    }

    private void Assign(string v)
    {
        f = v;  // GOOD
    }
}

[Serializable]
public class Test5 : ISerializable
{
    public int Age;

    public Test5(int age)
    {
        if (age < 0)
            throw new ArgumentException(nameof(age));
        Age = age;  // GOOD
    }

    [OnDeserializing]
    void ISerializable.GetObjectData(SerializationInfo info, StreamingContext context)
    {
        Age = info.GetInt32("age");  // BAD
    }
}

[Serializable]
public class Test6 : ISerializable
{
    public int Age;

    public Test6(int age)
    {
        if (age < 0)
            throw new ArgumentException(nameof(age));
        Age = age;  // GOOD
    }

    [OnDeserializing]
    void ISerializable.GetObjectData(SerializationInfo info, StreamingContext context)
    {
        int age = info.GetInt32("age");
        if (age < 0)
            throw new SerializationException("age");
        Age = age;  // GOOD
    }
}

[Serializable]
public class Test7 : ISerializable
{
    public int Age;

    public Test7(int age)
    {
        if (age < 0)
            throw new ArgumentException(nameof(age));
        Age = age;  // GOOD
    }

    [OnDeserializing]
    void ISerializable.GetObjectData(SerializationInfo info, StreamingContext context)
    {
        int age = info.GetInt32("age");
        if (false)
            throw new SerializationException("age");
        Age = age;  // BAD
    }
}

[Serializable]
public class Test8 : ISerializable
{
    string Options;

    public int Age;

    public Test8(string options)
    {
        if (options == null)
            throw new ArgumentNullException(nameof(options));
        Options = options;  // GOOD
    }

    [OnDeserializing]
    void ISerializable.GetObjectData(SerializationInfo info, StreamingContext context)
    {
        Options = new string("");  // GOOD: A created object
    }
}
