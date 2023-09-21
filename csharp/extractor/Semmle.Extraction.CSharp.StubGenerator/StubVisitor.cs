using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using Microsoft.CodeAnalysis;
using Semmle.Extraction.CSharp.Util;
using Semmle.Util;

namespace Semmle.Extraction.CSharp.StubGenerator;

internal sealed class StubVisitor : SymbolVisitor, IDisposable
{
    private readonly IAssemblySymbol assembly;
    private readonly Lazy<TextWriter> stubWriterLazy;
    public TextWriter StubWriter => stubWriterLazy.Value;
    private readonly MemoizedFunc<INamespaceSymbol, bool> isRelevantNamespace;

    public StubVisitor(IAssemblySymbol assembly, Func<TextWriter> makeStubWriter)
    {
        this.assembly = assembly;
        this.stubWriterLazy = new(makeStubWriter);
        this.isRelevantNamespace = new(symbol =>
            symbol.GetTypeMembers().Any(IsRelevantNamedType) ||
            symbol.GetNamespaceMembers().Any(IsRelevantNamespace));
    }

    private static bool IsNotPublic(Accessibility accessibility) =>
        accessibility == Accessibility.Private ||
        accessibility == Accessibility.Internal ||
        accessibility == Accessibility.ProtectedAndInternal;

    private static bool IsRelevantBaseType(INamedTypeSymbol symbol) =>
        !IsNotPublic(symbol.DeclaredAccessibility) &&
        symbol.CanBeReferencedByName;

    private bool IsRelevantNamedType(INamedTypeSymbol symbol) =>
        IsRelevantBaseType(symbol) &&
        SymbolEqualityComparer.Default.Equals(symbol.ContainingAssembly, assembly);

    public bool IsRelevantNamespace(INamespaceSymbol symbol) => isRelevantNamespace.Invoke(symbol);

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

