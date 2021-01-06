using Microsoft.CodeAnalysis;
using Microsoft.CodeAnalysis.CSharp;
using Microsoft.CodeAnalysis.CSharp.Syntax;
using Semmle.Extraction.Kinds;
using System.Collections.Generic;
using System.IO;
using System.Linq;

namespace Semmle.Extraction.CSharp.Entities.Expressions
{
    internal abstract class ArrayCreation<TSyntaxNode> : Expression<TSyntaxNode>
        where TSyntaxNode : ExpressionSyntax
    {
        protected const int InitializerIndex = -1;

        protected ArrayCreation(ExpressionNodeInfo info) : base(info) { }
    }

    internal abstract class ExplicitArrayCreation<TSyntaxNode> : ArrayCreation<TSyntaxNode>
        where TSyntaxNode : ExpressionSyntax
    {
        protected ExplicitArrayCreation(ExpressionNodeInfo info) : base(info.SetKind(ExprKind.ARRAY_CREATION)) { }

        protected abstract ArrayTypeSyntax TypeSyntax { get; }

        public abstract InitializerExpressionSyntax Initializer { get; }

        protected override void PopulateExpression(TextWriter trapFile)
        {
            var explicitlySized = false;

            if (TypeSyntax is null)
            {
                cx.ModelError(Syntax, "Array has unexpected type syntax");
            }

            var firstLevelSizes = TypeSyntax.RankSpecifiers.First()?.Sizes ?? SyntaxFactory.SeparatedList<ExpressionSyntax>();

            if (firstLevelSizes.OfType<ExpressionSyntax>().Any(s => s is OmittedArraySizeExpressionSyntax))
            {
                SetArraySizes(Initializer, firstLevelSizes.Count);
            }
            else
            {
                for (var sizeIndex = 0; sizeIndex < firstLevelSizes.Count; sizeIndex++)
                {
                    Create(cx, firstLevelSizes[sizeIndex], this, sizeIndex);
                }
                explicitlySized = true;
            }

            if (!(Initializer is null))
            {
                ArrayInitializer.Create(new ExpressionNodeInfo(cx, Initializer, this, InitializerIndex));
            }

            if (explicitlySized)
                trapFile.explicitly_sized_array_creation(this);

            TypeMention.Create(cx, TypeSyntax, this, Type);
        }

        private void SetArraySizes(InitializerExpressionSyntax initializer, int rank)
        {
            for (var level = 0; level < rank; level++)
            {
                if (initializer is null)
                {
                    return;
                }

                Literal.CreateGenerated(cx, this, level, cx.Compilation.GetSpecialType(SpecialType.System_Int32), initializer.Expressions.Count, Location);

                initializer = initializer.Expressions.FirstOrDefault() as InitializerExpressionSyntax;
            }
        }
    }

    internal class NormalArrayCreation : ExplicitArrayCreation<ArrayCreationExpressionSyntax>
    {
        private NormalArrayCreation(ExpressionNodeInfo info) : base(info) { }

        protected override ArrayTypeSyntax TypeSyntax => Syntax.Type;

        public override InitializerExpressionSyntax Initializer => Syntax.Initializer;

        public static Expression Create(ExpressionNodeInfo info) => new NormalArrayCreation(info).TryPopulate();

        public static Expression CreateGenerated(Context cx, IExpressionParentEntity parent, int childIndex, ITypeSymbol type, IEnumerable<TypedConstant> items, Semmle.Extraction.Entities.Location location)
        {
            var info = new ExpressionInfo(
                cx,
                new AnnotatedType(Entities.Type.Create(cx, type), NullableAnnotation.None),
                location,
                ExprKind.ARRAY_CREATION,
                parent,
                childIndex,
                true,
                null);

            var arrayCreation = new Expression(info);

            var length = items.Count();

            Literal.CreateGenerated(cx, arrayCreation, 0, cx.Compilation.GetSpecialType(SpecialType.System_Int32), length, location);

            if (length > 0)
            {
                var arrayInit = ArrayInitializer.CreateGenerated(cx, arrayCreation, InitializerIndex, location);
                var child = 0;
                foreach (var item in items)
                {
                    Expression.CreateGenerated(cx, item, arrayInit, child++, location);
                }
            }

            return arrayCreation;
        }
    }

    internal class StackAllocArrayCreation : ExplicitArrayCreation<StackAllocArrayCreationExpressionSyntax>
    {
        private StackAllocArrayCreation(ExpressionNodeInfo info) : base(info) { }

        protected override ArrayTypeSyntax TypeSyntax => Syntax.Type as ArrayTypeSyntax;

        public override InitializerExpressionSyntax Initializer => Syntax.Initializer;

        protected override void PopulateExpression(TextWriter trapFile)
        {
            base.PopulateExpression(trapFile);
            trapFile.stackalloc_array_creation(this);
        }

        public static Expression Create(ExpressionNodeInfo info) => new StackAllocArrayCreation(info).TryPopulate();
    }

    internal class ImplicitStackAllocArrayCreation : ArrayCreation<ImplicitStackAllocArrayCreationExpressionSyntax>
    {
        private ImplicitStackAllocArrayCreation(ExpressionNodeInfo info) : base(info.SetKind(ExprKind.ARRAY_CREATION)) { }

        public static Expression Create(ExpressionNodeInfo info) => new ImplicitStackAllocArrayCreation(info).TryPopulate();

        protected override void PopulateExpression(TextWriter trapFile)
        {
            ArrayInitializer.Create(new ExpressionNodeInfo(cx, Syntax.Initializer, this, InitializerIndex));
            trapFile.implicitly_typed_array_creation(this);
            trapFile.stackalloc_array_creation(this);
        }
    }

    internal class ImplicitArrayCreation : ArrayCreation<ImplicitArrayCreationExpressionSyntax>
    {
        private ImplicitArrayCreation(ExpressionNodeInfo info) : base(info.SetKind(ExprKind.ARRAY_CREATION)) { }

        public static Expression Create(ExpressionNodeInfo info) => new ImplicitArrayCreation(info).TryPopulate();

        protected override void PopulateExpression(TextWriter trapFile)
        {
            if (Syntax.Initializer != null)
            {
                ArrayInitializer.Create(new ExpressionNodeInfo(cx, Syntax.Initializer, this, InitializerIndex));
            }

            trapFile.implicitly_typed_array_creation(this);
        }
    }
}
