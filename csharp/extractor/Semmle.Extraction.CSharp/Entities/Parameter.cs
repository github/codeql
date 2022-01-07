using Microsoft.CodeAnalysis;
using Semmle.Extraction.CSharp.Populators;
using System.Linq;
using Microsoft.CodeAnalysis.CSharp.Syntax;
using Semmle.Extraction.Entities;
using System.IO;
using System;

namespace Semmle.Extraction.CSharp.Entities
{
    internal class Parameter : CachedSymbol<IParameterSymbol>, IExpressionParentEntity
    {
        protected IEntity? Parent { get; set; }
        protected Parameter Original { get; }

        protected Parameter(Context cx, IParameterSymbol init, IEntity? parent, Parameter? original)
            : base(cx, init)
        {
            Parent = parent;
            Original = original ?? this;
        }

        public override Microsoft.CodeAnalysis.Location ReportingLocation => Symbol.GetSymbolLocation();

        public enum Kind
        {
            None, Ref, Out, Params, This, In
        }

        protected virtual int Ordinal => Symbol.Ordinal;

        private Kind ParamKind
        {
            get
            {
                switch (Symbol.RefKind)
                {
                    case RefKind.Out:
                        return Kind.Out;
                    case RefKind.Ref:
                        return Kind.Ref;
                    case RefKind.In:
                        return Kind.In;
                    default:
                        if (Symbol.IsParams)
                            return Kind.Params;

                        if (Ordinal == 0)
                        {
                            if (Symbol.ContainingSymbol is IMethodSymbol method && method.IsExtensionMethod)
                                return Kind.This;
                        }
                        return Kind.None;
                }
            }
        }

        public static Parameter Create(Context cx, IParameterSymbol param, IEntity parent, Parameter? original = null)
        {
            var cachedSymbol = cx.GetPossiblyCachedParameterSymbol(param);
            return ParameterFactory.Instance.CreateEntity(cx, cachedSymbol, (cachedSymbol, parent, original));
        }

        public static Parameter Create(Context cx, IParameterSymbol param)
        {
            var cachedSymbol = cx.GetPossiblyCachedParameterSymbol(param);
            return ParameterFactory.Instance.CreateEntity(cx, cachedSymbol, (cachedSymbol, null, null));
        }

        public override void WriteId(EscapingTextWriter trapFile)
        {
            if (Parent is null)
                Parent = Method.Create(Context, Symbol.ContainingSymbol as IMethodSymbol);

            if (Parent is null)
                throw new InternalError(Symbol, "Couldn't get parent of symbol.");

            trapFile.WriteSubId(Parent);
            trapFile.Write('_');
            trapFile.Write(Ordinal);
            trapFile.Write(";parameter");
        }

        public override bool NeedsPopulation => true;

        private string Name
        {
            get
            {
                // Very rarely, two parameters have the same name according to the data model.
                // This breaks our database constraints.
                // Generate an impossible name to ensure that it doesn't conflict.
                var conflictingCount = Symbol.ContainingSymbol.GetParameters().Count(p => p.Ordinal < Symbol.Ordinal && p.Name == Symbol.Name);
                return conflictingCount > 0 ? Symbol.Name + "`" + conflictingCount : Symbol.Name;
            }
        }

        public override void Populate(TextWriter trapFile)
        {
            PopulateAttributes();
            PopulateNullability(trapFile, Symbol.GetAnnotatedType());
            PopulateRefKind(trapFile, Symbol.RefKind);

            if (Symbol.Name != Original.Symbol.Name)
                Context.ModelError(Symbol, "Inconsistent parameter declaration");

            var type = Type.Create(Context, Symbol.Type);
            trapFile.@params(this, Name, type.TypeRef, Ordinal, ParamKind, Parent!, Original);

            foreach (var l in Symbol.Locations)
                trapFile.param_location(this, Context.CreateLocation(l));

            if (!Symbol.Locations.Any() &&
                Symbol.ContainingSymbol is IMethodSymbol ms &&
                ms.Name == WellKnownMemberNames.TopLevelStatementsEntryPointMethodName &&
                ms.ContainingType.Name == WellKnownMemberNames.TopLevelStatementsEntryPointTypeName)
            {
                trapFile.param_location(this, Context.CreateLocation());
            }

            if (Symbol.HasExplicitDefaultValue && Context.Defines(Symbol))
            {
                var defaultValueSyntax = GetDefaultValueFromSyntax(Symbol);

                Action defaultValueExpressionCreation = defaultValueSyntax is not null
                    ? () => Expression.Create(Context, defaultValueSyntax.Value, this, 0)
                    : () => Expression.CreateGenerated(Context, Symbol, this, 0, Location);

                Context.PopulateLater(defaultValueExpressionCreation);
            }

            if (!IsSourceDeclaration || !Symbol.FromSource())
                return;

            BindComments();

            if (IsSourceDeclaration)
            {
                foreach (var syntax in Symbol.DeclaringSyntaxReferences
                    .Select(d => d.GetSyntax())
                    .OfType<ParameterSyntax>()
                    .Where(s => s.Type is not null))
                {
                    TypeMention.Create(Context, syntax.Type!, this, type);
                }
            }
        }

