using System.IO;
using Microsoft.CodeAnalysis;

namespace Semmle.Extraction.CSharp.Entities
{
    internal sealed class Namespace : CachedEntity<INamespaceSymbol>
    {
        private Namespace(Context cx, INamespaceSymbol init)
            : base(cx, init) { }

        public override Microsoft.CodeAnalysis.Location ReportingLocation => null;

        public override void Populate(TextWriter trapFile)
        {
            trapFile.namespaces(this, symbol.Name);

            if (symbol.ContainingNamespace != null)
            {
                var parent = Create(Context, symbol.ContainingNamespace);
                trapFile.parent_namespace(this, parent);
            }
        }

        public override bool NeedsPopulation => true;

        public override void WriteId(TextWriter trapFile)
        {
            if (!symbol.IsGlobalNamespace)
            {
                trapFile.WriteSubId(Create(Context, symbol.ContainingNamespace));
                trapFile.Write('.');
                trapFile.Write(symbol.Name);
            }
            trapFile.Write(";namespace");
        }

        public static Namespace Create(Context cx, INamespaceSymbol ns) => NamespaceFactory.Instance.CreateEntityFromSymbol(cx, ns);

        private class NamespaceFactory : ICachedEntityFactory<INamespaceSymbol, Namespace>
        {
            public static NamespaceFactory Instance { get; } = new NamespaceFactory();

            public Namespace Create(Context cx, INamespaceSymbol init) => new Namespace(cx, init);
        }

        public override TrapStackBehaviour TrapStackBehaviour => TrapStackBehaviour.NoLabel;

        public override int GetHashCode() => QualifiedName.GetHashCode();

        private string QualifiedName => symbol.ToDisplayString();

        public override bool Equals(object obj)
        {
            return obj is Namespace ns && QualifiedName == ns.QualifiedName;
        }
    }
}
