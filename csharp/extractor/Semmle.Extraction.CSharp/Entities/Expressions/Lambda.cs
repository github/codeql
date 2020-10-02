using Microsoft.CodeAnalysis.CSharp.Syntax;
using Semmle.Extraction.Kinds;
using Microsoft.CodeAnalysis.CSharp;
using Microsoft.CodeAnalysis;
using System.Collections.Generic;
using Semmle.Util;
using System.Linq;
using System.IO;

namespace Semmle.Extraction.CSharp.Entities.Expressions
{
    internal class Lambda : Expression<AnonymousFunctionExpressionSyntax>, IStatementParentEntity
    {
        bool IStatementParentEntity.IsTopLevelParent => false;

        protected override void PopulateExpression(TextWriter trapFile) { }

        private void VisitParameter(ParameterSyntax p)
        {
            var symbol = cx.GetModel(p).GetDeclaredSymbol(p);
            Parameter.Create(cx, symbol, this);
        }

        private Lambda(ExpressionNodeInfo info, CSharpSyntaxNode body, IEnumerable<ParameterSyntax> @params)
            : base(info)
        {
            // No need to use `Populate` as the population happens later
            cx.PopulateLater(() =>
            {
                foreach (var param in @params)
                    VisitParameter(param);

                if (body is ExpressionSyntax)
                    Create(cx, (ExpressionSyntax)body, this, 0);
                else if (body is BlockSyntax)
                    Statements.Block.Create(cx, (BlockSyntax)body, this, 0);
                else
                    cx.ModelError(body, "Unhandled lambda body");
            });
        }

        private Lambda(ExpressionNodeInfo info, ParenthesizedLambdaExpressionSyntax node)
            : this(info.SetKind(ExprKind.LAMBDA), node.Body, node.ParameterList.Parameters) { }

        public static Lambda Create(ExpressionNodeInfo info, ParenthesizedLambdaExpressionSyntax node) => new Lambda(info, node);

        private Lambda(ExpressionNodeInfo info, SimpleLambdaExpressionSyntax node)
            : this(info.SetKind(ExprKind.LAMBDA), node.Body, Enumerators.Singleton(node.Parameter)) { }

        public static Lambda Create(ExpressionNodeInfo info, SimpleLambdaExpressionSyntax node) => new Lambda(info, node);

        private Lambda(ExpressionNodeInfo info, AnonymousMethodExpressionSyntax node) :
            this(info.SetKind(ExprKind.ANONYMOUS_METHOD), node.Body, node.ParameterList == null ? Enumerable.Empty<ParameterSyntax>() : node.ParameterList.Parameters)
        { }

        public static Lambda Create(ExpressionNodeInfo info, AnonymousMethodExpressionSyntax node) => new Lambda(info, node);
    }
}
