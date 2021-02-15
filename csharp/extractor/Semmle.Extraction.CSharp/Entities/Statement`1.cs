using Semmle.Extraction.CSharp.Populators;
using Microsoft.CodeAnalysis.CSharp;
using Semmle.Extraction.Entities;
using System.IO;

namespace Semmle.Extraction.CSharp.Entities
{
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
            : this(cx, stmt, kind, parent, child, cx.CreateLocation(stmt.FixedLocation())) { }

        public override string ToString() => Label.ToString();
    }
}
