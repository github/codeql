using Microsoft.CodeAnalysis;
using Microsoft.CodeAnalysis.CSharp.Syntax;
using System.Linq;
using Microsoft.CodeAnalysis.CSharp;
using Semmle.Extraction.Kinds;
using System.IO;

namespace Semmle.Extraction.CSharp.Entities.Expressions
{
    internal class Invocation : Expression<InvocationExpressionSyntax>
    {
        private Invocation(ExpressionNodeInfo info)
            : base(info.SetKind(GetKind(info)))
        {
            this.info = info;
        }

        private readonly ExpressionNodeInfo info;

        public static Expression Create(ExpressionNodeInfo info) => new Invocation(info).TryPopulate();

        protected override void PopulateExpression(TextWriter trapFile)
        {
            if (IsNameof(Syntax))
            {
                PopulateArguments(trapFile, Syntax.ArgumentList, 0);
                return;
            }

            var child = -1;
            string memberName = null;
            var target = TargetSymbol;
            switch (Syntax.Expression)
            {
                case MemberAccessExpressionSyntax memberAccess:
                    memberName = memberAccess.Name.Identifier.Text;
                    if (Syntax.Expression.Kind() == SyntaxKind.SimpleMemberAccessExpression)
                        // Qualified method call; `x.M()`
                        Create(cx, memberAccess.Expression, this, child++);
                    else
                        // Pointer member access; `x->M()`
                        Create(cx, Syntax.Expression, this, child++);
                    break;
                case MemberBindingExpressionSyntax memberBinding:
                    // Conditionally qualified method call; `x?.M()`
                    memberName = memberBinding.Name.Identifier.Text;
                    Create(cx, FindConditionalQualifier(memberBinding), this, child++);
                    MakeConditional(trapFile);
                    break;
                case SimpleNameSyntax simpleName when (Kind == ExprKind.METHOD_INVOCATION):
                    // Unqualified method call; `M()`
                    memberName = simpleName.Identifier.Text;
                    if (target != null && !target.IsStatic)
                    {
                        // Implicit `this` qualifier; add explicitly

                        if (cx.GetModel(Syntax).GetEnclosingSymbol(Location.symbol.SourceSpan.Start) is IMethodSymbol callingMethod)
                            This.CreateImplicit(cx, Entities.Type.Create(cx, callingMethod.ContainingType), Location, this, child++);
                        else
                            cx.ModelError(Syntax, "Couldn't determine implicit this type");
                    }
                    else
                    {
                        // No implicit `this` qualifier
                        child++;
                    }
                    break;
                default:
                    // Delegate call; `d()`
                    Create(cx, Syntax.Expression, this, child++);
                    break;
            }

            var isDynamicCall = IsDynamicCall(info);
            if (isDynamicCall)
            {
                if (memberName != null)
                    trapFile.dynamic_member_name(this, memberName);
                else
                    cx.ModelError(Syntax, "Unable to get name for dynamic call.");
            }

            PopulateArguments(trapFile, Syntax.ArgumentList, child);

            if (target == null)
            {
                if (!isDynamicCall && !IsDelegateCall(info))
                    cx.ModelError(Syntax, "Unable to resolve target for call. (Compilation error?)");
                return;
            }

            var targetKey = Method.Create(cx, target);
            trapFile.expr_call(this, targetKey);
        }

        private static bool IsDynamicCall(ExpressionNodeInfo info)
        {
            // Either the qualifier (Expression) is dynamic,
            // or one of the arguments is dynamic.
            var node = (InvocationExpressionSyntax)info.Node;
            return !IsDelegateCall(info) &&
                (IsDynamic(info.Context, node.Expression) || node.ArgumentList.Arguments.Any(arg => IsDynamic(info.Context, arg.Expression)));
        }

        public SymbolInfo SymbolInfo => info.SymbolInfo;

        public IMethodSymbol TargetSymbol
        {
            get
            {
                var si = SymbolInfo;

                if (si.Symbol != null)
                    return si.Symbol as IMethodSymbol;

                if (si.CandidateReason == CandidateReason.OverloadResolutionFailure)
                {
                    // This seems to be a bug in Roslyn
                    // For some reason, typeof(X).InvokeMember(...) fails to resolve the correct
                    // InvokeMember() method, even though the number of parameters clearly identifies the correct method

                    var candidates = si.CandidateSymbols
                        .OfType<IMethodSymbol>()
                        .Where(method => method.Parameters.Length >= Syntax.ArgumentList.Arguments.Count)
                        .Where(method => method.Parameters.Count(p => !p.HasExplicitDefaultValue) <= Syntax.ArgumentList.Arguments.Count);

                    return cx.Extractor.Standalone ?
                        candidates.FirstOrDefault() :
                        candidates.SingleOrDefault();
                }

                return si.Symbol as IMethodSymbol;
            }
        }

        private static bool IsDelegateCall(ExpressionNodeInfo info)
        {
            var si = info.SymbolInfo;

            if (si.CandidateReason == CandidateReason.OverloadResolutionFailure &&
                si.CandidateSymbols.OfType<IMethodSymbol>().All(s => s.MethodKind == MethodKind.DelegateInvoke))
            {
                return true;
            }

            // Delegate variable is a dynamic
            var node = (InvocationExpressionSyntax)info.Node;
            if (si.CandidateReason == CandidateReason.LateBound &&
                node.Expression is IdentifierNameSyntax &&
                IsDynamic(info.Context, node.Expression) &&
                si.Symbol == null)
            {
                return true;
            }

            return si.Symbol != null &&
                si.Symbol.Kind == SymbolKind.Method &&
                ((IMethodSymbol)si.Symbol).MethodKind == MethodKind.DelegateInvoke;
        }

        private static bool IsLocalFunctionInvocation(ExpressionNodeInfo info)
        {
            return info.SymbolInfo.Symbol is IMethodSymbol target &&
                target.MethodKind == MethodKind.LocalFunction;
        }

        private static ExprKind GetKind(ExpressionNodeInfo info)
        {
            return IsNameof((InvocationExpressionSyntax)info.Node)
                ? ExprKind.NAMEOF
                : IsDelegateCall(info)
                    ? ExprKind.DELEGATE_INVOCATION
                    : IsLocalFunctionInvocation(info)
                        ? ExprKind.LOCAL_FUNCTION_INVOCATION
                        : ExprKind.METHOD_INVOCATION;
        }

        private static bool IsNameof(InvocationExpressionSyntax syntax)
        {
            // Odd that this is not a separate expression type.
            // Maybe it will be in the future.
            return syntax.Expression is IdentifierNameSyntax id && id.Identifier.Text == "nameof";
        }
    }
}
