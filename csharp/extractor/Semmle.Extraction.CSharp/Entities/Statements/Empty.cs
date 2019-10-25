using Microsoft.CodeAnalysis.CSharp.Syntax;
using Semmle.Extraction.Kinds;
using System.IO;

namespace Semmle.Extraction.CSharp.Entities.Statements
{
    class Empty : Statement<EmptyStatementSyntax>
    {
        Empty(Context cx, EmptyStatementSyntax block, IStatementParentEntity parent, int child)
            : base(cx, block, StmtKind.EMPTY, parent, child) { }

        public static Empty Create(Context cx, EmptyStatementSyntax node, IStatementParentEntity parent, int child)
        {
            var ret = new Empty(cx, node, parent, child);
            ret.TryPopulate();
            return ret;
        }

        protected override void PopulateStatement(TextWriter trapFile) { }
    }
}
