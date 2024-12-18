using System.IO;
using Microsoft.CodeAnalysis.CSharp;
using Semmle.Extraction.CSharp.Populators;

namespace Semmle.Extraction.CSharp.Entities
{
    internal abstract class Statement<TSyntax> : Statement where TSyntax : CSharpSyntaxNode
    {
        protected readonly TSyntax Stmt;
        private readonly Location location;
        private readonly bool isCompilerGenerated;

        protected Statement(Context cx, TSyntax stmt, Kinds.StmtKind kind, IStatementParentEntity parent, int child, Location location, bool isCompilerGenerated = false)
            : base(cx, kind, parent, child)
        {
            Stmt = stmt;
            this.location = location;
            this.isCompilerGenerated = isCompilerGenerated;
            if (!isCompilerGenerated)
            {
                cx.BindComments(this, location.Symbol);
            }
        }

        protected Statement(Context cx, TSyntax stmt, Kinds.StmtKind kind, IStatementParentEntity parent, int child)
            : this(cx, stmt, kind, parent, child, cx.CreateLocation(stmt.FixedLocation())) { }

        protected sealed override void Populate(TextWriter trapFile)
        {
            base.Populate(trapFile);

            trapFile.stmt_location(this, location);

            if (isCompilerGenerated)
            {
                trapFile.compiler_generated(this);
            }
        }

        public override Microsoft.CodeAnalysis.Location ReportingLocation => Stmt.GetLocation();

        public override string ToString() => Label.ToString();
    }
}
