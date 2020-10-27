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
        protected Context cx { get; }
        protected IEntity parent { get; }
        protected TextWriter trapFile { get; }

        public TypeContainerVisitor(Context cx, TextWriter trapFile, IEntity parent)
        {
            this.cx = cx;
            this.parent = parent;
            this.trapFile = trapFile;
        }

        public override void DefaultVisit(SyntaxNode node)
        {
            throw new InternalError(node, "Unhandled top-level syntax node");
        }

        public override void VisitDelegateDeclaration(DelegateDeclarationSyntax node)
        {
            Entities.NamedType.Create(cx, cx.GetModel(node).GetDeclaredSymbol(node)).ExtractRecursive(trapFile, parent);
        }

        public override void VisitClassDeclaration(ClassDeclarationSyntax classDecl)
        {
            Entities.Type.Create(cx, cx.GetModel(classDecl).GetDeclaredSymbol(classDecl)).ExtractRecursive(trapFile, parent);
        }

        public override void VisitStructDeclaration(StructDeclarationSyntax node)
        {
            Entities.Type.Create(cx, cx.GetModel(node).GetDeclaredSymbol(node)).ExtractRecursive(trapFile, parent);
        }

        public override void VisitEnumDeclaration(EnumDeclarationSyntax node)
        {
            Entities.Type.Create(cx, cx.GetModel(node).GetDeclaredSymbol(node)).ExtractRecursive(trapFile, parent);
        }

        public override void VisitInterfaceDeclaration(InterfaceDeclarationSyntax node)
        {
            Entities.Type.Create(cx, cx.GetModel(node).GetDeclaredSymbol(node)).ExtractRecursive(trapFile, parent);
        }

        public override void VisitAttributeList(AttributeListSyntax node)
        {
            if (cx.Extractor.Standalone)
                return;

            var outputAssembly = Assembly.CreateOutputAssembly(cx);
            foreach (var attribute in node.Attributes)
            {
                var ae = new Attribute(cx, attribute, outputAssembly);
                cx.BindComments(ae, attribute.GetLocation());
            }
        }
    }

    internal class TypeOrNamespaceVisitor : TypeContainerVisitor
    {
        public TypeOrNamespaceVisitor(Context cx, TextWriter trapFile, IEntity parent)
            : base(cx, trapFile, parent) { }

        public override void VisitUsingDirective(UsingDirectiveSyntax usingDirective)
        {
            // Only deal with "using namespace" not "using X = Y"
            if (usingDirective.Alias == null)
                new UsingDirective(cx, usingDirective, (NamespaceDeclaration)parent);
        }

        public override void VisitNamespaceDeclaration(NamespaceDeclarationSyntax node)
        {
            NamespaceDeclaration.Create(cx, node, (NamespaceDeclaration)parent);
        }
    }

    internal class CompilationUnitVisitor : TypeOrNamespaceVisitor
    {
        public CompilationUnitVisitor(Context cx)
            : base(cx, cx.TrapWriter.Writer, null) { }

        public override void VisitExternAliasDirective(ExternAliasDirectiveSyntax node)
        {
            // This information is not yet extracted.
            cx.ExtractionError("Not implemented extern alias directive", node.ToFullString(), Extraction.Entities.Location.Create(cx, node.GetLocation()), "", Severity.Info);
        }

        public override void VisitCompilationUnit(CompilationUnitSyntax compilationUnit)
        {
            foreach (var m in compilationUnit.ChildNodes())
            {
                cx.Try(m, null, () => ((CSharpSyntaxNode)m).Accept(this));
            }

            // Gather comments:
            foreach (var trivia in compilationUnit.DescendantTrivia(compilationUnit.Span))
            {
                CommentLine.Extract(cx, trivia);
            }

            foreach (var trivia in compilationUnit.GetLeadingTrivia())
            {
                CommentLine.Extract(cx, trivia);
            }

            foreach (var trivia in compilationUnit.GetTrailingTrivia())
            {
                CommentLine.Extract(cx, trivia);
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