            StubWriter.Write(explicitInterfaceType.GetQualifiedName());
            StubWriter.Write('.');
            if (writeName)
                StubWriter.Write(explicitInterfaceSymbol.GetName());
        }
        else if (writeName)
        {
            StubWriter.Write(symbol.GetName());
        }
    }

    private void StubAccessibility(Accessibility accessibility)
    {
        switch (accessibility)
        {
            case Accessibility.Public:
                StubWriter.Write("public ");
                break;
            case Accessibility.Protected or Accessibility.ProtectedOrInternal:
                StubWriter.Write("protected ");
                break;
            case Accessibility.Internal:
                StubWriter.Write("internal ");
                break;
            case Accessibility.ProtectedAndInternal:
                StubWriter.Write("protected internal ");
                break;
            default:
                StubWriter.Write($"/* TODO: {accessibility} */");
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
                StubWriter.Write("abstract ");
            }
        }

        if (symbol.IsStatic && !(symbol is IFieldSymbol field && field.IsConst))
            StubWriter.Write("static ");
        if (symbol.IsVirtual)
            StubWriter.Write("virtual ");
        if (symbol.IsOverride)
            StubWriter.Write("override ");
        if (symbol.IsSealed)
        {
            if (!(symbol is INamedTypeSymbol type && (type.TypeKind == TypeKind.Enum || type.TypeKind == TypeKind.Delegate || type.TypeKind == TypeKind.Struct)))
                StubWriter.Write("sealed ");
        }
        if (symbol.IsExtern)
            StubWriter.Write("extern ");
    }

    private void StubTypedConstant(TypedConstant c)
    {
        switch (c.Kind)
        {
            case TypedConstantKind.Primitive:
                if (c.Value is string s)
                {
                    StubWriter.Write($"\"{s}\"");
                }
                else if (c.Value is char ch)
                {
                    StubWriter.Write($"'{ch}'");
                }
                else if (c.Value is bool b)
                {
                    StubWriter.Write(b ? "true" : "false");
                }
                else if (c.Value is int i)
                {
                    StubWriter.Write(i);
                }
                else if (c.Value is long l)
                {
                    StubWriter.Write(l);
                }
                else if (c.Value is float f)
                {
                    StubWriter.Write(f);
                }
                else if (c.Value is double d)
                {
                    StubWriter.Write(d);
                }
                else
                {
                    StubWriter.Write("throw null");
                }
                break;
            case TypedConstantKind.Enum:
                StubWriter.Write("throw null");
                break;
            case TypedConstantKind.Array:
                StubWriter.Write("new []{");
                WriteCommaSep(c.Values, StubTypedConstant);
                StubWriter.Write("}");
                break;
            default:
                StubWriter.Write($"/* TODO: {c.Kind} */ throw null");
                break;
        }
    }

    private static readonly HashSet<string> attributeAllowList = new() {
        "System.FlagsAttribute"
    };

    private void StubAttribute(AttributeData a, string prefix)
    {
        if (a.AttributeClass is not INamedTypeSymbol @class)
            return;

        var qualifiedName = @class.GetQualifiedName();
        if (!attributeAllowList.Contains(qualifiedName))
            return;

        if (qualifiedName.EndsWith("Attribute"))
            qualifiedName = qualifiedName[..^9];
        StubWriter.Write($"[{prefix}{qualifiedName}");
        if (a.ConstructorArguments.Any())
        {
            StubWriter.Write("(");
            WriteCommaSep(a.ConstructorArguments, StubTypedConstant);
            StubWriter.Write(")");
        }
        StubWriter.WriteLine("]");
    }

    public void StubAttributes(IEnumerable<AttributeData> a, string prefix = "")
    {
        foreach (var attribute in a)
        {
            StubAttribute(attribute, prefix);
        }
    }

    private void StubEvent(IEventSymbol symbol, IEventSymbol? explicitInterfaceSymbol)
    {
        StubAttributes(symbol.GetAttributes());

        StubModifiers(symbol, explicitInterfaceSymbol is not null);
        StubWriter.Write("event ");
        StubWriter.Write(symbol.Type.GetQualifiedName());
        StubWriter.Write(" ");

        StubExplicitInterface(symbol, explicitInterfaceSymbol);

        if (explicitInterfaceSymbol is null)
        {
            StubWriter.WriteLine(";");
        }
        else
        {
            StubWriter.Write(" { ");
            StubWriter.Write("add {} ");
            StubWriter.Write("remove {} ");
            StubWriter.WriteLine("}");
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

    private static readonly HashSet<string> keywords = new() {
        "abstract", "as", "base", "bool", "break", "byte", "case", "catch", "char", "checked",
        "class", "const", "continue", "decimal", "default", "delegate", "do", "double", "else",
        "enum", "event", "explicit", "extern", "false", "finally", "fixed", "float", "for", "foreach",
        "goto", "if", "implicit", "in", "int", "interface", "internal", "is", "lock", "long",
        "namespace", "new", "null", "object", "operator", "out", "override", "params", "private",
        "protected", "public", "readonly", "ref", "return", "sbyte", "sealed", "short", "sizeof",
        "stackalloc", "static", "string", "struct", "switch", "this", "throw", "true", "try",
        "typeof", "uint", "ulong", "unchecked", "unsafe", "ushort", "using", "virtual", "void",
        "volatile", "while"
    };

    private static string EscapeIdentifier(string identifier) =>
        keywords.Contains(identifier) ? "@" + identifier : identifier;

    public override void VisitField(IFieldSymbol symbol)
    {
        if (IsNotPublic(symbol.DeclaredAccessibility))
            return;

        StubAttributes(symbol.GetAttributes());

        StubModifiers(symbol);

        if (symbol.IsConst)
            StubWriter.Write("const ");

        if (IsUnsafe(symbol.Type))
        {
            StubWriter.Write("unsafe ");
        }

        StubWriter.Write(symbol.Type.GetQualifiedName());
        StubWriter.Write(" ");
        StubWriter.Write(EscapeIdentifier(symbol.Name));
        if (symbol.IsConst)
            StubWriter.Write(" = default");
        StubWriter.WriteLine(";");
    }

    private void WriteCommaSep<T>(IEnumerable<T> items, Action<T> writeItem)
    {
        var first = true;
        foreach (var item in items)
        {
            if (!first)
            {
                StubWriter.Write(", ");
            }
            writeItem(item);
            first = false;
        }
    }

    private void WriteStringCommaSep<T>(IEnumerable<T> items, Func<T, string> writeItem)
    {
        WriteCommaSep(items, item => StubWriter.Write(writeItem(item)));
    }

    private void StubTypeParameters(IEnumerable<ITypeParameterSymbol> typeParameters)
    {
        if (!typeParameters.Any())
            return;

        StubWriter.Write('<');
        WriteStringCommaSep(typeParameters, typeParameter => typeParameter.Name);
        StubWriter.Write('>');
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
                    StubWriter.Write($" where {typeParameter.Name} : ");
                }
                else
                {
                    StubWriter.Write(", ");
                }
                a();
                firstTypeParameterConstraint = false;
            }

            if (typeParameter.HasReferenceTypeConstraint)
            {
                WriteTypeParameterConstraint(() => StubWriter.Write("class"));
            }

            if (typeParameter.HasValueTypeConstraint &&
                !typeParameter.HasUnmanagedTypeConstraint &&
                !typeParameter.ConstraintTypes.Any(t => t.GetQualifiedName() is "System.Enum"))
            {
                WriteTypeParameterConstraint(() => StubWriter.Write("struct"));
            }

            if (inheritsConstraints)
                continue;

            if (typeParameter.HasUnmanagedTypeConstraint)
            {
                WriteTypeParameterConstraint(() => StubWriter.Write("unmanaged"));
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
                WriteTypeParameterConstraint(() => StubWriter.Write("new()"));
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
            switch (parameter.RefKind)
            {
                case RefKind.None:
                    break;
                case RefKind.Ref:
                    StubWriter.Write("ref ");
                    break;
                case RefKind.Out:
                    StubWriter.Write("out ");
                    break;
                case RefKind.In:
                    StubWriter.Write("in ");
                    break;
                default:
                    StubWriter.Write($"/* TODO: {parameter.RefKind} */");
                    break;
            }

            if (parameter.IsParams)
                StubWriter.Write("params ");

            StubWriter.Write(parameter.Type.GetQualifiedName());
            StubWriter.Write(" ");
            StubWriter.Write(EscapeIdentifier(parameter.Name));

            if (parameter.HasExplicitDefaultValue)
            {
                StubWriter.Write(" = ");
                StubWriter.Write($"default({parameter.Type.GetQualifiedName()})");
            }
        });
    }

    private void StubMethod(IMethodSymbol symbol, IMethodSymbol? explicitInterfaceSymbol, IMethodSymbol? baseCtor)
    {
        var methodKind = explicitInterfaceSymbol is null ? symbol.MethodKind : explicitInterfaceSymbol.MethodKind;

        var relevantMethods = new[] {
                MethodKind.Constructor,
                MethodKind.Conversion,
                MethodKind.UserDefinedOperator,
                MethodKind.Ordinary
            };

        if (!relevantMethods.Contains(methodKind))
            return;

        StubAttributes(symbol.GetAttributes());

        StubModifiers(symbol, explicitInterfaceSymbol is not null);

        if (IsUnsafe(symbol.ReturnType) || symbol.Parameters.Any(p => IsUnsafe(p.Type)))
        {
            StubWriter.Write("unsafe ");
        }

        if (methodKind == MethodKind.Constructor)
        {
            StubWriter.Write(symbol.ContainingType.Name);
        }
        else if (methodKind == MethodKind.Conversion)
        {
            if (!symbol.TryGetOperatorSymbol(out var operatorName))
            {
                StubWriter.WriteLine($"/* TODO: {symbol.Name} */");
                return;
            }

            switch (operatorName)
            {
                case "explicit conversion":
                    StubWriter.Write("explicit operator ");
                    break;
                case "checked explicit conversion":
                    StubWriter.Write("explicit operator checked ");
                    break;
                case "implicit conversion":
                    StubWriter.Write("implicit operator ");
                    break;
                case "checked implicit conversion":
                    StubWriter.Write("implicit operator checked ");
                    break;
                default:
                    StubWriter.Write($"/* TODO: {symbol.Name} */");
                    break;
            }

            StubWriter.Write(symbol.ReturnType.GetQualifiedName());
        }
        else if (methodKind == MethodKind.UserDefinedOperator)
        {
            if (!symbol.TryGetOperatorSymbol(out var operatorName))
            {
                StubWriter.WriteLine($"/* TODO: {symbol.Name} */");
                return;
            }

            StubWriter.Write(symbol.ReturnType.GetQualifiedName());
            StubWriter.Write(" ");
            StubExplicitInterface(symbol, explicitInterfaceSymbol, writeName: false);
            StubWriter.Write("operator ");
            StubWriter.Write(operatorName);
        }
        else
        {
            StubWriter.Write(symbol.ReturnType.GetQualifiedName());
            StubWriter.Write(" ");
            StubExplicitInterface(symbol, explicitInterfaceSymbol);
            StubTypeParameters(symbol.TypeParameters);
        }

        StubWriter.Write("(");

        if (symbol.IsExtensionMethod)
        {
            StubWriter.Write("this ");
        }

        StubParameters(symbol.Parameters);

        StubWriter.Write(")");

        if (baseCtor is not null)
        {
            StubWriter.Write(" : base(");
            WriteStringCommaSep(baseCtor.Parameters, parameter => $"default({parameter.Type.GetQualifiedName()})");
            StubWriter.Write(")");
        }

        StubTypeParameterConstraints(symbol.TypeParameters);

        if (symbol.IsAbstract)
            StubWriter.WriteLine(";");
        else
            StubWriter.WriteLine(" => throw null;");
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
        if (!IsRelevantNamedType(symbol))
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
                StubWriter.Write("unsafe ");
            }

            StubWriter.Write("delegate ");
            StubWriter.Write(invokeMethod.ReturnType.GetQualifiedName());
            StubWriter.Write($" {symbol.Name}");
            StubTypeParameters(symbol.TypeParameters);
            StubWriter.Write("(");
            StubParameters(invokeMethod.Parameters);
            StubWriter.Write(")");
            StubTypeParameterConstraints(symbol.TypeParameters);
            StubWriter.WriteLine(";");
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
                    StubWriter.Write("partial ");
                StubWriter.Write("class ");
                break;
            case TypeKind.Enum:
                StubAttributes(symbol.GetAttributes());
                StubModifiers(symbol);
                StubWriter.Write("enum ");
                break;
            case TypeKind.Interface:
                StubAttributes(symbol.GetAttributes());
                StubModifiers(symbol);
                StubWriter.Write("interface ");
                break;
            case TypeKind.Struct:
                StubAttributes(symbol.GetAttributes());
                StubModifiers(symbol);
                StubWriter.Write("struct ");
                break;
            default:
                return;
        }

        StubWriter.Write(symbol.Name);

        StubTypeParameters(symbol.TypeParameters);

        if (symbol.TypeKind == TypeKind.Enum)
        {
            if (symbol.EnumUnderlyingType is INamedTypeSymbol enumBase && enumBase.SpecialType != SpecialType.System_Int32)
            {
                StubWriter.Write(" : ");
                StubWriter.Write(enumBase.GetQualifiedName());
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
                StubWriter.Write(" : ");
                WriteStringCommaSep(bases, b => b.GetQualifiedName());
            }
        }

        StubTypeParameterConstraints(symbol.TypeParameters);

        StubWriter.WriteLine(" {");

        if (symbol.TypeKind == TypeKind.Enum)
        {
            foreach (var field in symbol.GetMembers().OfType<IFieldSymbol>().Where(field => field.ConstantValue is not null))
            {
                StubWriter.Write(field.Name);
                StubWriter.Write(" = ");
                StubWriter.Write(field.ConstantValue);
                StubWriter.WriteLine(",");
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
                StubWriter.Write($"internal {symbol.Name}() : base(");
                WriteStringCommaSep(baseCtor.Parameters, parameter => $"default({parameter.Type.GetQualifiedName()})");
                StubWriter.WriteLine(") {}");
            }
        }

        StubWriter.WriteLine("}");
    }

    public override void VisitNamespace(INamespaceSymbol symbol)
    {
        if (!IsRelevantNamespace(symbol))
        {
            return;
        }

        var isGlobal = symbol.IsGlobalNamespace;

        if (!isGlobal)
            StubWriter.WriteLine($"namespace {symbol.Name} {{");

        foreach (var childSymbol in symbol.GetMembers().OrderBy(m => m.GetName()))
        {
            childSymbol.Accept(this);
        }

        if (!isGlobal)
            StubWriter.WriteLine("}");
    }

    private void StubProperty(IPropertySymbol symbol, IPropertySymbol? explicitInterfaceSymbol)
    {
        if (symbol.Parameters.Any())
        {
            var name = symbol.GetName(useMetadataName: true);
            if (name is not "Item" && explicitInterfaceSymbol is null)
                StubWriter.WriteLine($"[System.Runtime.CompilerServices.IndexerName(\"{name}\")]");
        }

        StubAttributes(symbol.GetAttributes());
        StubModifiers(symbol, explicitInterfaceSymbol is not null);

        if (IsUnsafe(symbol.Type) || symbol.Parameters.Any(p => IsUnsafe(p.Type)))
        {
            StubWriter.Write("unsafe ");
        }

        StubWriter.Write(symbol.Type.GetQualifiedName());
        StubWriter.Write(" ");

        if (symbol.Parameters.Any())
        {
            StubExplicitInterface(symbol, explicitInterfaceSymbol, writeName: false);
            StubWriter.Write("this[");
            StubParameters(symbol.Parameters);
            StubWriter.Write("]");
        }
        else
        {
            StubExplicitInterface(symbol, explicitInterfaceSymbol);
        }

        StubWriter.Write(" { ");
        if (symbol.GetMethod is not null)
            StubWriter.Write(symbol.IsAbstract ? "get; " : "get => throw null; ");
        if (symbol.SetMethod is not null)
            StubWriter.Write(symbol.IsAbstract ? "set; " : "set {} ");
        StubWriter.WriteLine("}");
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

    public void Dispose()
    {
        StubWriter.Dispose();
    }
}