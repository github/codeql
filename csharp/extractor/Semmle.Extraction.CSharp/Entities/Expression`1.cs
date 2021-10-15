using Microsoft.CodeAnalysis;
using Microsoft.CodeAnalysis.CSharp.Syntax;
using System.IO;

namespace Semmle.Extraction.CSharp.Entities
{
    internal abstract class Expression<TExpressionSyntax> : Expression
        where TExpressionSyntax : ExpressionSyntax
    {
        public TExpressionSyntax Syntax { get; }

        protected Expression(ExpressionNodeInfo info)
            : base(info)
        {
            Syntax = (TExpressionSyntax)info.Node;
        }

        /// <summary>
        /// Populates expression-type specific relations in the trap file. The general relations
        /// <code>expressions</code> and <code>expr_location</code> are populated by the constructor
        /// (should not fail), so even if expression-type specific population fails (e.g., in
        /// standalone extraction), the expression created via
        /// <see cref="Expression.Create(Context, ExpressionSyntax, IEntity, int, ITypeSymbol)"/> will
        /// still be valid.
        /// </summary>
        protected abstract void PopulateExpression(TextWriter trapFile);

        protected new Expression TryPopulate()
        {
            Context.Try(Syntax, null, () => PopulateExpression(Context.TrapWriter.Writer));
            return this;
        }
    }
}
