using Microsoft.CodeAnalysis;
using Microsoft.CodeAnalysis.CSharp;
using Microsoft.CodeAnalysis.CSharp.Syntax;
using System.Linq;
using Semmle.Extraction.Kinds;
using System.Collections.Generic;
using Semmle.Extraction.Entities;

namespace Semmle.Extraction.CSharp.Entities.Expressions
{
    internal static class Query
    {
        /// <summary>
        /// An expression representing a call in a LINQ query.
        /// </summary>
        ///
        /// <remarks>
        /// This code has some problems because the expression kind isn't correct - it should really be
        /// a new ExprKind. The other issue is that the argument to the call is technically a lambda,
        /// rather than the sub-expression itself.
        /// </remarks>
        private class QueryCall : Expression
        {
            public QueryCall(Context cx, IMethodSymbol? method, SyntaxNode clause, IExpressionParentEntity parent, int child)
                : base(new ExpressionInfo(cx, method?.GetAnnotatedReturnType(),
                        cx.CreateLocation(clause.GetLocation()),
                        ExprKind.METHOD_INVOCATION, parent, child, false, null))
            {
                if (method is not null)
                    cx.TrapWriter.Writer.expr_call(this, Method.Create(cx, method));
            }
        }

        /// <summary>
        /// Represents a chain of method calls (the operand being recursive).
        /// </summary>
        private abstract class Clause
        {
            protected readonly IMethodSymbol? method;
            protected readonly List<ExpressionSyntax> arguments = new List<ExpressionSyntax>();
            protected readonly SyntaxNode node;

            protected Clause(IMethodSymbol? method, SyntaxNode node)
            {
                this.method = method;
                this.node = node;
            }

            public ExpressionSyntax Expr => arguments.First();

            public CallClause WithCallClause(IMethodSymbol? newMethod, SyntaxNode newNode) =>
                new CallClause(this, newMethod, newNode);

            public LetClause WithLetClause(IMethodSymbol? newMethod, SyntaxNode newNode, ISymbol newDeclaration, SyntaxToken newName) =>
                new LetClause(this, newMethod, newNode, newDeclaration, newName);

            public Clause AddArgument(ExpressionSyntax arg)
            {
                if (arg is not null)
                    arguments.Add(arg);
                return this;
            }

            protected Expression DeclareRangeVariable(Context cx, IExpressionParentEntity parent, int child, bool getElement, ISymbol variableSymbol, SyntaxToken name)
            {
                var type = cx.GetType(Expr);

                AnnotatedTypeSymbol? declType;
                TypeSyntax? declTypeSyntax = null;
                if (getElement)
                {
                    if (node is FromClauseSyntax from && from.Type is not null)
                    {
                        declTypeSyntax = from.Type;
                        declType = cx.GetType(from.Type);
                    }
                    else
                    {
                        declTypeSyntax = null;
                        declType = GetElementType(cx, type.Symbol);
                    }
                }
                else
                {
                    declType = type;
                }

                var decl = VariableDeclaration.Create(cx,
                    variableSymbol,
                    declType,
                    declTypeSyntax,
                    cx.CreateLocation(node.GetLocation()),
                    true,
                    parent,
                    child
                    );

                Expression.Create(cx, Expr, decl, 0);

                var nameLoc = cx.CreateLocation(name.GetLocation());
                var access = new Expression(new ExpressionInfo(cx, type, nameLoc, ExprKind.LOCAL_VARIABLE_ACCESS, decl, 1, false, null));
                cx.TrapWriter.Writer.expr_access(access, LocalVariable.Create(cx, variableSymbol));

                return decl;
            }

            private static AnnotatedTypeSymbol? GetEnumerableType(Context cx, INamedTypeSymbol type)
            {
                return type.SpecialType == SpecialType.System_Collections_IEnumerable
                    ? cx.Compilation.ObjectType.WithAnnotation(NullableAnnotation.NotAnnotated)
                    : type.OriginalDefinition.SpecialType == SpecialType.System_Collections_Generic_IEnumerable_T
                        ? type.GetAnnotatedTypeArguments().First()
                        : (AnnotatedTypeSymbol?)null;
            }

