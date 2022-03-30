using System;
using System.Runtime.Serialization;

[Serializable]
public class PersonGood : ISerializable
{
    public int Age;

    public PersonGood(int age)
    {
        if (age < 0)
            throw new ArgumentException(nameof(age));
        Age = age;
    }

    [OnDeserializing]
    void ISerializable.GetObjectData(SerializationInfo info, StreamingContext context)
    {
        int age = info.GetInt32("age");
        if (age < 0)
            throw new SerializationException(nameof(Age));
        Age = age;  // GOOD - write is safe
    }
}
