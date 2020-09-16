using Microsoft.CodeAnalysis;
using Microsoft.CodeAnalysis.CSharp.Syntax;
using Semmle.Util;
using System.Collections.Generic;
using System.IO;
using System.Linq;

namespace Semmle.Extraction.CSharp.Entities
{
    /// <summary>
    /// Represents an annotated type consisting of a type entity and nullability information.
    /// </summary>
    public struct AnnotatedType
    {
        public AnnotatedType(Type t, NullableAnnotation n)
        {
            Type = t;
            annotation = n;
        }

        /// <summary>
        /// The underlying type.
        /// </summary>
        public Type Type { get; set; }

        readonly private NullableAnnotation annotation;

        /// <summary>
        /// Gets the annotated type symbol of this annotated type.
        /// </summary>
        public AnnotatedTypeSymbol Symbol => new AnnotatedTypeSymbol(Type.Symbol, annotation);
    }

    public abstract class Type : CachedSymbol<ITypeSymbol>
    {
        public Type(Context cx, ITypeSymbol init)
            : base(cx, init) { }

        public virtual AnnotatedType ElementType => default(AnnotatedType);

        public override bool NeedsPopulation =>
            base.NeedsPopulation || Symbol.TypeKind == TypeKind.Dynamic || Symbol.TypeKind == TypeKind.TypeParameter;

        public static bool ConstructedOrParentIsConstructed(INamedTypeSymbol symbol)
        {
            return !SymbolEqualityComparer.Default.Equals(symbol, symbol.OriginalDefinition) ||
                symbol.ContainingType != null && ConstructedOrParentIsConstructed(symbol.ContainingType);
        }

        static Kinds.TypeKind GetClassType(Context cx, ITypeSymbol t, bool constructUnderlyingTupleType)
        {
            switch (t.SpecialType)
            {
                case SpecialType.System_Int32: return Kinds.TypeKind.INT;
                case SpecialType.System_UInt32: return Kinds.TypeKind.UINT;
                case SpecialType.System_Int16: return Kinds.TypeKind.SHORT;
                case SpecialType.System_UInt16: return Kinds.TypeKind.USHORT;
                case SpecialType.System_UInt64: return Kinds.TypeKind.ULONG;
                case SpecialType.System_Int64: return Kinds.TypeKind.LONG;
                case SpecialType.System_Void: return Kinds.TypeKind.VOID;
                case SpecialType.System_Double: return Kinds.TypeKind.DOUBLE;
                case SpecialType.System_Byte: return Kinds.TypeKind.BYTE;
                case SpecialType.System_SByte: return Kinds.TypeKind.SBYTE;
                case SpecialType.System_Boolean: return Kinds.TypeKind.BOOL;
                case SpecialType.System_Char: return Kinds.TypeKind.CHAR;
                case SpecialType.System_Decimal: return Kinds.TypeKind.DECIMAL;
                case SpecialType.System_Single: return Kinds.TypeKind.FLOAT;
                case SpecialType.System_IntPtr: return Kinds.TypeKind.INT_PTR;
                default:
                    if (t.IsBoundNullable()) return Kinds.TypeKind.NULLABLE;
                    switch (t.TypeKind)
                    {
                        case TypeKind.Class: return Kinds.TypeKind.CLASS;
                        case TypeKind.Struct:
                            return ((INamedTypeSymbol)t).IsTupleType && !constructUnderlyingTupleType
                                ? Kinds.TypeKind.TUPLE
                                : Kinds.TypeKind.STRUCT;
                        case TypeKind.Interface: return Kinds.TypeKind.INTERFACE;
                        case TypeKind.Array: return Kinds.TypeKind.ARRAY;
                        case TypeKind.Enum: return Kinds.TypeKind.ENUM;
                        case TypeKind.Delegate: return Kinds.TypeKind.DELEGATE;
                        case TypeKind.Pointer: return Kinds.TypeKind.POINTER;
                        default:
                            cx.ModelError(t, $"Unhandled type kind '{t.TypeKind}'");
                            return Kinds.TypeKind.UNKNOWN;
                    }
            }
        }