        private static EqualsValueClauseSyntax? GetDefaultValueFromSyntax(IParameterSymbol symbol)
        {
            // This is a slight bug in the dbscheme
            // We should really define param_default(param, string)
            // And use parameter child #0 to encode the default expression.
            var defaultValue = GetParameterDefaultValue(symbol);
            if (defaultValue is null)
            {
                // In case this parameter belongs to an accessor of an indexer, we need
                // to get the default value from the corresponding parameter belonging
                // to the indexer itself
                if (symbol.ContainingSymbol is IMethodSymbol method)
                {
                    var i = method.Parameters.IndexOf(symbol);
                    if (method.AssociatedSymbol is IPropertySymbol indexer)
                        defaultValue = GetParameterDefaultValue(indexer.Parameters[i]);
                }
            }

            return defaultValue;
        }

        public override bool IsSourceDeclaration => Symbol.IsSourceDeclaration();

        bool IExpressionParentEntity.IsTopLevelParent => true;

        private static EqualsValueClauseSyntax? GetParameterDefaultValue(IParameterSymbol parameter)
        {
            var syntax = parameter.DeclaringSyntaxReferences.Select(@ref => @ref.GetSyntax()).OfType<ParameterSyntax>().FirstOrDefault();
            return syntax?.Default;
        }

        private class ParameterFactory : CachedEntityFactory<(IParameterSymbol, IEntity?, Parameter?), Parameter>
        {
            public static ParameterFactory Instance { get; } = new ParameterFactory();

            public override Parameter Create(Context cx, (IParameterSymbol, IEntity?, Parameter?) init) => new Parameter(cx, init.Item1, init.Item2, init.Item3);
        }

        public override TrapStackBehaviour TrapStackBehaviour => TrapStackBehaviour.OptionalLabel;
    }

    internal class VarargsType : Type
    {
        private VarargsType(Context cx)
            : base(cx, null) { }

        public override void Populate(TextWriter trapFile)
        {
            trapFile.types(this, Kinds.TypeKind.ARGLIST, "__arglist");
            trapFile.parent_namespace(this, Namespace.Create(Context, Context.Compilation.GlobalNamespace));
            Modifier.HasModifier(Context, trapFile, this, "public");
        }

        public override bool NeedsPopulation => true;

        public override void WriteId(EscapingTextWriter trapFile)
        {
            trapFile.Write("__arglist;type");
        }

        public override int GetHashCode()
        {
            return 98735267;
        }

        public override bool Equals(object? obj)
        {
            return obj is not null && obj.GetType() == typeof(VarargsType);
        }

        public static VarargsType Create(Context cx) => VarargsTypeFactory.Instance.CreateEntity(cx, typeof(VarargsType), null);

        private class VarargsTypeFactory : CachedEntityFactory<string?, VarargsType>
        {
            public static VarargsTypeFactory Instance { get; } = new VarargsTypeFactory();

            public override VarargsType Create(Context cx, string? init) => new VarargsType(cx);
        }
    }

    internal class VarargsParam : Parameter
    {
#nullable disable warnings
        private VarargsParam(Context cx, Method methodKey)
            : base(cx, null, methodKey, null) { }
#nullable restore warnings

        public override void Populate(TextWriter trapFile)
        {
            var typeKey = VarargsType.Create(Context);
            // !! Maybe originaldefinition is wrong
            trapFile.@params(this, "", typeKey, Ordinal, Kind.None, Parent!, this);
            trapFile.param_location(this, GeneratedLocation.Create(Context));
        }

        protected override int Ordinal => ((Method)Parent!).OriginalDefinition.Symbol.Parameters.Length;

        public override int GetHashCode()
        {
            return 9873567;
        }

        public override bool Equals(object? obj)
        {
            return obj is not null && obj.GetType() == typeof(VarargsParam);
        }

        public static VarargsParam Create(Context cx, Method method) => VarargsParamFactory.Instance.CreateEntity(cx, typeof(VarargsParam), method);

        private class VarargsParamFactory : CachedEntityFactory<Method, VarargsParam>
        {
            public static VarargsParamFactory Instance { get; } = new VarargsParamFactory();

            public override VarargsParam Create(Context cx, Method init) => new VarargsParam(cx, init);
        }
    }
}
