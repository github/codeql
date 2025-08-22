using System.IO;
using Microsoft.CodeAnalysis;

namespace Semmle.Extraction.CSharp.Entities
{
    internal class Modifier : CachedEntity<string>
    {
        private Modifier(Context cx, string init)
            : base(cx, init) { }

        public override Microsoft.CodeAnalysis.Location? ReportingLocation => null;

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

        public static string AccessibilityModifier(Accessibility access)
        {
            return access switch
            {
                Accessibility.Private => Modifiers.Private,
                Accessibility.Protected => Modifiers.Protected,
                Accessibility.Public => Modifiers.Public,
                Accessibility.Internal => Modifiers.Internal,
                _ => throw new InternalError("Unavailable modifier combination"),
            };
        }

        public static void HasAccessibility(Context cx, TextWriter trapFile, IEntity type, Accessibility access)
        {
            switch (access)
            {
                case Accessibility.Private:
                case Accessibility.Public:
                case Accessibility.Protected:
                case Accessibility.Internal:
                    HasModifier(cx, trapFile, type, AccessibilityModifier(access));
                    break;
                case Accessibility.NotApplicable:
                    break;
                case Accessibility.ProtectedOrInternal:
                    HasModifier(cx, trapFile, type, Modifiers.Protected);
                    HasModifier(cx, trapFile, type, Modifiers.Internal);
                    break;
                case Accessibility.ProtectedAndInternal:
                    HasModifier(cx, trapFile, type, Modifiers.Protected);
                    HasModifier(cx, trapFile, type, Modifiers.Private);
                    break;
                default:
                    throw new InternalError($"Unhandled Microsoft.CodeAnalysis.Accessibility value: {access}");
            }
        }

        public static void HasModifier(Context cx, TextWriter trapFile, IEntity target, string modifier)
        {
            trapFile.has_modifiers(target, Modifier.Create(cx, modifier));
        }

        private static void ExtractFieldModifiers(Context cx, TextWriter trapFile, IEntity key, IFieldSymbol symbol)
        {
            if (symbol.IsReadOnly)
                HasModifier(cx, trapFile, key, Modifiers.Readonly);

            if (symbol.IsRequired)
                HasModifier(cx, trapFile, key, Modifiers.Required);
        }

        private static void ExtractNamedTypeModifiers(Context cx, TextWriter trapFile, IEntity key, ISymbol symbol)
        {
            if (symbol.Kind != SymbolKind.NamedType)
                return;

            if (symbol is not INamedTypeSymbol nt)
                throw new InternalError(symbol, "Symbol kind is inconsistent with its type");

            if (nt.IsRecord)
                HasModifier(cx, trapFile, key, Modifiers.Record);

            if (nt.IsFileLocal)
                HasModifier(cx, trapFile, key, Modifiers.File);

            if (nt.TypeKind == TypeKind.Struct)
            {
                if (nt.IsReadOnly)
                    HasModifier(cx, trapFile, key, Modifiers.Readonly);

                if (nt.IsRefLikeType)
                    HasModifier(cx, trapFile, key, Modifiers.Ref);
            }
        }

        public static void ExtractModifiers(Context cx, TextWriter trapFile, IEntity key, ISymbol symbol)
        {
            // A file scoped type has declared accessibility `internal` which we shouldn't extract.
            // The file modifier is extracted as a source level modifier.
            if (symbol.Kind != SymbolKind.NamedType || !((INamedTypeSymbol)symbol).IsFileLocal)
                HasAccessibility(cx, trapFile, key, symbol.DeclaredAccessibility);

            if (symbol.Kind == SymbolKind.ErrorType)
                trapFile.has_modifiers(key, Modifier.Create(cx, Accessibility.Public));

            if (symbol.IsAbstract && (symbol.Kind != SymbolKind.NamedType || ((INamedTypeSymbol)symbol).TypeKind != TypeKind.Interface))
                HasModifier(cx, trapFile, key, Modifiers.Abstract);

            if (symbol.IsSealed)
                HasModifier(cx, trapFile, key, Modifiers.Sealed);

            var fromSource = symbol.DeclaringSyntaxReferences.Length > 0;

            if (symbol.IsStatic && !(symbol.Kind == SymbolKind.Field && ((IFieldSymbol)symbol).IsConst && !fromSource))
                HasModifier(cx, trapFile, key, Modifiers.Static);

            if (symbol.IsVirtual)
                HasModifier(cx, trapFile, key, Modifiers.Virtual);

            if (symbol is IFieldSymbol field)
                ExtractFieldModifiers(cx, trapFile, key, field);

            if (symbol.Kind == SymbolKind.Property && ((IPropertySymbol)symbol).IsRequired)
                HasModifier(cx, trapFile, key, Modifiers.Required);

            if (symbol.IsOverride)
                HasModifier(cx, trapFile, key, Modifiers.Override);

            if (symbol.Kind == SymbolKind.Method && ((IMethodSymbol)symbol).IsAsync)
                HasModifier(cx, trapFile, key, Modifiers.Async);

            if (symbol.IsExtern)
                HasModifier(cx, trapFile, key, Modifiers.Extern);

            foreach (var modifier in symbol.GetSourceLevelModifiers())
                HasModifier(cx, trapFile, key, modifier);

            ExtractNamedTypeModifiers(cx, trapFile, key, symbol);
        }

        public static Modifier Create(Context cx, string modifier)
        {
            return ModifierFactory.Instance.CreateEntity(cx, (typeof(Modifier), modifier), modifier);
        }

        public static Modifier Create(Context cx, Accessibility access)
        {
            var modifier = AccessibilityModifier(access);
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
