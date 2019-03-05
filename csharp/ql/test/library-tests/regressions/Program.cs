

using System;
using System.Threading.Tasks;

namespace TestCsharpProject
{
    static class Program
    {
        public static void Create(Func<string, IDisposable> subscribe) { return; }
        public static void Create(Func<string, Task<Action>> subscribeAsync) { return; }
        public static void Create(Func<string, Task<IDisposable>> subscribeAsync) { return; }

        static void Main(string[] args)
        {
            Create(obs => (IDisposable)null);
        }
    }
}

namespace LabelRegression
{
    class Container<T>
    {
        public class Builder
        {
        }
    }

    class Use
    {
        void First<T>(Container<T>.Builder b)
        {
        }
    }
}

namespace EnumConstants
{
    enum E { A = 0, B = 1 };
}

class TypeMentions
{
    ValueTuple<int, TypeMentions> f;

    interface I<T> { }
    interface I<T, U> { }

    class C : I<int>, I<string, string>, I<string>
    {
    }
}

class NameOfMethodGroups
{
    int MethodGroup() => 0;
    int MethodGroup(int x) => x;

    void Test()
    {
        var x = nameof(MethodGroup);
        x = nameof(NameOfMethodGroups.MethodGroup);
    }
}

class Designations
{
    bool f(out int x)
    {
        x = 0;
        return true;
    }

    int Test()
    {
        if (f(out var x) && f(out var _))
        {
            return x;
        }
        return 0;
    }
}

class WhileIs
{
    void Test()
    {
        object x = null;
        while(x is string s)
        {
            var y = s;
        }
    }
}

class ObjectInitializerType
{
    struct Point
    {
        public object Name;
    }

    void F()
    {
        new Point() { Name = "Bob" };
    }
}

class LiteralConversions
{
    struct Point
    {
        public int? x, y;
    }

    void F()
    {
        new Point { x=1, y=2 };
    }
}

class DynamicType
{
    void F()
    {
        dynamic t = (dynamic)null;
    }
}

class LocalVariableTags
{
    Func<int, int> F = x => { int y=x; return y; };

    private static Func<object, string, object> _getter => (o, n) =>
    {
         object x = o;
         return x;
    };
}

partial class C1<T> where T: DynamicType
{
}

partial class C1<T> where T: DynamicType
{
}

namespace NoPia
{
    class CommonEmbeddedTypesManager { }
    class CommonPEModuleBuilder { }
    class SyntaxNode {  }
    class CommonCompilationState { }
    class CommonModuleCompilationState { }
    class AttributeData { }

    namespace Cci
    {
        interface IGenericMethodParameterReference { }
        interface ICustomAttribute { }
        interface INamespaceTypeReference { }
        interface IFieldReference { }
        interface ITypeMemberReference { }
        interface IMethodReference { }
        interface IParameterListEntry { }
        interface INamedEntity { }
    }

