using Semmle.Extraction.Kinds;
using System.Linq;
using System.IO;
using Semmle.Extraction.Entities;

namespace Semmle.Extraction.CSharp.Entities.Statements
{
    internal class GlobalStatementsBlock : Statement
    {
        private readonly Method parent;

        private GlobalStatementsBlock(Context cx, Method parent)
            : base(cx, StmtKind.BLOCK, parent, 0)
        {
            this.parent = parent;
        }

        public override Microsoft.CodeAnalysis.Location? ReportingLocation
        {
            get
            {
                return parent.Symbol
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
            trapFile.stmt_location(this, Context.CreateLocation(ReportingLocation));
        }
    }
}
