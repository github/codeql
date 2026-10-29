using System.IO;
using Microsoft.CodeAnalysis.CSharp.Syntax;

namespace Semmle.Extraction.CSharp.Entities.Expressions
{
    internal class ImplicitObjectCreation : BaseObjectCreation<ImplicitObjectCreationExpressionSyntax>
    {
        private ImplicitObjectCreation(ExpressionNodeInfo info) : base(info) { }

        public static Expression Create(ExpressionNodeInfo info) => new ImplicitObjectCreation(info).TryPopulate();

        protected override void PopulateExpression(TextWriter trapFile)
        {
            base.PopulateExpression(trapFile);

            trapFile.implicitly_typed_object_creation(this);
        }
    }
}
