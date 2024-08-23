using Semmle.Util;
using System.IO;
using System.Management.Automation.Language;
using System.Runtime.CompilerServices;
using Semmle.Extraction.Entities;
using Folder = Semmle.Extraction.PowerShell.Entities.Folder;
using Semmle.Extraction.PowerShell.Entities;
[assembly:InternalsVisibleTo("Microsoft.Extractor.Tests")]
namespace Semmle.Extraction.PowerShell
{
    /// <summary>
    /// Methods for writing DB tuples.
    /// </summary>
    ///
    /// <remarks>
    /// The parameters to the tuples are well-typed.
    /// </remarks>
    internal static class Tuples
    {
        internal static void numlines(this TextWriter trapFile, IEntity label, int total, int code, int comment)
        {
            trapFile.WriteTuple("numlines", label, total, code, comment);
        }

        internal static Tuple containerparent(Folder parent, IFileOrFolder child) =>
            new Tuple("containerparent", parent, child);
        //
        // internal static Tuple files(Entities.File file, string fullName) =>
        //     new Tuple("files", file, fullName);

        internal static Tuple folders(Folder folder, string path) =>
            new Tuple("folders", folder, path);

        internal static void comment_entity(this TextWriter trapFile, CommentEntity commentEntity, StringLiteralEntity text)
        {
            trapFile.WriteTuple("comment_entity", commentEntity, text);
        }

        internal static void comment_entity_location(this TextWriter trapFile, CommentEntity commentEntity, Location location)
        {
            trapFile.WriteTuple("comment_entity_location", commentEntity, location);
        }

        internal static void not_implemented(this TextWriter trapFile, NotImplementedEntity notImplementedEntity, string notImplementedTypeName)
        {
            trapFile.WriteTuple("not_implemented", notImplementedEntity, notImplementedTypeName);
        }

        internal static void not_implemented_location(this TextWriter trapFile, NotImplementedEntity notImplementedEntity, Location location)
        {
            trapFile.WriteTuple("not_implemented_location", notImplementedEntity, location);
        }
        
        internal static void script_block(this TextWriter trapFile, ScriptBlockEntity scriptBlockEntity, int numUsings, int numRequiredModules, int numRequiredAssemblies, int numRequiredPsEditions, int numRequiredPsSnapins)
        {
            trapFile.WriteTuple("script_block", scriptBlockEntity, numUsings, numRequiredModules, numRequiredAssemblies, numRequiredPsEditions, numRequiredPsSnapins);
        }
        
        internal static void script_block_param_block(this TextWriter trapFile, ScriptBlockEntity scriptBlockEntity, Entity paramBlock)
        {
            trapFile.WriteTuple("script_block_param_block", scriptBlockEntity, paramBlock);
        }
        
        internal static void script_block_begin_block(this TextWriter trapFile, ScriptBlockEntity scriptBlockEntity, Entity beginBlock)
        {
            trapFile.WriteTuple("script_block_begin_block", scriptBlockEntity, beginBlock);
        }
        
        internal static void script_block_clean_block(this TextWriter trapFile, ScriptBlockEntity scriptBlockEntity, Entity cleanBlock)
        {
            trapFile.WriteTuple("script_block_clean_block", scriptBlockEntity, cleanBlock);
        }
        
        internal static void script_block_dynamic_param_block(this TextWriter trapFile, ScriptBlockEntity scriptBlockEntity, Entity dynamicParamBlock)
        {
            trapFile.WriteTuple("script_block_dynamic_param_block", scriptBlockEntity, dynamicParamBlock);
        }
        
        internal static void script_block_end_block(this TextWriter trapFile, ScriptBlockEntity scriptBlockEntity, Entity endBlock)
        {
            trapFile.WriteTuple("script_block_end_block", scriptBlockEntity, endBlock);
        }
        
        internal static void script_block_process_block(this TextWriter trapFile, ScriptBlockEntity scriptBlockEntity, Entity processBlock)
        {
            trapFile.WriteTuple("script_block_process_block", scriptBlockEntity, processBlock);
        }
        
        internal static void script_block_using(this TextWriter trapFile, ScriptBlockEntity scriptBlockEntity, int index, Entity paramBlock)
        {
            trapFile.WriteTuple("script_block_using", scriptBlockEntity, index, paramBlock);
        }

        internal static void script_block_required_application_id(this TextWriter trapFile, ScriptBlockEntity scriptBlockEntity, string requiredApplicationId)
        {
            trapFile.WriteTuple("script_block_required_application_id", scriptBlockEntity, requiredApplicationId);
        }

        internal static void script_block_requires_elevation(this TextWriter trapFile, ScriptBlockEntity scriptBlockEntity, bool requiresElevation)
        {
            trapFile.WriteTuple("script_block_requires_elevation", scriptBlockEntity, requiresElevation);
        }

        internal static void script_block_required_ps_version(this TextWriter trapFile, ScriptBlockEntity scriptBlockEntity, string requiredPsVersion)
        {
            trapFile.WriteTuple("script_block_required_ps_version", scriptBlockEntity, requiredPsVersion);
        }

        internal static void script_block_required_module(this TextWriter trapFile, ScriptBlockEntity scriptBlockEntity, int index, ModuleSpecificationEntity module)
        {
            trapFile.WriteTuple("script_block_required_module", scriptBlockEntity, index, module);
        }
        
        internal static void module_specification(this TextWriter trapFile, ModuleSpecificationEntity moduleSpecificationEntity, string name, string guid, string maximumVersion, string requiredVersion, string version)
        {
            trapFile.WriteTuple("module_specification", moduleSpecificationEntity, name, guid, maximumVersion, requiredVersion, version);
        }

        internal static void script_block_required_assembly(this TextWriter trapFile, ScriptBlockEntity scriptBlockEntity, int index, string requiredAssembly)
        {
            trapFile.WriteTuple("script_block_required_assembly", scriptBlockEntity, index, requiredAssembly);
        }

        internal static void script_block_required_ps_edition(this TextWriter trapFile, ScriptBlockEntity scriptBlockEntity, int index, string requiredPsEdition)
        {
            trapFile.WriteTuple("script_block_required_ps_edition", scriptBlockEntity, index, requiredPsEdition);
        }

        internal static void script_block_requires_ps_snapin(this TextWriter trapFile, ScriptBlockEntity scriptBlockEntity, int index, string name, string version)
        {
            trapFile.WriteTuple("script_block_requires_ps_snapin", scriptBlockEntity, index, name, version);
        }

