using System.Management.Automation.Language;
using System.Management.Automation.Runspaces;
using Semmle.Extraction.PowerShell.Entities;

namespace Semmle.Extraction.PowerShell;

public static class EntityConstructor
{
    public static Entity ConstructAppropriateEntity(PowerShellContext powerShellContext, Ast ast)
    {
        return ast switch
        {
            AssignmentStatementAst assignmentStatementAst => AssignmentStatementEntity.Create(powerShellContext, assignmentStatementAst),
            ArrayExpressionAst arrayExpressionAst => ArrayExpressionEntity.Create(powerShellContext, arrayExpressionAst),
            ArrayLiteralAst arrayLiteralAst => ArrayLiteralEntity.Create(powerShellContext, arrayLiteralAst),
            BinaryExpressionAst binaryExpressionAst => BinaryExpressionEntity.Create(powerShellContext, binaryExpressionAst),
            CommandAst commandAst => CommandEntity.Create(powerShellContext,  commandAst),
            CommandExpressionAst commandExpressionAst => CommandExpressionEntity.Create(powerShellContext, commandExpressionAst),
            CommandParameterAst commandParameterAst => CommandParameterEntity.Create(powerShellContext, commandParameterAst),
            ConvertExpressionAst convertExpressionAst => ConvertExpressionEntity.Create(powerShellContext, convertExpressionAst),
            ExitStatementAst exitStatementAst => ExitStatementEntity.Create(powerShellContext,exitStatementAst),
            IndexExpressionAst indexExpressionAst => IndexExpressionEntity.Create(powerShellContext, indexExpressionAst),
            InvokeMemberExpressionAst invokeMemberExpressionAst => InvokeMemberExpressionEntity.Create(powerShellContext, invokeMemberExpressionAst),
            MemberExpressionAst memberExpressionAst => MemberExpressionEntity.Create(powerShellContext, memberExpressionAst),
            NamedBlockAst namedBlockAst => NamedBlockEntity.Create(powerShellContext, namedBlockAst),
            ParenExpressionAst parenExpressionAst => ParenExpressionEntity.Create(powerShellContext, parenExpressionAst),
            PipelineAst pipelineAst => PipelineEntity.Create(powerShellContext, pipelineAst),
            ScriptBlockAst scriptBlockAst => ScriptBlockEntity.Create(powerShellContext, scriptBlockAst),
            StatementBlockAst statementBlockAst => StatementBlockEntity.Create(powerShellContext, statementBlockAst),
            StringConstantExpressionAst stringConstantExpressionAst => StringConstantExpressionEntity.Create(powerShellContext, stringConstantExpressionAst),
            SubExpressionAst subExpressionAst => SubExpressionEntity.Create(powerShellContext, subExpressionAst),
            TernaryExpressionAst ternaryExpressionAst => TernaryExpressionEntity.Create(powerShellContext, ternaryExpressionAst),
            TypeConstraintAst typeConstraintAst => TypeConstraintEntity.Create(powerShellContext, typeConstraintAst),
            TypeExpressionAst typeExpressionAst => TypeExpressionEntity.Create(powerShellContext, typeExpressionAst),
            VariableExpressionAst variableExpressionAst => VariableExpressionEntity.Create(powerShellContext, variableExpressionAst),
            ParamBlockAst paramBlockAst => ParamBlockEntity.Create(powerShellContext, paramBlockAst),
            ParameterAst parameterAst => ParameterEntity.Create(powerShellContext, parameterAst),
            AttributeAst attributeAst => AttributeEntity.Create(powerShellContext, attributeAst),
            FunctionDefinitionAst functionDefinitionAst => FunctionDefinitionEntity.Create(powerShellContext, functionDefinitionAst),
            NamedAttributeArgumentAst namedAttributeArgumentAst => NamedAttributeArgumentEntity.Create(powerShellContext, namedAttributeArgumentAst),
            BreakStatementAst breakStatementAst => BreakStatementEntity.Create(powerShellContext, breakStatementAst),
            ForEachStatementAst forEachStatementAst => ForEachStatementEntity.Create(powerShellContext, forEachStatementAst),
            ContinueStatementAst continueStatementAst => ContinueStatementEntity.Create(powerShellContext, continueStatementAst),
            ReturnStatementAst returnStatementAst => ReturnStatementEntity.Create(powerShellContext, returnStatementAst),
            WhileStatementAst whileStatementAst => WhileStatementEntity.Create(powerShellContext, whileStatementAst),
            DoUntilStatementAst doUntilStatementAst => DoUntilStatementEntity.Create(powerShellContext, doUntilStatementAst),
            DoWhileStatementAst doWhileStatementAst => DoWhileStatementEntity.Create(powerShellContext, doWhileStatementAst),
            ExpandableStringExpressionAst expandableStringExpressionAst => ExpandableStringExpressionEntity.Create(powerShellContext, expandableStringExpressionAst),
            ForStatementAst forStatementAst => ForStatementEntity.Create(powerShellContext, forStatementAst),
            IfStatementAst ifStatementAst => IfStatementEntity.Create(powerShellContext, ifStatementAst),
            UnaryExpressionAst unaryExpressionAst => UnaryExpressionEntity.Create(powerShellContext, unaryExpressionAst),
            TryStatementAst tryStatementAst => TryStatementEntity.Create(powerShellContext, tryStatementAst),
            CatchClauseAst catchClauseAst => CatchClauseEntity.Create(powerShellContext, catchClauseAst),
            ThrowStatementAst throwStatementAst => ThrowStatementEntity.Create(powerShellContext, throwStatementAst),
            FileRedirectionAst fileRedirectionAst => FileRedirectionEntity.Create(powerShellContext, fileRedirectionAst),
            TrapStatementAst trapStatementAst => TrapStatementEntity.Create(powerShellContext, trapStatementAst),
            BlockStatementAst blockStatementAst => BlockStatementEntity.Create(powerShellContext, blockStatementAst),
            ConfigurationDefinitionAst configurationDefinitionAst => ConfigurationDefinitionEntity.Create(powerShellContext, configurationDefinitionAst),
            DataStatementAst dataStatementAst => DataStatementEntity.Create(powerShellContext, dataStatementAst),
            DynamicKeywordStatementAst dynamicKeywordStatementAst => DynamicKeywordStatementEntity.Create(powerShellContext, dynamicKeywordStatementAst),
            ErrorExpressionAst errorExpressionAst => ErrorExpressionEntity.Create(powerShellContext, errorExpressionAst),
            ErrorStatementAst errorStatementAst => ErrorStatementEntity.Create(powerShellContext, errorStatementAst),
            FunctionMemberAst functionMemberAst => FunctionMemberEntity.Create(powerShellContext, functionMemberAst),
            MergingRedirectionAst mergingRedirectionAst => MergingRedirectionEntity.Create(powerShellContext, mergingRedirectionAst),
            PipelineChainAst pipelineChainAst => PipelineChainEntity.Create(powerShellContext, pipelineChainAst),
            PropertyMemberAst propertyMemberAst => PropertyMemberEntity.Create(powerShellContext, propertyMemberAst),
            ScriptBlockExpressionAst scriptBlockExpressionAst => ScriptBlockExpressionEntity.Create(powerShellContext, scriptBlockExpressionAst),
            SwitchStatementAst switchStatementAst => SwitchStatementEntity.Create(powerShellContext, switchStatementAst),
            TypeDefinitionAst typeDefinitionAst => TypeDefinitionEntity.Create(powerShellContext, typeDefinitionAst),
            UsingExpressionAst usingExpressionAst => UsingExpressionEntity.Create(powerShellContext, usingExpressionAst),
            UsingStatementAst usingStatementAst => UsingStatementEntity.Create(powerShellContext, usingStatementAst),
            AttributedExpressionAst attributedExpressionAst => AttributedExpressionEntity.Create(powerShellContext, attributedExpressionAst),
            HashtableAst hashtableAst => HashtableEntity.Create(powerShellContext, hashtableAst),
            // Other classes are derived from ConstantExpressionAst, so this switch case must be listed after those classes
            ConstantExpressionAst constantExpressionAst => ConstantExpressionEntity.Create(powerShellContext, constantExpressionAst),
            _ => NotImplementedEntity.Create(powerShellContext, ast, ast.GetType()),

            // These base classes are abstract and won't be directly returned from the visitor
            // AttributeBaseAst attributeBaseAst => throw new NotImplementedException(),
            // RedirectionAst redirectionAst => RedirectionEntity.Create(powerShellContext, redirectionAst),
            // MemberAst memberAst => throw new NotImplementedException(),
            // ChainableAst chainableAst => throw new NotImplementedException(),
            // BaseCtorInvokeMemberExpressionAst baseCtorInvokeMemberExpressionAst => throw new NotImplementedException(),
            // ExpressionAst expressionAst => throw new NotImplementedException(),
            // StatementAst statementAst => throw new NotImplementedException(),
            // CommandBaseAst commandBaseAst => throw new NotImplementedException(),
            // CommandElementAst commandElementAst => throw new NotImplementedException(),
            // LabeledStatementAst labeledStatementAst => throw new NotImplementedException(),
            // LoopStatementAst loopStatementAst => throw new NotImplementedException(),
            // PipelineBaseAst pipelineBaseAst => throw new NotImplementedException(),
        };
    }
}