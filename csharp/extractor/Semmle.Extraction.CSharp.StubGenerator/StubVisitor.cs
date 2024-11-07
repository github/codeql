using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;

using Microsoft.CodeAnalysis;

using Semmle.Extraction.CSharp.Util;

namespace Semmle.Extraction.CSharp.StubGenerator;

internal sealed class StubVisitor : SymbolVisitor
{
    private readonly TextWriter stubWriter;
    private readonly IRelevantSymbol relevantSymbol;

    public StubVisitor(TextWriter stubWriter, IRelevantSymbol relevantSymbol)
    {
        this.stubWriter = stubWriter;
        this.relevantSymbol = relevantSymbol;
    }

    private static bool IsNotPublic(Accessibility accessibility) =>
        accessibility == Accessibility.Private ||
        accessibility == Accessibility.Internal ||
        accessibility == Accessibility.ProtectedAndInternal;

    public static bool IsRelevantBaseType(INamedTypeSymbol symbol) =>
        !IsNotPublic(symbol.DeclaredAccessibility) &&
        symbol.CanBeReferencedByName;

    private void StubExplicitInterface(ISymbol symbol, ISymbol? explicitInterfaceSymbol, bool writeName = true)
    {
        static bool ContainsTupleType(ITypeSymbol type) =>
            type is INamedTypeSymbol named && (named.IsTupleType || named.TypeArguments.Any(ContainsTupleType)) ||
            type is IArrayTypeSymbol array && ContainsTupleType(array.ElementType) ||
            type is IPointerTypeSymbol pointer && ContainsTupleType(pointer.PointedAtType);

        static bool EqualsModuloTupleElementNames(ITypeSymbol t1, ITypeSymbol t2) =>
           SymbolEqualityComparer.Default.Equals(t1, t2) ||
            (
                t1 is INamedTypeSymbol named1 &&
                t2 is INamedTypeSymbol named2 &&
                (!SymbolEqualityComparer.Default.Equals(named1, named1.ConstructedFrom) || !SymbolEqualityComparer.Default.Equals(named2, named2.ConstructedFrom)) &&
                EqualsModuloTupleElementNames(named1.ConstructedFrom, named2.ConstructedFrom) &&
                named1.TypeArguments.Length == named2.TypeArguments.Length &&
                named1.TypeArguments.Zip(named2.TypeArguments).All(p => EqualsModuloTupleElementNames(p.First, p.Second))
            ) ||
            (
                t1 is IArrayTypeSymbol array1 &&
                t2 is IArrayTypeSymbol array2 &&
                EqualsModuloTupleElementNames(array1.ElementType, array2.ElementType)
            ) ||
            (
                t1 is IPointerTypeSymbol pointer1 &&
                t2 is IPointerTypeSymbol pointer2 &&
                EqualsModuloTupleElementNames(pointer1.PointedAtType, pointer2.PointedAtType)
            );

        if (explicitInterfaceSymbol is not null)
        {
            var explicitInterfaceType = explicitInterfaceSymbol.ContainingType;

            // Workaround for when the explicit interface type contains named tuple types,
            // in which case Roslyn may incorrectly forget the names of the tuple elements.
            //
            // For example, without this workaround we would incorrectly generate the following stub:
            //
            // ```csharp
            // public sealed class UnorderedItemsCollection : System.Collections.Generic.IEnumerable<(TElement Element, TPriority Priority)>, ...
            // {
            //     System.Collections.Generic.IEnumerator<(TElement Element, TPriority Priority)> System.Collections.Generic.IEnumerable<(TElement, TPriority)>.GetEnumerator() => throw null;
            // }
            // ```
            if (ContainsTupleType(explicitInterfaceType))
            {
                explicitInterfaceType = symbol.ContainingType.Interfaces.First(i => ContainsTupleType(i) && EqualsModuloTupleElementNames(i, explicitInterfaceSymbol.ContainingType));
            }

            stubWriter.Write(explicitInterfaceType.GetQualifiedName());
            stubWriter.Write('.');
            if (writeName)
                stubWriter.Write(EscapeIdentifier(explicitInterfaceSymbol.GetName()));
        }
        else if (writeName)
        {
            stubWriter.Write(EscapeIdentifier(symbol.GetName()));
        }
    }