        internal static void script_block_location(this TextWriter trapFile, ScriptBlockEntity scriptBlockEntity, Location location)
        {
            trapFile.WriteTuple("script_block_location", scriptBlockEntity, location);
        }
        
        internal static void named_block(this TextWriter trapFile, NamedBlockEntity namedBlockEntity, int numStatements, int numTraps)
        {
            trapFile.WriteTuple("named_block", namedBlockEntity, numStatements, numTraps);
        }

        internal static void named_block_statement(this TextWriter trapFile, NamedBlockEntity namedBlockEntity, int index, Entity statement)
        {
            trapFile.WriteTuple("named_block_statement", namedBlockEntity, index, statement);
        }

        internal static void named_block_trap(this TextWriter trapFile, NamedBlockEntity namedBlockEntity,  int index, Entity trap)
        {
            trapFile.WriteTuple("named_block_trap", namedBlockEntity, index, trap);
        }

        internal static void named_block_location(this TextWriter trapFile, NamedBlockEntity namedBlockEntity, Location location)
        {
            trapFile.WriteTuple("named_block_location", namedBlockEntity, location);
        }

        internal static void array_expression(this TextWriter trapFile, ArrayExpressionEntity arrayExpressionEntity, Entity subExpression)
        {
            trapFile.WriteTuple("array_expression", arrayExpressionEntity, subExpression);
        }

        internal static void array_expression_location(this TextWriter trapFile, ArrayExpressionEntity arrayExpressionEntity, Location location)
        {
            trapFile.WriteTuple("array_expression_location", arrayExpressionEntity, location);
        }

        internal static void array_literal(this TextWriter trapFile, ArrayLiteralEntity arrayLiteralEntity)
        {
            trapFile.WriteTuple("array_literal", arrayLiteralEntity);
        }

        internal static void array_literal_location(this TextWriter trapFile, ArrayLiteralEntity arrayLiteralEntity, Location location)
        {
            trapFile.WriteTuple("array_literal_location", arrayLiteralEntity, location);
        }

        internal static void array_literal_element(this TextWriter trapFile, ArrayLiteralEntity arrayLiteralEntity, int index, Entity component)
        {
            trapFile.WriteTuple("array_literal_element", arrayLiteralEntity, index, component);
        }

        internal static void assignment_statement(this TextWriter trapFile, AssignmentStatementEntity assignmentStatementEntity, TokenKind operation, Entity left, Entity right)
        {
            trapFile.WriteTuple("assignment_statement", assignmentStatementEntity, operation, left, right);
        }

        internal static void assignment_statement_location(this TextWriter trapFile, AssignmentStatementEntity assignmentStatementEntity, Location location)
        {
            trapFile.WriteTuple("assignment_statement_location", assignmentStatementEntity, location);
        }

        internal static void constant_expression(this TextWriter trapFile, ConstantExpressionEntity contextExpressionEntity, string staticType)
        {
            trapFile.WriteTuple("constant_expression", contextExpressionEntity, staticType);
        }
        
        internal static void constant_expression_value(this TextWriter trapFile, ConstantExpressionEntity contextExpressionEntity, StringLiteralEntity value)
        {
            trapFile.WriteTuple("constant_expression_value", contextExpressionEntity, value);
        }

        internal static void constant_expression_location(this TextWriter trapFile, ConstantExpressionEntity contextExpressionEntity, Location location)
        {
            trapFile.WriteTuple("constant_expression_location", contextExpressionEntity, location);
        }

        internal static void convert_expression(this TextWriter trapFile, ConvertExpressionEntity convertExpressionEntity, Entity attribute, Entity child, Entity type, string staticType)
        {
            trapFile.WriteTuple("convert_expression", convertExpressionEntity, attribute, child, type, staticType);
        }

        internal static void convert_expression_location(this TextWriter trapFile, ConvertExpressionEntity convertExpressionEntity, Location location)
        {
            trapFile.WriteTuple("convert_expression_location", convertExpressionEntity, location);
        }

        internal static void exit_statement_pipeline(this TextWriter trapFile, ExitStatementEntity exitStatementEntity, Entity expression)
        {
            trapFile.WriteTuple("exit_statement_pipeline", exitStatementEntity, expression);
        }

        internal static void exit_statement(this TextWriter trapFile, ExitStatementEntity exitStatementEntity)
        {
            trapFile.WriteTuple("exit_statement", exitStatementEntity);
        }

        internal static void exit_statement_location(this TextWriter trapFile, ExitStatementEntity exitStatementEntity, Location location)
        {
            trapFile.WriteTuple("exit_statement_location", exitStatementEntity, location);
        }


        internal static void index_expression(this TextWriter trapFile, IndexExpressionEntity indexExpressionEntity, Entity index, Entity target, bool nullConditional)
        {
            trapFile.WriteTuple("index_expression", indexExpressionEntity, index, target, nullConditional);
        }

        internal static void index_expression_location(this TextWriter trapFile, IndexExpressionEntity indexExpressionEntity, Location location)
        {
            trapFile.WriteTuple("index_expression_location", indexExpressionEntity, location);
        }

        internal static void member_expression(this TextWriter trapFile, MemberExpressionEntity memberExpressionEntity, Entity expression, Entity member, bool nullConditional, bool isStatic)
        {
            trapFile.WriteTuple("member_expression", memberExpressionEntity, expression, member, nullConditional, isStatic);
        }

        internal static void member_expression_location(this TextWriter trapFile, MemberExpressionEntity memberExpressionEntity, Location location)
        {
            trapFile.WriteTuple("member_expression_location", memberExpressionEntity, location);
        }
        internal static void statement_block(this TextWriter trapFile, StatementBlockEntity statementBlockEntity, int numStatements, int numTraps)
        {
            trapFile.WriteTuple("statement_block", statementBlockEntity, numStatements, numTraps);
        }

        internal static void statement_block_location(this TextWriter trapFile, StatementBlockEntity statementBlockEntity, Location location)
        {
            trapFile.WriteTuple("statement_block_location", statementBlockEntity, location);
        }

        internal static void statement_block_statement(this TextWriter trapFile, StatementBlockEntity statementBlockEntity, int index, Entity statement)
        {
            trapFile.WriteTuple("statement_block_statement", statementBlockEntity, index, statement);
        }

        internal static void statement_block_trap(this TextWriter trapFile, StatementBlockEntity statementBlockEntity, int index, Entity trap)
        {
            trapFile.WriteTuple("statement_block_trap", statementBlockEntity, index, trap);
        }

