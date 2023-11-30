using System;
using System.IO;
using Microsoft.CodeAnalysis.CSharp.Syntax;
using Semmle.Extraction.Kinds;

namespace Semmle.Extraction.CSharp.Entities.Expressions
{
    internal class ArgList : Expression<ExpressionSyntax>
    {
        private ArgList(ExpressionNodeInfo info) : base(info.SetKind(ExprKind.UNKNOWN)) { }

        protected override void PopulateExpression(TextWriter trapFile)
        {
            throw new NotImplementedException();
        }

        public static ArgList Create(ExpressionNodeInfo info) => new ArgList(info);
    }
}