    internal abstract partial class EmbeddedTypesManager<
        TPEModuleBuilder,
        TModuleCompilationState,
        TEmbeddedTypesManager,
        TSyntaxNode,
        TAttributeData,
        TSymbol,
        TAssemblySymbol,
        TNamedTypeSymbol,
        TFieldSymbol,
        TMethodSymbol,
        TEventSymbol,
        TPropertySymbol,
        TParameterSymbol,
        TTypeParameterSymbol,
        TEmbeddedType,
        TEmbeddedField,
        TEmbeddedMethod,
        TEmbeddedEvent,
        TEmbeddedProperty,
        TEmbeddedParameter,
        TEmbeddedTypeParameter> : CommonEmbeddedTypesManager
        where TPEModuleBuilder : CommonPEModuleBuilder
        where TModuleCompilationState : CommonModuleCompilationState
        where TEmbeddedTypesManager : EmbeddedTypesManager<TPEModuleBuilder, TModuleCompilationState, TEmbeddedTypesManager, TSyntaxNode, TAttributeData, TSymbol, TAssemblySymbol, TNamedTypeSymbol, TFieldSymbol, TMethodSymbol, TEventSymbol, TPropertySymbol, TParameterSymbol, TTypeParameterSymbol, TEmbeddedType, TEmbeddedField, TEmbeddedMethod, TEmbeddedEvent, TEmbeddedProperty, TEmbeddedParameter, TEmbeddedTypeParameter>
        where TSyntaxNode : SyntaxNode
        where TAttributeData : AttributeData, Cci.ICustomAttribute
        where TAssemblySymbol : class, TSymbol
        where TNamedTypeSymbol : class, TSymbol, Cci.INamespaceTypeReference
        where TFieldSymbol : class, TSymbol, Cci.IFieldReference
        where TMethodSymbol : class, TSymbol, Cci.IMethodReference
        where TEventSymbol : class, TSymbol, Cci.ITypeMemberReference
        where TPropertySymbol : class, TSymbol, Cci.ITypeMemberReference
        where TParameterSymbol : class, TSymbol, Cci.IParameterListEntry, Cci.INamedEntity
        where TTypeParameterSymbol : class, TSymbol, Cci.IGenericMethodParameterReference
        where TEmbeddedType : EmbeddedTypesManager<TPEModuleBuilder, TModuleCompilationState, TEmbeddedTypesManager, TSyntaxNode, TAttributeData, TSymbol, TAssemblySymbol, TNamedTypeSymbol, TFieldSymbol, TMethodSymbol, TEventSymbol, TPropertySymbol, TParameterSymbol, TTypeParameterSymbol, TEmbeddedType, TEmbeddedField, TEmbeddedMethod, TEmbeddedEvent, TEmbeddedProperty, TEmbeddedParameter, TEmbeddedTypeParameter>.CommonEmbeddedType
        where TEmbeddedField : EmbeddedTypesManager<TPEModuleBuilder, TModuleCompilationState, TEmbeddedTypesManager, TSyntaxNode, TAttributeData, TSymbol, TAssemblySymbol, TNamedTypeSymbol, TFieldSymbol, TMethodSymbol, TEventSymbol, TPropertySymbol, TParameterSymbol, TTypeParameterSymbol, TEmbeddedType, TEmbeddedField, TEmbeddedMethod, TEmbeddedEvent, TEmbeddedProperty, TEmbeddedParameter, TEmbeddedTypeParameter>.CommonEmbeddedField
        where TEmbeddedMethod : EmbeddedTypesManager<TPEModuleBuilder, TModuleCompilationState, TEmbeddedTypesManager, TSyntaxNode, TAttributeData, TSymbol, TAssemblySymbol, TNamedTypeSymbol, TFieldSymbol, TMethodSymbol, TEventSymbol, TPropertySymbol, TParameterSymbol, TTypeParameterSymbol, TEmbeddedType, TEmbeddedField, TEmbeddedMethod, TEmbeddedEvent, TEmbeddedProperty, TEmbeddedParameter, TEmbeddedTypeParameter>.CommonEmbeddedMethod
        where TEmbeddedEvent : EmbeddedTypesManager<TPEModuleBuilder, TModuleCompilationState, TEmbeddedTypesManager, TSyntaxNode, TAttributeData, TSymbol, TAssemblySymbol, TNamedTypeSymbol, TFieldSymbol, TMethodSymbol, TEventSymbol, TPropertySymbol, TParameterSymbol, TTypeParameterSymbol, TEmbeddedType, TEmbeddedField, TEmbeddedMethod, TEmbeddedEvent, TEmbeddedProperty, TEmbeddedParameter, TEmbeddedTypeParameter>.CommonEmbeddedEvent
        where TEmbeddedProperty : EmbeddedTypesManager<TPEModuleBuilder, TModuleCompilationState, TEmbeddedTypesManager, TSyntaxNode, TAttributeData, TSymbol, TAssemblySymbol, TNamedTypeSymbol, TFieldSymbol, TMethodSymbol, TEventSymbol, TPropertySymbol, TParameterSymbol, TTypeParameterSymbol, TEmbeddedType, TEmbeddedField, TEmbeddedMethod, TEmbeddedEvent, TEmbeddedProperty, TEmbeddedParameter, TEmbeddedTypeParameter>.CommonEmbeddedProperty
        where TEmbeddedParameter : EmbeddedTypesManager<TPEModuleBuilder, TModuleCompilationState, TEmbeddedTypesManager, TSyntaxNode, TAttributeData, TSymbol, TAssemblySymbol, TNamedTypeSymbol, TFieldSymbol, TMethodSymbol, TEventSymbol, TPropertySymbol, TParameterSymbol, TTypeParameterSymbol, TEmbeddedType, TEmbeddedField, TEmbeddedMethod, TEmbeddedEvent, TEmbeddedProperty, TEmbeddedParameter, TEmbeddedTypeParameter>.CommonEmbeddedParameter
        where TEmbeddedTypeParameter : EmbeddedTypesManager<TPEModuleBuilder, TModuleCompilationState, TEmbeddedTypesManager, TSyntaxNode, TAttributeData, TSymbol, TAssemblySymbol, TNamedTypeSymbol, TFieldSymbol, TMethodSymbol, TEventSymbol, TPropertySymbol, TParameterSymbol, TTypeParameterSymbol, TEmbeddedType, TEmbeddedField, TEmbeddedMethod, TEmbeddedEvent, TEmbeddedProperty, TEmbeddedParameter, TEmbeddedTypeParameter>.CommonEmbeddedTypeParameter
    {
        public class CommonEmbeddedType {  }
        public class CommonEmbeddedField { }
        public class CommonEmbeddedMethod { }
        public class CommonEmbeddedEvent { }
        public class CommonEmbeddedProperty { }
        public class CommonEmbeddedParameter { }
        public class CommonEmbeddedTypeParameter { }
    }
}

// semmle-extractor-options: /r:System.Dynamic.Runtime.dll