        internal static void sub_expression(this TextWriter trapFile, SubExpressionEntity subExpressionEntity, Entity subExpression)
        {
            trapFile.WriteTuple("sub_expression", subExpressionEntity, subExpression);
        }

        internal static void sub_expression_location(this TextWriter trapFile, SubExpressionEntity subExpressionEntity, Location location)
        {
            trapFile.WriteTuple("sub_expression_location", subExpressionEntity, location);
        }

        internal static void variable_expression(this TextWriter trapFile, VariableExpressionEntity variableExpressionEntity, string userPath, string driveName, bool isConstant, bool isGlobal, bool isLocal, bool isPrivate, bool isScript, bool isUnqualified, bool isUnscoped, bool isVariable, bool isDriveQualified)
        {
            trapFile.WriteTuple("variable_expression", variableExpressionEntity, userPath, driveName, isConstant, isGlobal, isLocal, isPrivate, isScript, isUnqualified, isUnscoped, isVariable, isDriveQualified);
        }

        internal static void variable_expression_location(this TextWriter trapFile, VariableExpressionEntity variableExpressionEntity, Location location)
        {
            trapFile.WriteTuple("variable_expression_location", variableExpressionEntity, location);
        }
        
        internal static void command_expression(this TextWriter trapFile, CommandExpressionEntity commandExpressionEntity, Entity wrappedEntity, int numRedirections)
        {
            trapFile.WriteTuple("command_expression", commandExpressionEntity, wrappedEntity, numRedirections);
        }

        internal static void command_expression_location(this TextWriter trapFile, CommandExpressionEntity commandExpressionEntity, Location location)
        {
            trapFile.WriteTuple("command_expression_location", commandExpressionEntity, location);
        }

        internal static void command_expression_redirection(this TextWriter trapFile,
            CommandExpressionEntity commandExpressionEntity, int index, Entity redirection)
        {
            trapFile.WriteTuple("command_expression_redirection", commandExpressionEntity, index, redirection);
        }
        
        internal static void string_constant_expression(this TextWriter trapFile, StringConstantExpressionEntity stringConstantExpressionEntity, StringLiteralEntity value)
        {
            trapFile.WriteTuple("string_constant_expression", stringConstantExpressionEntity, value);
        }

        internal static void string_constant_expression_location(this TextWriter trapFile, StringConstantExpressionEntity stringConstantExpressionEntity, Location location)
        {
            trapFile.WriteTuple("string_constant_expression_location", stringConstantExpressionEntity, location);
        }
        
        internal static void pipeline(this TextWriter trapFile, PipelineEntity pipelineEntity, int numElements)
        {
            trapFile.WriteTuple("pipeline", pipelineEntity, numElements);
        }

        internal static void pipeline_location(this TextWriter trapFile, PipelineEntity pipelineEntity, Location location)
        {
            trapFile.WriteTuple("pipeline_location", pipelineEntity, location);
        }
        
        internal static void pipeline_component(this TextWriter trapFile, PipelineEntity pipelineEntity, int index, Entity component)
        {
            trapFile.WriteTuple("pipeline_component", pipelineEntity, index, component);
        }
        
        internal static void command(this TextWriter trapFile, CommandEntity commandEntity, string name, TokenKind tokenKind, int numElements, int numRedirections)
        {
            trapFile.WriteTuple("command", commandEntity, name, tokenKind, numElements, numRedirections);
        }

        internal static void command_location(this TextWriter trapFile, CommandEntity commandEntity, Location location)
        {
            trapFile.WriteTuple("command_location", commandEntity, location);
        }
        
        internal static void command_command_element(this TextWriter trapFile, CommandEntity commandEntity, int index, Entity component)
        {
            trapFile.WriteTuple("command_command_element", commandEntity, index, component);
        }
        
        internal static void command_redirection(this TextWriter trapFile, CommandEntity commandEntity, int index, Entity component)
        {
            trapFile.WriteTuple("command_redirection", commandEntity, index, component);
        }
        
        internal static void invoke_member_expression(this TextWriter trapFile, InvokeMemberExpressionEntity invokeMemberExpressionEntity, Entity expression, Entity member)
        {
            trapFile.WriteTuple("invoke_member_expression", invokeMemberExpressionEntity, expression, member);
        }

        internal static void invoke_member_expression_location(this TextWriter trapFile, InvokeMemberExpressionEntity commandEntity, Location location)
        {
            trapFile.WriteTuple("invoke_member_expression_location", commandEntity, location);
        }
        
        internal static void invoke_member_expression_argument(this TextWriter trapFile, InvokeMemberExpressionEntity commandEntity, int index, Entity component)
        {
            trapFile.WriteTuple("invoke_member_expression_argument", commandEntity, index, component);
        }
        
        internal static void paren_expression(this TextWriter trapFile, ParenExpressionEntity parenExpressionEntity, Entity expression)
        {
            trapFile.WriteTuple("paren_expression", parenExpressionEntity, expression);
        }

        internal static void paren_expression_location(this TextWriter trapFile, ParenExpressionEntity parenExpressionEntity, Location location)
        {
            trapFile.WriteTuple("paren_expression_location", parenExpressionEntity, location);
        }

        internal static void ternary_expression(this TextWriter trapFile, TernaryExpressionEntity ternaryExpressionEntity, Entity condition, Entity ifFalse, Entity ifTrue)
        {
            trapFile.WriteTuple("ternary_expression", ternaryExpressionEntity, condition, ifFalse, ifTrue);
        }
        internal static void ternary_expression_location(this TextWriter trapFile, TernaryExpressionEntity ternaryExpressionEntity, Location location)
        {
            trapFile.WriteTuple("ternary_expression_location", ternaryExpressionEntity, location);
        }

        internal static void type_expression(this TextWriter trapFile, TypeExpressionEntity typeExpressionEntity, string typeName, string typeFullName)
        {
            trapFile.WriteTuple("type_expression", typeExpressionEntity, typeName, typeFullName);
        }

        internal static void type_expression_location(this TextWriter trapFile, TypeExpressionEntity typeExpressionEntity, Location location)
        {
            trapFile.WriteTuple("type_expression_location", typeExpressionEntity, location);
        }

        internal static void command_parameter(this TextWriter trapFile, CommandParameterEntity commandParameterEntity, string paramName)
        {
            trapFile.WriteTuple("command_parameter", commandParameterEntity, paramName);
        }
        
