using Microsoft.CodeAnalysis;
using Microsoft.CodeAnalysis.CSharp;
using Microsoft.CodeAnalysis.CSharp.Syntax;
using Semmle.Extraction.CSharp.Populators;
using System.Linq;

namespace Semmle.Extraction.CSharp.Entities.Expressions
{
    static class Name
    {
        public static Expression Create(ExpressionNodeInfo info)
        {
            var symbolInfo = info.Context.GetSymbolInfo(info.Node);

            var target = symbolInfo.Symbol;

            if (target == null && symbolInfo.CandidateReason == CandidateReason.OverloadResolutionFailure)
            {
                // The expression is probably a cast
                target = info.Context.GetSymbolInfo((CSharpSyntaxNode)info.Node.Parent).Symbol;
            }

            if (target == null && (symbolInfo.CandidateReason == CandidateReason.Ambiguous || symbolInfo.CandidateReason == CandidateReason.MemberGroup))
            {
                // Pick one at random - they probably resolve to the same ID
                target = symbolInfo.CandidateSymbols.First();
            }

            if (target == null)
            {
                info.Context.ModelError(info.Node, "Failed to resolve name");
                return new Unknown(info);
            }

            // There is a very strange bug in Microsoft.CodeAnalysis whereby
            // target.Kind throws System.InvalidOperationException for Discard symbols.
            // So, short-circuit that test here.
            // Ideally this would be another case in the switch statement below.
            if (target is IDiscardSymbol)
                return new Discard(info);

            switch (target.Kind)
            {
                case SymbolKind.TypeParameter:
                case SymbolKind.NamedType:
                case SymbolKind.DynamicType:
                    return TypeAccess.Create(info);

                case SymbolKind.Property:
                case SymbolKind.Field:
                case SymbolKind.Event:
                case SymbolKind.Method:
                    return Access.Create(info, target, true, info.Context.CreateEntity(target));

                case SymbolKind.Local:
                case SymbolKind.RangeVariable:
                    return Access.Create(info, target, false, LocalVariable.GetAlreadyCreated(info.Context, target));

                case SymbolKind.Parameter:
                    return Access.Create(info, target, false, Parameter.GetAlreadyCreated(info.Context, (IParameterSymbol)target));

                default:
                    throw new InternalError(info.Node, $"Unhandled identifier kind '{target.Kind}'");
            }
        }
    }
}
