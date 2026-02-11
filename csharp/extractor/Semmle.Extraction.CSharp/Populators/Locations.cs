using System.Linq;
using Microsoft.CodeAnalysis;
using Microsoft.CodeAnalysis.CSharp;
using Microsoft.CodeAnalysis.CSharp.Syntax;

namespace Semmle.Extraction.CSharp.Populators
{
    public static class LocationExtensions
    {
        /// <summary>
        /// Manually extend a location.
        /// </summary>
        /// <param name="l1">The location to extend.</param>
        /// <param name="n2">The node to extend the location to.</param>
        /// <returns>Extended location.</returns>
        public static Location ExtendLocation(this Location l1, SyntaxNode n2, bool onlyStart = false)
        {
            if (n2 is null)
            {
                return l1;
            }

            var l2 = n2.FixedLocation();
            var start = System.Math.Min(l1.SourceSpan.Start, l2.SourceSpan.Start);
            var end = onlyStart ? l1.SourceSpan.End : System.Math.Max(l1.SourceSpan.End, l2.SourceSpan.End);
            return Location.Create(n2.SyntaxTree, new Microsoft.CodeAnalysis.Text.TextSpan(start, end - start));
        }

        /// <summary>
        /// Adjust the location of some syntax nodes
        /// to make them more suitable for displaying results.
        /// Sometimes we do not wish to highlight the whole node,
        /// so select a sub-node such as the name.
        /// !! Refactor this into each entity.
        /// </summary>
        /// <param name="node">The syntax node.</param>
        /// <returns>The fixed location.</returns>
        public static Location FixedLocation(this SyntaxNode node)
        {
            Location result;
            switch (node.Kind())
            {
                case SyntaxKind.EqualsValueClause:
                    result = ((EqualsValueClauseSyntax)node).Value.FixedLocation();
                    break;
                case SyntaxKind.OperatorDeclaration:
                    {
                        var decl = (OperatorDeclarationSyntax)node;
                        result = decl.OperatorKeyword.GetLocation().ExtendLocation(decl.ParameterList);
                        break;
                    }
                case SyntaxKind.ConversionOperatorDeclaration:
                    {
                        var decl = (ConversionOperatorDeclarationSyntax)node;
                        result = decl.OperatorKeyword.GetLocation();
                        break;
                    }
                case SyntaxKind.DelegateDeclaration:
                    {
                        var decl = (DelegateDeclarationSyntax)node;
                        return decl.Identifier.GetLocation().ExtendLocation(decl.TypeParameterList!);
                    }
                case SyntaxKind.ClassDeclaration:
                case SyntaxKind.StructDeclaration:
                case SyntaxKind.InterfaceDeclaration:
                    {
                        var decl = (TypeDeclarationSyntax)node;
                        return decl.Identifier.GetLocation().ExtendLocation(decl.TypeParameterList!);
                    }
                case SyntaxKind.EnumDeclaration:
                    return ((EnumDeclarationSyntax)node).Identifier.GetLocation();
                case SyntaxKind.MethodDeclaration:
                    {
                        var decl = (MethodDeclarationSyntax)node;
                        return decl.Identifier.GetLocation().ExtendLocation(decl.TypeParameterList!);
                    }
                case SyntaxKind.ConstructorDeclaration:
                    {
                        var decl = (ConstructorDeclarationSyntax)node;
                        return decl.Identifier.GetLocation();
                    }
                case SyntaxKind.ParenthesizedExpression:
                    return ((ParenthesizedExpressionSyntax)node).Expression.FixedLocation();
                case SyntaxKind.CatchDeclaration:
                    return ((CatchDeclarationSyntax)node).Identifier.GetLocation();
                case SyntaxKind.LabeledStatement:
                    return ((LabeledStatementSyntax)node).Identifier.GetLocation();
                case SyntaxKind.ElementBindingExpression:
                    return node.GetLocation().ExtendLocation(Entities.Expression.FindConditionalAccessParent((ElementBindingExpressionSyntax)node).Root, onlyStart: true);
                case SyntaxKind.MemberBindingExpression:
                    return node.GetLocation().ExtendLocation(Entities.Expression.FindConditionalAccessParent((MemberBindingExpressionSyntax)node).Root, onlyStart: true);
                case SyntaxKind.ElementAccessExpression:
                    return node.GetLocation().ExtendLocation(((ElementAccessExpressionSyntax)node).Expression);
                case SyntaxKind.SimpleMemberAccessExpression:
                    return node.GetLocation().ExtendLocation(((MemberAccessExpressionSyntax)node).Expression);
                case SyntaxKind.InvocationExpression:
                    return node.GetLocation().ExtendLocation(((InvocationExpressionSyntax)node).Expression);

                default:
                    result = node.GetLocation();
                    break;
            }
            return result;
        }

        public static Location GetSymbolLocation(this ISymbol symbol)
        {
            return symbol.DeclaringSyntaxReferences.Any() ?
                symbol.DeclaringSyntaxReferences.First().GetSyntax().FixedLocation() :
                symbol.Locations.Best();
        }
    }
}
