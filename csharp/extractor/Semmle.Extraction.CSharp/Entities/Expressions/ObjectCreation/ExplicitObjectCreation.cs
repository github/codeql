using System.IO;
using Microsoft.CodeAnalysis.CSharp.Syntax;


namespace Semmle.Extraction.CSharp.Entities.Expressions
{
    // new Foo(...) { ... }.
    internal class ExplicitObjectCreation : BaseObjectCreation<ObjectCreationExpressionSyntax>
    {
        private ExplicitObjectCreation(ExpressionNodeInfo info) : base(info) { }

        public static Expression Create(ExpressionNodeInfo info) => new ExplicitObjectCreation(info).TryPopulate();

        protected override void PopulateExpression(TextWriter trapFile)
        {
            base.PopulateExpression(trapFile);

            TypeMention.Create(Context, Syntax.Type, this, Type);
        }
    }
}