            private static AnnotatedTypeSymbol? GetEnumerableElementType(Context cx, INamedTypeSymbol type)
            {
                var et = GetEnumerableType(cx, type);
                if (et is not null)
                    return et;

                return type.AllInterfaces
                    .Where(i => i.OriginalDefinition.SpecialType == SpecialType.System_Collections_Generic_IEnumerable_T)
                    .Concat(type.AllInterfaces.Where(i => i.SpecialType == SpecialType.System_Collections_IEnumerable))
                    .Select(i => GetEnumerableType(cx, i))
                    .FirstOrDefault();
            }

            private static AnnotatedTypeSymbol? GetElementType(Context cx, ITypeSymbol? symbol) =>
                symbol switch
                {
                    IArrayTypeSymbol a => a.GetAnnotatedElementType(),
                    INamedTypeSymbol n => GetEnumerableElementType(cx, n),
                    _ => null
                };

            protected void PopulateArguments(Context cx, QueryCall callExpr, int child)
            {
                foreach (var e in arguments)
                {
                    Expression.Create(cx, e, callExpr, child++);
                }
            }

            public abstract Expression Populate(Context cx, IExpressionParentEntity parent, int child);
        }

        private class RangeClause : Clause
        {
            private readonly ISymbol declaration;
            private readonly SyntaxToken name;

            public RangeClause(IMethodSymbol? method, SyntaxNode node, ISymbol declaration, SyntaxToken name) : base(method, node)
            {
                this.declaration = declaration;
                this.name = name;
            }

            public override Expression Populate(Context cx, IExpressionParentEntity parent, int child) =>
                DeclareRangeVariable(cx, parent, child, true, declaration, name);
        }

        private class LetClause : Clause
        {
            private readonly Clause operand;
            private readonly ISymbol declaration;
            private readonly SyntaxToken name;
            private ISymbol? intoDeclaration;

            public LetClause(Clause operand, IMethodSymbol? method, SyntaxNode node, ISymbol declaration, SyntaxToken name) : base(method, node)
            {
                this.operand = operand;
                this.declaration = declaration;
                this.name = name;
            }

            public Clause WithInto(ISymbol into)
            {
                intoDeclaration = into;
                return this;
            }

            private void DeclareIntoVariable(Context cx, IExpressionParentEntity parent, int intoChild, bool getElement)
            {
                if (intoDeclaration is not null)
                    DeclareRangeVariable(cx, parent, intoChild, getElement, intoDeclaration, name);
            }

            public override Expression Populate(Context cx, IExpressionParentEntity parent, int child)
            {
                if (method is null)
                    cx.ModelError(node, "Unable to determine target of query expression");

                var callExpr = new QueryCall(cx, method, node, parent, child);
                operand.Populate(cx, callExpr, 0);
                DeclareRangeVariable(cx, callExpr, 1, false, declaration, name);
                PopulateArguments(cx, callExpr, 2);
                DeclareIntoVariable(cx, callExpr, 2 + arguments.Count, false);
                return callExpr;
            }
        }

        private class CallClause : Clause
        {
            private readonly Clause operand;

            public CallClause(Clause operand, IMethodSymbol? method, SyntaxNode node) : base(method, node)
            {
                this.operand = operand;
            }

            public override Expression Populate(Context cx, IExpressionParentEntity parent, int child)
            {
                var callExpr = new QueryCall(cx, method, node, parent, child);
                operand.Populate(cx, callExpr, 0);
                PopulateArguments(cx, callExpr, 1);
                return callExpr;
            }
        }

