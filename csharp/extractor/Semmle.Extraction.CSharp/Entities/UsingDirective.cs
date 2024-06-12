using System.IO;
using Microsoft.CodeAnalysis;
using Microsoft.CodeAnalysis.CSharp;
using Microsoft.CodeAnalysis.CSharp.Syntax;

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
            // This is guaranteed to be non-null as we only deal with "using namespace" not "using X = Y"
            var name = node.Name!;

            var info = Context.GetModel(node).GetSymbolInfo(name);

            if (node.StaticKeyword.IsKind(SyntaxKind.None))
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
                    Context.ExtractionContext.MissingNamespace(name.ToFullString(), Context.FromSource);
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

            if (node.GlobalKeyword.IsKind(SyntaxKind.GlobalKeyword))
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
