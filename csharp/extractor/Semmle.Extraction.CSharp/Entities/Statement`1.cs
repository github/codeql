using Semmle.Extraction.CSharp.Populators;
using Microsoft.CodeAnalysis.CSharp;
using Semmle.Extraction.Entities;
using System.IO;

namespace Semmle.Extraction.CSharp.Entities
{
    internal abstract class Statement<TSyntax> : Statement where TSyntax : CSharpSyntaxNode
    {
        protected readonly TSyntax Stmt;
        private readonly Location location;

        protected Statement(Context cx, TSyntax stmt, Kinds.StmtKind kind, IStatementParentEntity parent, int child, Location location)
            : base(cx, kind, parent, child)
        {
            Stmt = stmt;
            this.location = location;
            cx.BindComments(this, location.Symbol);
        }

        protected Statement(Context cx, TSyntax stmt, Kinds.StmtKind kind, IStatementParentEntity parent, int child)
            : this(cx, stmt, kind, parent, child, cx.CreateLocation(stmt.FixedLocation())) { }

        protected sealed override void Populate(TextWriter trapFile)
        {
            base.Populate(trapFile);

            trapFile.stmt_location(this, location);
        }

        public override Microsoft.CodeAnalysis.Location ReportingLocation => Stmt.GetLocation();

        public override string ToString() => Label.ToString();
    }
}
