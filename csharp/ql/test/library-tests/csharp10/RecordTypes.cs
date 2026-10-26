using System;

public record MyEntry(string Name, string Address)
{
    sealed public override string ToString() => $"{Name} lives at {Address}";
};

public record class MyClassRecord(DateTime stuff) { }

public readonly record struct MyReadonlyRecordStruct(string Stuff) { }

public record struct MyRecordStruct1(int Stuff) { }
