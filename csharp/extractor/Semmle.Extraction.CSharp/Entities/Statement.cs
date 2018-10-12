using Microsoft.CodeAnalysis.CSharp.Syntax;
using Semmle.Extraction.CSharp.Populators;
using Microsoft.CodeAnalysis.CSharp;
using Semmle.Extraction.Entities;

namespace Semmle.Extraction.CSharp.Entities
{
    /// <summary>
    /// Whether this entity is the parent of a top-level statement.
    /// </summary>
    public interface IStatementParentEntity : IEntity
    {
        bool IsTopLevelParent { get; }
    }

    abstract class Statement : FreshEntity, IExpressionParentEntity, IStatementParentEntity
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

    abstract class Statement<TSyntax> : Statement where TSyntax : CSharpSyntaxNode
    {
        protected readonly TSyntax Stmt;

        protected override CSharpSyntaxNode GetStatementSyntax() => Stmt;

        protected Statement(Context cx, TSyntax stmt, Kinds.StmtKind kind, IStatementParentEntity parent, int child, Location location)
            : base(cx)
        {
            Stmt = stmt;
            cx.BindComments(this, location.symbol);
            cx.Emit(Tuples.statements(this, kind));
            if (parent.IsTopLevelParent)
                cx.Emit(Tuples.stmt_parent_top_level(this, child, parent));
            else
                cx.Emit(Tuples.stmt_parent(this, child, parent));
            cx.Emit(Tuples.stmt_location(this, location));
        }

        protected Statement(Context cx, TSyntax stmt, Kinds.StmtKind kind, IStatementParentEntity parent, int child)
            : this(cx, stmt, kind, parent, child, cx.Create(stmt.FixedLocation())) { }

        /// <summary>
        /// Populates statement-type specific relations in the trap file. The general relations
        /// <code>statements</code> and <code>stmt_location</code> are populated by the constructor
        /// (should not fail), so even if statement-type specific population fails (e.g., in
        /// standalone extraction), the statement created via
        /// <see cref="Statement.Create(Context, StatementSyntax, Statement, int)"/> will still
        /// be valid.
        /// </summary>
        protected abstract void Populate();

        protected void TryPopulate()
        {
            cx.Try(Stmt, null, Populate);
        }

        public override string ToString() => Label.ToString();
    }
}