        internal static void command_parameter_argument(this TextWriter trapFile, CommandParameterEntity commandParameterEntity, Entity argument)
        {
            trapFile.WriteTuple("command_parameter_argument", commandParameterEntity, argument);
        }

        internal static void command_parameter_location(this TextWriter trapFile, CommandParameterEntity commandParameterEntity, Location location)
        {
            trapFile.WriteTuple("command_parameter_location", commandParameterEntity, location);
        }
        
        internal static void parent(this TextWriter trapFile, Entity parent, Entity child)
        {
            trapFile.WriteTuple("parent", parent, child);
        }
        internal static void binary_expression(this TextWriter trapFile, BinaryExpressionEntity binaryExpressionEntity, TokenKind operation, Entity left, Entity right)
        {
            trapFile.WriteTuple("binary_expression", binaryExpressionEntity, operation, left, right);
        }

        internal static void binary_expression_location(this TextWriter trapFile, BinaryExpressionEntity binaryExpressionEntity, Location location)
        {
            trapFile.WriteTuple("binary_expression_location", binaryExpressionEntity, location);
        }

        internal static void param_block(this TextWriter trapFile, ParamBlockEntity paramBlockEntity, int numAttributes, int numParameters)
        {
            trapFile.WriteTuple("param_block", paramBlockEntity, numAttributes, numParameters);
        }
        
        internal static void param_block_attribute(this TextWriter trapFile, ParamBlockEntity paramBlockEntity, int index, Entity attribute)
        {
            trapFile.WriteTuple("param_block_attribute", paramBlockEntity, index, attribute);
        }

        internal static void param_block_parameter(this TextWriter trapFile, ParamBlockEntity paramBlockEntity, int index, Entity parameter)
        {
            trapFile.WriteTuple("param_block_parameter", paramBlockEntity, index, parameter);
        }
        
        internal static void param_block_location(this TextWriter trapFile, ParamBlockEntity paramBlockEntity, Location location)
        {
            trapFile.WriteTuple("param_block_location", paramBlockEntity, location);
        }
        
        internal static void parameter(this TextWriter trapFile, ParameterEntity parameterEntity, Entity name, string type, int numAttributes)
        {
            trapFile.WriteTuple("parameter", parameterEntity, name, type, numAttributes);
        }
        
        internal static void parameter_attribute(this TextWriter trapFile, ParameterEntity parameterEntity, int index, Entity attribute)
        {
            trapFile.WriteTuple("parameter_attribute", parameterEntity, index, attribute);
        }

        internal static void parameter_default_value(this TextWriter trapFile, ParameterEntity parameterEntity, Entity defaultValueExpression)
        {
            trapFile.WriteTuple("parameter_default_value", parameterEntity, defaultValueExpression);
        }
        
        internal static void parameter_location(this TextWriter trapFile, ParameterEntity parameterEntity, Location location)
        {
            trapFile.WriteTuple("parameter_location", parameterEntity, location);
        }
        
        internal static void attribute(this TextWriter trapFile, AttributeEntity parameterEntity, string type, int numNamedAttributes, int numPositionalAttributes)
        {
            trapFile.WriteTuple("attribute", parameterEntity, type, numNamedAttributes, numPositionalAttributes);
        }
        
        internal static void attribute_named_argument(this TextWriter trapFile, AttributeEntity parameterEntity, int index, Entity argument)
        {
            trapFile.WriteTuple("attribute_named_argument", parameterEntity, index, argument);
        }
        
        internal static void attribute_positional_argument(this TextWriter trapFile, AttributeEntity parameterEntity, int index, Entity argument)
        {
            trapFile.WriteTuple("attribute_positional_argument", parameterEntity, index, argument);
        }
        
        internal static void attribute_location(this TextWriter trapFile, AttributeEntity parameterEntity, Location location)
        {
            trapFile.WriteTuple("attribute_location", parameterEntity, location);
        }
        
        internal static void type_constraint(this TextWriter trapFile, TypeConstraintEntity typeConstraintEntity, string name, string fullname)
        {
            trapFile.WriteTuple("type_constraint", typeConstraintEntity, name, fullname);
        }
        
        internal static void type_constraint_location(this TextWriter trapFile, TypeConstraintEntity typeConstraintEntity, Location location)
        {
            trapFile.WriteTuple("type_constraint_location", typeConstraintEntity, location);
        }
        
        internal static void function_definition(this TextWriter trapFile, FunctionDefinitionEntity functionDefinitionEntity, Entity body, string name, bool isFilter, bool isWorkflow)
        {
            trapFile.WriteTuple("function_definition", functionDefinitionEntity, body, name, isFilter, isWorkflow);
        }
        
        internal static void function_definition_parameter(this TextWriter trapFile, FunctionDefinitionEntity functionDefinitionEntity, int index, Entity parameter)
        {
            trapFile.WriteTuple("function_definition_parameter", functionDefinitionEntity, index, parameter);
        }
        
        internal static void function_definition_location(this TextWriter trapFile, FunctionDefinitionEntity functionDefinitionEntity, Location location)
        {
            trapFile.WriteTuple("function_definition_location", functionDefinitionEntity, location);
        }
        
        internal static void named_attribute_argument(this TextWriter trapFile, NamedAttributeArgumentEntity namedAttributeArgumentEntity, string name, Entity argument)
        {
            trapFile.WriteTuple("named_attribute_argument", namedAttributeArgumentEntity, name, argument);
        }

        internal static void named_attribute_argument_location(this TextWriter trapFile, NamedAttributeArgumentEntity namedAttributeArgumentEntity, Location location)
        {
            trapFile.WriteTuple("named_attribute_argument_location", namedAttributeArgumentEntity, location);
        }

        internal static void if_statement(this TextWriter trapFile, IfStatementEntity ifStatementEntity)
        {
            trapFile.WriteTuple("if_statement", ifStatementEntity);
        }

        internal static void if_statement_location(this TextWriter trapFile, IfStatementEntity ifStatementEntity, Location location)
        {
            trapFile.WriteTuple("if_statement_location", ifStatementEntity, location);
        }

        internal static void if_statement_clause(this TextWriter trapFile, IfStatementEntity ifStatementEntity, int index, Entity pipeline, Entity statementBlock)
        {
            trapFile.WriteTuple("if_statement_clause", ifStatementEntity, index, pipeline, statementBlock);
        }

