using Microsoft.CodeAnalysis.CSharp.Syntax;
using Semmle.Extraction.Kinds;

namespace Semmle.Extraction.CSharp.Entities.Expressions
{
    class Cast : Expression<CastExpressionSyntax>
    {
        Cast(ExpressionNodeInfo info) : base(info.SetKind(UnaryOperatorKind(info.Context, ExprKind.CAST, info.Node))) { }

        public static Expression Create(ExpressionNodeInfo info) => new Cast(info).TryPopulate();

        protected override void Populate()
        {
            Create(cx, Syntax.Expression, this, 0);

            if (Kind == ExprKind.CAST)
                // Type cast
                TypeAccess.Create(new ExpressionNodeInfo(cx, Syntax.Type, this, 1));
            else
            {
                // Type conversion
                OperatorCall(Syntax);
                TypeMention.Create(cx, Syntax.Type, this, Type.Type);
            }
        }

        public override Microsoft.CodeAnalysis.Location ReportingLocation => Syntax.GetLocation();
    }
}
