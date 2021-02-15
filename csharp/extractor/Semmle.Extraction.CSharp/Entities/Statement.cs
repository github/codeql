using Microsoft.CodeAnalysis.CSharp.Syntax;
using Microsoft.CodeAnalysis.CSharp;

namespace Semmle.Extraction.CSharp.Entities
{
    internal abstract class Statement : FreshEntity, IExpressionParentEntity, IStatementParentEntity
    {
        protected Statement(Context cx) : base(cx) { }

        public static Statement Create(Context cx, StatementSyntax node, Statement parent, int child) =>
            Statements.Factory.Create(cx, node, parent, child);

        /// <summary>
        /// How many statements does this take up in a block.
        /// The default is 1, however labelled statements can be more.
        /// </summary>
        public virtual int NumberOfStatements => 1;

        public override Microsoft.CodeAnalysis.Location ReportingLocation => GetStatementSyntax().GetLocation();

        bool IExpressionParentEntity.IsTopLevelParent => false;

        bool IStatementParentEntity.IsTopLevelParent => false;

        protected abstract CSharpSyntaxNode GetStatementSyntax();

        public override TrapStackBehaviour TrapStackBehaviour => TrapStackBehaviour.NeedsLabel;
    }
}