        internal static void if_statement_else(this TextWriter trapFile, IfStatementEntity ifStatementEntity, Entity elseItem)
        {
            trapFile.WriteTuple("if_statement_else", ifStatementEntity, elseItem);
        }
        
        internal static void break_statement(this TextWriter trapFile, BreakStatementEntity breakStatementEntity)
        {
            trapFile.WriteTuple("break_statement", breakStatementEntity);
        }

        internal static void break_statement_location(this TextWriter trapFile, BreakStatementEntity breakStatementEntity, Location location)
        {
            trapFile.WriteTuple("break_statement_location", breakStatementEntity, location);
        }

        internal static void statement_label(this TextWriter trapFile, Entity breakStatementEntity, Entity label)
        {
            trapFile.WriteTuple("statement_label", breakStatementEntity, label);
        }

        internal static void foreach_statement(this TextWriter trapFile, ForEachStatementEntity foreachStatementEntity, Entity variable, Entity condition, Entity body, ForEachFlags flags)
        {
            trapFile.WriteTuple("foreach_statement", foreachStatementEntity, variable, condition, body, flags);
        }

        internal static void foreach_statement_location(this TextWriter trapFile, ForEachStatementEntity foreachStatementEntity, Location location)
        {
            trapFile.WriteTuple("foreach_statement_location", foreachStatementEntity, location);
        }

        internal static void for_statement(this TextWriter trapFile, ForStatementEntity forStatementEntity, Entity body)
        {
            trapFile.WriteTuple("for_statement", forStatementEntity, body);
        }

        internal static void for_statement_condition(this TextWriter trapFile, ForStatementEntity forStatementEntity, Entity condition)
        {
            trapFile.WriteTuple("for_statement_condition", forStatementEntity, condition);
        }

        internal static void for_statement_initializer(this TextWriter trapFile, ForStatementEntity forStatementEntity, Entity initializer)
        {
            trapFile.WriteTuple("for_statement_initializer", forStatementEntity, initializer);
        }

        internal static void for_statement_iterator(this TextWriter trapFile, ForStatementEntity forStatementEntity, Entity iterator)
        {
            trapFile.WriteTuple("for_statement_iterator", forStatementEntity, iterator);
        }

        internal static void for_statement_location(this TextWriter trapFile, ForStatementEntity forStatementEntity, Location location)
        {
            trapFile.WriteTuple("for_statement_location", forStatementEntity, location);
        }

        internal static void continue_statement(this TextWriter trapFile, ContinueStatementEntity continueStatementEntity)
        {
            trapFile.WriteTuple("continue_statement", continueStatementEntity);
        }

        internal static void continue_statement_location(this TextWriter trapFile, ContinueStatementEntity continueStatementEntity, Location location)
        {
            trapFile.WriteTuple("continue_statement_location", continueStatementEntity, location);
        }

        internal static void return_statement(this TextWriter trapFile, ReturnStatementEntity returnStatementEntity)
        {
            trapFile.WriteTuple("return_statement", returnStatementEntity);
        }

        internal static void return_statement_location(this TextWriter trapFile, ReturnStatementEntity returnStatementEntity, Location location)
        {
            trapFile.WriteTuple("return_statement_location", returnStatementEntity, location);
        }

        internal static void return_statement_pipeline(this TextWriter trapFile, ReturnStatementEntity returnStatementEntity, Entity pipeline)
        {
            trapFile.WriteTuple("return_statement_pipeline", returnStatementEntity, pipeline);
        }

        internal static void while_statement(this TextWriter trapFile, WhileStatementEntity whileStatementEntity, Entity body)
        {
            trapFile.WriteTuple("while_statement", whileStatementEntity, body);
        }

        internal static void while_statement_condition(this TextWriter trapFile, WhileStatementEntity whileStatementEntity, Entity condition)
        {
            trapFile.WriteTuple("while_statement_condition", whileStatementEntity, condition);
        }

        internal static void while_statement_location(this TextWriter trapFile, WhileStatementEntity whileStatementEntity, Location location)
        {
            trapFile.WriteTuple("while_statement_location", whileStatementEntity, location);
        }

        internal static void do_until_statement(this TextWriter trapFile, DoUntilStatementEntity doUntilStatementEntity, Entity body)
        {
            trapFile.WriteTuple("do_until_statement", doUntilStatementEntity, body);
        }

        internal static void do_until_statement_condition(this TextWriter trapFile, DoUntilStatementEntity doUntilStatementEntity, Entity condition)
        {
            trapFile.WriteTuple("do_until_statement_condition", doUntilStatementEntity, condition);
        }

        internal static void do_until_statement_location(this TextWriter trapFile, DoUntilStatementEntity doUntilStatementEntity, Location location)
        {
            trapFile.WriteTuple("do_until_statement_location", doUntilStatementEntity, location);
        }

        internal static void do_while_statement(this TextWriter trapFile, DoWhileStatementEntity doWhileStatementEntity, Entity body)
        {
            trapFile.WriteTuple("do_while_statement", doWhileStatementEntity, body);
        }

        internal static void do_while_statement_condition(this TextWriter trapFile, DoWhileStatementEntity doWhileStatementEntity, Entity condition)
        {
            trapFile.WriteTuple("do_while_statement_condition", doWhileStatementEntity, condition);
        }

        internal static void do_while_statement_location(this TextWriter trapFile, DoWhileStatementEntity doWhileStatementEntity, Location location)
        {
            trapFile.WriteTuple("do_while_statement_location", doWhileStatementEntity, location);
        }

        internal static void label(this TextWriter trapFile, CachedEntity labelledStatementEntity, string label)
        {
            trapFile.WriteTuple("label", labelledStatementEntity, label);
        }

        internal static void expandable_string_expression(this TextWriter trapFile, ExpandableStringExpressionEntity expandableStringExpressionEntity, StringLiteralEntity value, StringConstantType type, int numExpressions)
        {
            trapFile.WriteTuple("expandable_string_expression", expandableStringExpressionEntity, value, type, numExpressions);
        }

        internal static void expandable_string_expression_location(this TextWriter trapFile, ExpandableStringExpressionEntity expandableStringExpressionEntity, Location location)
        {
            trapFile.WriteTuple("expandable_string_expression_location", expandableStringExpressionEntity, location);
        }

        internal static void expandable_string_expression_nested_expression(this TextWriter trapFile, ExpandableStringExpressionEntity expandableStringExpressionEntity, int index, Entity nestedExpression)
        {
            trapFile.WriteTuple("expandable_string_expression_nested_expression", expandableStringExpressionEntity, index, nestedExpression);
        }

