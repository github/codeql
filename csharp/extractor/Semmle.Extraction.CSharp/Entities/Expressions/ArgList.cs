using Semmle.Extraction.Kinds;
using Microsoft.CodeAnalysis.CSharp.Syntax;
using System;
using System.IO;

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
