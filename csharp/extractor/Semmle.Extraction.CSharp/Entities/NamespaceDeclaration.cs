
using Microsoft.CodeAnalysis;
using Microsoft.CodeAnalysis.CSharp;
using Microsoft.CodeAnalysis.CSharp.Syntax;
using Semmle.Extraction.Entities;
using System.IO;
using System.Linq;

namespace Semmle.Extraction.CSharp.Entities
{
    class NamespaceDeclaration : FreshEntity
    {
        private readonly NamespaceDeclaration parent;
        private readonly NamespaceDeclarationSyntax node;

        public NamespaceDeclaration(Context cx, NamespaceDeclarationSyntax node, NamespaceDeclaration parent)
            : base(cx)
        {
            this.node = node;
            this.parent = parent;
            TryPopulate();
        }

        protected override void Populate(TextWriter trapFile)
        {
            var @namespace = (INamespaceSymbol)Cx.GetModel(node).GetSymbolInfo(node.Name).Symbol;
            var ns = Namespace.Create(Cx, @namespace);
            trapFile.namespace_declarations(this, ns);
            trapFile.namespace_declaration_location(this, Cx.Create(node.Name.GetLocation()));

            var visitor = new Populators.TypeOrNamespaceVisitor(Cx, trapFile, this);

            foreach (var member in node.Members.Cast<CSharpSyntaxNode>().Concat(node.Usings))
            {
                member.Accept(visitor);
            }

            if (parent != null)
            {
                trapFile.parent_namespace_declaration(this, parent);
            }
        }

        public static NamespaceDeclaration Create(Context cx, NamespaceDeclarationSyntax decl, NamespaceDeclaration parent) => new NamespaceDeclaration(cx, decl, parent);

        public override TrapStackBehaviour TrapStackBehaviour => TrapStackBehaviour.NoLabel;
    }
}
