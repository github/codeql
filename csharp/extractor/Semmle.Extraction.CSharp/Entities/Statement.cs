using Microsoft.CodeAnalysis.CSharp.Syntax;
using Semmle.Extraction.CSharp.Populators;
using Microsoft.CodeAnalysis.CSharp;
using Semmle.Extraction.Entities;
using System.IO;

namespace Semmle.Extraction.CSharp.Entities
{
    /// <summary>
    /// Whether this entity is the parent of a top-level statement.
    /// </summary>
    public interface IStatementParentEntity : IEntity
    {
        bool IsTopLevelParent { get; }
    }

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

    internal abstract class Statement<TSyntax> : Statement where TSyntax : CSharpSyntaxNode
    {
        protected readonly TSyntax Stmt;
        private readonly int child;
        private readonly Kinds.StmtKind kind;
        private readonly IStatementParentEntity parent;
        private readonly Location location;

        protected override CSharpSyntaxNode GetStatementSyntax() => Stmt;

        protected Statement(Context cx, TSyntax stmt, Kinds.StmtKind kind, IStatementParentEntity parent, int child, Location location)
            : base(cx)
        {
            Stmt = stmt;
            this.parent = parent;
            this.child = child;
            this.location = location;
            this.kind = kind;
            cx.BindComments(this, location.symbol);
        }

        protected sealed override void Populate(TextWriter trapFile)
        {
            trapFile.statements(this, kind);
            if (parent.IsTopLevelParent)
                trapFile.stmt_parent_top_level(this, child, parent);
            else
                trapFile.stmt_parent(this, child, parent);
            trapFile.stmt_location(this, location);
            PopulateStatement(trapFile);
        }

        protected abstract void PopulateStatement(TextWriter trapFile);

        protected Statement(Context cx, TSyntax stmt, Kinds.StmtKind kind, IStatementParentEntity parent, int child)
            : this(cx, stmt, kind, parent, child, cx.Create(stmt.FixedLocation())) { }

        public override string ToString() => Label.ToString();
    }
}
