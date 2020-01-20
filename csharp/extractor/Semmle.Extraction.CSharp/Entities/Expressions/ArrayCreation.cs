using Microsoft.CodeAnalysis;
using Microsoft.CodeAnalysis.CSharp.Syntax;
using Semmle.Extraction.Kinds;
using System.IO;
using System.Linq;

namespace Semmle.Extraction.CSharp.Entities.Expressions
{
    abstract class ArrayCreation<SyntaxNode> : Expression<SyntaxNode> where SyntaxNode : ExpressionSyntax
    {
        protected ArrayCreation(ExpressionNodeInfo info) : base(info) { }
    }

    abstract class ExplicitArrayCreation<SyntaxNode> : ArrayCreation<SyntaxNode> where SyntaxNode : ExpressionSyntax
    {
        protected ExplicitArrayCreation(ExpressionNodeInfo info) : base(info.SetKind(ExprKind.ARRAY_CREATION)) { }

        protected abstract ArrayTypeSyntax TypeSyntax { get; }

        public abstract InitializerExpressionSyntax  Initializer { get;  }

        protected override void PopulateExpression(TextWriter trapFile)
        {
            var child = 0;
            var explicitlySized = false;

            if (TypeSyntax is null)
            {
                cx.ModelError(Syntax, "Array has unexpected type syntax");
            }

            foreach (var rank in TypeSyntax.RankSpecifiers.SelectMany(rs => rs.Sizes))
            {
                if (rank is OmittedArraySizeExpressionSyntax)
                {
                    // Create an expression which simulates the explicit size of the array

                    if (!(Initializer is null))
                    {
                        // An implicitly-sized array must have an initializer.
                        // Guard it just in case.
                        var size = Initializer.Expressions.Count;

                        var info = new ExpressionInfo(
                            cx,
                            new AnnotatedType(Entities.Type.Create(cx, cx.Compilation.GetSpecialType(Microsoft.CodeAnalysis.SpecialType.System_Int32)), NullableAnnotation.None),
                            Location,
                            ExprKind.INT_LITERAL,
                            this,
                            child,
                            false,
                            size.ToString());

                        new Expression(info);
                    }
                }
                else
                {
                    Create(cx, rank, this, child);
                    explicitlySized = true;
                }
                child++;
            }
            if (!(Initializer is null))
            {
                ArrayInitializer.Create(new ExpressionNodeInfo(cx, Initializer, this, -1));
            }

            if (explicitlySized)
                trapFile.explicitly_sized_array_creation(this);
        }
    }

    class NormalArrayCreation : ExplicitArrayCreation<ArrayCreationExpressionSyntax>
    {
        private NormalArrayCreation(ExpressionNodeInfo info) : base(info) { }

        protected override ArrayTypeSyntax TypeSyntax => Syntax.Type;

        public override InitializerExpressionSyntax Initializer => Syntax.Initializer;

        public static Expression Create(ExpressionNodeInfo info) => new NormalArrayCreation(info).TryPopulate();
    }

    class StackAllocArrayCreation : ExplicitArrayCreation<StackAllocArrayCreationExpressionSyntax>
    {
        StackAllocArrayCreation(ExpressionNodeInfo info) : base(info) { }

        protected override ArrayTypeSyntax TypeSyntax => Syntax.Type as ArrayTypeSyntax;

        public override InitializerExpressionSyntax Initializer => Syntax.Initializer;

        public static Expression Create(ExpressionNodeInfo info) => new StackAllocArrayCreation(info).TryPopulate();
    }

    class ImplicitArrayCreation : ArrayCreation<ImplicitArrayCreationExpressionSyntax>
    {
        ImplicitArrayCreation(ExpressionNodeInfo info) : base(info.SetKind(ExprKind.ARRAY_CREATION)) { }

        public static Expression Create(ExpressionNodeInfo info) => new ImplicitArrayCreation(info).TryPopulate();

        protected override void PopulateExpression(TextWriter trapFile)
        {
            if (Syntax.Initializer != null)
            {
                ArrayInitializer.Create(new ExpressionNodeInfo(cx, Syntax.Initializer, this, -1));
            }

            trapFile.implicitly_typed_array_creation(this);
        }
    }
}
