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
        private readonly int Child;
        private readonly Kinds.StmtKind Kind;
        private readonly IStatementParentEntity Parent;
        private readonly Location Location;

        protected override CSharpSyntaxNode GetStatementSyntax() => Stmt;

        protected Statement(Context cx, TSyntax stmt, Kinds.StmtKind kind, IStatementParentEntity parent, int child, Location location)
            : base(cx)
        {
            Stmt = stmt;
            Parent = parent;
            Child = child;
            Location = location;
            Kind = kind;
            cx.BindComments(this, location.symbol);
        }

        protected override void Populate(TextWriter trapFile)
        {
            trapFile.Emit(Tuples.statements(this, Kind));
            if (Parent.IsTopLevelParent)
                trapFile.Emit(Tuples.stmt_parent_top_level(this, Child, Parent));
            else
                trapFile.Emit(Tuples.stmt_parent(this, Child, Parent));
            cx.Emit(Tuples.stmt_location(this, Location));
            PopulateStatement(trapFile);
        }

        protected abstract void PopulateStatement(TextWriter trapFile);

        protected Statement(Context cx, TSyntax stmt, Kinds.StmtKind kind, IStatementParentEntity parent, int child)
            : this(cx, stmt, kind, parent, child, cx.Create(stmt.FixedLocation())) { }

        public override string ToString() => Label.ToString();
    }
}
