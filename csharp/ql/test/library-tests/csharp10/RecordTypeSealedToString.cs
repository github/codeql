using System;

public record MyEntry(string Name, string Address)
{
    sealed public override string ToString() => $"{Name} lives at {Address}";
};