    private void StubAccessibility(Accessibility accessibility)
    {
        switch (accessibility)
        {
            case Accessibility.Public:
                stubWriter.Write("public ");
                break;
            case Accessibility.Protected or Accessibility.ProtectedOrInternal:
                stubWriter.Write("protected ");
                break;
            case Accessibility.Internal:
                stubWriter.Write("internal ");
                break;
            case Accessibility.ProtectedAndInternal:
                stubWriter.Write("protected internal ");
                break;
            default:
                stubWriter.Write($"/* TODO: {accessibility} */");
                break;
        }
    }

    private void StubModifiers(ISymbol symbol, bool skipAccessibility = false)
    {
        if (symbol.ContainingType is ITypeSymbol containing && containing.TypeKind == TypeKind.Interface)
            skipAccessibility = true;

        if (symbol is IMethodSymbol method && method.MethodKind == MethodKind.Constructor && symbol.IsStatic)
            skipAccessibility = true;

        if (!skipAccessibility)
            StubAccessibility(symbol.DeclaredAccessibility);

        if (symbol.IsAbstract)
        {
            if (
                // exclude interface declarations
                (symbol is not INamedTypeSymbol type || type.TypeKind != TypeKind.Interface) &&
                // exclude non-static interface members
                (symbol.ContainingType is not INamedTypeSymbol containingType || containingType.TypeKind != TypeKind.Interface || symbol.IsStatic))
            {
                stubWriter.Write("abstract ");
            }
        }

        if (symbol.IsStatic && !(symbol is IFieldSymbol field && field.IsConst))
            stubWriter.Write("static ");
        if (symbol.IsVirtual)
            stubWriter.Write("virtual ");
        if (symbol.IsOverride)
            stubWriter.Write("override ");
        if (symbol.IsSealed)
        {
            if (!(symbol is INamedTypeSymbol type && (type.TypeKind == TypeKind.Enum || type.TypeKind == TypeKind.Delegate || type.TypeKind == TypeKind.Struct)))
                stubWriter.Write("sealed ");
        }
        if (symbol.IsExtern)
            stubWriter.Write("extern ");
    }

    private void StubTypedConstant(TypedConstant c)
    {
        switch (c.Kind)
        {
            case TypedConstantKind.Primitive:
                if (c.Value is string s)
                {
                    stubWriter.Write($"\"{s}\"");
                }
                else if (c.Value is char ch)
                {
                    stubWriter.Write($"'{ch}'");
                }
                else if (c.Value is bool b)
                {
                    stubWriter.Write(b ? "true" : "false");
                }
                else if (c.Value is int i)
                {
                    stubWriter.Write(i);
                }
                else if (c.Value is long l)
                {
                    stubWriter.Write(l);
                }
                else if (c.Value is float f)
                {
                    stubWriter.Write(f);
                }
                else if (c.Value is double d)
                {
                    stubWriter.Write(d);
                }
                else
                {
                    stubWriter.Write("throw null");
                }
                break;
            case TypedConstantKind.Enum:
                stubWriter.Write($"({c.Type!.GetQualifiedName()}) ");
                stubWriter.Write(c.Value!.ToString());
                break;
            case TypedConstantKind.Array:
                stubWriter.Write("new []{");
                WriteCommaSep(c.Values, StubTypedConstant);
                stubWriter.Write("}");
                break;
            default:
                stubWriter.Write($"/* TODO: {c.Kind} */ throw null");
                break;
        }
    }

