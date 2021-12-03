using Microsoft.CodeAnalysis.CSharp.Syntax;
using Semmle.Extraction.CSharp.Entities;
using System.IO;

namespace Semmle.Extraction.CSharp.Populators
{
    internal class TypeOrNamespaceVisitor : TypeContainerVisitor
    {
        public TypeOrNamespaceVisitor(Context cx, TextWriter trapFile, IEntity parent)
            : base(cx, trapFile, parent) { }

        public override void VisitUsingDirective(UsingDirectiveSyntax usingDirective)
        {
            // Only deal with "using namespace" not "using X = Y"
            if (usingDirective.Alias is null)
                new UsingDirective(Cx, usingDirective, (NamespaceDeclaration)Parent);
        }

        public override void VisitNamespaceDeclaration(NamespaceDeclarationSyntax node)
        {
            NamespaceDeclaration.Create(Cx, node, (NamespaceDeclaration)Parent);
        }
    }
}
