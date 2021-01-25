using Microsoft.CodeAnalysis;
using Microsoft.CodeAnalysis.CSharp;
using Microsoft.CodeAnalysis.CSharp.Syntax;
using Semmle.Extraction.Entities;
using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;

namespace Semmle.Extraction.CSharp.Populators
{
    public class TypeContainerVisitor : CSharpSyntaxVisitor
    {
        protected Context cx { get; }
        protected IEntity parent { get; }
        protected TextWriter trapFile { get; }
        private readonly Lazy<Func<SyntaxNode, AttributeData>> attributeLookup;

        public TypeContainerVisitor(Context cx, TextWriter trapFile, IEntity parent)
        {
            this.cx = cx;
            this.parent = parent;
            this.trapFile = trapFile;
            attributeLookup = new Lazy<Func<SyntaxNode, AttributeData>>(() =>
                {
                    var dict = new Dictionary<SyntaxNode, AttributeData>();
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
                if (attributeLookup.Value(attribute) is AttributeData attributeData)
                {
                    var ae = Semmle.Extraction.CSharp.Entities.Attribute.Create(cx, attributeData, outputAssembly);
                    cx.BindComments(ae, attribute.GetLocation());
                }
            }
        }
    }
}