    private static readonly HashSet<string> attributeAllowList = [
        "System.FlagsAttribute",
        "System.AttributeUsageAttribute",
        "System.Runtime.CompilerServices.InterpolatedStringHandlerAttribute",
        "System.Runtime.CompilerServices.InterpolatedStringHandlerArgumentAttribute",
    ];

    private void StubAttribute(AttributeData a, string prefix, bool addNewLine)
    {
        if (a.AttributeClass is not INamedTypeSymbol @class)
            return;

        var qualifiedName = @class.GetQualifiedName();
        if (!attributeAllowList.Contains(qualifiedName))
            return;

        if (qualifiedName.EndsWith("Attribute"))
            qualifiedName = qualifiedName[..^9];
        stubWriter.Write($"[{prefix}{qualifiedName}");
        if (a.ConstructorArguments.Any())
        {
            stubWriter.Write("(");
            WriteCommaSep(a.ConstructorArguments, StubTypedConstant);
            if (a.ConstructorArguments.Any() && a.NamedArguments.Any())
                stubWriter.Write(",");
            WriteCommaSep(a.NamedArguments, arg =>
            {
                stubWriter.Write(arg.Key);
                stubWriter.Write(" = ");
                StubTypedConstant(arg.Value);
            });
            stubWriter.Write(")");
        }
        stubWriter.Write("]");
        if (addNewLine)
        {
            stubWriter.WriteLine();
        }
    }

    public void StubAttributes(IEnumerable<AttributeData> a, string prefix = "", bool addNewLine = true)
    {
        foreach (var attribute in a)
        {
            StubAttribute(attribute, prefix, addNewLine);
        }
    }

    private void StubEvent(IEventSymbol symbol, IEventSymbol? explicitInterfaceSymbol)
    {
        StubAttributes(symbol.GetAttributes());

        StubModifiers(symbol, explicitInterfaceSymbol is not null);
        stubWriter.Write("event ");
        stubWriter.Write(symbol.Type.GetQualifiedName());
        stubWriter.Write(" ");

        StubExplicitInterface(symbol, explicitInterfaceSymbol);

        if (explicitInterfaceSymbol is null)
        {
            stubWriter.WriteLine(";");
        }
        else
        {
            stubWriter.Write(" { ");
            stubWriter.Write("add {} ");
            stubWriter.Write("remove {} ");
            stubWriter.WriteLine("}");
        }
    }

    private static T[] FilterExplicitInterfaceImplementations<T>(IEnumerable<T> explicitInterfaceImplementations) where T : ISymbol =>
        explicitInterfaceImplementations.Where(i => IsRelevantBaseType(i.ContainingType)).ToArray();

    public override void VisitEvent(IEventSymbol symbol)
    {
        var explicitInterfaceImplementations = FilterExplicitInterfaceImplementations(symbol.ExplicitInterfaceImplementations);

        if (IsNotPublic(symbol.DeclaredAccessibility) && explicitInterfaceImplementations.Length == 0)
            return;

        foreach (var explicitInterfaceSymbol in explicitInterfaceImplementations)
        {
            StubEvent(symbol, explicitInterfaceSymbol);
        }

        if (explicitInterfaceImplementations.Length == 0)
            StubEvent(symbol, null);
    }

    private static bool IsUnsafe(ITypeSymbol symbol) =>
        symbol.TypeKind == TypeKind.Pointer ||
        symbol.TypeKind == TypeKind.FunctionPointer ||
        (symbol is INamedTypeSymbol named && named.TypeArguments.Any(IsUnsafe)) ||
        (symbol is IArrayTypeSymbol at && IsUnsafe(at.ElementType));

