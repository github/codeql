using Microsoft.CodeAnalysis;
using Microsoft.CodeAnalysis.CSharp;
using Microsoft.CodeAnalysis.CSharp.Syntax;
using Semmle.Extraction.Entities;
using System.IO;

namespace Semmle.Extraction.CSharp.Entities
{
    class UsingDirective : FreshEntity
    {
        readonly UsingDirectiveSyntax Node;
        readonly NamespaceDeclaration Parent;

        public UsingDirective(Context cx, UsingDirectiveSyntax usingDirective, NamespaceDeclaration parent)
            : base(cx)
        {
            Node = usingDirective;
            Parent = parent;
            TryPopulate();
        }

        protected override void Populate(TextWriter trapFile)
        {
            var info = cx.GetModel(Node).GetSymbolInfo(Node.Name);

            if (Node.StaticKeyword.Kind() == SyntaxKind.None)
            {
                // A normal using
                var namespaceSymbol = info.Symbol as INamespaceSymbol;

                if (namespaceSymbol == null)
                {
                    cx.Extractor.MissingNamespace(Node.Name.ToFullString(), cx.FromSource);
                    cx.ModelError(Node, "Namespace not found");
                    return;
                }
                else
                {
                    var ns = Namespace.Create(cx, namespaceSymbol);
                    trapFile.using_namespace_directives(this, ns);
                    trapFile.using_directive_location(this, cx.Create(ReportingLocation));
                }
            }
            else
            {
                // A "using static"
                Type m = Type.Create(cx, (ITypeSymbol)info.Symbol);
                trapFile.using_static_directives(this, m.TypeRef);
                trapFile.using_directive_location(this, cx.Create(ReportingLocation));
            }

            if (Parent != null)
            {
                trapFile.parent_namespace_declaration(this, Parent);
            }
        }

        public sealed override Microsoft.CodeAnalysis.Location ReportingLocation => Node.GetLocation();

        public override TrapStackBehaviour TrapStackBehaviour => TrapStackBehaviour.NoLabel;
    }
}