        internal static void unary_expression(this TextWriter trapFile, UnaryExpressionEntity unaryExpressionEntity, Entity child, TokenKind kind, string staticType)
        {
            trapFile.WriteTuple("unary_expression", unaryExpressionEntity, child, kind, staticType);
        }

        internal static void unary_expression_location(this TextWriter trapFile, UnaryExpressionEntity unaryExpressionEntity, Location location)
        {
            trapFile.WriteTuple("unary_expression_location", unaryExpressionEntity, location);
        }

        internal static void catch_clause(this TextWriter trapFile, CatchClauseEntity catchClauseEntity, Entity body, bool isCatchAll){
            trapFile.WriteTuple("catch_clause", catchClauseEntity, body, isCatchAll);
        }

        internal static void catch_clause_catch_type(this TextWriter trapFile, CatchClauseEntity catchClauseEntity, int index, Entity catchType)
        {
            trapFile.WriteTuple("catch_clause_catch_type", catchClauseEntity, index, catchType);
        }

        internal static void catch_clause_location(this TextWriter trapFile, CatchClauseEntity catchClauseEntity, Location location)
        {
            trapFile.WriteTuple("catch_clause_location", catchClauseEntity, location);
        }

        internal static void try_statement(this TextWriter trapFile, TryStatementEntity tryStatementEntity, Entity body)
        {
            trapFile.WriteTuple("try_statement", tryStatementEntity, body);
        }

        internal static void try_statement_catch_clause(this TextWriter trapFile, TryStatementEntity tryStatementEntity, int index, Entity catchClause)
        {
            trapFile.WriteTuple("try_statement_catch_clause", tryStatementEntity, index, catchClause);
        }

        internal static void try_statement_finally(this TextWriter trapFile, TryStatementEntity tryStatementEntity, Entity finallyClause)
        {
            trapFile.WriteTuple("try_statement_finally", tryStatementEntity, finallyClause);
        }

        internal static void try_statement_location(this TextWriter trapFile, TryStatementEntity tryStatementEntity, Location location)
        {
            trapFile.WriteTuple("try_statement_location", tryStatementEntity, location);
        }

        internal static void throw_statement(this TextWriter trapFile, ThrowStatementEntity throwStatementEntity, bool isRethrow)
        {
            trapFile.WriteTuple("throw_statement", throwStatementEntity, isRethrow);
        }

        internal static void throw_statement_location(this TextWriter trapFile, ThrowStatementEntity throwStatementEntity, Location location)
        {
            trapFile.WriteTuple("throw_statement_location", throwStatementEntity, location);
        }

        internal static void throw_statement_pipeline(this TextWriter trapFile, ThrowStatementEntity throwStatementEntity, Entity pipeline)
        {
            trapFile.WriteTuple("throw_statement_pipeline", throwStatementEntity, pipeline);
        }

        internal static void string_literal(this TextWriter trapFile, StringLiteralEntity stringLiteralEntity)
        {
            trapFile.WriteTuple("string_literal", stringLiteralEntity);
        }

        internal static void string_literal_location(this TextWriter trapFile, StringLiteralEntity stringLiteralEntity, Location location)
        {
            trapFile.WriteTuple("string_literal_location", stringLiteralEntity, location);
        }

        internal static void string_literal_line(this TextWriter trapFile, StringLiteralEntity stringLiteralEntity,
            int index, string line)
        {
            trapFile.WriteTuple("string_literal_line", stringLiteralEntity, index, line);
        }

        internal static void trap_statement(this TextWriter trapFile, TrapStatementEntity trapStatementEntity, Entity body)
        {
            trapFile.WriteTuple("trap_statement", trapStatementEntity, body);
        }

        internal static void trap_statement_type(this TextWriter trapFile, TrapStatementEntity trapStatementEntity,
            TypeConstraintEntity typeConstraintEntity)
        {
            trapFile.WriteTuple("trap_statement_type", trapStatementEntity, typeConstraintEntity);
        }

        internal static void trap_statement_location(this TextWriter trapFile, TrapStatementEntity trapStatementEntity, Entity location)
        {
            trapFile.WriteTuple("trap_statement_location", trapStatementEntity, location);
        }
        
        internal static void file_redirection(this TextWriter trapFile, FileRedirectionEntity fileRedirectionEntity, Entity location, bool isAppend, RedirectionStream stream)
        {
            trapFile.WriteTuple("file_redirection", fileRedirectionEntity, location, isAppend, stream);
        }

        internal static void file_redirection_location(this TextWriter trapFile, FileRedirectionEntity fileRedirectionEntity, Location location)
        {
            trapFile.WriteTuple("file_redirection_location", fileRedirectionEntity, location);
        }

        internal static void block_statement(this TextWriter trapFile, BlockStatementEntity blockStatementEntity, Entity body, TokenEntity token)
        {
            trapFile.WriteTuple("block_statement", blockStatementEntity, body, token);
        }

        internal static void block_statement_location(this TextWriter trapFile, BlockStatementEntity blockStatementEntity, Location location)
        {
            trapFile.WriteTuple("block_statement_location", blockStatementEntity, location);
        }

        internal static void token(this TextWriter trapFile, TokenEntity tokenEntity, bool hasError, TokenKind kind, string text, TokenFlags flags)
        {
            trapFile.WriteTuple("token", tokenEntity, hasError, kind, text, flags);
        }

        internal static void token_location(this TextWriter trapFile, TokenEntity tokenEntity, Location location)
        {
            trapFile.WriteTuple("token_location", tokenEntity, location);
        }

        internal static void configuration_definition(this TextWriter trapFile, ConfigurationDefinitionEntity configurationDefinitionEntity, Entity body, ConfigurationType type, Entity name)
        {
            trapFile.WriteTuple("configuration_definition", configurationDefinitionEntity, body, type, name);
        }

        internal static void configuration_definition_location(this TextWriter trapFile, ConfigurationDefinitionEntity configurationDefinitionEntity, Location location)
        {
            trapFile.WriteTuple("configuration_definition_location", configurationDefinitionEntity, location);
        }

        internal static void data_statement(this TextWriter trapFile, DataStatementEntity dataStatementEntity, Entity body)
        {
            trapFile.WriteTuple("data_statement", dataStatementEntity, body);
        }

