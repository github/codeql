using Microsoft.CodeAnalysis;
using Microsoft.CodeAnalysis.CSharp;
using Microsoft.CodeAnalysis.CSharp.Syntax;
using Semmle.Extraction.CSharp.Entities;
using Semmle.Extraction.Entities;
using Semmle.Util.Logging;
using System.IO;

namespace Semmle.Extraction.CSharp.Populators
{
    public class TypeContainerVisitor : CSharpSyntaxVisitor
    {
        protected Context Cx { get; }
        protected IEntity Parent { get; }
        protected TextWriter TrapFile { get; }

        public TypeContainerVisitor(Context cx, TextWriter trapFile, IEntity parent)
        {
            this.Cx = cx;
            this.Parent = parent;
            this.TrapFile = trapFile;
        }

        public override void DefaultVisit(SyntaxNode node)
        {
            throw new InternalError(node, "Unhandled top-level syntax node");
        }

        public override void VisitDelegateDeclaration(DelegateDeclarationSyntax node)
        {
            Entities.NamedType.Create(Cx, Cx.GetModel(node).GetDeclaredSymbol(node)).ExtractRecursive(TrapFile, Parent);
        }

        public override void VisitClassDeclaration(ClassDeclarationSyntax classDecl)
        {
            Entities.Type.Create(Cx, Cx.GetModel(classDecl).GetDeclaredSymbol(classDecl)).ExtractRecursive(TrapFile, Parent);
        }

        public override void VisitStructDeclaration(StructDeclarationSyntax node)
        {
            Entities.Type.Create(Cx, Cx.GetModel(node).GetDeclaredSymbol(node)).ExtractRecursive(TrapFile, Parent);
        }

        public override void VisitEnumDeclaration(EnumDeclarationSyntax node)
        {
            Entities.Type.Create(Cx, Cx.GetModel(node).GetDeclaredSymbol(node)).ExtractRecursive(TrapFile, Parent);
        }

        public override void VisitInterfaceDeclaration(InterfaceDeclarationSyntax node)
        {
            Entities.Type.Create(Cx, Cx.GetModel(node).GetDeclaredSymbol(node)).ExtractRecursive(TrapFile, Parent);
        }

        public override void VisitAttributeList(AttributeListSyntax node)
        {
            if (Cx.Extractor.Standalone) return;

            var outputAssembly = Assembly.CreateOutputAssembly(Cx);
            foreach (var attribute in node.Attributes)
            {
                var ae = new Attribute(Cx, attribute, outputAssembly);
                Cx.BindComments(ae, attribute.GetLocation());
            }
        }
    }

    class TypeOrNamespaceVisitor : TypeContainerVisitor
    {
        public TypeOrNamespaceVisitor(Context cx, TextWriter trapFile, IEntity parent)
            : base(cx, trapFile, parent) { }

        public override void VisitUsingDirective(UsingDirectiveSyntax usingDirective)
        {
            // Only deal with "using namespace" not "using X = Y"
            if (usingDirective.Alias == null)
                new UsingDirective(Cx, usingDirective, (NamespaceDeclaration)Parent);
        }

        public override void VisitNamespaceDeclaration(NamespaceDeclarationSyntax node)
        {
            NamespaceDeclaration.Create(Cx, node, (NamespaceDeclaration)Parent);
        }
    }

    class CompilationUnitVisitor : TypeOrNamespaceVisitor
    {
        public CompilationUnitVisitor(Context cx)
            : base(cx, cx.TrapWriter.Writer, null) { }

        public override void VisitExternAliasDirective(ExternAliasDirectiveSyntax node)
        {
            // This information is not yet extracted.
            Cx.ExtractionError("Not implemented extern alias directive", node.ToFullString(), Extraction.Entities.Location.Create(Cx, node.GetLocation()), "", Severity.Info);
        }

        public override void VisitCompilationUnit(CompilationUnitSyntax compilationUnit)
        {
            foreach (var m in compilationUnit.ChildNodes())
            {
                Cx.Try(m, null, () => ((CSharpSyntaxNode)m).Accept(this));
            }

            // Gather comments:
            foreach (SyntaxTrivia trivia in compilationUnit.DescendantTrivia(compilationUnit.Span))
            {
                CommentLine.Extract(Cx, trivia);
            }

            foreach (var trivia in compilationUnit.GetLeadingTrivia())
            {
                CommentLine.Extract(Cx, trivia);
            }

            foreach (var trivia in compilationUnit.GetTrailingTrivia())
            {
                CommentLine.Extract(Cx, trivia);
            }
        }
    }

    public class CompilationUnit
    {
        public static void Extract(Context cx, SyntaxNode unit)
        {
            // Ensure that the file itself is populated in case the source file is totally empty
            Semmle.Extraction.Entities.File.Create(cx, unit.SyntaxTree.FilePath);

            ((CSharpSyntaxNode)unit).Accept(new CompilationUnitVisitor(cx));
        }
    }
}
