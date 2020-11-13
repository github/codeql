using Semmle.Extraction.Kinds;
using System.Linq;
using System.IO;
using Semmle.Extraction.Entities;

namespace Semmle.Extraction.CSharp.Entities.Statements
{
    internal class GlobalStatementsBlock : Statement
    {
        private GlobalStatementsBlock(Context cx, Method parent)
            : base(cx, StmtKind.BLOCK, parent, 0) { }

        public override Microsoft.CodeAnalysis.Location ReportingLocation
        {
            get
            {
                // We only create a `GlobalStatementsBlock` if there are global statements. This also means that the
                // entry point is going to be the generated method around those global statements
                return cx.Compilation.GetEntryPoint(System.Threading.CancellationToken.None)
                    ?.DeclaringSyntaxReferences
                    .FirstOrDefault()
                    ?.GetSyntax()
                    .GetLocation();
            }
        }

        public static GlobalStatementsBlock Create(Context cx, Method parent)
        {
            var ret = new GlobalStatementsBlock(cx, parent);
            ret.TryPopulate();
            return ret;
        }

        protected override void PopulateStatement(TextWriter trapFile)
        {
            trapFile.global_stmt_block(this);

            trapFile.stmt_location(this, cx.CreateLocation(ReportingLocation));
        }
    }
}
