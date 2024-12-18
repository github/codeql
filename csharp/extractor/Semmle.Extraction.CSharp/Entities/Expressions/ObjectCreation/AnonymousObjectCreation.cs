using System.IO;
using Microsoft.CodeAnalysis;
using Microsoft.CodeAnalysis.CSharp;
using Microsoft.CodeAnalysis.CSharp.Syntax;
using Semmle.Extraction.Kinds;

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
            var target = Context.GetSymbolInfo(Syntax);
            var method = (IMethodSymbol?)target.Symbol;
            if (method is not null)
            {
                trapFile.expr_call(this, Method.Create(Context, method));
            }

            var child = 0;

            if (!Syntax.Initializers.Any())
            {
                return;
            }

            var objectInitializer = new Expression(new ExpressionInfo(Context, Type, Location, ExprKind.OBJECT_INIT, this, -1, isCompilerGenerated: false, null));

            foreach (var init in Syntax.Initializers)
            {
                // Create an "assignment"
                var property = Context.GetModel(init).GetDeclaredSymbol(init)!;
                var propEntity = Property.Create(Context, property);
                var type = property.GetAnnotatedType();
                var loc = Context.CreateLocation(init.GetLocation());

                var assignment = new Expression(new ExpressionInfo(Context, type, loc, ExprKind.SIMPLE_ASSIGN, objectInitializer, child++, isCompilerGenerated: false, null));
                Create(Context, init.Expression, assignment, 0);
                Property.Create(Context, property);

                var access = new Expression(new ExpressionInfo(Context, type, loc, ExprKind.PROPERTY_ACCESS, assignment, 1, isCompilerGenerated: false, null));
                trapFile.expr_access(access, propEntity);
            }
        }
    }
}
