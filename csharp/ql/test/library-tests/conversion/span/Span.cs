using System;
using System.Collections.Generic;

public interface CovariantInterface<out T> { }

public interface ContravariantInterface<in T> { }

public interface InvariantInterface<T> { }

public interface MixedInterface<out T1, in T2> { }

public class Base { }

public class Derived : Base { }

public class C
{
    public void M()
    {
        string[] stringArray = [];
        string[][] stringArrayArray = [];
        string[,] stringArray2D = new string[0, 0];

        Span<string> stringSpan = stringArray; // string[] -> Span<string>;

        // Assignments are included to illustrate that it compiles.
        // Only the use of the types matter in terms of test output.
        // Covariant conversions to ReadOnlySpan
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

        // Contravariant conversions to ReadOnlySpan
        ReadOnlySpan<ContravariantInterface<Derived>> contravariantInterfaceDerivedReadOnlySpan;
        ReadOnlySpan<ContravariantInterface<Base>> contravariantInterfaceBaseReadOnlySpan = default;
        Span<ContravariantInterface<Base>> contravariantInterfaceBaseSpan = default;
        ContravariantInterface<Base>[] contravariantInterfaceBaseArray = [];
        contravariantInterfaceDerivedReadOnlySpan = contravariantInterfaceBaseReadOnlySpan; // ReadOnlySpan<ContravariantInterface<Base>> -> ReadOnlySpan<ContravariantInterface<Derived>>
        contravariantInterfaceDerivedReadOnlySpan = contravariantInterfaceBaseSpan; // Span<ContravariantInterface<Base>> -> ReadOnlySpan<ContravariantInterface<Derived>>
        contravariantInterfaceDerivedReadOnlySpan = contravariantInterfaceBaseArray; // ContravariantInterface<Base>[] -> ReadOnlySpan<ContravariantInterface<Derived>>

        // Mixed variance conversions to ReadOnlySpan
        ReadOnlySpan<MixedInterface<Base, Derived>> mixedInterfaceBaseReadOnlySpan;
        ReadOnlySpan<MixedInterface<Derived, Base>> mixedInterfaceDerivedReadOnlySpan = default;
        Span<MixedInterface<Derived, Base>> mixedInterfaceDerivedSpan = default;
        MixedInterface<Derived, Base>[] mixedInterfaceDerivedArray = [];
        mixedInterfaceBaseReadOnlySpan = mixedInterfaceDerivedReadOnlySpan; // ReadOnlySpan<MixedInterface<Derived, Base>> -> ReadOnlySpan<MixedInterface<Base, Derived>>
        mixedInterfaceBaseReadOnlySpan = mixedInterfaceDerivedSpan; // Span<MixedInterface<Derived, Base>> -> ReadOnlySpan<MixedInterface<Base, Derived>>
        mixedInterfaceBaseReadOnlySpan = mixedInterfaceDerivedArray; // MixedInterface<Derived, Base>[] -> ReadOnlySpan<MixedInterface<Base, Derived>>

        // Convert string to ReadOnlySpan<char>
        string s = "";
        ReadOnlySpan<char> charReadOnlySpan = s; // string -> ReadOnlySpan<char>

        // Various ref type conversions
        Derived[] derivedArray = [];
        ReadOnlySpan<Base> baseReadOnlySpan;
        baseReadOnlySpan = derivedArray; // Derived[] -> ReadOnlySpan<Base>

        ReadOnlySpan<object> objectReadOnlySpan;
        objectReadOnlySpan = stringArray; // string[] -> ReadOnlySpan<object>

        byte[][] byteByteArray = [];
        objectReadOnlySpan = byteByteArray; // byte[][] -> ReadOnlySpan<object>

        // No conversion possible except for identity.
        ReadOnlySpan<InvariantInterface<Base>> invariantInterfaceBaseReadOnlySpan;
        ReadOnlySpan<InvariantInterface<Derived>> invariantInterfaceDerivedReadOnlySpan;
        Span<InvariantInterface<Derived>> invariantInterfaceDerivedSpan;
        InvariantInterface<Derived>[] invariantInterfaceDerivedArray;
    }
}
