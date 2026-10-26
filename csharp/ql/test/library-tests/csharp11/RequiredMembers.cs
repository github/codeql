using System;
using System.Diagnostics.CodeAnalysis;

public class ClassRequiredMembers
{
    public required object? RequiredField;
    public required string? RequiredProperty { get; init; }
    public virtual object? VirtualProperty { get; init; }

    public ClassRequiredMembers() { }

    [SetsRequiredMembers]
    public ClassRequiredMembers(object requiredField, string requiredProperty)
    {
        RequiredField = requiredField;
        RequiredProperty = requiredProperty;
    }
}

public class ClassRequiredMembersSub : ClassRequiredMembers
{
    public override required object? VirtualProperty { get; init; }

    public ClassRequiredMembersSub() : base() { }

    [SetsRequiredMembers]
    public ClassRequiredMembersSub(object requiredField, string requiredProperty, object virtualProperty) : base(requiredField, requiredProperty)
    {
        VirtualProperty = virtualProperty;
    }
}

public record RecordRequiredMembers
{
    public required object? X { get; init; }
}

public struct StructRequiredMembers
{
    public required string? Y { get; init; }
}

