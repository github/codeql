
using Microsoft.CodeAnalysis;
using Microsoft.CodeAnalysis.CSharp;
using Microsoft.CodeAnalysis.CSharp.Syntax;
using Semmle.Extraction.Entities;
using System.IO;
using System.Linq;

namespace Semmle.Extraction.CSharp.Entities
{
    internal class NamespaceDeclaration : CachedEntity<BaseNamespaceDeclarationSyntax>
    {
        private readonly NamespaceDeclaration parent;
        private readonly BaseNamespaceDeclarationSyntax node;

        public NamespaceDeclaration(Context cx, BaseNamespaceDeclarationSyntax node, NamespaceDeclaration parent)
            : base(cx, node)
        {
            this.node = node;
            this.parent = parent;
        }

        public override void WriteId(EscapingTextWriter trapFile)
        {
            trapFile.WriteSubId(Context.CreateLocation(ReportingLocation));
            trapFile.Write(";namespacedeclaration");
        }

        public override void Populate(TextWriter trapFile)
        {
            var @namespace = (INamespaceSymbol)Context.GetModel(node).GetSymbolInfo(node.Name).Symbol!;
            var ns = Namespace.Create(Context, @namespace);
            trapFile.namespace_declarations(this, ns);
            trapFile.namespace_declaration_location(this, Context.CreateLocation(node.Name.GetLocation()));

            var visitor = new Populators.TypeOrNamespaceVisitor(Context, trapFile, this);

            foreach (var member in node.Members.Cast<CSharpSyntaxNode>().Concat(node.Usings))
            {
                member.Accept(visitor);
            }

            if (parent is not null)
            {
                trapFile.parent_namespace_declaration(this, parent);
            }
        }

        public static NamespaceDeclaration Create(Context cx, BaseNamespaceDeclarationSyntax decl, NamespaceDeclaration parent)
        {
            var init = (decl, parent);
            return NamespaceDeclarationFactory.Instance.CreateEntity(cx, decl, init);
        }

        private class NamespaceDeclarationFactory : CachedEntityFactory<(BaseNamespaceDeclarationSyntax decl, NamespaceDeclaration parent), NamespaceDeclaration>
        {
            public static readonly NamespaceDeclarationFactory Instance = new NamespaceDeclarationFactory();

            public override NamespaceDeclaration Create(Context cx, (BaseNamespaceDeclarationSyntax decl, NamespaceDeclaration parent) init) =>
                new NamespaceDeclaration(cx, init.decl, init.parent);
        }

        public override Microsoft.CodeAnalysis.Location ReportingLocation => node.Name.GetLocation();

        public override bool NeedsPopulation => true;
    }
}