        /// <summary>
        /// Construct a "syntax tree" representing the LINQ query.
        /// </summary>
        ///
        /// <param name="cx">The extraction context.</param>
        /// <param name="node">The query expression.</param>
        /// <returns>A "syntax tree" of the query.</returns>
        private static Clause ConstructQueryExpression(Context cx, QueryExpressionSyntax node)
        {
            var info = cx.GetModel(node).GetQueryClauseInfo(node.FromClause);
            var method = info.OperationInfo.Symbol as IMethodSymbol;

            var clauseExpr = new RangeClause(method, node.FromClause, cx.GetModel(node).GetDeclaredSymbol(node.FromClause)!, node.FromClause.Identifier).AddArgument(node.FromClause.Expression);

            foreach (var qc in node.Body.Clauses)
            {
                info = cx.GetModel(node).GetQueryClauseInfo(qc);

                method = info.OperationInfo.Symbol as IMethodSymbol;

                switch (qc.Kind())
                {
                    case SyntaxKind.OrderByClause:
                        var orderByClause = (OrderByClauseSyntax)qc;
                        foreach (var ordering in orderByClause.Orderings)
                        {
                            method = cx.GetModel(node).GetSymbolInfo(ordering).Symbol as IMethodSymbol;

                            clauseExpr = clauseExpr.WithCallClause(method, orderByClause).AddArgument(ordering.Expression);

                            if (method is null)
                                cx.ModelError(ordering, "Could not determine method call for orderby clause");
                        }
                        break;
                    case SyntaxKind.WhereClause:
                        var whereClause = (WhereClauseSyntax)qc;
                        clauseExpr = clauseExpr.WithCallClause(method, whereClause).AddArgument(whereClause.Condition);
                        break;
                    case SyntaxKind.FromClause:
                        var fromClause = (FromClauseSyntax)qc;
                        clauseExpr = clauseExpr.
                            WithLetClause(method, fromClause, cx.GetModel(node).GetDeclaredSymbol(fromClause)!, fromClause.Identifier).
                            AddArgument(fromClause.Expression);
                        break;
                    case SyntaxKind.LetClause:
                        var letClause = (LetClauseSyntax)qc;
                        clauseExpr = clauseExpr.WithLetClause(method, letClause, cx.GetModel(node).GetDeclaredSymbol(letClause)!, letClause.Identifier).
                            AddArgument(letClause.Expression);
                        break;
                    case SyntaxKind.JoinClause:
                        var joinClause = (JoinClauseSyntax)qc;

                        clauseExpr = clauseExpr.WithLetClause(method, joinClause, cx.GetModel(node).GetDeclaredSymbol(joinClause)!, joinClause.Identifier).
                            AddArgument(joinClause.InExpression).
                            AddArgument(joinClause.LeftExpression).
                            AddArgument(joinClause.RightExpression);

                        if (joinClause.Into is not null)
                        {
                            var into = cx.GetModel(node).GetDeclaredSymbol(joinClause.Into)!;
                            ((LetClause)clauseExpr).WithInto(into);
                        }

                        break;
                    default:
                        throw new InternalError(qc, $"Unhandled query clause of kind {qc.Kind()}");
                }
            }

            method = cx.GetModel(node).GetSymbolInfo(node.Body.SelectOrGroup).Symbol as IMethodSymbol;

            clauseExpr = new CallClause(clauseExpr, method, node.Body.SelectOrGroup);

            if (node.Body.SelectOrGroup is SelectClauseSyntax selectClause)
            {
                clauseExpr.AddArgument(selectClause.Expression);
            }
            else if (node.Body.SelectOrGroup is GroupClauseSyntax groupClause)
            {
                clauseExpr.
                    AddArgument(groupClause.GroupExpression).
                    AddArgument(groupClause.ByExpression);
            }
            else
            {
                throw new InternalError(node, "Failed to process select/group by clause");
            }

            return clauseExpr;
        }

        public static Expression Create(ExpressionNodeInfo info) =>
            ConstructQueryExpression(info.Context, (QueryExpressionSyntax)info.Node).Populate(info.Context, info.Parent, info.Child);
    }
}
