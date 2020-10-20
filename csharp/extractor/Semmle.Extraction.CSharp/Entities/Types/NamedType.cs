using Microsoft.CodeAnalysis;
using Microsoft.CodeAnalysis.CSharp;
using Semmle.Extraction.CSharp.Populators;
using Semmle.Extraction.Entities;
using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;

namespace Semmle.Extraction.CSharp.Entities
{
    internal class NamedType : Type<INamedTypeSymbol>
    {
        private NamedType(Context cx, INamedTypeSymbol init, bool constructUnderlyingTupleType)
            : base(cx, init)
        {
            typeArgumentsLazy = new Lazy<Type[]>(() => symbol.TypeArguments.Select(t => Create(cx, t)).ToArray());
            this.constructUnderlyingTupleType = constructUnderlyingTupleType;
        }

        public static NamedType Create(Context cx, INamedTypeSymbol type) =>
            NamedTypeFactory.Instance.CreateEntityFromSymbol(cx, type);

        /// <summary>
        /// Creates a named type entity from a tuple type. Unlike `Create`, this
        /// will create an entity for the underlying `System.ValueTuple` struct.
        /// For example, `(int, string)` will result in an entity for
        /// `System.ValueTuple<int, string>`.
        /// </summary>
        public static NamedType CreateNamedTypeFromTupleType(Context cx, INamedTypeSymbol type) =>
            UnderlyingTupleTypeFactory.Instance.CreateEntity(cx, (new SymbolEqualityWrapper(type), typeof(TupleType)), type);

        public override bool NeedsPopulation => base.NeedsPopulation || symbol.TypeKind == TypeKind.Error;

        public override void Populate(TextWriter trapFile)
        {
            if (symbol.TypeKind == TypeKind.Error)
            {
                Context.Extractor.MissingType(symbol.ToString(), Context.FromSource);
                return;
            }

            if (UsesTypeRef)
                trapFile.typeref_type((NamedTypeRef)TypeRef, this);

            if (symbol.IsGenericType)
            {
                if (symbol.IsBoundNullable())
                {
                    // An instance of Nullable<T>
                    trapFile.nullable_underlying_type(this, Create(Context, symbol.TypeArguments[0]).TypeRef);
                }
                else if (symbol.IsReallyUnbound())
                {
                    for (var i = 0; i < symbol.TypeParameters.Length; ++i)
                    {
                        TypeParameter.Create(Context, symbol.TypeParameters[i]);
                        var param = symbol.TypeParameters[i];
                        var typeParameter = TypeParameter.Create(Context, param);
                        trapFile.type_parameters(typeParameter, i, this);
                    }
                }
                else
                {
                    var unbound = constructUnderlyingTupleType
                        ? CreateNamedTypeFromTupleType(Context, symbol.ConstructedFrom)
                        : Type.Create(Context, symbol.ConstructedFrom);
                    trapFile.constructed_generic(this, unbound.TypeRef);

                    for (var i = 0; i < symbol.TypeArguments.Length; ++i)
                    {
                        trapFile.type_arguments(TypeArguments[i].TypeRef, i, this);
                    }
                }
            }

            PopulateType(trapFile, constructUnderlyingTupleType);

            if (symbol.EnumUnderlyingType != null)
            {
                trapFile.enum_underlying_type(this, Type.Create(Context, symbol.EnumUnderlyingType).TypeRef);
            }

            // Class location
            if (!symbol.IsGenericType || symbol.IsReallyUnbound())
            {
                foreach (var l in Locations)
                    trapFile.type_location(this, l);
            }
        }

        private readonly Lazy<Type[]> typeArgumentsLazy;
        private readonly bool constructUnderlyingTupleType;

        public Type[] TypeArguments => typeArgumentsLazy.Value;

        public override IEnumerable<Type> TypeMentions => TypeArguments;

        public override IEnumerable<Extraction.Entities.Location> Locations
        {
            get
            {
                foreach (var l in GetLocations(symbol))
                    yield return Context.Create(l);

                if (Context.Extractor.OutputPath != null && symbol.DeclaringSyntaxReferences.Any())
                    yield return Assembly.CreateOutputAssembly(Context);
            }
        }

        private static IEnumerable<Microsoft.CodeAnalysis.Location> GetLocations(INamedTypeSymbol type)
        {
            return type.Locations
                .Where(l => l.IsInMetadata)
                .Concat(type.DeclaringSyntaxReferences
                    .Select(loc => loc.GetSyntax())
                    .OfType<CSharpSyntaxNode>()
                    .Select(l => l.FixedLocation())
                );
        }

