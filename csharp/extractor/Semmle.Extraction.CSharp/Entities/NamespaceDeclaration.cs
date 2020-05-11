
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
        private readonly NamespaceDeclaration Parent;
        private readonly NamespaceDeclarationSyntax Node;

        public NamespaceDeclaration(Context cx, NamespaceDeclarationSyntax node, NamespaceDeclaration parent)
            : base(cx)
        {
            Node = node;
            Parent = parent;
            TryPopulate();
        }

        protected override void Populate(TextWriter trapFile)
        {
            var @namespace = (INamespaceSymbol) cx.GetModel(Node).GetSymbolInfo(Node.Name).Symbol;
            var ns = Namespace.Create(cx, @namespace);
            trapFile.namespace_declarations(this, ns);
            trapFile.namespace_declaration_location(this, cx.Create(Node.Name.GetLocation()));

            var visitor = new Populators.TypeOrNamespaceVisitor(cx, trapFile, this);

            foreach (var member in Node.Members.Cast<CSharpSyntaxNode>().Concat(Node.Usings))
            {
                member.Accept(visitor);
            }

            if (Parent != null)
            {
                trapFile.parent_namespace_declaration(this, Parent);
            }
        }

        public static NamespaceDeclaration Create(Context cx, NamespaceDeclarationSyntax decl, NamespaceDeclaration parent) => new NamespaceDeclaration(cx, decl, parent);

        public override TrapStackBehaviour TrapStackBehaviour => TrapStackBehaviour.NoLabel;
    }
}
