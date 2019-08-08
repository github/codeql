using Microsoft.CodeAnalysis;
using Microsoft.CodeAnalysis.CSharp;
using Microsoft.CodeAnalysis.CSharp.Syntax;
using Semmle.Extraction.CSharp.Populators;
using Semmle.Extraction.Entities;
using System.Collections.Generic;

namespace Semmle.Extraction.CSharp.Entities
{
    class UsingDirective : FreshEntity
    {
        readonly UsingDirectiveSyntax node;

        public UsingDirective(Context cx, UsingDirectiveSyntax usingDirective, NamespaceDeclaration parent)
            : base(cx)
        {
            node = usingDirective;
            var info = cx.GetModel(node).GetSymbolInfo(usingDirective.Name);

            if (usingDirective.StaticKeyword.Kind() == SyntaxKind.None)
            {
                // A normal using
                var namespaceSymbol = info.Symbol as INamespaceSymbol;

                if (namespaceSymbol == null)
                {
                    cx.Extractor.MissingNamespace(usingDirective.Name.ToFullString());
                    cx.ModelError(usingDirective, "Namespace not found");
                    return;
                }
                else
                {
                    var ns = Namespace.Create(cx, namespaceSymbol);
                    cx.Emit(Tuples.using_namespace_directives(this, ns));
                    cx.Emit(Tuples.using_directive_location(this, cx.Create(ReportingLocation)));
                }
            }
            else
            {
                // A "using static"
                Type m = Type.Create(cx, (ITypeSymbol)info.Symbol);
                cx.Emit(Tuples.using_static_directives(this, m.TypeRef));
                cx.Emit(Tuples.using_directive_location(this, cx.Create(ReportingLocation)));
            }

            if (parent != null)
            {
                cx.Emit(Tuples.parent_namespace_declaration(this, parent));
            }
        }

        public sealed override Microsoft.CodeAnalysis.Location ReportingLocation => node.GetLocation();

        public IEnumerable<Tuple> GetTuples()
        {
            yield break;
        }

        public override TrapStackBehaviour TrapStackBehaviour => TrapStackBehaviour.NoLabel;
    }
}
