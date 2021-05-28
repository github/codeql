using Microsoft.CodeAnalysis.CSharp.Syntax;
using Semmle.Extraction.Kinds;
using Microsoft.CodeAnalysis.CSharp;
using Semmle.Extraction.Entities;
using System.IO;

namespace Semmle.Extraction.CSharp.Entities.Statements
{
    internal class ForEach : Statement<ForEachStatementSyntax>
    {
        internal enum ForeachSymbolType
        {
            GetEnumeratorMethod = 1,
            CurrentProperty,
            MoveNextMethod,
            DisposeMethod,
            ElementType
        }

        private ForEach(Context cx, ForEachStatementSyntax stmt, IStatementParentEntity parent, int child)
            : base(cx, stmt, StmtKind.FOREACH, parent, child) { }

        public static ForEach Create(Context cx, ForEachStatementSyntax node, IStatementParentEntity parent, int child)
        {
            var ret = new ForEach(cx, node, parent, child);
            ret.TryPopulate();
            return ret;
        }

        protected override void PopulateStatement(TextWriter trapFile)
        {
            Expression.Create(Context, Stmt.Expression, this, 1);

            var semanticModel = Context.GetModel(Stmt);
            var typeSymbol = semanticModel.GetDeclaredSymbol(Stmt)!;
            var type = typeSymbol.GetAnnotatedType();

            var location = Context.CreateLocation(Stmt.Identifier.GetLocation());

            Expressions.VariableDeclaration.Create(Context, typeSymbol, type, Stmt.Type, location, Stmt.Type.IsVar, this, 0);

            Statement.Create(Context, Stmt.Statement, this, 2);

            var info = semanticModel.GetForEachStatementInfo(Stmt);

            if (info.Equals(default))
            {
                Context.ExtractionError("Could not get foreach statement info", null, Context.CreateLocation(this.ReportingLocation), severity: Util.Logging.Severity.Info);
                return;
            }

            trapFile.foreach_stmt_info(this, info.IsAsynchronous);

            if (info.GetEnumeratorMethod is not null)
            {
                var m = Method.Create(Context, info.GetEnumeratorMethod);
                trapFile.foreach_stmt_desugar(this, m, ForeachSymbolType.GetEnumeratorMethod);
            }

            if (info.MoveNextMethod is not null)
            {
                var m = Method.Create(Context, info.MoveNextMethod);
                trapFile.foreach_stmt_desugar(this, m, ForeachSymbolType.MoveNextMethod);
            }

            if (info.DisposeMethod is not null)
            {
                var m = Method.Create(Context, info.DisposeMethod);
                trapFile.foreach_stmt_desugar(this, m, ForeachSymbolType.DisposeMethod);
            }

            if (info.CurrentProperty is not null)
            {
                var p = Property.Create(Context, info.CurrentProperty);
                trapFile.foreach_stmt_desugar(this, p, ForeachSymbolType.CurrentProperty);
            }

            if (info.ElementType is not null)
            {
                var t = Type.Create(Context, info.ElementType);
                trapFile.foreach_stmt_desugar(this, t, ForeachSymbolType.ElementType);
            }
        }
    }

    internal class ForEachVariable : Statement<ForEachVariableStatementSyntax>
    {
        private ForEachVariable(Context cx, ForEachVariableStatementSyntax stmt, IStatementParentEntity parent, int child)
            : base(cx, stmt, StmtKind.FOREACH, parent, child) { }

        public static ForEachVariable Create(Context cx, ForEachVariableStatementSyntax node, IStatementParentEntity parent, int child)
        {
            var ret = new ForEachVariable(cx, node, parent, child);
            ret.TryPopulate();
            return ret;
        }

        protected override void PopulateStatement(TextWriter trapFile)
        {
            Expression.Create(Context, Stmt.Variable, this, 0);
            Expression.Create(Context, Stmt.Expression, this, 1);
            Statement.Create(Context, Stmt.Statement, this, 2);
        }
    }
}