    private static readonly HashSet<string> keywords = [
        "abstract", "as", "base", "bool", "break", "byte", "case", "catch", "char", "checked",
        "class", "const", "continue", "decimal", "default", "delegate", "do", "double", "else",
        "enum", "event", "explicit", "extern", "false", "finally", "fixed", "float", "for", "foreach",
        "goto", "if", "implicit", "in", "int", "interface", "internal", "is", "lock", "long",
        "namespace", "new", "null", "object", "operator", "out", "override", "params", "private",
        "protected", "public", "readonly", "ref", "return", "sbyte", "sealed", "short", "sizeof",
        "stackalloc", "static", "string", "struct", "switch", "this", "throw", "true", "try",
        "typeof", "uint", "ulong", "unchecked", "unsafe", "ushort", "using", "virtual", "void",
        "volatile", "while"
    ];

    private static string EscapeIdentifier(string identifier) =>
        keywords.Contains(identifier) ? $"@{identifier}" : identifier;

    private static bool TryGetConstantValue(IFieldSymbol symbol, out string value)
    {
        value = "";
        if (!symbol.HasConstantValue)
        {
            return false;
        }

        var v = symbol.ConstantValue;
        switch (symbol.Type.SpecialType)
        {
            case SpecialType.System_Boolean:
                value = (bool)v ? "true" : "false";
                return true;
            case SpecialType.System_Byte:
            case SpecialType.System_SByte:
            case SpecialType.System_UInt16:
            case SpecialType.System_UInt32:
            case SpecialType.System_UInt64:
            case SpecialType.System_Int16:
            case SpecialType.System_Int32:
            case SpecialType.System_Int64:
                value = v.ToString()!;
                return true;
            default:
                return false;
        }
    }

    public override void VisitField(IFieldSymbol symbol)
    {
        if (IsNotPublic(symbol.DeclaredAccessibility))
            return;

        StubAttributes(symbol.GetAttributes());

        StubModifiers(symbol);

        if (symbol.IsConst)
        {
            stubWriter.Write("const ");
        }

        if (!symbol.IsConst && symbol.IsReadOnly)
        {
            stubWriter.Write("readonly ");
        }

        if (IsUnsafe(symbol.Type))
        {
            stubWriter.Write("unsafe ");
        }

        stubWriter.Write(symbol.Type.GetQualifiedName());
        stubWriter.Write(" ");
        stubWriter.Write(EscapeIdentifier(symbol.Name));
        if (symbol.IsConst)
        {
            var v = TryGetConstantValue(symbol, out var value) ? value : "default";
            stubWriter.Write($" = {v}");
        }
        stubWriter.WriteLine(";");
    }

    private void WriteCommaSep<T>(IEnumerable<T> items, Action<T> writeItem)
    {
        var first = true;
        foreach (var item in items)
        {
            if (!first)
            {
                stubWriter.Write(", ");
            }
            writeItem(item);
            first = false;
        }
    }

    private void WriteStringCommaSep<T>(IEnumerable<T> items, Func<T, string> writeItem)
    {
        WriteCommaSep(items, item => stubWriter.Write(writeItem(item)));
    }

    private void StubTypeParameters(IEnumerable<ITypeParameterSymbol> typeParameters)
    {
        if (!typeParameters.Any())
            return;

        stubWriter.Write('<');
        WriteStringCommaSep(typeParameters, typeParameter => typeParameter.Name);
        stubWriter.Write('>');
    }

