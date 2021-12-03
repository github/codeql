using Microsoft.CodeAnalysis;
using System.IO;

namespace Semmle.Extraction.CSharp.Entities
{
    internal class Modifier : Extraction.CachedEntity<string>
    {
        private Modifier(Context cx, string init)
            : base(cx, init) { }

        public override Location? ReportingLocation => null;

        public override void WriteId(EscapingTextWriter trapFile)
        {
            trapFile.Write(Symbol);
            trapFile.Write(";modifier");
        }

        public override bool NeedsPopulation => true;

        public override void Populate(TextWriter trapFile)
        {
            trapFile.modifiers(Label, Symbol);
        }

        public static string AccessbilityModifier(Accessibility access)
        {
            switch (access)
            {
                case Accessibility.Private:
                    return "private";
                case Accessibility.Protected:
                    return "protected";
                case Accessibility.Public:
                    return "public";
                case Accessibility.Internal:
                    return "internal";
                default:
                    throw new InternalError("Unavailable modifier combination");
            }
        }

        public static void HasAccessibility(Context cx, TextWriter trapFile, IEntity type, Accessibility access)
        {
            switch (access)
            {
                case Accessibility.Private:
                case Accessibility.Public:
                case Accessibility.Protected:
                case Accessibility.Internal:
                    HasModifier(cx, trapFile, type, Modifier.AccessbilityModifier(access));
                    break;
                case Accessibility.NotApplicable:
                    break;
                case Accessibility.ProtectedOrInternal:
                    HasModifier(cx, trapFile, type, "protected");
                    HasModifier(cx, trapFile, type, "internal");
                    break;
                case Accessibility.ProtectedAndInternal:
                    HasModifier(cx, trapFile, type, "protected");
                    HasModifier(cx, trapFile, type, "private");
                    break;
                default:
                    throw new InternalError($"Unhandled Microsoft.CodeAnalysis.Accessibility value: {access}");
            }
        }

        public static void HasModifier(Context cx, TextWriter trapFile, IEntity target, string modifier)
        {
            trapFile.has_modifiers(target, Modifier.Create(cx, modifier));
        }

        public static void ExtractModifiers(Context cx, TextWriter trapFile, IEntity key, ISymbol symbol)
        {
            HasAccessibility(cx, trapFile, key, symbol.DeclaredAccessibility);
            if (symbol.Kind == SymbolKind.ErrorType)
                trapFile.has_modifiers(key, Modifier.Create(cx, Accessibility.Public));

            if (symbol.IsAbstract && (symbol.Kind != SymbolKind.NamedType || ((INamedTypeSymbol)symbol).TypeKind != TypeKind.Interface))
                HasModifier(cx, trapFile, key, "abstract");

            if (symbol.IsSealed)
                HasModifier(cx, trapFile, key, "sealed");

            var fromSource = symbol.DeclaringSyntaxReferences.Length > 0;

            if (symbol.IsStatic && !(symbol.Kind == SymbolKind.Field && ((IFieldSymbol)symbol).IsConst && !fromSource))
                HasModifier(cx, trapFile, key, "static");

            if (symbol.IsVirtual)
                HasModifier(cx, trapFile, key, "virtual");

            if (symbol.Kind == SymbolKind.Field && ((IFieldSymbol)symbol).IsReadOnly)
                HasModifier(cx, trapFile, key, "readonly");

            if (symbol.IsOverride)
                HasModifier(cx, trapFile, key, "override");

            if (symbol.Kind == SymbolKind.Method && ((IMethodSymbol)symbol).IsAsync)
                HasModifier(cx, trapFile, key, "async");

            if (symbol.IsExtern)
                HasModifier(cx, trapFile, key, "extern");

            foreach (var modifier in symbol.GetSourceLevelModifiers())
                HasModifier(cx, trapFile, key, modifier);

            if (symbol.Kind == SymbolKind.NamedType)
            {
                var nt = symbol as INamedTypeSymbol;
                if (nt is null)
                    throw new InternalError(symbol, "Symbol kind is inconsistent with its type");

                if (nt.TypeKind == TypeKind.Struct)
                {
                    if (nt.IsReadOnly)
                        HasModifier(cx, trapFile, key, "readonly");
                    if (nt.IsRefLikeType)
                        HasModifier(cx, trapFile, key, "ref");
                }
            }
        }

        public static Modifier Create(Context cx, string modifier)
        {
            return ModifierFactory.Instance.CreateEntity(cx, (typeof(Modifier), modifier), modifier);
        }

        public static Modifier Create(Context cx, Accessibility access)
        {
            var modifier = AccessbilityModifier(access);
            return ModifierFactory.Instance.CreateEntity(cx, (typeof(Modifier), modifier), modifier);
        }

        private class ModifierFactory : CachedEntityFactory<string, Modifier>
        {
            public static ModifierFactory Instance { get; } = new ModifierFactory();

            public override Modifier Create(Context cx, string init) => new Modifier(cx, init);
        }
        public override TrapStackBehaviour TrapStackBehaviour => TrapStackBehaviour.OptionalLabel;
    }
}