        protected void PopulateType(TextWriter trapFile, bool constructUnderlyingTupleType = false)
        {
            PopulateMetadataHandle(trapFile);
            PopulateAttributes();

            trapFile.Write("types(");
            trapFile.WriteColumn(this);
            trapFile.Write(',');
            trapFile.WriteColumn((int)GetClassType(Context, Symbol, constructUnderlyingTupleType));
            trapFile.Write(",\"");
            Symbol.BuildDisplayName(Context, trapFile, constructUnderlyingTupleType);
            trapFile.WriteLine("\")");

            // Visit base types
            var baseTypes = new List<Type>();
            if (Symbol.GetNonObjectBaseType(Context) is INamedTypeSymbol @base)
            {
                var baseKey = Create(Context, @base);
                trapFile.extend(this, baseKey.TypeRef);
                if (Symbol.TypeKind != TypeKind.Struct)
                    baseTypes.Add(baseKey);
            }

            if (!(base.Symbol is IArrayTypeSymbol))
            {
                foreach (var t in base.Symbol.Interfaces.Select(i => Create(Context, i)))
                {
                    trapFile.implement(this, t.TypeRef);
                    baseTypes.Add(t);
                }
            }

            var containingType = ContainingType;
            if (containingType != null && Symbol.Kind != SymbolKind.TypeParameter)
            {
                var originalDefinition = Symbol.TypeKind == TypeKind.Error ? this : Create(Context, Symbol.OriginalDefinition);
                trapFile.nested_types(this, containingType, originalDefinition);
            }
            else if (Symbol.ContainingNamespace != null)
            {
                trapFile.parent_namespace(this, Namespace.Create(Context, Symbol.ContainingNamespace));
            }

            if (Symbol is IArrayTypeSymbol array)
            {
                // They are in the namespace of the original object
                var elementType = array.ElementType;
                var ns = elementType.TypeKind == TypeKind.TypeParameter ? Context.Compilation.GlobalNamespace : elementType.ContainingNamespace;

                if (ns != null)
                    trapFile.parent_namespace(this, Namespace.Create(Context, ns));
            }

            if (Symbol is IPointerTypeSymbol pointer)
            {
                var elementType = pointer.PointedAtType;
                var ns = elementType.TypeKind == TypeKind.TypeParameter ? Context.Compilation.GlobalNamespace : elementType.ContainingNamespace;

                if (ns != null)
                    trapFile.parent_namespace(this, Namespace.Create(Context, ns));
            }

            if (Symbol.BaseType != null && Symbol.BaseType.SpecialType == SpecialType.System_MulticastDelegate)
            {
                // This is a delegate.
                // The method "Invoke" has the return type.
                var invokeMethod = ((INamedTypeSymbol)Symbol).DelegateInvokeMethod;

                // Copy the parameters from the "Invoke" method to the delegate type
                for (var i = 0; i < invokeMethod.Parameters.Length; ++i)
                {
                    var param = invokeMethod.Parameters[i];
                    var originalParam = invokeMethod.OriginalDefinition.Parameters[i];
                    var originalParamEntity = SymbolEqualityComparer.Default.Equals(param, originalParam) ? null :
                        DelegateTypeParameter.Create(Context, originalParam, Create(Context, ((INamedTypeSymbol)Symbol).OriginalDefinition));
                    DelegateTypeParameter.Create(Context, param, this, originalParamEntity);
                }

                var returnKey = Create(Context, invokeMethod.ReturnType);
                trapFile.delegate_return_type(this, returnKey.TypeRef);
                if (invokeMethod.ReturnsByRef)
                    trapFile.type_annotation(this, Kinds.TypeAnnotation.Ref);
                if (invokeMethod.ReturnsByRefReadonly)
                    trapFile.type_annotation(this, Kinds.TypeAnnotation.ReadonlyRef);
            }

            Modifier.ExtractModifiers(Context, trapFile, this, Symbol);

            if (IsSourceDeclaration && Symbol.FromSource())
            {
                var declSyntaxReferences = Symbol.DeclaringSyntaxReferences.Select(d => d.GetSyntax()).ToArray();

                var baseLists = declSyntaxReferences.OfType<ClassDeclarationSyntax>().Select(c => c.BaseList);
                baseLists = baseLists.Concat(declSyntaxReferences.OfType<InterfaceDeclarationSyntax>().Select(c => c.BaseList));
                baseLists = baseLists.Concat(declSyntaxReferences.OfType<StructDeclarationSyntax>().Select(c => c.BaseList));

                baseLists.
                    Where(bl => bl != null).
                    SelectMany(bl => bl.Types).
                    Zip(baseTypes.Where(bt => bt.Symbol.SpecialType != SpecialType.System_Object),
                        (s, t) => TypeMention.Create(Context, s.Type, this, t)).
                    Enumerate();
            }
        }

