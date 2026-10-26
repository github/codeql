using System.Collections.Generic;
using System.IO;
using Microsoft.CodeAnalysis;
using Microsoft.CodeAnalysis.CSharp.Syntax;
using Semmle.Extraction.CSharp.Entities.Statements;

namespace Semmle.Extraction.CSharp.Entities
{
    internal class ImplicitMainMethod : OrdinaryMethod
    {
        private readonly List<GlobalStatementSyntax> globalStatements;

        public ImplicitMainMethod(Context cx, IMethodSymbol symbol, List<GlobalStatementSyntax> globalStatements)
            : base(cx, symbol)
        {
            this.globalStatements = globalStatements;
        }

        protected override void PopulateMethodBody(TextWriter trapFile)
        {
            GlobalStatementsBlock.Create(Context, this, globalStatements);
        }

        public static ImplicitMainMethod Create(Context cx, IMethodSymbol method, List<GlobalStatementSyntax> globalStatements)
        {
            return ImplicitMainMethodFactory.Instance.CreateEntity(cx, method, (method, globalStatements));
        }

        private class ImplicitMainMethodFactory : CachedEntityFactory<(IMethodSymbol, List<GlobalStatementSyntax>), ImplicitMainMethod>
        {
            public static ImplicitMainMethodFactory Instance { get; } = new ImplicitMainMethodFactory();

            public override ImplicitMainMethod Create(Context cx, (IMethodSymbol, List<GlobalStatementSyntax>) init) => new ImplicitMainMethod(cx, init.Item1, init.Item2);
        }
    }
}
