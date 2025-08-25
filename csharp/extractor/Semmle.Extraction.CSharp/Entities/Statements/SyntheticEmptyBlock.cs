using System.IO;
using Microsoft.CodeAnalysis.CSharp;
using Microsoft.CodeAnalysis.CSharp.Syntax;
using Semmle.Extraction.Kinds;

namespace Semmle.Extraction.CSharp.Entities.Statements
{
    internal class SyntheticEmptyBlock : Statement<BlockSyntax>
    {
        private SyntheticEmptyBlock(Context cx, BlockSyntax block, IStatementParentEntity parent, int child, Location location)
            : base(cx, block, StmtKind.BLOCK, parent, child, location, isCompilerGenerated: true) { }

        public static SyntheticEmptyBlock Create(Context cx, IStatementParentEntity parent, int child, Location location)
        {
            var block = SyntaxFactory.Block();
            var ret = new SyntheticEmptyBlock(cx, block, parent, child, location);
            ret.TryPopulate();
            return ret;
        }

        protected override void PopulateStatement(TextWriter trapFile) { }
    }
}