    private void StubTypeParameterConstraints(IEnumerable<ITypeParameterSymbol> typeParameters)
    {
        if (!typeParameters.Any())
            return;

        var inheritsConstraints = typeParameters.Any(tp =>
            tp.DeclaringMethod is IMethodSymbol method &&
            (method.IsOverride || method.ExplicitInterfaceImplementations.Any()));

        foreach (var typeParameter in typeParameters)
        {
            var firstTypeParameterConstraint = true;

            void WriteTypeParameterConstraint(Action a)
            {
                if (firstTypeParameterConstraint)
                {
                    stubWriter.Write($" where {typeParameter.Name} : ");
                }
                else
                {
                    stubWriter.Write(", ");
                }
                a();
                firstTypeParameterConstraint = false;
            }

            if (typeParameter.HasReferenceTypeConstraint)
            {
                WriteTypeParameterConstraint(() => stubWriter.Write("class"));
            }

            if (typeParameter.HasValueTypeConstraint &&
                !typeParameter.HasUnmanagedTypeConstraint &&
                !typeParameter.ConstraintTypes.Any(t => t.GetQualifiedName() is "System.Enum"))
            {
                WriteTypeParameterConstraint(() => stubWriter.Write("struct"));
            }

            if (inheritsConstraints)
                continue;

            if (typeParameter.HasUnmanagedTypeConstraint)
            {
                WriteTypeParameterConstraint(() => stubWriter.Write("unmanaged"));
            }

            var constraintTypes = typeParameter.ConstraintTypes.Select(t => t.GetQualifiedName()).Where(s => s is not "").ToArray();
            if (constraintTypes.Any())
            {
                WriteTypeParameterConstraint(() =>
                {
                    WriteStringCommaSep(constraintTypes, constraintType => constraintType);
                });
            }

            if (typeParameter.HasConstructorConstraint)
            {
                WriteTypeParameterConstraint(() => stubWriter.Write("new()"));
            }
        }
    }

    private static INamedTypeSymbol? GetBaseType(INamedTypeSymbol symbol)
    {
        if (symbol.BaseType is INamedTypeSymbol @base &&
            @base.SpecialType != SpecialType.System_Object &&
            @base.SpecialType != SpecialType.System_ValueType)
        {
            return @base;
        }

        return null;
    }

    private static IMethodSymbol? GetBaseConstructor(INamedTypeSymbol symbol)
    {
        if (GetBaseType(symbol) is not INamedTypeSymbol @base)
            return null;

        var containingTypes = new HashSet<INamedTypeSymbol>(SymbolEqualityComparer.Default);
        var current = symbol;
        while (current is not null)
        {
            containingTypes.Add(current);
            current = current.ContainingType;
        }

        var baseCtor = @base.Constructors.
            Where(c => !c.IsStatic).
            Where(c =>
                c.DeclaredAccessibility == Accessibility.Public ||
                c.DeclaredAccessibility == Accessibility.Protected ||
                c.DeclaredAccessibility == Accessibility.ProtectedOrInternal ||
                containingTypes.Contains(c.ContainingType)
            ).
            MinBy(c => c.Parameters.Length);

        return baseCtor?.Parameters.Length > 0 ? baseCtor : null;
    }

    private static IMethodSymbol? GetBaseConstructor(IMethodSymbol ctor)
    {
        if (ctor.MethodKind != MethodKind.Constructor)
            return null;

        return GetBaseConstructor(ctor.ContainingType);
    }

    private void StubParameters(ICollection<IParameterSymbol> parameters)
    {
        WriteCommaSep(parameters, parameter =>
        {
            StubAttributes(parameter.GetAttributes(), addNewLine: false);

            switch (parameter.RefKind)
            {
                case RefKind.None:
                    break;
                case RefKind.Ref:
                    stubWriter.Write("ref ");
                    break;
                case RefKind.Out:
                    stubWriter.Write("out ");
                    break;
                case RefKind.In:
                    stubWriter.Write("in ");
                    break;
                case RefKind.RefReadOnlyParameter:
                    stubWriter.Write("ref readonly ");
                    break;
                default:
                    stubWriter.Write($"/* TODO: {parameter.RefKind} */");
                    break;
            }

            if (parameter.IsParams)
                stubWriter.Write("params ");

            stubWriter.Write(parameter.Type.GetQualifiedName());
            stubWriter.Write(" ");
            stubWriter.Write(EscapeIdentifier(parameter.Name));

            if (parameter.HasExplicitDefaultValue)
            {
                stubWriter.Write(" = ");
                stubWriter.Write($"default({parameter.Type.GetQualifiedName()})");
            }
        });
    }

