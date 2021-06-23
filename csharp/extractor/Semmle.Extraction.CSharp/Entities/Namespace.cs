using System.IO;
using Microsoft.CodeAnalysis;

namespace Semmle.Extraction.CSharp.Entities
{
    internal sealed class Namespace : CachedEntity<INamespaceSymbol>
    {
        private Namespace(Context cx, INamespaceSymbol init)
            : base(cx, init) { }

        public override Location? ReportingLocation => null;

        public override void Populate(TextWriter trapFile)
        {
            trapFile.namespaces(this, Symbol.Name);

            if (Symbol.ContainingNamespace is not null)
            {
                var parent = Create(Context, Symbol.ContainingNamespace);
                trapFile.parent_namespace(this, parent);
            }
        }

        public override bool NeedsPopulation => true;

        public override void WriteId(EscapingTextWriter trapFile)
        {
            if (!Symbol.IsGlobalNamespace)
            {
                trapFile.WriteSubId(Create(Context, Symbol.ContainingNamespace));
                trapFile.Write('.');
                trapFile.Write(Symbol.Name);
            }
            trapFile.Write(";namespace");
        }

        public static Namespace Create(Context cx, INamespaceSymbol ns) => NamespaceFactory.Instance.CreateEntityFromSymbol(cx, ns);

        private class NamespaceFactory : CachedEntityFactory<INamespaceSymbol, Namespace>
        {
            public static NamespaceFactory Instance { get; } = new NamespaceFactory();

            public override Namespace Create(Context cx, INamespaceSymbol init) => new Namespace(cx, init);
        }

        public override int GetHashCode() => QualifiedName.GetHashCode();

        private string QualifiedName => Symbol.ToDisplayString();

        public override bool Equals(object? obj)
        {
            return obj is Namespace ns && QualifiedName == ns.QualifiedName;
        }
    }
}
