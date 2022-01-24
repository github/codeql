using System;
using System.Collections.Generic;
using Microsoft.CodeAnalysis.CSharp.Syntax;
using Semmle.Extraction.Kinds;
using Semmle.Extraction.Entities;

namespace Semmle.Extraction.CSharp.Entities.Expressions
{
    internal class PropertyPattern : Expression
    {
        internal PropertyPattern(Context cx, PropertyPatternClauseSyntax pp, IExpressionParentEntity parent, int child) :
            base(new ExpressionInfo(cx, null, cx.CreateLocation(pp.GetLocation()), ExprKind.PROPERTY_PATTERN, parent, child, false, null))
        {
            child = 0;
            foreach (var sub in pp.Subpatterns)
            {
                if (sub.ExpressionColon is null)
                {
                    Context.ModelError(sub, "Expected to find 'Expression:' in pattern.");
                    continue;
                }
                MakeExpressions(cx, this, sub, child++);
            }
        }

        private class AccessStep
        {
            public readonly string Identifier;
            public readonly Microsoft.CodeAnalysis.Location Location;

            public AccessStep(string identifier, Microsoft.CodeAnalysis.Location location)
            {
                Identifier = identifier;
                Location = location;
            }
        }

        private class AccessStepPack
        {
            public readonly List<AccessStep> Prefix = new List<AccessStep>();
            public AccessStep Last { get; private set; }

            public AccessStepPack Add(string identifier, Microsoft.CodeAnalysis.Location location)
            {
                Prefix.Add(Last);
                Last = new AccessStep(identifier, location);
                return this;
            }

            public AccessStepPack(string identifier, Microsoft.CodeAnalysis.Location location)
            {
                Last = new AccessStep(identifier, location);
            }
        }

        private static AccessStepPack GetAccessStepPack(ExpressionSyntax syntax)
        {
            switch (syntax)
            {
                case MemberAccessExpressionSyntax memberAccess:
                    return GetAccessStepPack(memberAccess.Expression).Add(memberAccess.Name.Identifier.ValueText, memberAccess.Name.Identifier.GetLocation());
                case IdentifierNameSyntax identifier:
                    return new AccessStepPack(identifier.Identifier.Text, identifier.GetLocation());
                default:
                    throw new InternalError(syntax, "Unexpected expression syntax in property patterns.");
            }
        }

        private static AccessStepPack GetAccessStepPack(BaseExpressionColonSyntax syntax)
        {
            switch (syntax)
            {
                case NameColonSyntax ncs:
                    return new AccessStepPack(ncs.Name.ToString(), ncs.Name.GetLocation());
                case ExpressionColonSyntax ecs:
                    return GetAccessStepPack(ecs.Expression);
                default:
                    throw new InternalError(syntax, "Unsupported expression colon in property pattern.");
            };
        }

        private static Expression CreateSyntheticExp(Context cx, Microsoft.CodeAnalysis.Location location, IExpressionParentEntity parent, int child) =>
            new Expression(new ExpressionInfo(cx, null, cx.CreateLocation(location), ExprKind.PROPERTY_PATTERN, parent, child, false, null));

        private static void MakeExpressions(Context cx, IExpressionParentEntity parent, SubpatternSyntax syntax, int child)
        {
            var trapFile = cx.TrapWriter.Writer;
            var pack = GetAccessStepPack(syntax.ExpressionColon!);

            foreach (var step in pack.Prefix)
            {
                var exp = CreateSyntheticExp(cx, step.Location, parent, child);
                trapFile.exprorstmt_name(exp, step.Identifier);
                parent = exp;
                child = 0;
            }

            var p = Expressions.Pattern.Create(cx, syntax.Pattern, parent, child);
            trapFile.exprorstmt_name(p, pack.Last.Identifier);
        }
    }
}
