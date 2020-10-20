using Microsoft.CodeAnalysis;
using Microsoft.CodeAnalysis.CSharp;
using Microsoft.CodeAnalysis.CSharp.Syntax;
using Semmle.Extraction.Entities;
using System.IO;

namespace Semmle.Extraction.CSharp.Entities
{
    internal class UsingDirective : FreshEntity
    {
        private readonly UsingDirectiveSyntax node;
        private readonly NamespaceDeclaration parent;

        public UsingDirective(Context cx, UsingDirectiveSyntax usingDirective, NamespaceDeclaration parent)
            : base(cx)
        {
            node = usingDirective;
            this.parent = parent;
            TryPopulate();
        }

        protected override void Populate(TextWriter trapFile)
        {
            var info = cx.GetModel(node).GetSymbolInfo(node.Name);

            if (node.StaticKeyword.Kind() == SyntaxKind.None)
            {
                // A normal using
                if (info.Symbol is INamespaceSymbol namespaceSymbol)
                {
                    var ns = Namespace.Create(cx, namespaceSymbol);
                    trapFile.using_namespace_directives(this, ns);
                    trapFile.using_directive_location(this, cx.Create(ReportingLocation));
                }
                else
                {
                    cx.Extractor.MissingNamespace(node.Name.ToFullString(), cx.FromSource);
                    cx.ModelError(node, "Namespace not found");
                    return;
                }
            }
            else
            {
                // A "using static"
                var m = Type.Create(cx, (ITypeSymbol)info.Symbol);
                trapFile.using_static_directives(this, m.TypeRef);
                trapFile.using_directive_location(this, cx.Create(ReportingLocation));
            }

            if (parent != null)
            {
                trapFile.parent_namespace_declaration(this, parent);
            }
        }

        public sealed override Microsoft.CodeAnalysis.Location ReportingLocation => node.GetLocation();

        public override TrapStackBehaviour TrapStackBehaviour => TrapStackBehaviour.NoLabel;
    }
}