    private static bool ExcludeMethod(IMethodSymbol symbol) =>
        symbol.Name == "<Clone>$";

    private void StubMethod(IMethodSymbol symbol, IMethodSymbol? explicitInterfaceSymbol, IMethodSymbol? baseCtor)
    {
        var methodKind = explicitInterfaceSymbol is null ? symbol.MethodKind : explicitInterfaceSymbol.MethodKind;

        var relevantMethods = new[] {
                MethodKind.Constructor,
                MethodKind.Conversion,
                MethodKind.UserDefinedOperator,
                MethodKind.Ordinary
            };

        if (!relevantMethods.Contains(methodKind) || ExcludeMethod(symbol))
            return;

        StubAttributes(symbol.GetAttributes());

        StubModifiers(symbol, explicitInterfaceSymbol is not null);

        if (IsUnsafe(symbol.ReturnType) || symbol.Parameters.Any(p => IsUnsafe(p.Type)))
        {
            stubWriter.Write("unsafe ");
        }

        if (methodKind == MethodKind.Constructor)
        {
            stubWriter.Write(symbol.ContainingType.Name);
        }
        else if (methodKind == MethodKind.Conversion)
        {
            if (!symbol.TryGetOperatorSymbol(out var operatorName))
            {
                stubWriter.WriteLine($"/* TODO: {symbol.Name} */");
                return;
            }

            switch (operatorName)
            {
                case "explicit conversion":
                    stubWriter.Write("explicit operator ");
                    break;
                case "checked explicit conversion":
                    stubWriter.Write("explicit operator checked ");
                    break;
                case "implicit conversion":
                    stubWriter.Write("implicit operator ");
                    break;
                case "checked implicit conversion":
                    stubWriter.Write("implicit operator checked ");
                    break;
                default:
                    stubWriter.Write($"/* TODO: {symbol.Name} */");
                    break;
            }

            stubWriter.Write(symbol.ReturnType.GetQualifiedName());
        }
        else if (methodKind == MethodKind.UserDefinedOperator)
        {
            if (!symbol.TryGetOperatorSymbol(out var operatorName))
            {
                stubWriter.WriteLine($"/* TODO: {symbol.Name} */");
                return;
            }

            stubWriter.Write(symbol.ReturnType.GetQualifiedName());
            stubWriter.Write(" ");
            StubExplicitInterface(symbol, explicitInterfaceSymbol, writeName: false);
            stubWriter.Write("operator ");
            stubWriter.Write(operatorName);
        }
        else
        {
            stubWriter.Write(symbol.ReturnType.GetQualifiedName());
            stubWriter.Write(" ");
            StubExplicitInterface(symbol, explicitInterfaceSymbol);
            StubTypeParameters(symbol.TypeParameters);
        }

        stubWriter.Write("(");

        if (symbol.IsExtensionMethod)
        {
            stubWriter.Write("this ");
        }

        StubParameters(symbol.Parameters);

        stubWriter.Write(")");

        if (baseCtor is not null)
        {
            stubWriter.Write(" : base(");
            WriteStringCommaSep(baseCtor.Parameters, parameter => $"default({parameter.Type.GetQualifiedName()})");
            stubWriter.Write(")");
        }

        StubTypeParameterConstraints(symbol.TypeParameters);

        if (symbol.IsAbstract)
            stubWriter.WriteLine(";");
        else
            stubWriter.WriteLine(" => throw null;");
    }

