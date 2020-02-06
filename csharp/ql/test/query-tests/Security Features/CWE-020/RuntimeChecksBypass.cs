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
            f = v /* safe write */;
        }
    }

    [OnDeserializing]
    public void Deserialize()
    {
        f = "invalid" /* unsafe write */;
    }
}

[Serializable]
public class Test2
{
    public string f;

    public Test2(string v)
    {
        if (v == "valid")
        {
            f = v /* safe write */;
        }
    }

    [OnDeserializing]
    public void Deserialize()
    {
        var v = "invalid";
        f = v /* unsafe write -- false negative */;

        if (v == "valid")
        {
            f = v;  /* safe write */
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
            f = v /* safe write */;
        }
    }

    [OnDeserializing]
    public void Deserialize()
    {
        var v = "invalid";
        f = v /* unsafe write -- false negative */;
        Assign(v);
    }

    private void Assign(string v)
    {
        f = v /* unsafe write -- false negative */;

        if (v == "valid")
        {
            f = v /* safe write */;
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
            f = v /* safe write */;
        }
    }

    [OnDeserializing]
    public void Deserialize()
    {
        var v = "invalid";
        if (v == "valid")
            Assign(v);
    }

    private void Assign(string v)
    {
        f = v /* safe write */;
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
        Age = age /* safe write */;
    }

    [OnDeserializing]
    void ISerializable.GetObjectData(SerializationInfo info, StreamingContext context)
    {
        Age = info.GetInt32("age"); /* unsafe write */;
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
        Age = age /* safe write */;
    }

    [OnDeserializing]
    void ISerializable.GetObjectData(SerializationInfo info, StreamingContext context)
    {
        int age = info.GetInt32("age");
        if (age < 0)
            throw new SerializationException("age");
        Age = age; /* safe write */;
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
        Age = age /* safe write */;
    }

    [OnDeserializing]
    void ISerializable.GetObjectData(SerializationInfo info, StreamingContext context)
    {
        int age = info.GetInt32("age");
        if (false)
            throw new SerializationException("age");
        Age = age; /* unsafe write */;
    }
}
