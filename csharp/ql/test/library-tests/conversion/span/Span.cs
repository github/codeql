using System;
using System.Collections.Generic;

public interface CovariantInterface<out T> { }

public interface InvariantInterface<T> { }

public interface Interface<out T1, T2> { }

public class Base { }

public class Derived : Base { }

public class C
{
    public void M()
    {
        string[] stringArray = [];
        string[][] stringArrayArray;
        string[,] stringArray2D;

        Span<string> stringSpan = stringArray; // string[] -> Span<string>;

        // Covariant conversions to ReadOnlySpan
        // Assignments are included to illustrate that this compiles.
        // Only the use of the types matter in terms of test output.
        ReadOnlySpan<CovariantInterface<Base>> covariantInterfaceBaseReadOnlySpan;
        ReadOnlySpan<CovariantInterface<Derived>> covariantInterfaceDerivedReadOnlySpan = default;
        Span<CovariantInterface<Derived>> covariantInterfaceDerivedSpan = default;
        CovariantInterface<Derived>[] covariantInterfaceDerivedArray = [];
        covariantInterfaceBaseReadOnlySpan = covariantInterfaceDerivedReadOnlySpan; // ReadOnlySpan<CovariantInterface<Derived>> -> ReadOnlySpan<CovariantInterface<Base>>
        covariantInterfaceBaseReadOnlySpan = covariantInterfaceDerivedSpan; // Span<CovariantInterface<Derived>> -> ReadOnlySpan<CovariantInterface<Base>>
        covariantInterfaceBaseReadOnlySpan = covariantInterfaceDerivedArray; // CovariantInterface<Derived>[] -> ReadOnlySpan<CovariantInterface<Base>>

        // Identify conversions to ReadOnlySpan
        ReadOnlySpan<string> stringReadOnlySpan;
        stringReadOnlySpan = stringSpan; // Span<string> -> ReadOnlySpan<string>;
        stringReadOnlySpan = stringArray; // string[] -> ReadOnlySpan<string>;

        // Convert string to ReadOnlySpan<char>
        string s = "";
        ReadOnlySpan<char> charReadOnlySpan = s; // string -> ReadOnlySpan<char>

        // Use the non-covariant interfaces to show that no conversion is possible.
        ReadOnlySpan<InvariantInterface<Base>> invariantInterfaceBaseReadOnlySpan;
        ReadOnlySpan<InvariantInterface<Derived>> invariantInterfaceDerivedReadOnlySpan;
        Span<InvariantInterface<Derived>> invariantInterfaceDerivedSpan;
        InvariantInterface<Derived>[] invariantInterfaceDerivedArray;
        ReadOnlySpan<Interface<Base, string>> interfaceBaseReadOnlySpan;
        ReadOnlySpan<Interface<Derived, string>> interfaceDerivedReadOnlySpan;
        Span<Interface<Derived, string>> interfaceDerivedSpan;
        Interface<Derived, string>[] interfaceDerivedArray;
    }
}