        internal static void data_statement_location(this TextWriter trapFile, DataStatementEntity dataStatementEntity, Location location)
        {
            trapFile.WriteTuple("data_statement_location", dataStatementEntity, location);
        }

        internal static void data_statement_variable(this TextWriter trapFile, DataStatementEntity dataStatementEntity, string variable)
        {
            trapFile.WriteTuple("data_statement_variable", dataStatementEntity, variable);
        }

        internal static void data_statement_commands_allowed(this TextWriter trapFile, DataStatementEntity dataStatementEntity, int index, Entity commandAllowed)
        {
            trapFile.WriteTuple("data_statement_commands_allowed", dataStatementEntity, index, commandAllowed);
        }

        internal static void dynamic_keyword_statement(this TextWriter trapFile, DynamicKeywordStatementEntity dynamicKeywordStatementEntity)
        {
            trapFile.WriteTuple("dynamic_keyword_statement", dynamicKeywordStatementEntity);
        }

        internal static void dynamic_keyword_statement_location(this TextWriter trapFile, DynamicKeywordStatementEntity dynamicKeywordStatementEntity, Location location)
        {
            trapFile.WriteTuple("dynamic_keyword_statement_location", dynamicKeywordStatementEntity, location);
        }

        internal static void dynamic_keyword_statement_command_elements(this TextWriter trapFile, DynamicKeywordStatementEntity dynamicKeywordStatementEntity, int index, Entity commandElement)
        {
            trapFile.WriteTuple("dynamic_keyword_statement_command_elements", dynamicKeywordStatementEntity, index, commandElement);
        }

        internal static void error_expression(this TextWriter trapFile, ErrorExpressionEntity errorExpressionEntity)
        {
            trapFile.WriteTuple("error_expression", errorExpressionEntity);
        }

        internal static void error_expression_nested_ast(this TextWriter trapFile, ErrorExpressionEntity errorExpressionEntity, int index, Entity nestedAst)
        {
            trapFile.WriteTuple("error_expression_nested_ast", errorExpressionEntity, index, nestedAst);
        }

        internal static void error_expression_location(this TextWriter trapFile, ErrorExpressionEntity errorExpressionEntity, Location location)
        {
            trapFile.WriteTuple("error_expression_location", errorExpressionEntity, location);
        }

        internal static void error_statement(this TextWriter trapFile, ErrorStatementEntity errorStatementEntity, TokenEntity token)
        {
            trapFile.WriteTuple("error_statement", errorStatementEntity, token);
        }

        internal static void error_statement_flag(this TextWriter trapFile, ErrorStatementEntity errorStatementEntity, int index, string flagKey, TokenEntity token, Entity ast)
        {
            trapFile.WriteTuple("error_statement_flag", errorStatementEntity, index, flagKey, token, ast);    
        }

        internal static void error_statement_nested_ast(this TextWriter trapFile, ErrorStatementEntity errorStatementEntity, int index, Entity nestedAst)
        {
            trapFile.WriteTuple("error_statement_nested_ast", errorStatementEntity, index, nestedAst);
        }

        internal static void error_statement_conditions(this TextWriter trapFile, ErrorStatementEntity errorStatementEntity, int index, Entity condition)
        {
            trapFile.WriteTuple("error_statement_conditions", errorStatementEntity, index, condition);
        }

        internal static void error_statement_bodies(this TextWriter trapFile, ErrorStatementEntity errorStatementEntity, int index, Entity body)
        {
            trapFile.WriteTuple("error_statement_bodies", errorStatementEntity, index, body);
        }

        internal static void error_statement_location(this TextWriter trapFile, ErrorStatementEntity errorStatementEntity, Location location)
        {
            trapFile.WriteTuple("error_statement_location", errorStatementEntity, location);
        }

        internal static void function_member(this TextWriter trapFile, FunctionMemberEntity functionMemberEntity, Entity body, bool isConstructor, bool isHidden, bool isPrivate, bool isPublic, bool isStatic, string name, MethodAttributes attributes)
        {
            trapFile.WriteTuple("function_member", functionMemberEntity, body, isConstructor, isHidden, isPrivate, isPublic, isStatic, name, attributes);
        }

        internal static void function_member_parameter(this TextWriter trapFile, FunctionMemberEntity functionMemberEntity, int index, Entity parameter)
        {
            trapFile.WriteTuple("function_member_parameter", functionMemberEntity, index, parameter);
        }

        internal static void function_member_attribute(this TextWriter trapFile, FunctionMemberEntity functionMemberEntity, int index, Entity attribute)
        {
            trapFile.WriteTuple("function_member_attribute", functionMemberEntity, index, attribute);
        }

        internal static void function_member_return_type(this TextWriter trapFile, FunctionMemberEntity functionMemberEntity, Entity returnType)
        {
            trapFile.WriteTuple("function_member_return_type", functionMemberEntity, returnType);
        }

        internal static void function_member_location(this TextWriter trapFile, FunctionMemberEntity functionMemberEntity, Location location)
        {
            trapFile.WriteTuple("function_member_location", functionMemberEntity, location);
        }

        internal static void merging_redirection(this TextWriter trapFile, MergingRedirectionEntity mergingRedirectionEntity, RedirectionStream from, RedirectionStream to)
        {
            trapFile.WriteTuple("merging_redirection", mergingRedirectionEntity, from, to);
        }

        internal static void merging_redirection_location(this TextWriter trapFile, MergingRedirectionEntity mergingRedirectionEntity, Location location)
        {
            trapFile.WriteTuple("merging_redirection_location", mergingRedirectionEntity, location);
        }

        internal static void pipeline_chain(this TextWriter trapFile, PipelineChainEntity pipelineChainEntity, bool isBackground, TokenKind kind, Entity left, Entity right)
        {
            trapFile.WriteTuple("pipeline_chain", pipelineChainEntity, isBackground, kind, left, right);
        }

        internal static void pipeline_chain_location(this TextWriter trapFile, PipelineChainEntity pipelineChainEntity, Location location)
        {
            trapFile.WriteTuple("pipeline_chain_location", pipelineChainEntity, location);
        }

        internal static void property_member(this TextWriter trapFile, PropertyMemberEntity propertyMemberEntity, bool isHidden, bool isPrivate, bool isPublic, bool isStatic, string name, PropertyAttributes attributes)
        {
            trapFile.WriteTuple("property_member", propertyMemberEntity, isHidden, isPrivate, isPublic, isStatic, name, attributes);
        }

