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
                Context.Extractor.MissingType(symbol.ToString());
                return;
            }

            trapFile.typeref_type((TypeRef)TypeRef, this);

            if (symbol.IsGenericType)
            {
                if (symbol.IsBoundNullable())
                {
                    // An instance of Nullable<T>
                    trapFile.nullable_underlying_type(this, Create(Context, symbol.TypeArguments[0]).TypeRef);
                }
                else if (symbol.IsReallyUnbound())
                {
                    trapFile.is_generic(this);

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
                    trapFile.is_constructed(this);
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
            symbol.BuildTypeId(Context, trapFile, (cx0, tb0, sub, _) => tb0.WriteSubId(Create(cx0, sub)), TypeIdentifierContext.TypeName, symbol);
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

        public override Type TypeRef => Entities.TypeRef.Create(Context, this, symbol);
    }

    class TypeRef : Type<ITypeSymbol>
    {
        readonly Type referencedType;

        public TypeRef(Context cx, Type type, ITypeSymbol symbol) : base(cx, symbol)
        {
            referencedType = type;
        }

        public static TypeRef Create(Context cx, Type referencedType, ITypeSymbol type) =>
            NamedTypeRefFactory.Instance.CreateEntity2(cx, (referencedType, type));

        class NamedTypeRefFactory : ICachedEntityFactory<(Type, ITypeSymbol), TypeRef>
        {
            public static readonly NamedTypeRefFactory Instance = new NamedTypeRefFactory();

            public TypeRef Create(Context cx, (Type, ITypeSymbol) init) => new TypeRef(cx, init.Item1, init.Item2);
        }

        public override bool NeedsPopulation => true;

        public override void WriteId(TextWriter trapFile)
        {
            void ExpandType(Context cx0, TextWriter tb0, ITypeSymbol sub, ISymbol gc)
            {
                sub.BuildTypeId(cx0, tb0, ExpandType, TypeIdentifierContext.TypeRef, gc);
            }

            symbol.BuildTypeId(Context, trapFile, ExpandType, TypeIdentifierContext.TypeRef, symbol);
            trapFile.Write(";typeref");
        }

        public override void Populate(TextWriter trapFile)
        {
            trapFile.typerefs(this, symbol.Name);
        }
    };
}
