using Microsoft.CodeAnalysis.CSharp;
using Microsoft.CodeAnalysis.CSharp.Syntax;
using Semmle.Extraction.Kinds;

namespace Semmle.Extraction.CSharp.Entities.Expressions
{
    internal static class Factory
    {
        internal static Expression Create(ExpressionNodeInfo info)
        {
            // Some expressions can be extremely deep (e.g. string + string + string ...)
            // to the extent that the stack has been known to overflow.
            using (info.Context.StackGuard)
            {
                if (info.Node is null)
                {
                    info.Context.ModelError(info.Location, "Attempt to create a null expression");
                    return new Unknown(info);
                }

                switch (info.Node.Kind())
                {
                    case SyntaxKind.AddExpression:
                    case SyntaxKind.SubtractExpression:
                    case SyntaxKind.LessThanExpression:
                    case SyntaxKind.LessThanOrEqualExpression:
                    case SyntaxKind.GreaterThanExpression:
                    case SyntaxKind.GreaterThanOrEqualExpression:
                    case SyntaxKind.MultiplyExpression:
                    case SyntaxKind.LogicalAndExpression:
                    case SyntaxKind.EqualsExpression:
                    case SyntaxKind.ModuloExpression:
                    case SyntaxKind.BitwiseAndExpression:
                    case SyntaxKind.BitwiseOrExpression:
                    case SyntaxKind.DivideExpression:
                    case SyntaxKind.NotEqualsExpression:
                    case SyntaxKind.LogicalOrExpression:
                    case SyntaxKind.IsExpression:
                    case SyntaxKind.AsExpression:
                    case SyntaxKind.RightShiftExpression:
                    case SyntaxKind.LeftShiftExpression:
                    case SyntaxKind.ExclusiveOrExpression:
                    case SyntaxKind.CoalesceExpression:
                        return Binary.Create(info);

                    case SyntaxKind.FalseLiteralExpression:
                    case SyntaxKind.TrueLiteralExpression:
                    case SyntaxKind.StringLiteralExpression:
                    case SyntaxKind.NullLiteralExpression:
                    case SyntaxKind.NumericLiteralExpression:
                    case SyntaxKind.CharacterLiteralExpression:
                    case SyntaxKind.DefaultLiteralExpression:
                        return Literal.Create(info);

                    case SyntaxKind.InvocationExpression:
                        return Invocation.Create(info);

                    case SyntaxKind.PostIncrementExpression:
                        return PostfixUnary.Create(info.SetKind(ExprKind.POST_INCR), ((PostfixUnaryExpressionSyntax)info.Node).Operand);

                    case SyntaxKind.PostDecrementExpression:
                        return PostfixUnary.Create(info.SetKind(ExprKind.POST_DECR), ((PostfixUnaryExpressionSyntax)info.Node).Operand);

                    case SyntaxKind.AwaitExpression:
                        return Await.Create(info);

                    case SyntaxKind.ElementAccessExpression:
                        return NormalElementAccess.Create(info);

                    case SyntaxKind.SimpleAssignmentExpression:
                    case SyntaxKind.OrAssignmentExpression:
                    case SyntaxKind.AndAssignmentExpression:
                    case SyntaxKind.SubtractAssignmentExpression:
                    case SyntaxKind.AddAssignmentExpression:
                    case SyntaxKind.MultiplyAssignmentExpression:
                    case SyntaxKind.ExclusiveOrAssignmentExpression:
                    case SyntaxKind.LeftShiftAssignmentExpression:
                    case SyntaxKind.RightShiftAssignmentExpression:
                    case SyntaxKind.DivideAssignmentExpression:
                    case SyntaxKind.ModuloAssignmentExpression:
                    case SyntaxKind.CoalesceAssignmentExpression:
                        return Assignment.Create(info);

                    case SyntaxKind.ObjectCreationExpression:
                        return ExplicitObjectCreation.Create(info);

                    case SyntaxKind.ImplicitObjectCreationExpression:
                        return ImplicitObjectCreation.Create(info);

                    case SyntaxKind.ArrayCreationExpression:
                        return NormalArrayCreation.Create(info);

                    case SyntaxKind.ObjectInitializerExpression:
                        return ObjectInitializer.Create(info);

                    case SyntaxKind.ArrayInitializerExpression:
                        return ImplicitArrayInitializer.Create(info);

                    case SyntaxKind.CollectionInitializerExpression:
                        return CollectionInitializer.Create(info);

                    case SyntaxKind.ConditionalAccessExpression:
                        return MemberAccess.Create(info, (ConditionalAccessExpressionSyntax)info.Node);

                    case SyntaxKind.SimpleMemberAccessExpression:
                        return MemberAccess.Create(info, (MemberAccessExpressionSyntax)info.Node);

                    case SyntaxKind.UnaryMinusExpression:
                        return Unary.Create(info.SetKind(ExprKind.MINUS));

                    case SyntaxKind.UnaryPlusExpression:
                        return Unary.Create(info.SetKind(ExprKind.PLUS));

                    case SyntaxKind.SimpleLambdaExpression:
                        return Lambda.Create(info, (SimpleLambdaExpressionSyntax)info.Node);

                    case SyntaxKind.ParenthesizedLambdaExpression:
                        return Lambda.Create(info, (ParenthesizedLambdaExpressionSyntax)info.Node);

                    case SyntaxKind.ConditionalExpression:
                        return Conditional.Create(info);

                    case SyntaxKind.CastExpression:
                        return Cast.Create(info);

                    case SyntaxKind.ParenthesizedExpression:
                        return Create(info.SetNode(((ParenthesizedExpressionSyntax)info.Node).Expression));

                    case SyntaxKind.PointerType:
                    case SyntaxKind.ArrayType:
                    case SyntaxKind.PredefinedType:
                    case SyntaxKind.NullableType:
                    case SyntaxKind.TupleType:
                        return TypeAccess.Create(info);

                    case SyntaxKind.TypeOfExpression:
                        return TypeOf.Create(info);

                    case SyntaxKind.QualifiedName:
                    case SyntaxKind.IdentifierName:
                    case SyntaxKind.AliasQualifiedName:
                    case SyntaxKind.GenericName:
                        return Name.Create(info);

                    case SyntaxKind.LogicalNotExpression:
                        return Unary.Create(info.SetKind(ExprKind.LOG_NOT));

                    case SyntaxKind.BitwiseNotExpression:
                        return Unary.Create(info.SetKind(ExprKind.BIT_NOT));

                    case SyntaxKind.PreIncrementExpression:
                        return Unary.Create(info.SetKind(ExprKind.PRE_INCR));

                    case SyntaxKind.PreDecrementExpression:
                        return Unary.Create(info.SetKind(ExprKind.PRE_DECR));

                    case SyntaxKind.ThisExpression:
                        return This.CreateExplicit(info);

                    case SyntaxKind.AddressOfExpression:
                        return Unary.Create(info.SetKind(ExprKind.ADDRESS_OF));

                    case SyntaxKind.PointerIndirectionExpression:
                        return Unary.Create(info.SetKind(ExprKind.POINTER_INDIRECTION));

                    case SyntaxKind.DefaultExpression:
                        return Default.Create(info);

                    case SyntaxKind.CheckedExpression:
                        return Checked.Create(info);

                    case SyntaxKind.UncheckedExpression:
                        return Unchecked.Create(info);

                    case SyntaxKind.BaseExpression:
                        return Base.Create(info);

                    case SyntaxKind.AnonymousMethodExpression:
                        return Lambda.Create(info, (AnonymousMethodExpressionSyntax)info.Node);

                    case SyntaxKind.ImplicitArrayCreationExpression:
                        return ImplicitArrayCreation.Create(info);

                    case SyntaxKind.AnonymousObjectCreationExpression:
                        return AnonymousObjectCreation.Create(info);

                    case SyntaxKind.ComplexElementInitializerExpression:
                        return CollectionInitializer.Create(info);

                    case SyntaxKind.SizeOfExpression:
                        return SizeOf.Create(info);

                    case SyntaxKind.PointerMemberAccessExpression:
                        return PointerMemberAccess.Create(info);

                    case SyntaxKind.QueryExpression:
                        return Query.Create(info);

                    case SyntaxKind.InterpolatedStringExpression:
                        return InterpolatedString.Create(info);

                    case SyntaxKind.MemberBindingExpression:
                        return MemberAccess.Create(info, (MemberBindingExpressionSyntax)info.Node);

                    case SyntaxKind.ElementBindingExpression:
                        return BindingElementAccess.Create(info);

                    case SyntaxKind.StackAllocArrayCreationExpression:
                        return StackAllocArrayCreation.Create(info);

                    case SyntaxKind.ImplicitStackAllocArrayCreationExpression:
                        return ImplicitStackAllocArrayCreation.Create(info);

                    case SyntaxKind.ArgListExpression:
                        return ArgList.Create(info);

                    case SyntaxKind.RefTypeExpression:
                        return RefType.Create(info);

                    case SyntaxKind.RefValueExpression:
                        return RefValue.Create(info);

                    case SyntaxKind.MakeRefExpression:
                        return MakeRef.Create(info);

                    case SyntaxKind.ThrowExpression:
                        return Throw.Create(info);

                    case SyntaxKind.DeclarationExpression:
                        return VariableDeclaration.Create(info.Context, (DeclarationExpressionSyntax)info.Node, info.Parent, info.Child);

                    case SyntaxKind.TupleExpression:
                        return Tuple.Create(info);

                    case SyntaxKind.RefExpression:
                        return Ref.Create(info);

                    case SyntaxKind.IsPatternExpression:
                        return IsPattern.Create(info);

                    case SyntaxKind.RangeExpression:
                        return RangeExpression.Create(info);

                    case SyntaxKind.IndexExpression:
                        return Unary.Create(info.SetKind(ExprKind.INDEX));

                    case SyntaxKind.SwitchExpression:
                        return Switch.Create(info);

                    case SyntaxKind.SuppressNullableWarningExpression:
                        return PostfixUnary.Create(info.SetKind(ExprKind.SUPPRESS_NULLABLE_WARNING), ((PostfixUnaryExpressionSyntax)info.Node).Operand);

                    case SyntaxKind.WithExpression:
                        return WithExpression.Create(info);

                    default:
                        info.Context.ModelError(info.Node, $"Unhandled expression '{info.Node}' of kind '{info.Node.Kind()}'");
                        return new Unknown(info);
                }
            }
        }
    }
}
