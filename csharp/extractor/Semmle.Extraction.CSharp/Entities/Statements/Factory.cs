using Microsoft.CodeAnalysis.CSharp;
using Microsoft.CodeAnalysis.CSharp.Syntax;

namespace Semmle.Extraction.CSharp.Entities.Statements
{
    internal static class Factory
    {
        internal static Statement Create(Context cx, StatementSyntax node, Statement parent, int child)
        {
            switch (node.Kind())
            {
                case SyntaxKind.ForStatement:
                    return For.Create(cx, (ForStatementSyntax)node, parent, child);
                case SyntaxKind.ExpressionStatement:
                    return ExpressionStatement.Create(cx, (ExpressionStatementSyntax)node, parent, child);
                case SyntaxKind.UsingStatement:
                    return Using.Create(cx, (UsingStatementSyntax)node, parent, child);
                case SyntaxKind.LocalDeclarationStatement:
                    return LocalDeclaration.Create(cx, (LocalDeclarationStatementSyntax)node, parent, child);
                case SyntaxKind.Block:
                    return Block.Create(cx, (BlockSyntax)node, parent, child);
                case SyntaxKind.ReturnStatement:
                    return Return.Create(cx, (ReturnStatementSyntax)node, parent, child);
                case SyntaxKind.SwitchStatement:
                    return Switch.Create(cx, (SwitchStatementSyntax)node, parent, child);
                case SyntaxKind.BreakStatement:
                    return Break.Create(cx, (BreakStatementSyntax)node, parent, child);
                case SyntaxKind.IfStatement:
                    return If.Create(cx, (IfStatementSyntax)node, parent, child);
                case SyntaxKind.WhileStatement:
                    return While.Create(cx, (WhileStatementSyntax)node, parent, child);
                case SyntaxKind.DoStatement:
                    return Do.Create(cx, (DoStatementSyntax)node, parent, child);
                case SyntaxKind.YieldReturnStatement:
                    return Yield.Create(cx, (YieldStatementSyntax)node, parent, child);
                case SyntaxKind.ThrowStatement:
                    return Throw.Create(cx, (ThrowStatementSyntax)node, parent, child);
                case SyntaxKind.TryStatement:
                    return Try.Create(cx, (TryStatementSyntax)node, parent, child);
                case SyntaxKind.EmptyStatement:
                    return Empty.Create(cx, (EmptyStatementSyntax)node, parent, child);
                case SyntaxKind.FixedStatement:
                    return Fixed.Create(cx, (FixedStatementSyntax)node, parent, child);
                case SyntaxKind.LockStatement:
                    return Lock.Create(cx, (LockStatementSyntax)node, parent, child);
                case SyntaxKind.GotoDefaultStatement:
                case SyntaxKind.GotoStatement:
                case SyntaxKind.GotoCaseStatement:
                    return Goto.Create(cx, (GotoStatementSyntax)node, parent, child);
                case SyntaxKind.LabeledStatement:
                    return Labeled.Create(cx, (LabeledStatementSyntax)node, parent, child);
                case SyntaxKind.CheckedStatement:
                    return Checked.Create(cx, (CheckedStatementSyntax)node, parent, child);
                case SyntaxKind.UncheckedStatement:
                    return Unchecked.Create(cx, (CheckedStatementSyntax)node, parent, child);
                case SyntaxKind.ForEachStatement:
                    return ForEach.Create(cx, (ForEachStatementSyntax)node, parent, child);
                case SyntaxKind.YieldBreakStatement:
                    return Yield.Create(cx, (YieldStatementSyntax)node, parent, child);
                case SyntaxKind.ContinueStatement:
                    return Continue.Create(cx, (ContinueStatementSyntax)node, parent, child);
                case SyntaxKind.UnsafeStatement:
                    return Unsafe.Create(cx, (UnsafeStatementSyntax)node, parent, child);
                case SyntaxKind.LocalFunctionStatement:
                    return LocalFunction.Create(cx, (LocalFunctionStatementSyntax)node, parent, child);
                case SyntaxKind.ForEachVariableStatement:
                    return ForEachVariable.Create(cx, (ForEachVariableStatementSyntax)node, parent, child);
                default:
                    throw new InternalError(node, $"Unhandled statement of kind '{node.Kind()}'");
            }
        }
    }
}