    public override void VisitMethod(IMethodSymbol symbol)
    {
        var baseCtor = GetBaseConstructor(symbol);
        var explicitInterfaceImplementations = FilterExplicitInterfaceImplementations(symbol.ExplicitInterfaceImplementations);

        if (baseCtor is null &&
            ((IsNotPublic(symbol.DeclaredAccessibility) && explicitInterfaceImplementations.Length == 0) ||
            symbol.IsImplicitlyDeclared))
        {
            return;
        }

        foreach (var explicitInterfaceSymbol in explicitInterfaceImplementations)
        {
            StubMethod(symbol, explicitInterfaceSymbol, baseCtor);
        }

        // Roslyn reports certain methods to be only explicit interface methods, such as
        //  `System.Numerics.INumberBase<int>.TryParse(string s, System.Globalization.NumberStyles style, System.IFormatProvider provider, out int result)`
        // in the `System.Int32` struct. However, we also need a non-explicit implementation
        // in order for things to compile.
        var roslynExplicitInterfaceWorkaround =
            symbol.ContainingType.GetQualifiedName() is "int" &&
            explicitInterfaceImplementations.Any(i => i.ContainingType.GetQualifiedName() is "System.Numerics.INumberBase<int>");

        if (explicitInterfaceImplementations.Length == 0 || roslynExplicitInterfaceWorkaround)
            StubMethod(symbol, null, baseCtor);
    }

    public override void VisitNamedType(INamedTypeSymbol symbol)
    {
        if (!relevantSymbol.IsRelevantNamedType(symbol))
        {
            return;
        }

        if (symbol.TypeKind == TypeKind.Delegate)
        {
            var invokeMethod = symbol.DelegateInvokeMethod!;
            StubAttributes(symbol.GetAttributes());
            StubModifiers(symbol);

            if (IsUnsafe(invokeMethod.ReturnType) || invokeMethod.Parameters.Any(p => IsUnsafe(p.Type)))
            {
                stubWriter.Write("unsafe ");
            }

            stubWriter.Write("delegate ");
            stubWriter.Write(invokeMethod.ReturnType.GetQualifiedName());
            stubWriter.Write($" {symbol.Name}");
            StubTypeParameters(symbol.TypeParameters);
            stubWriter.Write("(");
            StubParameters(invokeMethod.Parameters);
            stubWriter.Write(")");
            StubTypeParameterConstraints(symbol.TypeParameters);
            stubWriter.WriteLine(";");
            return;
        }

        switch (symbol.TypeKind)
        {
            case TypeKind.Class:
                StubAttributes(symbol.GetAttributes());
                StubModifiers(symbol);
                // certain classes, such as `Microsoft.Extensions.Logging.LoggingBuilderExtensions`
                // exist in multiple assemblies, so make them partial
                if (symbol.IsStatic && symbol.Name.EndsWith("Extensions"))
                    stubWriter.Write("partial ");
                stubWriter.Write("class ");
                break;
            case TypeKind.Enum:
                StubAttributes(symbol.GetAttributes());
                StubModifiers(symbol);
                stubWriter.Write("enum ");
                break;
            case TypeKind.Interface:
                StubAttributes(symbol.GetAttributes());
                StubModifiers(symbol);
                stubWriter.Write("interface ");
                break;
            case TypeKind.Struct:
                StubAttributes(symbol.GetAttributes());
                StubModifiers(symbol);
                stubWriter.Write("struct ");
                break;
            default:
                return;
        }

        stubWriter.Write(symbol.Name);

        StubTypeParameters(symbol.TypeParameters);

        if (symbol.TypeKind == TypeKind.Enum)
        {
            if (symbol.EnumUnderlyingType is INamedTypeSymbol enumBase && enumBase.SpecialType != SpecialType.System_Int32)
            {
                stubWriter.Write(" : ");
                stubWriter.Write(enumBase.GetQualifiedName());
            }
        }
        else
        {
            var bases = symbol.Interfaces.Where(IsRelevantBaseType).OrderBy(i => i.GetName()).ToList();
            if (GetBaseType(symbol) is INamedTypeSymbol @base && IsRelevantBaseType(@base))
            {
                bases.Insert(0, @base);
            }

            if (bases.Any())
            {
                stubWriter.Write(" : ");
                WriteStringCommaSep(bases, b => b.GetQualifiedName());
            }
        }

        StubTypeParameterConstraints(symbol.TypeParameters);

        stubWriter.WriteLine(" {");

        if (symbol.TypeKind == TypeKind.Enum)
        {
            foreach (var field in symbol.GetMembers().OfType<IFieldSymbol>().Where(field => field.ConstantValue is not null))
            {
                stubWriter.Write(field.Name);
                stubWriter.Write(" = ");
                stubWriter.Write(field.ConstantValue);
                stubWriter.WriteLine(",");
            }
        }
        else
        {
            var seenCtor = false;
            foreach (var childSymbol in symbol.GetMembers().OrderBy(m => m.GetName()))
            {
                seenCtor |= childSymbol is IMethodSymbol method && method.MethodKind == MethodKind.Constructor;
                childSymbol.Accept(this);
            }

            if (!seenCtor && GetBaseConstructor(symbol) is IMethodSymbol baseCtor)
            {
                stubWriter.Write($"internal {symbol.Name}() : base(");
                WriteStringCommaSep(baseCtor.Parameters, parameter => $"default({parameter.Type.GetQualifiedName()})");
                stubWriter.WriteLine(") {}");
            }
        }

        stubWriter.WriteLine("}");
    }

