using System.IO;
using Microsoft.CodeAnalysis.CSharp.Syntax;
using Semmle.Extraction.Kinds;

namespace Semmle.Extraction.CSharp.Entities.Statements
{
    internal class Catch : Statement<CatchClauseSyntax>
    {
        private static readonly string systemExceptionName = typeof(System.Exception).ToString();

        private Catch(Context cx, CatchClauseSyntax node, Try parent, int child)
            : base(cx, node, StmtKind.CATCH, parent, child, cx.CreateLocation(node.GetLocation())) { }

        protected override void PopulateStatement(TextWriter trapFile)
        {
            var isSpecificCatchClause = Stmt.Declaration is not null;
            var hasVariableDeclaration = isSpecificCatchClause && Stmt.Declaration!.Identifier.RawKind != 0;

            if (hasVariableDeclaration) // A catch clause of the form 'catch(Ex ex) { ... }'
            {
                var decl = Expressions.VariableDeclaration.Create(Context, Stmt.Declaration!, false, this, 0);
                trapFile.catch_type(this, Type.Create(Context, decl.Type).TypeRef, true);
            }
            else if (isSpecificCatchClause) // A catch clause of the form 'catch(Ex) { ... }'
            {
                trapFile.catch_type(this, Type.Create(Context, Context.GetType(Stmt.Declaration!.Type)).TypeRef, true);
            }
            else // A catch clause of the form 'catch { ... }'
            {
                var exception = Type.Create(Context, Context.Compilation.GetTypeByMetadataName(systemExceptionName));
                trapFile.catch_type(this, exception, false);
            }

            if (Stmt.Filter is not null)
            {
                // For backward compatibility, the catch filter clause is child number 2.
                Expression.Create(Context, Stmt.Filter.FilterExpression, this, 2);
            }

            Create(Context, Stmt.Block, this, 1);
        }

        public static Catch Create(Context cx, CatchClauseSyntax node, Try parent, int child)
        {
            var ret = new Catch(cx, node, parent, child);
            ret.TryPopulate();
            return ret;
        }
    }
}
