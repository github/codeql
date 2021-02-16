using Microsoft.CodeAnalysis.CSharp.Syntax;
using Microsoft.CodeAnalysis.CSharp;
using System.IO;

namespace Semmle.Extraction.CSharp.Entities
{
    internal abstract class Statement : FreshEntity, IExpressionParentEntity, IStatementParentEntity
    {
        private readonly int child;
        private readonly Kinds.StmtKind kind;
        private readonly IStatementParentEntity parent;

        protected Statement(Context cx, Kinds.StmtKind kind, IStatementParentEntity parent, int child)
            : base(cx)
        {
            this.kind = kind;
            this.parent = parent;
            this.child = child;
        }

        protected override void Populate(TextWriter trapFile)
        {
            trapFile.statements(this, kind);
            if (parent.IsTopLevelParent)
            {
                trapFile.stmt_parent_top_level(this, child, parent);
            }
            else
            {
                trapFile.stmt_parent(this, child, parent);
            }

            PopulateStatement(trapFile);
        }

        protected abstract void PopulateStatement(TextWriter trapFile);

        public static Statement Create(Context cx, StatementSyntax node, IStatementParentEntity parent, int child) =>
            Statements.Factory.Create(cx, node, parent, child);

        /// <summary>
        /// How many statements does this take up in a block.
        /// The default is 1, however labelled statements can be more.
        /// </summary>
        public virtual int NumberOfStatements => 1;

        bool IExpressionParentEntity.IsTopLevelParent => false;

        bool IStatementParentEntity.IsTopLevelParent => false;

        public override TrapStackBehaviour TrapStackBehaviour => TrapStackBehaviour.NeedsLabel;
    }
}