        public override Microsoft.CodeAnalysis.Location ReportingLocation => GetLocations(symbol).FirstOrDefault();

        private bool IsAnonymousType() => symbol.IsAnonymousType || symbol.Name.Contains("__AnonymousType");

        public override void WriteId(TextWriter trapFile)
        {
            if (IsAnonymousType())
            {
                trapFile.Write('*');
            }
            else
            {
                symbol.BuildTypeId(Context, trapFile, symbol, constructUnderlyingTupleType);
                trapFile.Write(";type");
            }
        }

        public override void WriteQuotedId(TextWriter trapFile)
        {
            if (IsAnonymousType())
                trapFile.Write('*');
            else
                base.WriteQuotedId(trapFile);
        }

        /// <summary>
        /// Returns the element type in an Enumerable/IEnumerable
        /// </summary>
        /// <param name="cx">Extraction context.</param>
        /// <param name="type">The enumerable type.</param>
        /// <returns>The element type, or null.</returns>
        private static AnnotatedTypeSymbol GetElementType(Context cx, INamedTypeSymbol type)
        {
            var et = GetEnumerableType(cx, type);
            if (et.Symbol != null)
                return et;

            return type.AllInterfaces
                .Where(i => i.OriginalDefinition.SpecialType == SpecialType.System_Collections_Generic_IEnumerable_T)
                .Concat(type.AllInterfaces.Where(i => i.SpecialType == SpecialType.System_Collections_IEnumerable))
                .Select(i => GetEnumerableType(cx, i))
                .FirstOrDefault();
        }

        private static AnnotatedTypeSymbol GetEnumerableType(Context cx, INamedTypeSymbol type)
        {
            return type.SpecialType == SpecialType.System_Collections_IEnumerable
                ? cx.Compilation.ObjectType.WithAnnotation(NullableAnnotation.NotAnnotated)
                : type.OriginalDefinition.SpecialType == SpecialType.System_Collections_Generic_IEnumerable_T
                    ? type.GetAnnotatedTypeArguments().First()
                    : default(AnnotatedTypeSymbol);
        }

        public override AnnotatedType ElementType => Type.Create(Context, GetElementType(Context, symbol));

        private class NamedTypeFactory : ICachedEntityFactory<INamedTypeSymbol, NamedType>
        {
            public static NamedTypeFactory Instance { get; } = new NamedTypeFactory();

            public NamedType Create(Context cx, INamedTypeSymbol init) => new NamedType(cx, init, false);
        }

        private class UnderlyingTupleTypeFactory : ICachedEntityFactory<INamedTypeSymbol, NamedType>
        {
            public static UnderlyingTupleTypeFactory Instance { get; } = new UnderlyingTupleTypeFactory();

            public NamedType Create(Context cx, INamedTypeSymbol init) => new NamedType(cx, init, true);
        }

        // Do not create typerefs of constructed generics as they are always in the current trap file.
        // Create typerefs for constructed error types in case they are fully defined elsewhere.
        // We cannot use `!this.NeedsPopulation` because this would not be stable as it would depend on
        // the assembly that was being extracted at the time.
        private bool UsesTypeRef => symbol.TypeKind == TypeKind.Error || SymbolEqualityComparer.Default.Equals(symbol.OriginalDefinition, symbol);

        public override Type TypeRef => UsesTypeRef ? (Type)NamedTypeRef.Create(Context, symbol) : this;
    }

    internal class NamedTypeRef : Type<INamedTypeSymbol>
    {
        private readonly Type referencedType;

        public NamedTypeRef(Context cx, INamedTypeSymbol symbol) : base(cx, symbol)
        {
            referencedType = Type.Create(cx, symbol);
        }

        public static NamedTypeRef Create(Context cx, INamedTypeSymbol type) =>
            // We need to use a different cache key than `type` to avoid mixing up
            // `NamedType`s and `NamedTypeRef`s
            NamedTypeRefFactory.Instance.CreateEntity(cx, (typeof(NamedTypeRef), new SymbolEqualityWrapper(type)), type);

        private class NamedTypeRefFactory : ICachedEntityFactory<INamedTypeSymbol, NamedTypeRef>
        {
            public static NamedTypeRefFactory Instance { get; } = new NamedTypeRefFactory();

            public NamedTypeRef Create(Context cx, INamedTypeSymbol init) => new NamedTypeRef(cx, init);
        }

        public override bool NeedsPopulation => true;

        public override void WriteId(TextWriter trapFile)
        {
            trapFile.WriteSubId(referencedType);
            trapFile.Write(";typeRef");
        }

        public override void Populate(TextWriter trapFile)
        {
            trapFile.typerefs(this, symbol.Name);
        }
    };
}
