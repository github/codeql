using Microsoft.CodeAnalysis;
using Microsoft.CodeAnalysis.CSharp;
using Microsoft.CodeAnalysis.CSharp.Syntax;
using Semmle.Extraction.Entities;
using System.IO;

namespace Semmle.Extraction.CSharp.Entities
{
    class UsingDirective : FreshEntity
    {
        readonly UsingDirectiveSyntax node;
        readonly NamespaceDeclaration parent;

        public UsingDirective(Context cx, UsingDirectiveSyntax usingDirective, NamespaceDeclaration parent)
            : base(cx)
        {
            node = usingDirective;
            this.parent = parent;
            TryPopulate();
        }

        protected override void Populate(TextWriter trapFile)
        {
            var info = Cx.GetModel(node).GetSymbolInfo(node.Name);

            if (node.StaticKeyword.Kind() == SyntaxKind.None)
            {
                // A normal using
                var namespaceSymbol = info.Symbol as INamespaceSymbol;

                if (namespaceSymbol == null)
                {
                    Cx.Extractor.MissingNamespace(node.Name.ToFullString(), Cx.FromSource);
                    Cx.ModelError(node, "Namespace not found");
                    return;
                }
                else
                {
                    var ns = Namespace.Create(Cx, namespaceSymbol);
                    trapFile.using_namespace_directives(this, ns);
                    trapFile.using_directive_location(this, Cx.Create(ReportingLocation));
                }
            }
            else
            {
                // A "using static"
                var m = Type.Create(Cx, (ITypeSymbol)info.Symbol);
                trapFile.using_static_directives(this, m.TypeRef);
                trapFile.using_directive_location(this, Cx.Create(ReportingLocation));
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
