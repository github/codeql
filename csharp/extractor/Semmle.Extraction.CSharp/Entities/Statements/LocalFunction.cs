using System.IO;
using Microsoft.CodeAnalysis;
using Microsoft.CodeAnalysis.CSharp;
using Microsoft.CodeAnalysis.CSharp.Syntax;
using Semmle.Extraction.Kinds;

namespace Semmle.Extraction.CSharp.Entities.Statements
{
    internal class LocalFunction : Statement<LocalFunctionStatementSyntax>
    {
        private LocalFunction(Context cx, LocalFunctionStatementSyntax node, IStatementParentEntity parent, int child)
            : base(cx, node, StmtKind.LOCAL_FUNCTION, parent, child, cx.CreateLocation(node.GetLocation())) { }

        public static LocalFunction Create(Context cx, LocalFunctionStatementSyntax node, IStatementParentEntity parent, int child)
        {
            var ret = new LocalFunction(cx, node, parent, child);
            ret.TryPopulate();
            return ret;
        }

        /// <summary>
        /// Gets the IMethodSymbol for this local function statement.
        /// </summary>
        private IMethodSymbol? Symbol
        {
            get
            {
                var m = Context.GetModel(Stmt);
                return m.GetDeclaredSymbol(Stmt) as IMethodSymbol;
            }
        }

        protected override void PopulateStatement(TextWriter trapFile)
        {
            if (Symbol is null)
            {
                Context.ExtractionError("Could not get local function symbol", null, Context.CreateLocation(this.ReportingLocation), severity: Semmle.Util.Logging.Severity.Warning);
                return;
            }

            var function = Entities.LocalFunction.Create(Context, Symbol);
            trapFile.local_function_stmts(this, function);
        }
    }
}
