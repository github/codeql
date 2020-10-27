using Microsoft.CodeAnalysis.CSharp.Syntax;
using Semmle.Extraction.Kinds;
using Semmle.Extraction.Entities;
using System.IO;

namespace Semmle.Extraction.CSharp.Entities.Statements
{
    internal class Catch : Statement<CatchClauseSyntax>
    {
        private static readonly string systemExceptionName = typeof(System.Exception).ToString();

        private Catch(Context cx, CatchClauseSyntax node, Try parent, int child)
            : base(cx, node, StmtKind.CATCH, parent, child, cx.Create(node.GetLocation())) { }

        protected override void PopulateStatement(TextWriter trapFile)
        {
            var isSpecificCatchClause = Stmt.Declaration != null;
            var hasVariableDeclaration = isSpecificCatchClause && Stmt.Declaration.Identifier.RawKind != 0;

            if (hasVariableDeclaration) // A catch clause of the form 'catch(Ex ex) { ... }'
            {
                var decl = Expressions.VariableDeclaration.Create(cx, Stmt.Declaration, false, this, 0);
                trapFile.catch_type(this, decl.Type.Type.TypeRef, true);
            }
            else if (isSpecificCatchClause) // A catch clause of the form 'catch(Ex) { ... }'
            {
                trapFile.catch_type(this, Type.Create(cx, cx.GetType(Stmt.Declaration.Type)).Type.TypeRef, true);
            }
            else // A catch clause of the form 'catch { ... }'
            {
                var exception = Type.Create(cx, cx.Compilation.GetTypeByMetadataName(systemExceptionName));
                trapFile.catch_type(this, exception, false);
            }

            if (Stmt.Filter != null)
            {
                // For backward compatibility, the catch filter clause is child number 2.
                Expression.Create(cx, Stmt.Filter.FilterExpression, this, 2);
            }

            Create(cx, Stmt.Block, this, 1);
        }

        public static Catch Create(Context cx, CatchClauseSyntax node, Try parent, int child)
        {
            var ret = new Catch(cx, node, parent, child);
            ret.TryPopulate();
            return ret;
        }
    }
}
