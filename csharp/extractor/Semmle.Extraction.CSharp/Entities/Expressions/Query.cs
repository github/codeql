using Microsoft.CodeAnalysis;
using Microsoft.CodeAnalysis.CSharp;
using Microsoft.CodeAnalysis.CSharp.Syntax;
using System.Linq;
using Semmle.Extraction.Kinds;
using System.Collections.Generic;
using Semmle.Extraction.CSharp.Populators;
using Semmle.Extraction.Entities;

namespace Semmle.Extraction.CSharp.Entities.Expressions
{
    static class Query
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
            public QueryCall(Context cx, IMethodSymbol method, SyntaxNode clause, IExpressionParentEntity parent, int child)
                : base(new ExpressionInfo(cx, Type.Create(cx, method?.ReturnType), cx.Create(clause.GetLocation()), ExprKind.METHOD_INVOCATION, parent, child, false, null))
            {
                if (method != null)
                    cx.Emit(Tuples.expr_call(this, Method.Create(cx, method)));
            }
        }

        /// <summary>
        /// Represents a chain of method calls (the operand being recursive).
        /// </summary>
        class ClauseCall
        {
            public ClauseCall operand;
            public IMethodSymbol method;
            public readonly List<ExpressionSyntax> arguments = new List<ExpressionSyntax>();
            public SyntaxNode node;
            public ISymbol declaration;
            public SyntaxToken name;
            public ISymbol intoDeclaration;

            public ExpressionSyntax Expr => arguments.First();

            public ClauseCall WithClause(IMethodSymbol newMethod, SyntaxNode newNode, SyntaxToken newName = default(SyntaxToken), ISymbol newDeclaration = null)
            {
                return new ClauseCall
                {
                    operand = this,
                    method = newMethod,
                    node = newNode,
                    name = newName,
                    declaration = newDeclaration
                };
            }

            public ClauseCall AddArgument(ExpressionSyntax arg)
            {
                if (arg != null)
                    arguments.Add(arg);
                return this;
            }

            public ClauseCall WithInto(ISymbol into)
            {
                intoDeclaration = into;
                return this;
            }

            Expression DeclareRangeVariable(Context cx, IExpressionParentEntity parent, int child, bool getElement)
            {
                return DeclareRangeVariable(cx, parent, child, getElement, declaration);
            }

            void DeclareIntoVariable(Context cx, IExpressionParentEntity parent, int intoChild, bool getElement)
            {
                if (intoDeclaration != null)
                    DeclareRangeVariable(cx, parent, intoChild, getElement, intoDeclaration);
            }

            Expression DeclareRangeVariable(Context cx, IExpressionParentEntity parent, int child, bool getElement, ISymbol variableSymbol)
            {
                var type = Type.Create(cx, cx.GetType(Expr));
                Semmle.Extraction.Entities.Location nameLoc;

                Type declType;
                if (getElement)
                {
                    var from = node as FromClauseSyntax;
                    declType = from != null && from.Type != null
                         ? Type.Create(cx, cx.GetType(from.Type))
                         : type.ElementType;
                }
                else
                    declType = type;

                var decl = VariableDeclaration.Create(cx,
                    variableSymbol,
                    declType,
                    cx.Create(node.GetLocation()),
                    nameLoc = cx.Create(name.GetLocation()),
                    true,
                    parent,
                    child
                    );

                Expression.Create(cx, Expr, decl, 0);

                var access = new Expression(new ExpressionInfo(cx, type, nameLoc, ExprKind.LOCAL_VARIABLE_ACCESS, decl, 1, false, null));
                cx.Emit(Tuples.expr_access(access, LocalVariable.GetAlreadyCreated(cx, variableSymbol)));

                return decl;
            }

            void PopulateArguments(Context cx, QueryCall callExpr, int child)
            {
                foreach (var e in arguments)
                {
                    Expression.Create(cx, e, callExpr, child++);
                }
            }

            public Expression Populate(Context cx, IExpressionParentEntity parent, int child)
            {
                if (declaration != null)    // The first "from" clause, or a "let" clause
                {
                    if (operand == null)
                    {
                        return DeclareRangeVariable(cx, parent, child, true);
                    }
                    else
                    {
                        if (method == null)
                            cx.ModelError(node, "Unable to determine target of query expression");

                        var callExpr = new QueryCall(cx, method, node, parent, child);
                        operand.Populate(cx, callExpr, 0);
                        DeclareRangeVariable(cx, callExpr, 1, false);
                        PopulateArguments(cx, callExpr, 2);
                        DeclareIntoVariable(cx, callExpr, 2 + arguments.Count, false);
                        return callExpr;
                    }
                }
                else
                {
                    var callExpr = new QueryCall(cx, method, node, parent, child);
                    operand.Populate(cx, callExpr, 0);
                    PopulateArguments(cx, callExpr, 1);
                    return callExpr;
                }
            }
        }

        /// <summary>
        /// Construct a "syntax tree" representing the LINQ query.
        /// </summary>
        ///
        /// <param name="cx">The extraction context.</param>
        /// <param name="node">The query expression.</param>
        /// <returns>A "syntax tree" of the query.</returns>
        static ClauseCall ConstructQueryExpression(Context cx, QueryExpressionSyntax node)
        {
            var info = cx.Model(node).GetQueryClauseInfo(node.FromClause);
            var method = info.OperationInfo.Symbol as IMethodSymbol;

            ClauseCall clauseExpr = new ClauseCall
            {
                declaration = cx.Model(node).GetDeclaredSymbol(node.FromClause),
                name = node.FromClause.Identifier,
                method = method,
                node = node.FromClause
            }.AddArgument(node.FromClause.Expression);

            foreach (var qc in node.Body.Clauses)
            {
                info = cx.Model(node).GetQueryClauseInfo(qc);

                method = info.OperationInfo.Symbol as IMethodSymbol;

                switch (qc.Kind())
                {
                    case SyntaxKind.OrderByClause:
                        var orderByClause = (OrderByClauseSyntax)qc;
                        foreach (var ordering in orderByClause.Orderings)
                        {
                            method = cx.Model(node).GetSymbolInfo(ordering).Symbol as IMethodSymbol;

                            clauseExpr = clauseExpr.WithClause(method, orderByClause).AddArgument(ordering.Expression);

                            if (method == null)
                                cx.ModelError(ordering, "Could not determine method call for orderby clause");
                        }
                        break;
                    case SyntaxKind.WhereClause:
                        var whereClause = (WhereClauseSyntax)qc;
                        clauseExpr = clauseExpr.WithClause(method, whereClause).AddArgument(whereClause.Condition);
                        break;
                    case SyntaxKind.FromClause:
                        var fromClause = (FromClauseSyntax)qc;
                        clauseExpr = clauseExpr.
                            WithClause(method, fromClause, fromClause.Identifier, cx.Model(node).GetDeclaredSymbol(fromClause)).
                            AddArgument(fromClause.Expression);
                        break;
                    case SyntaxKind.LetClause:
                        var letClause = (LetClauseSyntax)qc;
                        clauseExpr = clauseExpr.WithClause(method, letClause, letClause.Identifier, cx.Model(node).GetDeclaredSymbol(letClause)).
                            AddArgument(letClause.Expression);
                        break;
                    case SyntaxKind.JoinClause:
                        var joinClause = (JoinClauseSyntax)qc;

                        clauseExpr = clauseExpr.WithClause(method, joinClause, joinClause.Identifier, cx.Model(node).GetDeclaredSymbol(joinClause)).
                            AddArgument(joinClause.InExpression).
                            AddArgument(joinClause.LeftExpression).
                            AddArgument(joinClause.RightExpression);

                        if (joinClause.Into != null)
                        {
                            var into = cx.Model(node).GetDeclaredSymbol(joinClause.Into);
                            clauseExpr.WithInto(into);
                        }

                        break;
                    default:
                        throw new InternalError(qc, "Unhandled query clause of kind {0}", qc.Kind());
                }
            }

            method = cx.Model(node).GetSymbolInfo(node.Body.SelectOrGroup).Symbol as IMethodSymbol;

            var selectClause = node.Body.SelectOrGroup as SelectClauseSyntax;
            var groupClause = node.Body.SelectOrGroup as GroupClauseSyntax;

            clauseExpr = new ClauseCall { operand = clauseExpr, method = method, node = node.Body.SelectOrGroup };

            if (selectClause != null)
            {
                clauseExpr.AddArgument(selectClause.Expression);
            }
            else if (groupClause != null)
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
