using System;
using System.IO;
using System.Linq;
using Microsoft.CodeAnalysis;
using Microsoft.CodeAnalysis.CSharp;
using Microsoft.CodeAnalysis.CSharp.Syntax;
using Semmle.Extraction.Kinds;

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

        private bool IsEventDelegateCall() => Kind == ExprKind.DELEGATE_INVOCATION && Context.GetModel(Syntax.Expression).GetSymbolInfo(Syntax.Expression).Symbol?.Kind == SymbolKind.Event;

        private bool IsExplicitDelegateInvokeCall() => Kind == ExprKind.DELEGATE_INVOCATION && Context.GetModel(Syntax.Expression).GetSymbolInfo(Syntax.Expression).Symbol is IMethodSymbol m && m.MethodKind == MethodKind.DelegateInvoke;

        protected override void PopulateExpression(TextWriter trapFile)
        {
            if (IsNameof(Syntax))
            {
                PopulateArguments(trapFile, Syntax.ArgumentList, 0);
                return;
            }

            var child = -1;
            string? memberName = null;
            var target = TargetSymbol;
            switch (Syntax.Expression)
            {
                case MemberAccessExpressionSyntax memberAccess when Kind == ExprKind.METHOD_INVOCATION || IsEventDelegateCall() || IsExplicitDelegateInvokeCall():
                    memberName = memberAccess.Name.Identifier.Text;
                    if (Syntax.Expression.Kind() == SyntaxKind.SimpleMemberAccessExpression)
                        // Qualified method call; `x.M()`
                        Create(Context, memberAccess.Expression, this, child++);
                    else
                        // Pointer member access; `x->M()`
                        Create(Context, Syntax.Expression, this, child++);
                    break;
                case MemberBindingExpressionSyntax memberBinding:
                    // Conditionally qualified method call; `x?.M()`
                    memberName = memberBinding.Name.Identifier.Text;
                    Create(Context, FindConditionalQualifier(memberBinding), this, child++);
                    MakeConditional(trapFile);
                    break;
                case SimpleNameSyntax simpleName when Kind == ExprKind.METHOD_INVOCATION:
                    // Unqualified method call; `M()`
                    memberName = simpleName.Identifier.Text;
                    if (target is not null && !target.IsStatic)
                    {
                        // Implicit `this` qualifier; add explicitly
                        if (Location.Symbol is not null &&
                            Context.GetModel(Syntax).GetEnclosingSymbol(Location.Symbol.SourceSpan.Start) is IMethodSymbol callingMethod)
                        {
                            This.CreateImplicit(Context, callingMethod.ContainingType, Location, this, child++);
                        }
                        else
                        {
                            Context.ModelError(Syntax, "Couldn't determine implicit this type");
                        }
                    }
                    else
                    {
                        // No implicit `this` qualifier
                        child++;
                    }
                    break;
                default:
                    // Delegate or function pointer call; `d()`
                    Create(Context, Syntax.Expression, this, child++);
                    break;
            }

            var isDynamicCall = IsDynamicCall(info);
            if (isDynamicCall)
            {
                if (memberName is not null)
                    trapFile.dynamic_member_name(this, memberName);
                else
                    Context.ModelError(Syntax, "Unable to get name for dynamic call.");
            }

            PopulateArguments(trapFile, Syntax.ArgumentList, child);

            if (target is null)
            {
                if (!isDynamicCall && !IsDelegateLikeCall(info))
                    Context.ModelError(Syntax, "Unable to resolve target for call. (Compilation error?)");
                return;
            }

            var targetKey = Method.Create(Context, target);
            trapFile.expr_call(this, targetKey);
        }

        private static bool IsDynamicCall(ExpressionNodeInfo info)
        {
            // Either the qualifier (Expression) is dynamic,
            // or one of the arguments is dynamic.
            var node = (InvocationExpressionSyntax)info.Node;
            return !IsDelegateLikeCall(info) &&
                (IsDynamic(info.Context, node.Expression) || node.ArgumentList.Arguments.Any(arg => IsDynamic(info.Context, arg.Expression)));
        }

        public SymbolInfo SymbolInfo => info.SymbolInfo;

        public IMethodSymbol? TargetSymbol
        {
            get
            {
                var si = SymbolInfo;

                if (si.Symbol is not null)
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

                    return Context.ExtractionContext.Mode.HasFlag(ExtractorMode.Standalone) ?
                        candidates.FirstOrDefault() :
                        candidates.SingleOrDefault();
                }

                return si.Symbol as IMethodSymbol;
            }
        }

        private static bool IsDelegateLikeCall(ExpressionNodeInfo info)
        {
            return IsDelegateLikeCall(info, symbol => IsFunctionPointer(symbol) || IsDelegateInvoke(symbol));
        }

        private static bool IsDelegateInvokeCall(ExpressionNodeInfo info)
        {
            return IsDelegateLikeCall(info, IsDelegateInvoke);
        }

        private static bool IsDelegateLikeCall(ExpressionNodeInfo info, Func<ISymbol?, bool> check)
        {
            var si = info.SymbolInfo;

            if (si.CandidateReason == CandidateReason.OverloadResolutionFailure &&
                si.CandidateSymbols.All(check))
            {
                return true;
            }

            // Delegate variable is a dynamic
            var node = (InvocationExpressionSyntax)info.Node;
            if (si.CandidateReason == CandidateReason.LateBound &&
                node.Expression is IdentifierNameSyntax &&
                IsDynamic(info.Context, node.Expression) &&
                si.Symbol is null)
            {
                return true;
            }

            return check(si.Symbol);
        }

        private static bool IsFunctionPointer(ISymbol? symbol)
        {
            return symbol is not null &&
                symbol.Kind == SymbolKind.FunctionPointerType;
        }

        private static bool IsDelegateInvoke(ISymbol? symbol)
        {
            return symbol is not null &&
                symbol.Kind == SymbolKind.Method &&
                ((IMethodSymbol)symbol).MethodKind == MethodKind.DelegateInvoke;
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
                : IsDelegateLikeCall(info)
                    ? IsDelegateInvokeCall(info)
                        ? ExprKind.DELEGATE_INVOCATION
                        : ExprKind.FUNCTION_POINTER_INVOCATION
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
