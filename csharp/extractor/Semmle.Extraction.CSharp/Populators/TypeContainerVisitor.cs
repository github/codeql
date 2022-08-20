using Microsoft.CodeAnalysis;
using Microsoft.CodeAnalysis.CSharp;
using Microsoft.CodeAnalysis.CSharp.Syntax;
using Semmle.Extraction.CSharp.Entities;
using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;

namespace Semmle.Extraction.CSharp.Populators
{
    internal class TypeContainerVisitor : CSharpSyntaxVisitor
    {
        protected Context Cx { get; }
        protected IEntity Parent { get; }
        protected TextWriter TrapFile { get; }
        private readonly Lazy<Func<SyntaxNode, AttributeData?>> attributeLookup;

        public TypeContainerVisitor(Context cx, TextWriter trapFile, IEntity parent)
        {
            Cx = cx;
            Parent = parent;
            TrapFile = trapFile;

            attributeLookup = new Lazy<Func<SyntaxNode, AttributeData?>>(() =>
                {
                    var dict = new Dictionary<SyntaxNode, AttributeData?>();
                    foreach (var attributeData in cx.Compilation.Assembly.GetAttributes().Concat(cx.Compilation.Assembly.Modules.SelectMany(m => m.GetAttributes())))
                    {
                        if (attributeData.ApplicationSyntaxReference?.GetSyntax() is SyntaxNode syntax)
                            dict.Add(syntax, attributeData);
                    }
                    return dict.GetValueOrDefault;
                });
        }

        public override void DefaultVisit(SyntaxNode node)
        {
            throw new InternalError(node, $"Unhandled top-level syntax node of type  {node.GetType()}");
        }

        public override void VisitGlobalStatement(GlobalStatementSyntax node)
        {
            // Intentionally left empty.
            // Global statements are handled in CompilationUnitVisitor
        }

        public override void VisitDelegateDeclaration(DelegateDeclarationSyntax node)
        {
            Entities.NamedType.Create(Cx, Cx.GetModel(node).GetDeclaredSymbol(node)!).ExtractRecursive(TrapFile, Parent);
        }

        public override void VisitRecordDeclaration(RecordDeclarationSyntax node)
        {
            ExtractTypeDeclaration(node);
        }

        public override void VisitClassDeclaration(ClassDeclarationSyntax node)
        {
            ExtractTypeDeclaration(node);
        }

        public override void VisitStructDeclaration(StructDeclarationSyntax node)
        {
            ExtractTypeDeclaration(node);
        }

        public override void VisitEnumDeclaration(EnumDeclarationSyntax node)
        {
            ExtractTypeDeclaration(node);
        }

        public override void VisitInterfaceDeclaration(InterfaceDeclarationSyntax node)
        {
            ExtractTypeDeclaration(node);
        }

        private void ExtractTypeDeclaration(BaseTypeDeclarationSyntax node)
        {
            Entities.Type.Create(Cx, Cx.GetModel(node).GetDeclaredSymbol(node)).ExtractRecursive(TrapFile, Parent);
        }

        public override void VisitAttributeList(AttributeListSyntax node)
        {
            if (Cx.Extractor.Mode.HasFlag(ExtractorMode.Standalone))
                return;

            var outputAssembly = Assembly.CreateOutputAssembly(Cx);
            var kind = node.Target?.Identifier.Kind() switch
            {
                SyntaxKind.AssemblyKeyword => Entities.AttributeKind.Assembly,
                SyntaxKind.ModuleKeyword => Entities.AttributeKind.Module,
                _ => throw new InternalError(node, "Unhandled global target")
            };
            foreach (var attribute in node.Attributes)
            {
                if (attributeLookup.Value(attribute) is AttributeData attributeData)
                {
                    var ae = Entities.Attribute.Create(Cx, attributeData, outputAssembly, kind);
                    Cx.BindComments(ae, attribute.GetLocation());
                }
            }
        }
    }
}
