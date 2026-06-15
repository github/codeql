using System.IO;
using Microsoft.CodeAnalysis.CSharp;
using Microsoft.CodeAnalysis.CSharp.Syntax;
using Semmle.Util;
using Semmle.Extraction.Kinds;

namespace Semmle.Extraction.CSharp.Entities.Expressions
{
    internal class Collection : Expression<CollectionExpressionSyntax>
    {
        private Collection(ExpressionNodeInfo info) : base(info.SetKind(ExprKind.COLLECTION)) { }

        protected override void PopulateExpression(TextWriter trapFile) =>
            Syntax.Elements.ForEach((element, i) =>
            {
                switch (element.Kind())
                {
                    case SyntaxKind.ExpressionElement:
                        {
                            Create(Context, ((ExpressionElementSyntax)element).Expression, this, i);
                            return;
                        }
                    case SyntaxKind.SpreadElement:
                        {
                            Spread.Create(Context, (SpreadElementSyntax)element, this, i);
                            return;
                        }
                    default:
                        {
                            Context.ModelError(element, $"Unhandled collection element type {element.Kind()}");
                            return;
                        }
                }
            });

        public static Expression Create(ExpressionNodeInfo info) => new Collection(info).TryPopulate();
    }
}