    public override void VisitNamespace(INamespaceSymbol symbol)
    {
        if (!relevantSymbol.IsRelevantNamespace(symbol))
        {
            return;
        }

        var isGlobal = symbol.IsGlobalNamespace;

        if (!isGlobal)
            stubWriter.WriteLine($"namespace {symbol.Name} {{");

        foreach (var childSymbol in symbol.GetMembers().OrderBy(m => m.GetName()))
        {
            childSymbol.Accept(this);
        }

        if (!isGlobal)
            stubWriter.WriteLine("}");
    }

    private void StubProperty(IPropertySymbol symbol, IPropertySymbol? explicitInterfaceSymbol)
    {
        if (symbol.Parameters.Any())
        {
            var name = symbol.GetName(useMetadataName: true);
            if (name is not "Item" && explicitInterfaceSymbol is null)
                stubWriter.WriteLine($"[System.Runtime.CompilerServices.IndexerName(\"{name}\")]");
        }

        StubAttributes(symbol.GetAttributes());
        StubModifiers(symbol, explicitInterfaceSymbol is not null);

        if (IsUnsafe(symbol.Type) || symbol.Parameters.Any(p => IsUnsafe(p.Type)))
        {
            stubWriter.Write("unsafe ");
        }

        stubWriter.Write(symbol.Type.GetQualifiedName());
        stubWriter.Write(" ");

        if (symbol.Parameters.Any())
        {
            StubExplicitInterface(symbol, explicitInterfaceSymbol, writeName: false);
            stubWriter.Write("this[");
            StubParameters(symbol.Parameters);
            stubWriter.Write("]");
        }
        else
        {
            StubExplicitInterface(symbol, explicitInterfaceSymbol);
        }

        stubWriter.Write(" { ");
        if (symbol.GetMethod is not null)
            stubWriter.Write(symbol.IsAbstract ? "get; " : "get => throw null; ");
        if (symbol.SetMethod is not null)
            stubWriter.Write(symbol.IsAbstract ? "set; " : "set {} ");
        stubWriter.WriteLine("}");
    }

    public override void VisitProperty(IPropertySymbol symbol)
    {
        var explicitInterfaceImplementations = FilterExplicitInterfaceImplementations(symbol.ExplicitInterfaceImplementations);

        if (IsNotPublic(symbol.DeclaredAccessibility) && explicitInterfaceImplementations.Length == 0)
            return;

        foreach (var explicitInterfaceImplementation in explicitInterfaceImplementations)
        {
            StubProperty(symbol, explicitInterfaceImplementation);
        }

        if (explicitInterfaceImplementations.Length == 0)
            StubProperty(symbol, null);
    }
}
