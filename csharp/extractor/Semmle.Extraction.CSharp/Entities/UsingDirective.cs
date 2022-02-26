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
            var info = Context.GetModel(node).GetSymbolInfo(node.Name);

            if (node.StaticKeyword.Kind() == SyntaxKind.None)
            {
                // A normal using
                if (info.Symbol is INamespaceSymbol namespaceSymbol)
                {
                    var ns = Namespace.Create(Context, namespaceSymbol);
                    trapFile.using_namespace_directives(this, ns);
                    trapFile.using_directive_location(this, Context.CreateLocation(ReportingLocation));
                }
                else
                {
                    Context.Extractor.MissingNamespace(node.Name.ToFullString(), Context.FromSource);
                    Context.ModelError(node, "Namespace not found");
                    return;
                }
            }
            else
            {
                // A "using static"
                var m = Type.Create(Context, (ITypeSymbol?)info.Symbol);
                trapFile.using_static_directives(this, m.TypeRef);
                trapFile.using_directive_location(this, Context.CreateLocation(ReportingLocation));
            }

            if (node.GlobalKeyword.Kind() == SyntaxKind.GlobalKeyword)
            {
                trapFile.using_global(this);
            }

            if (parent is not null)
            {
                trapFile.parent_namespace_declaration(this, parent);
            }
        }

        public sealed override Microsoft.CodeAnalysis.Location ReportingLocation => node.GetLocation();
    }
}