        internal static void property_member_attribute(this TextWriter trapFile, PropertyMemberEntity propertyMemberEntity, int index, Entity attribute)
        {
            trapFile.WriteTuple("property_member_attribute", propertyMemberEntity, index, attribute);
        }

        internal static void property_member_property_type(this TextWriter trapFile, PropertyMemberEntity propertyMemberEntity, Entity propertyType)
        {
            trapFile.WriteTuple("property_member_property_type", propertyMemberEntity, propertyType);
        }

        internal static void property_member_initial_value(this TextWriter trapFile, PropertyMemberEntity propertyMemberEntity, Entity initialValue)
        {
            trapFile.WriteTuple("property_member_initial_value", propertyMemberEntity, initialValue);
        }

        internal static void property_member_location(this TextWriter trapFile, PropertyMemberEntity propertyMemberEntity, Location location)
        {
            trapFile.WriteTuple("property_member_location", propertyMemberEntity, location);
        }

        internal static void script_block_expression(this TextWriter trapFile, ScriptBlockExpressionEntity scriptBlockExpressionEntity, ScriptBlockEntity body)
        {
            trapFile.WriteTuple("script_block_expression", scriptBlockExpressionEntity, body);
        }

        internal static void script_block_expression_location(this TextWriter trapFile, ScriptBlockExpressionEntity scriptBlockExpressionEntity, Location location)
        {
            trapFile.WriteTuple("script_block_expression_location", scriptBlockExpressionEntity, location);
        }

        internal static void switch_statement(this TextWriter trapFile, SwitchStatementEntity switchStatementEntity, Entity expression, SwitchFlags flags)
        {
            trapFile.WriteTuple("switch_statement", switchStatementEntity, expression, flags);
        }

        internal static void switch_statement_clauses(this TextWriter trapFile, SwitchStatementEntity switchStatementEntity, int index, Entity expression, Entity statementBlock)
        {
            trapFile.WriteTuple("switch_statement_clauses", switchStatementEntity, index, expression, statementBlock);
        }

        internal static void switch_statement_default(this TextWriter trapFile, SwitchStatementEntity switchStatementEntity, Entity defaultAst)
        {
            trapFile.WriteTuple("switch_statement_default", switchStatementEntity, defaultAst);
        }

        internal static void switch_statement_location(this TextWriter trapFile, SwitchStatementEntity switchStatementEntity, Location location)
        {
            trapFile.WriteTuple("switch_statement_location", switchStatementEntity, location);
        }

        internal static void type_definition(this TextWriter trapFile, TypeDefinitionEntity typeDefinitionEntity, string name, TypeAttributes typeAttributes, bool isClass, bool isEnum, bool IsInterface)
        {
            trapFile.WriteTuple("type_definition", typeDefinitionEntity, name, typeAttributes, isClass, isEnum, IsInterface);
        }

        internal static void type_definition_location(this TextWriter trapFile, TypeDefinitionEntity typeDefinitionEntity, Location location)
        {
            trapFile.WriteTuple("type_definition_location", typeDefinitionEntity, location);
        }

        internal static void type_definition_members(this TextWriter trapFile, TypeDefinitionEntity typeDefinitionEntity, int index, Entity member)
        {
            trapFile.WriteTuple("type_definition_members", typeDefinitionEntity, index, member);
        }

        internal static void type_definition_attributes(this TextWriter trapFile, TypeDefinitionEntity typeDefinitionEntity, int index, Entity attribute)
        {
            trapFile.WriteTuple("type_definition_attributes", typeDefinitionEntity, index, attribute);
        }

        internal static void type_definition_base_type(this TextWriter trapFile, TypeDefinitionEntity typeDefinitionEntity, int index, TypeConstraintEntity baseType)
        {
            trapFile.WriteTuple("type_definition_base_type", typeDefinitionEntity, index, baseType);
        }

        internal static void using_expression(this TextWriter trapFile, UsingExpressionEntity usingExpressionEntity, Entity expression)
        {
            trapFile.WriteTuple("using_expression", usingExpressionEntity, expression);
        }

        internal static void using_expression_location(this TextWriter trapFile, UsingExpressionEntity usingExpressionEntity, Location location)
        {
            trapFile.WriteTuple("using_expression_location", usingExpressionEntity, location);
        }

        internal static void using_statement(this TextWriter trapFile, UsingStatementEntity usingStatementEntity, UsingStatementKind kind){
            trapFile.WriteTuple("using_statement", usingStatementEntity, kind);
        }

        internal static void using_statement_location(this TextWriter trapFile, UsingStatementEntity usingStatementEntity, Location location)
        {
            trapFile.WriteTuple("using_statement_location", usingStatementEntity, location);
        }

        internal static void using_statement_alias(this TextWriter trapFile, UsingStatementEntity usingStatementEntity, Entity alias)
        {
            trapFile.WriteTuple("using_statement_alias", usingStatementEntity, alias);
        }

        internal static void using_statement_module_specification(this TextWriter trapFile, UsingStatementEntity usingStatementEntity, HashtableEntity moduleSpecification)
        {
            trapFile.WriteTuple("using_statement_module_specification", usingStatementEntity, moduleSpecification);
        }

        internal static void using_statement_name(this TextWriter trapFile, UsingStatementEntity usingStatementEntity, Entity name)
        {
            trapFile.WriteTuple("using_statement_name", usingStatementEntity, name);
        }

        internal static void hash_table(this TextWriter trapFile, HashtableEntity hashtableEntity)
        {
            trapFile.WriteTuple("hash_table", hashtableEntity);
        }

        internal static void hash_table_location(this TextWriter trapFile, HashtableEntity hashtableEntity, Location location)
        {
            trapFile.WriteTuple("hash_table_location", hashtableEntity, location);
        }

        internal static void hash_table_key_value_pairs(this TextWriter trapFile, HashtableEntity hashtableEntity, int index, Entity key, Entity value)
        {
            trapFile.WriteTuple("hash_table_key_value_pairs", hashtableEntity, index, key, value);
        }

        internal static void attributed_expression(this TextWriter trapFile, AttributedExpressionEntity attributedExpressionEntity, Entity attribute, Entity child)
        {
            trapFile.WriteTuple("attributed_expression", attributedExpressionEntity, attribute, child);
        }

        internal static void attributed_expression_location(this TextWriter trapFile, AttributedExpressionEntity attributedExpressionEntity, Location location)
        {
            trapFile.WriteTuple("attributed_expression_location", attributedExpressionEntity, location);
        }
    }
}