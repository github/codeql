using Microsoft.CodeAnalysis;
using Microsoft.CodeAnalysis.CSharp;
using Microsoft.CodeAnalysis.CSharp.Syntax;
using Semmle.Extraction.Entities;
using Semmle.Extraction.Kinds;
using System.IO;

namespace Semmle.Extraction.CSharp.Entities.Expressions
{
    internal class AnonymousObjectCreation : Expression<AnonymousObjectCreationExpressionSyntax>
    {
        public AnonymousObjectCreation(ExpressionNodeInfo info)
            : base(info.SetKind(ExprKind.OBJECT_CREATION)) { }

        public static Expression Create(ExpressionNodeInfo info) =>
            new AnonymousObjectCreation(info).TryPopulate();

        protected override void PopulateExpression(TextWriter trapFile)
        {
            var target = cx.GetSymbolInfo(Syntax);
            var method = (IMethodSymbol)target.Symbol;

            if (method != null)
            {
                trapFile.expr_call(this, Method.Create(cx, method));
            }
            var child = 0;

            var objectInitializer = Syntax.Initializers.Any() ?
                new Expression(new ExpressionInfo(cx, Type, Location, ExprKind.OBJECT_INIT, this, -1, false, null)) :
                null;

            foreach (var init in Syntax.Initializers)
            {
                // Create an "assignment"
                var property = cx.GetModel(init).GetDeclaredSymbol(init);
                var propEntity = Property.Create(cx, property);
                var type = property.GetAnnotatedType();
                var loc = cx.Create(init.GetLocation());

                var assignment = new Expression(new ExpressionInfo(cx, type, loc, ExprKind.SIMPLE_ASSIGN, objectInitializer, child++, false, null));
                Create(cx, init.Expression, assignment, 0);
                Property.Create(cx, property);

                var access = new Expression(new ExpressionInfo(cx, type, loc, ExprKind.PROPERTY_ACCESS, assignment, 1, false, null));
                trapFile.expr_access(access, propEntity);
            }
        }
    }
}