        /// <summary>
        /// Called to extract all members and nested types.
        /// This is called on each member of a namespace,
        /// in either source code or an assembly.
        /// </summary>
        public void ExtractRecursive()
        {
            foreach (var l in Symbol.DeclaringSyntaxReferences.Select(s => s.GetSyntax().GetLocation()))
            {
                Context.BindComments(this, l);
            }

            foreach (var member in Symbol.GetMembers())
            {
                switch (member.Kind)
                {
                    case SymbolKind.NamedType:
                        Create(Context, (ITypeSymbol)member).ExtractRecursive();
                        break;
                    default:
                        Context.CreateEntity(member);
                        break;
                }
            }
        }

        /// <summary>
        /// Extracts all members and nested types of this type.
        /// </summary>
        public void PopulateGenerics()
        {
            if (Symbol == null || !NeedsPopulation || !Context.ExtractGenerics(this))
                return;

            var members = new List<ISymbol>();

            foreach (var member in Symbol.GetMembers())
                members.Add(member);
            foreach (var member in Symbol.GetTypeMembers())
                members.Add(member);

            // Mono extractor puts all BASE interface members as members of the current interface.

            if (Symbol.TypeKind == TypeKind.Interface)
            {
                foreach (var baseInterface in Symbol.Interfaces)
                {
                    foreach (var member in baseInterface.GetMembers())
                        members.Add(member);
                    foreach (var member in baseInterface.GetTypeMembers())
                        members.Add(member);
                }
            }

            foreach (var member in members)
            {
                Context.CreateEntity(member);
            }

            if (Symbol.BaseType != null)
                Create(Context, Symbol.BaseType).PopulateGenerics();

            foreach (var i in Symbol.Interfaces)
            {
                Create(Context, i).PopulateGenerics();
            }
        }

        public void ExtractRecursive(TextWriter trapFile, IEntity parent)
        {
            if (Symbol.ContainingSymbol.Kind == SymbolKind.Namespace && !Symbol.ContainingNamespace.IsGlobalNamespace)
            {
                trapFile.parent_namespace_declaration(this, (NamespaceDeclaration)parent);
            }

            ExtractRecursive();
        }

        public static Type Create(Context cx, ITypeSymbol type)
        {
            type = type.DisambiguateType();
            const bool errorTypeIsNull = false;
            return type == null || (errorTypeIsNull && type.TypeKind == TypeKind.Error) ?
                NullType.Create(cx).Type : (Type)cx.CreateEntity(type);
        }

        public static AnnotatedType Create(Context cx, AnnotatedTypeSymbol type) =>
            new AnnotatedType(Create(cx, type.Symbol), type.Nullability);

        public virtual int Dimension => 0;

        public static bool IsDelegate(ITypeSymbol symbol) =>
            symbol != null && symbol.TypeKind == TypeKind.Delegate;

        /// <summary>
        /// A copy of a delegate "Invoke" method parameter used for the delgate
        /// type.
        /// </summary>
        class DelegateTypeParameter : Parameter
        {
            DelegateTypeParameter(Context cx, IParameterSymbol init, IEntity parent, Parameter original)
                : base(cx, init, parent, original) { }

            new public static DelegateTypeParameter Create(Context cx, IParameterSymbol param, IEntity parent, Parameter original = null) =>
                // We need to use a different cache key than `param` to avoid mixing up
                // `DelegateTypeParameter`s and `Parameter`s
                DelegateTypeParameterFactory.Instance.CreateEntity(cx, (typeof(DelegateTypeParameter), new SymbolEqualityWrapper(param)), (param, parent, original));

            class DelegateTypeParameterFactory : ICachedEntityFactory<(IParameterSymbol, IEntity, Parameter), DelegateTypeParameter>
            {
                public static readonly DelegateTypeParameterFactory Instance = new DelegateTypeParameterFactory();

                public DelegateTypeParameter Create(Context cx, (IParameterSymbol, IEntity, Parameter) init) =>
                    new DelegateTypeParameter(cx, init.Item1, init.Item2, init.Item3);
            }
        }

        /// <summary>
        /// Gets a reference to this type, if the type
        /// is defined in another assembly.
        /// </summary>
        public virtual Type TypeRef => this;

        public virtual IEnumerable<Type> TypeMentions
        {
            get
            {
                yield break;
            }
        }

        public override TrapStackBehaviour TrapStackBehaviour => TrapStackBehaviour.NoLabel;

        public override bool Equals(object obj)
        {
            var other = obj as Type;
            return other?.GetType() == GetType() && SymbolEqualityComparer.IncludeNullability.Equals(other.Symbol, Symbol);
        }

        public override int GetHashCode() => SymbolEqualityComparer.IncludeNullability.GetHashCode(Symbol);
    }

    abstract class Type<T> : Type where T : ITypeSymbol
    {
        public Type(Context cx, T init)
            : base(cx, init) { }

        public new T Symbol => (T)base.Symbol;
    }
}
