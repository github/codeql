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
    class NamedType : Type<INamedTypeSymbol>
    {
        NamedType(Context cx, INamedTypeSymbol init)
            : base(cx, init)
        {
            typeArgumentsLazy = new Lazy<Type[]>(() => symbol.TypeArguments.Select(t => Create(cx, t)).ToArray());
        }

        public static NamedType Create(Context cx, INamedTypeSymbol type) => NamedTypeFactory.Instance.CreateEntity(cx, type);

        public override bool NeedsPopulation => base.NeedsPopulation || symbol.TypeKind == TypeKind.Error;

        public override void Populate(TextWriter trapFile)
        {
            if (symbol.TypeKind == TypeKind.Error)
            {
                Context.Extractor.MissingType(symbol.ToString(), Context.FromSource);
                return;
            }

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
                    for (int i = 0; i < symbol.TypeParameters.Length; ++i)
                    {
                        TypeParameter.Create(Context, symbol.TypeParameters[i]);
                        var param = symbol.TypeParameters[i];
                        var typeParameter = TypeParameter.Create(Context, param);
                        trapFile.type_parameters(typeParameter, i, this);
                    }
                }
                else
                {
                    trapFile.constructed_generic(this, Type.Create(Context, symbol.ConstructedFrom).TypeRef);

                    for (int i = 0; i < symbol.TypeArguments.Length; ++i)
                    {
                        trapFile.type_arguments(TypeArguments[i].TypeRef, i, this);
                    }
                }
            }

            PopulateType(trapFile);

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

        readonly Lazy<Type[]> typeArgumentsLazy;
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

        static IEnumerable<Microsoft.CodeAnalysis.Location> GetLocations(INamedTypeSymbol type)
        {
            return type.Locations.
                Where(l => l.IsInMetadata).
                Concat(
                    type.
                    DeclaringSyntaxReferences.
                    Select(loc => loc.GetSyntax()).
                    OfType<CSharpSyntaxNode>().
                    Select(l => l.FixedLocation())
                );
        }

        public override Microsoft.CodeAnalysis.Location ReportingLocation => GetLocations(symbol).FirstOrDefault();

        public override void WriteId(TextWriter trapFile)
        {
            symbol.BuildTypeId(Context, trapFile, (cx0, tb0, sub) => tb0.WriteSubId(Create(cx0, sub)));
            trapFile.Write(";type");
        }

        /// <summary>
        /// Returns the element type in an Enumerable/IEnumerable
        /// </summary>
        /// <param name="cx">Extraction context.</param>
        /// <param name="type">The enumerable type.</param>
        /// <returns>The element type, or null.</returns>
        static AnnotatedTypeSymbol GetElementType(Context cx, INamedTypeSymbol type)
        {
            var et = GetEnumerableType(cx, type);
            if (et.Symbol != null) return et;

            return type.AllInterfaces.
                        Where(i => i.OriginalDefinition.SpecialType == SpecialType.System_Collections_Generic_IEnumerable_T).
                        Concat(type.AllInterfaces.Where(i => i.SpecialType == SpecialType.System_Collections_IEnumerable)).
                        Select(i => GetEnumerableType(cx, i)).
                        FirstOrDefault();
        }

        static AnnotatedTypeSymbol GetEnumerableType(Context cx, INamedTypeSymbol type)
        {
            return type.SpecialType == SpecialType.System_Collections_IEnumerable ?
                    cx.Compilation.ObjectType.WithAnnotation(NullableAnnotation.NotAnnotated) :
                    type.OriginalDefinition.SpecialType == SpecialType.System_Collections_Generic_IEnumerable_T ?
                    type.GetAnnotatedTypeArguments().First() :
                    default(AnnotatedTypeSymbol);
        }

        public override AnnotatedType ElementType => Type.Create(Context, GetElementType(Context, symbol));

        class NamedTypeFactory : ICachedEntityFactory<INamedTypeSymbol, NamedType>
        {
            public static readonly NamedTypeFactory Instance = new NamedTypeFactory();

            public NamedType Create(Context cx, INamedTypeSymbol init) => new NamedType(cx, init);
        }

        public override Type TypeRef => NamedTypeRef.Create(Context, symbol);
    }

    class NamedTypeRef : Type<INamedTypeSymbol>
    {
        readonly Type referencedType;

        public NamedTypeRef(Context cx, INamedTypeSymbol symbol) : base(cx, symbol)
        {
            referencedType = Type.Create(cx, symbol);
        }

        public static NamedTypeRef Create(Context cx, INamedTypeSymbol type) =>
            NamedTypeRefFactory.Instance.CreateEntity2(cx, type);

        class NamedTypeRefFactory : ICachedEntityFactory<INamedTypeSymbol, NamedTypeRef>
        {
            public static readonly NamedTypeRefFactory Instance = new NamedTypeRefFactory();

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
