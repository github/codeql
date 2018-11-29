using Microsoft.CodeAnalysis;
using Microsoft.CodeAnalysis.CSharp.Syntax;
using Semmle.Extraction.CSharp.Populators;
using Semmle.Util;
using System;
using System.Collections.Generic;
using System.Linq;

namespace Semmle.Extraction.CSharp.Entities
{
    public abstract class Type : CachedSymbol<ITypeSymbol>
    {
        public Type(Context cx, ITypeSymbol init)
            : base(cx, init) { }

        public virtual Type ElementType => null;

        public override bool NeedsPopulation =>
            base.NeedsPopulation || symbol.TypeKind == TypeKind.Dynamic || symbol.TypeKind == TypeKind.TypeParameter;

        public static bool ConstructedOrParentIsConstructed(INamedTypeSymbol symbol)
        {
            return !Equals(symbol, symbol.OriginalDefinition) ||
                symbol.ContainingType != null && ConstructedOrParentIsConstructed(symbol.ContainingType);
        }

        static Kinds.TypeKind GetClassType(Context cx, ITypeSymbol t)
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
                            return ((INamedTypeSymbol)t).IsTupleType ? Kinds.TypeKind.TUPLE : Kinds.TypeKind.STRUCT;
                        case TypeKind.Interface: return Kinds.TypeKind.INTERFACE;
                        case TypeKind.Array: return Kinds.TypeKind.ARRAY;
                        case TypeKind.Enum: return Kinds.TypeKind.ENUM;
                        case TypeKind.Delegate: return Kinds.TypeKind.DELEGATE;
                        case TypeKind.Pointer: return Kinds.TypeKind.POINTER;
                        default:
                            cx.ModelError(t, "Unhandled type kind '{0}'", t.TypeKind);
                            return Kinds.TypeKind.UNKNOWN;
                    }
            }
        }

        class DisplayNameTrapBuilder : ITrapBuilder
        {
            public readonly List<string> Fragments = new List<string>();

            public ITrapBuilder Append(object arg)
            {
                Fragments.Add(arg.ToString());
                return this;
            }

            public ITrapBuilder Append(string arg)
            {
                Fragments.Add(arg);
                return this;
            }

            public ITrapBuilder AppendLine()
            {
                throw new NotImplementedException();
            }
        }

        protected void ExtractType()
        {
            ExtractMetadataHandle();
            ExtractAttributes();

            var tb = new DisplayNameTrapBuilder();
            symbol.BuildDisplayName(Context, tb);
            Context.Emit(Tuples.types(this, GetClassType(Context, symbol), tb.Fragments.ToArray()));

            // Visit base types
            var baseTypes = new List<Type>();
            if (symbol.BaseType != null)
            {
                Type baseKey = Create(Context, symbol.BaseType);
                Context.Emit(Tuples.extend(this, baseKey.TypeRef));
                if (symbol.TypeKind != TypeKind.Struct)
                    baseTypes.Add(baseKey);
            }

            if (base.symbol.TypeKind == TypeKind.Interface)
            {
                Context.Emit(Tuples.extend(this, Create(Context, Context.Compilation.ObjectType)));
            }

            if (!(base.symbol is IArrayTypeSymbol))
            {
                foreach (var t in base.symbol.Interfaces.Select(i=>Create(Context, i)))
                {
                    Context.Emit(Tuples.implement(this, t.TypeRef));
                    baseTypes.Add(t);
                }
            }

            var containingType = ContainingType;
            if (containingType != null && symbol.Kind != SymbolKind.TypeParameter)
            {
                Type originalDefinition = symbol.TypeKind == TypeKind.Error ? this : Create(Context, symbol.OriginalDefinition);
                Context.Emit(Tuples.nested_types(this, containingType, originalDefinition));
            }
            else if (symbol.ContainingNamespace != null)
            {
                Context.Emit(Tuples.parent_namespace(this, Namespace.Create(Context, symbol.ContainingNamespace)));
            }

            if (symbol is IArrayTypeSymbol)
            {
                // They are in the namespace of the original object
                ITypeSymbol elementType = ((IArrayTypeSymbol)symbol).ElementType;
                INamespaceSymbol ns = elementType.TypeKind == TypeKind.TypeParameter ? Context.Compilation.GlobalNamespace : elementType.ContainingNamespace;
                if (ns != null)
                    Context.Emit(Tuples.parent_namespace(this, Namespace.Create(Context, ns)));
            }

            if (symbol is IPointerTypeSymbol)
            {
                ITypeSymbol elementType = ((IPointerTypeSymbol)symbol).PointedAtType;
                INamespaceSymbol ns = elementType.TypeKind == TypeKind.TypeParameter ? Context.Compilation.GlobalNamespace : elementType.ContainingNamespace;

                if (ns != null)
                    Context.Emit(Tuples.parent_namespace(this, Namespace.Create(Context, ns)));
            }

            if (symbol.BaseType != null && symbol.BaseType.SpecialType == SpecialType.System_MulticastDelegate)
            {
                // This is a delegate.
                // The method "Invoke" has the return type.
                var invokeMethod = ((INamedTypeSymbol)symbol).DelegateInvokeMethod;

                // Copy the parameters from the "Invoke" method to the delegate type
                for (var i = 0; i < invokeMethod.Parameters.Length; ++i)
                {
                    var param = invokeMethod.Parameters[i];
                    var originalParam = invokeMethod.OriginalDefinition.Parameters[i];
                    var originalParamEntity = Equals(param, originalParam) ? null :
                        DelegateTypeParameter.Create(Context, originalParam, Create(Context, ((INamedTypeSymbol)symbol).ConstructedFrom));
                    DelegateTypeParameter.Create(Context, param, this, originalParamEntity);
                }

                var returnKey = Create(Context, invokeMethod.ReturnType);
                Context.Emit(Tuples.delegate_return_type(this, returnKey.TypeRef));
                if (invokeMethod.ReturnsByRef)
                    Context.Emit(Tuples.ref_returns(this));
                if (invokeMethod.ReturnsByRefReadonly)
                    Context.Emit(Tuples.ref_readonly_returns(this));
            }

            Modifier.ExtractModifiers(Context, this, symbol);

            if (IsSourceDeclaration && symbol.FromSource())
            {
                var declSyntaxReferences = symbol.DeclaringSyntaxReferences.Select(d => d.GetSyntax()).ToArray();

                var baseLists = declSyntaxReferences.OfType<ClassDeclarationSyntax>().Select(c => c.BaseList);
                baseLists = baseLists.Concat(declSyntaxReferences.OfType<InterfaceDeclarationSyntax>().Select(c => c.BaseList));
                baseLists = baseLists.Concat(declSyntaxReferences.OfType<StructDeclarationSyntax>().Select(c => c.BaseList));

                baseLists.
                    Where(bl => bl != null).
                    SelectMany(bl => bl.Types).
                    Zip(baseTypes.Where(bt => bt.symbol.SpecialType != SpecialType.System_Object),
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
            foreach (var l in symbol.DeclaringSyntaxReferences.Select(s => s.GetSyntax().GetLocation()))
            {
                Context.BindComments(this, l);
            }

            foreach (var member in symbol.GetMembers())
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
        public void ExtractGenerics()
        {
            if (symbol == null || !NeedsPopulation || !Context.ExtractGenerics(this))
                return;

            var members = new List<ISymbol>();

            foreach (var member in symbol.GetMembers())
                members.Add(member);
            foreach (var member in symbol.GetTypeMembers())
                members.Add(member);

            // Mono extractor puts all BASE interface members as members of the current interface.

            if (symbol.TypeKind == TypeKind.Interface)
            {
                foreach (var baseInterface in symbol.Interfaces)
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

            if (symbol.BaseType != null)
                Create(Context, symbol.BaseType).ExtractGenerics();

            foreach (var i in symbol.Interfaces)
            {
                Create(Context, i).ExtractGenerics();
            }
        }

        public void ExtractRecursive(IEntity parent)
        {
            if (symbol.ContainingSymbol.Kind == SymbolKind.Namespace && !symbol.ContainingNamespace.IsGlobalNamespace)
            {
                Context.Emit(Tuples.parent_namespace_declaration(this, (NamespaceDeclaration)parent));
            }

            ExtractRecursive();
        }

        public static Type Create(Context cx, ITypeSymbol type)
        {
            type = cx.DisambiguateType(type);
            const bool errorTypeIsNull = false;
            return type == null || (errorTypeIsNull && type.TypeKind == TypeKind.Error) ?
                NullType.Create(cx) : (Type)cx.CreateEntity(type);
        }

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
                DelegateTypeParameterFactory.Instance.CreateEntity(cx, (param, parent, original));

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
    }

    abstract class Type<T> : Type where T : ITypeSymbol
    {
        public Type(Context cx, T init)
            : base(cx, init) { }

        public new T symbol => (T)base.symbol;
    }
}
