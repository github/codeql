using Semmle.Extraction.Kinds;
using Microsoft.CodeAnalysis.CSharp.Syntax;
using System;

namespace Semmle.Extraction.CSharp.Entities.Expressions
{
    class ArgList : Expression<ExpressionSyntax>
    {
        ArgList(ExpressionNodeInfo info) : base(info.SetKind(ExprKind.UNKNOWN)) { }

        protected override void Populate()
        {
            throw new NotImplementedException();
        }

        public static ArgList Create(ExpressionNodeInfo info) => new ArgList(info);
    }
}
