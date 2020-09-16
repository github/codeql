using System.IO;
using Microsoft.CodeAnalysis;

namespace Semmle.Extraction.CSharp.Entities
{
    sealed class Namespace : CachedEntity<INamespaceSymbol>
    {
        Namespace(Context cx, INamespaceSymbol init)
            : base(cx, init) { }

        public override Microsoft.CodeAnalysis.Location ReportingLocation => null;

        public override void Populate(TextWriter trapFile)
        {
            trapFile.namespaces(this, Symbol.Name);

            if (Symbol.ContainingNamespace != null)
            {
                var parent = Create(Context, Symbol.ContainingNamespace);
                trapFile.parent_namespace(this, parent);
            }
        }

        public override bool NeedsPopulation => true;

        public override void WriteId(TextWriter trapFile)
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

        class NamespaceFactory : ICachedEntityFactory<INamespaceSymbol, Namespace>
        {
            public static readonly NamespaceFactory Instance = new NamespaceFactory();

            public Namespace Create(Context cx, INamespaceSymbol init) => new Namespace(cx, init);
        }

        public override TrapStackBehaviour TrapStackBehaviour => TrapStackBehaviour.NoLabel;

        public override int GetHashCode() => QualifiedName.GetHashCode();

        string QualifiedName => Symbol.ToDisplayString();

        public override bool Equals(object obj)
        {
            return obj is Namespace ns && QualifiedName == ns.QualifiedName;
        }
    }
}
