/*
 * CodeQL library for Ruby
 * Automatically generated from the tree-sitter grammar; do not edit
 */

import codeql.files.FileSystem
import codeql.Locations

class AstNode extends @ast_node {
  string toString() { result = this.describeQlClass() }

  Location getLocation() { none() }

  AstNode getAFieldOrChild() { none() }

  string describeQlClass() { result = "???" }
}

class UnderscoreArg extends @underscore_arg, AstNode, ArgumentListChildType, ArrayChildType,
  AssignmentRightType, BinaryLeftType, BinaryRightType, ElementReferenceChildType,
  ExceptionsChildType, IfModifierConditionType, OperatorAssignmentRightType, PairKeyType,
  PatternChildType, RescueModifierHandlerType, RightAssignmentListChildType,
  SingletonMethodObjectType, SuperclassChildType, UnaryChildType, UnderscoreStatement,
  UnlessModifierConditionType, UntilModifierConditionType, WhileModifierConditionType {
  override string describeQlClass() { result = "UnderscoreArg" }
}

class UnderscoreLhs extends @underscore_lhs, AstNode, AssignmentLeftType,
  DestructuredLeftAssignmentChildType, ForPatternType, LeftAssignmentListChildType,
  UnderscorePrimary {
  override string describeQlClass() { result = "UnderscoreLhs" }
}

class UnderscoreMethodName extends @underscore_method_name, AstNode {
  override string describeQlClass() { result = "UnderscoreMethodName" }
}

class UnderscorePrimary extends @underscore_primary, AstNode, CallReceiverType, UnderscoreArg {
  override string describeQlClass() { result = "UnderscorePrimary" }
}

class UnderscoreStatement extends @underscore_statement, AstNode, BeginBlockChildType,
  BeginChildType, BlockChildType, ClassChildType, DoBlockChildType, DoChildType, ElseChildType,
  EndBlockChildType, EnsureChildType, MethodChildType, ModuleChildType,
  ParenthesizedStatementsChildType, ProgramChildType, SingletonClassChildType,
  SingletonMethodChildType, ThenChildType {
  override string describeQlClass() { result = "UnderscoreStatement" }
}

class UnderscoreVariable extends @underscore_variable, AstNode, MethodCallMethodType,
  SingletonMethodObjectType, UnderscoreLhs {
  override string describeQlClass() { result = "UnderscoreVariable" }
}

class Alias extends @alias, AstNode, UnderscoreStatement {
  override string describeQlClass() { result = "Alias" }

  override Location getLocation() { alias_def(this, _, _, result) }

  UnderscoreMethodName getAlias() { alias_def(this, result, _, _) }

  UnderscoreMethodName getName() { alias_def(this, _, result, _) }

  override AstNode getAFieldOrChild() {
    alias_def(this, result, _, _) or alias_def(this, _, result, _)
  }
}

class ArgumentListChildType extends @argument_list_child_type, AstNode {
  override string describeQlClass() { result = "ArgumentListChildType" }
}

class ArgumentList extends @argument_list, AstNode, CallMethodType {
  override string describeQlClass() { result = "ArgumentList" }

  override Location getLocation() { argument_list_def(this, result) }

  ArgumentListChildType getChild(int i) { argument_list_child(this, i, result) }

  override AstNode getAFieldOrChild() { argument_list_child(this, _, result) }
}

class ArrayChildType extends @array_child_type, AstNode {
  override string describeQlClass() { result = "ArrayChildType" }
}

class Array extends @array, AstNode, UnderscorePrimary {
  override string describeQlClass() { result = "Array" }

  override Location getLocation() { array_def(this, result) }

  ArrayChildType getChild(int i) { array_child(this, i, result) }

  override AstNode getAFieldOrChild() { array_child(this, _, result) }
}

class AssignmentLeftType extends @assignment_left_type, AstNode {
  override string describeQlClass() { result = "AssignmentLeftType" }
}

class AssignmentRightType extends @assignment_right_type, AstNode {
  override string describeQlClass() { result = "AssignmentRightType" }
}

class Assignment extends @assignment, AstNode, UnderscoreArg, UnderscoreStatement {
  override string describeQlClass() { result = "Assignment" }

  override Location getLocation() { assignment_def(this, _, _, result) }

  AssignmentLeftType getLeft() { assignment_def(this, result, _, _) }

  AssignmentRightType getRight() { assignment_def(this, _, result, _) }

  override AstNode getAFieldOrChild() {
    assignment_def(this, result, _, _) or assignment_def(this, _, result, _)
  }
}

class BareStringChildType extends @bare_string_child_type, AstNode {
  override string describeQlClass() { result = "BareStringChildType" }
}

class BareString extends @bare_string, AstNode {
  override string describeQlClass() { result = "BareString" }

  override Location getLocation() { bare_string_def(this, result) }

  BareStringChildType getChild(int i) { bare_string_child(this, i, result) }

  override AstNode getAFieldOrChild() { bare_string_child(this, _, result) }
}

class BareSymbolChildType extends @bare_symbol_child_type, AstNode {
  override string describeQlClass() { result = "BareSymbolChildType" }
}

class BareSymbol extends @bare_symbol, AstNode {
  override string describeQlClass() { result = "BareSymbol" }

  override Location getLocation() { bare_symbol_def(this, result) }

  BareSymbolChildType getChild(int i) { bare_symbol_child(this, i, result) }

  override AstNode getAFieldOrChild() { bare_symbol_child(this, _, result) }
}

class BeginChildType extends @begin_child_type, AstNode {
  override string describeQlClass() { result = "BeginChildType" }
}

class Begin extends @begin, AstNode, UnderscorePrimary {
  override string describeQlClass() { result = "Begin" }

  override Location getLocation() { begin_def(this, result) }

  BeginChildType getChild(int i) { begin_child(this, i, result) }

  override AstNode getAFieldOrChild() { begin_child(this, _, result) }
}

class BeginBlockChildType extends @begin_block_child_type, AstNode {
  override string describeQlClass() { result = "BeginBlockChildType" }
}

class BeginBlock extends @begin_block, AstNode, UnderscoreStatement {
  override string describeQlClass() { result = "BeginBlock" }

  override Location getLocation() { begin_block_def(this, result) }

  BeginBlockChildType getChild(int i) { begin_block_child(this, i, result) }

  override AstNode getAFieldOrChild() { begin_block_child(this, _, result) }
}

class BinaryLeftType extends @binary_left_type, AstNode {
  override string describeQlClass() { result = "BinaryLeftType" }
}

class BinaryOperatorType extends @binary_operator_type, AstNode {
  override string describeQlClass() { result = "BinaryOperatorType" }
}

class BinaryRightType extends @binary_right_type, AstNode {
  override string describeQlClass() { result = "BinaryRightType" }
}

class Binary extends @binary, AstNode, UnderscoreArg, UnderscoreStatement {
  override string describeQlClass() { result = "Binary" }

  override Location getLocation() { binary_def(this, _, _, _, result) }

  BinaryLeftType getLeft() { binary_def(this, result, _, _, _) }

  BinaryOperatorType getOperator() { binary_def(this, _, result, _, _) }

  BinaryRightType getRight() { binary_def(this, _, _, result, _) }

  override AstNode getAFieldOrChild() {
    binary_def(this, result, _, _, _) or
    binary_def(this, _, result, _, _) or
    binary_def(this, _, _, result, _)
  }
}

class BlockChildType extends @block_child_type, AstNode {
  override string describeQlClass() { result = "BlockChildType" }
}

class Block extends @block, AstNode, LambdaBodyType, MethodCallBlockType {
  override string describeQlClass() { result = "Block" }

  override Location getLocation() { block_def(this, result) }

  BlockChildType getChild(int i) { block_child(this, i, result) }

  override AstNode getAFieldOrChild() { block_child(this, _, result) }
}

class BlockArgument extends @block_argument, AstNode, ArgumentListChildType, ArrayChildType,
  ElementReferenceChildType {
  override string describeQlClass() { result = "BlockArgument" }

  override Location getLocation() { block_argument_def(this, _, result) }

  UnderscoreArg getChild() { block_argument_def(this, result, _) }

  override AstNode getAFieldOrChild() { block_argument_def(this, result, _) }
}

class BlockParameter extends @block_parameter, AstNode, BlockParametersChildType,
  DestructuredParameterChildType, LambdaParametersChildType, MethodParametersChildType {
  override string describeQlClass() { result = "BlockParameter" }

  override Location getLocation() { block_parameter_def(this, _, result) }

  Identifier getName() { block_parameter_def(this, result, _) }

  override AstNode getAFieldOrChild() { block_parameter_def(this, result, _) }
}

class BlockParametersChildType extends @block_parameters_child_type, AstNode {
  override string describeQlClass() { result = "BlockParametersChildType" }
}

class BlockParameters extends @block_parameters, AstNode, BlockChildType, DoBlockChildType {
  override string describeQlClass() { result = "BlockParameters" }

  override Location getLocation() { block_parameters_def(this, result) }

  BlockParametersChildType getChild(int i) { block_parameters_child(this, i, result) }

  override AstNode getAFieldOrChild() { block_parameters_child(this, _, result) }
}

class Break extends @break, AstNode, ArgumentListChildType, ArrayChildType, AssignmentRightType,
  BinaryLeftType, BinaryRightType, ElementReferenceChildType, IfModifierConditionType,
  OperatorAssignmentRightType, RescueModifierHandlerType, SuperclassChildType, UnaryChildType,
  UnderscorePrimary, UnderscoreStatement, UnlessModifierConditionType, UntilModifierConditionType,
  WhileModifierConditionType {
  override string describeQlClass() { result = "Break" }

  override Location getLocation() { break_def(this, result) }

  ArgumentList getChild() { break_child(this, result) }

  override AstNode getAFieldOrChild() { break_child(this, result) }
}

class CallMethodType extends @call_method_type, AstNode {
  override string describeQlClass() { result = "CallMethodType" }
}

class CallReceiverType extends @call_receiver_type, AstNode {
  override string describeQlClass() { result = "CallReceiverType" }
}

class Call extends @call, AstNode, ArgumentListChildType, ArrayChildType, AssignmentRightType,
  BinaryLeftType, BinaryRightType, ElementReferenceChildType, IfModifierConditionType,
  MethodCallMethodType, OperatorAssignmentRightType, RescueModifierHandlerType, SuperclassChildType,
  UnaryChildType, UnderscoreLhs, UnderscoreStatement, UnlessModifierConditionType,
  UntilModifierConditionType, WhileModifierConditionType {
  override string describeQlClass() { result = "Call" }

  override Location getLocation() { call_def(this, _, _, result) }

  CallMethodType getMethod() { call_def(this, result, _, _) }

  CallReceiverType getReceiver() { call_def(this, _, result, _) }

  override AstNode getAFieldOrChild() {
    call_def(this, result, _, _) or call_def(this, _, result, _)
  }
}

class CaseChildType extends @case_child_type, AstNode {
  override string describeQlClass() { result = "CaseChildType" }
}

class Case extends @case__, AstNode, UnderscorePrimary {
  override string describeQlClass() { result = "Case" }

  override Location getLocation() { case_def(this, result) }

  UnderscoreStatement getValue() { case_value(this, result) }

  CaseChildType getChild(int i) { case_child(this, i, result) }

  override AstNode getAFieldOrChild() { case_value(this, result) or case_child(this, _, result) }
}

class ChainedString extends @chained_string, AstNode, UnderscorePrimary {
  override string describeQlClass() { result = "ChainedString" }

  override Location getLocation() { chained_string_def(this, result) }

  String getChild(int i) { chained_string_child(this, i, result) }

  override AstNode getAFieldOrChild() { chained_string_child(this, _, result) }
}

class ClassNameType extends @class_name_type, AstNode {
  override string describeQlClass() { result = "ClassNameType" }
}

class ClassChildType extends @class_child_type, AstNode {
  override string describeQlClass() { result = "ClassChildType" }
}

class Class extends @class, AstNode, UnderscorePrimary {
  override string describeQlClass() { result = "Class" }

  override Location getLocation() { class_def(this, _, result) }

  ClassNameType getName() { class_def(this, result, _) }

  ClassChildType getChild(int i) { class_child(this, i, result) }

  override AstNode getAFieldOrChild() { class_def(this, result, _) or class_child(this, _, result) }
}

class Conditional extends @conditional, AstNode, UnderscoreArg {
  override string describeQlClass() { result = "Conditional" }

  override Location getLocation() { conditional_def(this, _, _, _, result) }

  UnderscoreArg getAlternative() { conditional_def(this, result, _, _, _) }

  UnderscoreArg getCondition() { conditional_def(this, _, result, _, _) }

  UnderscoreArg getConsequence() { conditional_def(this, _, _, result, _) }

  override AstNode getAFieldOrChild() {
    conditional_def(this, result, _, _, _) or
    conditional_def(this, _, result, _, _) or
    conditional_def(this, _, _, result, _)
  }
}

class DestructuredLeftAssignmentChildType extends @destructured_left_assignment_child_type, AstNode {
  override string describeQlClass() { result = "DestructuredLeftAssignmentChildType" }
}

class DestructuredLeftAssignment extends @destructured_left_assignment, AstNode,
  DestructuredLeftAssignmentChildType, ForPatternType, LeftAssignmentListChildType {
  override string describeQlClass() { result = "DestructuredLeftAssignment" }

  override Location getLocation() { destructured_left_assignment_def(this, result) }

  DestructuredLeftAssignmentChildType getChild(int i) {
    destructured_left_assignment_child(this, i, result)
  }

  override AstNode getAFieldOrChild() { destructured_left_assignment_child(this, _, result) }
}

class DestructuredParameterChildType extends @destructured_parameter_child_type, AstNode {
  override string describeQlClass() { result = "DestructuredParameterChildType" }
}

class DestructuredParameter extends @destructured_parameter, AstNode, BlockParametersChildType,
  DestructuredParameterChildType, LambdaParametersChildType, MethodParametersChildType {
  override string describeQlClass() { result = "DestructuredParameter" }

  override Location getLocation() { destructured_parameter_def(this, result) }

  DestructuredParameterChildType getChild(int i) { destructured_parameter_child(this, i, result) }

  override AstNode getAFieldOrChild() { destructured_parameter_child(this, _, result) }
}

class DoChildType extends @do_child_type, AstNode {
  override string describeQlClass() { result = "DoChildType" }
}

class Do extends @do, AstNode {
  override string describeQlClass() { result = "Do" }

  override Location getLocation() { do_def(this, result) }

  DoChildType getChild(int i) { do_child(this, i, result) }

  override AstNode getAFieldOrChild() { do_child(this, _, result) }
}

class DoBlockChildType extends @do_block_child_type, AstNode {
  override string describeQlClass() { result = "DoBlockChildType" }
}

class DoBlock extends @do_block, AstNode, LambdaBodyType, MethodCallBlockType {
  override string describeQlClass() { result = "DoBlock" }

  override Location getLocation() { do_block_def(this, result) }

  DoBlockChildType getChild(int i) { do_block_child(this, i, result) }

  override AstNode getAFieldOrChild() { do_block_child(this, _, result) }
}

class ElementReferenceChildType extends @element_reference_child_type, AstNode {
  override string describeQlClass() { result = "ElementReferenceChildType" }
}

class ElementReference extends @element_reference, AstNode, UnderscoreLhs {
  override string describeQlClass() { result = "ElementReference" }

  override Location getLocation() { element_reference_def(this, _, result) }

  UnderscorePrimary getObject() { element_reference_def(this, result, _) }

  ElementReferenceChildType getChild(int i) { element_reference_child(this, i, result) }

  override AstNode getAFieldOrChild() {
    element_reference_def(this, result, _) or element_reference_child(this, _, result)
  }
}

class ElseChildType extends @else_child_type, AstNode {
  override string describeQlClass() { result = "ElseChildType" }
}

class Else extends @else, AstNode, BeginChildType, CaseChildType, ClassChildType, DoBlockChildType,
  ElsifAlternativeType, IfAlternativeType, MethodChildType, ModuleChildType,
  SingletonClassChildType, SingletonMethodChildType, UnlessAlternativeType {
  override string describeQlClass() { result = "Else" }

  override Location getLocation() { else_def(this, result) }

  SemicolonUnnamed getCondition() { else_condition(this, result) }

  ElseChildType getChild(int i) { else_child(this, i, result) }

  override AstNode getAFieldOrChild() {
    else_condition(this, result) or else_child(this, _, result)
  }
}

class ElsifAlternativeType extends @elsif_alternative_type, AstNode {
  override string describeQlClass() { result = "ElsifAlternativeType" }
}

class Elsif extends @elsif, AstNode, ElsifAlternativeType, IfAlternativeType, UnlessAlternativeType {
  override string describeQlClass() { result = "Elsif" }

  override Location getLocation() { elsif_def(this, _, result) }

  ElsifAlternativeType getAlternative() { elsif_alternative(this, result) }

  UnderscoreStatement getCondition() { elsif_def(this, result, _) }

  Then getConsequence() { elsif_consequence(this, result) }

  override AstNode getAFieldOrChild() {
    elsif_alternative(this, result) or elsif_def(this, result, _) or elsif_consequence(this, result)
  }
}

class EmptyStatement extends @empty_statement, AstNode, BeginBlockChildType, BeginChildType,
  BlockChildType, ClassChildType, DoBlockChildType, DoChildType, ElseChildType, EndBlockChildType,
  EnsureChildType, MethodChildType, ModuleChildType, ParenthesizedStatementsChildType,
  ProgramChildType, SingletonClassChildType, SingletonMethodChildType, ThenChildType {
  override string describeQlClass() { result = "EmptyStatement" }

  override Location getLocation() { empty_statement_def(this, _, result) }

  string getText() { empty_statement_def(this, result, _) }
}

class EndBlockChildType extends @end_block_child_type, AstNode {
  override string describeQlClass() { result = "EndBlockChildType" }
}

class EndBlock extends @end_block, AstNode, UnderscoreStatement {
  override string describeQlClass() { result = "EndBlock" }

  override Location getLocation() { end_block_def(this, result) }

  EndBlockChildType getChild(int i) { end_block_child(this, i, result) }

  override AstNode getAFieldOrChild() { end_block_child(this, _, result) }
}

class EnsureChildType extends @ensure_child_type, AstNode {
  override string describeQlClass() { result = "EnsureChildType" }
}

class Ensure extends @ensure, AstNode, BeginChildType, ClassChildType, DoBlockChildType,
  MethodChildType, ModuleChildType, SingletonClassChildType, SingletonMethodChildType {
  override string describeQlClass() { result = "Ensure" }

  override Location getLocation() { ensure_def(this, result) }

  EnsureChildType getChild(int i) { ensure_child(this, i, result) }

  override AstNode getAFieldOrChild() { ensure_child(this, _, result) }
}

class ExceptionVariable extends @exception_variable, AstNode {
  override string describeQlClass() { result = "ExceptionVariable" }

  override Location getLocation() { exception_variable_def(this, _, result) }

  UnderscoreLhs getChild() { exception_variable_def(this, result, _) }

  override AstNode getAFieldOrChild() { exception_variable_def(this, result, _) }
}

class ExceptionsChildType extends @exceptions_child_type, AstNode {
  override string describeQlClass() { result = "ExceptionsChildType" }
}

class Exceptions extends @exceptions, AstNode {
  override string describeQlClass() { result = "Exceptions" }

  override Location getLocation() { exceptions_def(this, result) }

  ExceptionsChildType getChild(int i) { exceptions_child(this, i, result) }

  override AstNode getAFieldOrChild() { exceptions_child(this, _, result) }
}

class ForPatternType extends @for_pattern_type, AstNode {
  override string describeQlClass() { result = "ForPatternType" }
}

class For extends @for, AstNode, UnderscorePrimary {
  override string describeQlClass() { result = "For" }

  override Location getLocation() { for_def(this, _, _, result) }

  Do getBody() { for_def(this, result, _, _) }

  ForPatternType getPattern(int i) { for_pattern(this, i, result) }

  In getValue() { for_def(this, _, result, _) }

  override AstNode getAFieldOrChild() {
    for_def(this, result, _, _) or for_pattern(this, _, result) or for_def(this, _, result, _)
  }
}

class HashChildType extends @hash_child_type, AstNode {
  override string describeQlClass() { result = "HashChildType" }
}

class Hash extends @hash, AstNode, UnderscorePrimary {
  override string describeQlClass() { result = "Hash" }

  override Location getLocation() { hash_def(this, result) }

  HashChildType getChild(int i) { hash_child(this, i, result) }

  override AstNode getAFieldOrChild() { hash_child(this, _, result) }
}

class HashSplatArgument extends @hash_splat_argument, AstNode, ArgumentListChildType,
  ArrayChildType, ElementReferenceChildType, HashChildType {
  override string describeQlClass() { result = "HashSplatArgument" }

  override Location getLocation() { hash_splat_argument_def(this, _, result) }

  UnderscoreArg getChild() { hash_splat_argument_def(this, result, _) }

  override AstNode getAFieldOrChild() { hash_splat_argument_def(this, result, _) }
}

class HashSplatParameter extends @hash_splat_parameter, AstNode, BlockParametersChildType,
  DestructuredParameterChildType, LambdaParametersChildType, MethodParametersChildType {
  override string describeQlClass() { result = "HashSplatParameter" }

  override Location getLocation() { hash_splat_parameter_def(this, result) }

  Identifier getName() { hash_splat_parameter_name(this, result) }

  override AstNode getAFieldOrChild() { hash_splat_parameter_name(this, result) }
}

class HeredocBodyChildType extends @heredoc_body_child_type, AstNode {
  override string describeQlClass() { result = "HeredocBodyChildType" }
}

class HeredocBody extends @heredoc_body, AstNode {
  override string describeQlClass() { result = "HeredocBody" }

  override Location getLocation() { heredoc_body_def(this, result) }

  HeredocBodyChildType getChild(int i) { heredoc_body_child(this, i, result) }

  override AstNode getAFieldOrChild() { heredoc_body_child(this, _, result) }
}

class IfAlternativeType extends @if_alternative_type, AstNode {
  override string describeQlClass() { result = "IfAlternativeType" }
}

class If extends @if, AstNode, UnderscorePrimary {
  override string describeQlClass() { result = "If" }

  override Location getLocation() { if_def(this, _, result) }

  IfAlternativeType getAlternative() { if_alternative(this, result) }

  UnderscoreStatement getCondition() { if_def(this, result, _) }

  Then getConsequence() { if_consequence(this, result) }

  override AstNode getAFieldOrChild() {
    if_alternative(this, result) or if_def(this, result, _) or if_consequence(this, result)
  }
}

class IfModifierConditionType extends @if_modifier_condition_type, AstNode {
  override string describeQlClass() { result = "IfModifierConditionType" }
}

class IfModifier extends @if_modifier, AstNode, UnderscoreStatement {
  override string describeQlClass() { result = "IfModifier" }

  override Location getLocation() { if_modifier_def(this, _, _, result) }

  UnderscoreStatement getBody() { if_modifier_def(this, result, _, _) }

  IfModifierConditionType getCondition() { if_modifier_def(this, _, result, _) }

  override AstNode getAFieldOrChild() {
    if_modifier_def(this, result, _, _) or if_modifier_def(this, _, result, _)
  }
}

class In extends @in, AstNode {
  override string describeQlClass() { result = "In" }

  override Location getLocation() { in_def(this, _, result) }

  UnderscoreArg getChild() { in_def(this, result, _) }

  override AstNode getAFieldOrChild() { in_def(this, result, _) }
}

class Interpolation extends @interpolation, AstNode, BareStringChildType, BareSymbolChildType,
  HeredocBodyChildType, RegexChildType, StringChildType, SubshellChildType, SymbolChildType {
  override string describeQlClass() { result = "Interpolation" }

  override Location getLocation() { interpolation_def(this, _, result) }

  UnderscoreStatement getChild() { interpolation_def(this, result, _) }

  override AstNode getAFieldOrChild() { interpolation_def(this, result, _) }
}

class KeywordParameter extends @keyword_parameter, AstNode, BlockParametersChildType,
  DestructuredParameterChildType, LambdaParametersChildType, MethodParametersChildType {
  override string describeQlClass() { result = "KeywordParameter" }

  override Location getLocation() { keyword_parameter_def(this, _, result) }

  Identifier getName() { keyword_parameter_def(this, result, _) }

  UnderscoreArg getValue() { keyword_parameter_value(this, result) }

  override AstNode getAFieldOrChild() {
    keyword_parameter_def(this, result, _) or keyword_parameter_value(this, result)
  }
}

class LambdaBodyType extends @lambda_body_type, AstNode {
  override string describeQlClass() { result = "LambdaBodyType" }
}

class Lambda extends @lambda, AstNode, UnderscorePrimary {
  override string describeQlClass() { result = "Lambda" }

  override Location getLocation() { lambda_def(this, _, result) }

  LambdaBodyType getBody() { lambda_def(this, result, _) }

  LambdaParameters getParameters() { lambda_parameters(this, result) }

  override AstNode getAFieldOrChild() {
    lambda_def(this, result, _) or lambda_parameters(this, result)
  }
}

class LambdaParametersChildType extends @lambda_parameters_child_type, AstNode {
  override string describeQlClass() { result = "LambdaParametersChildType" }
}

class LambdaParameters extends @lambda_parameters, AstNode {
  override string describeQlClass() { result = "LambdaParameters" }

  override Location getLocation() { lambda_parameters_def(this, result) }

  LambdaParametersChildType getChild(int i) { lambda_parameters_child(this, i, result) }

  override AstNode getAFieldOrChild() { lambda_parameters_child(this, _, result) }
}

class LeftAssignmentListChildType extends @left_assignment_list_child_type, AstNode {
  override string describeQlClass() { result = "LeftAssignmentListChildType" }
}

class LeftAssignmentList extends @left_assignment_list, AstNode, AssignmentLeftType {
  override string describeQlClass() { result = "LeftAssignmentList" }

  override Location getLocation() { left_assignment_list_def(this, result) }

  LeftAssignmentListChildType getChild(int i) { left_assignment_list_child(this, i, result) }

  override AstNode getAFieldOrChild() { left_assignment_list_child(this, _, result) }
}

class MethodChildType extends @method_child_type, AstNode {
  override string describeQlClass() { result = "MethodChildType" }
}

class Method extends @method, AstNode, UnderscorePrimary {
  override string describeQlClass() { result = "Method" }

  override Location getLocation() { method_def(this, _, result) }

  UnderscoreMethodName getName() { method_def(this, result, _) }

  MethodParameters getParameters() { method_parameters(this, result) }

  MethodChildType getChild(int i) { method_child(this, i, result) }

  override AstNode getAFieldOrChild() {
    method_def(this, result, _) or method_parameters(this, result) or method_child(this, _, result)
  }
}

class MethodCallBlockType extends @method_call_block_type, AstNode {
  override string describeQlClass() { result = "MethodCallBlockType" }
}

class MethodCallMethodType extends @method_call_method_type, AstNode {
  override string describeQlClass() { result = "MethodCallMethodType" }
}

class MethodCall extends @method_call, AstNode, ArgumentListChildType, ArrayChildType,
  AssignmentRightType, BinaryLeftType, BinaryRightType, CallReceiverType, ElementReferenceChildType,
  IfModifierConditionType, OperatorAssignmentRightType, RescueModifierHandlerType,
  SuperclassChildType, UnaryChildType, UnderscoreLhs, UnderscoreStatement,
  UnlessModifierConditionType, UntilModifierConditionType, WhileModifierConditionType {
  override string describeQlClass() { result = "MethodCall" }

  override Location getLocation() { method_call_def(this, _, result) }

  ArgumentList getArguments() { method_call_arguments(this, result) }

  MethodCallBlockType getBlock() { method_call_block(this, result) }

  MethodCallMethodType getMethod() { method_call_def(this, result, _) }

  override AstNode getAFieldOrChild() {
    method_call_arguments(this, result) or
    method_call_block(this, result) or
    method_call_def(this, result, _)
  }
}

class MethodParametersChildType extends @method_parameters_child_type, AstNode {
  override string describeQlClass() { result = "MethodParametersChildType" }
}

class MethodParameters extends @method_parameters, AstNode {
  override string describeQlClass() { result = "MethodParameters" }

  override Location getLocation() { method_parameters_def(this, result) }

  MethodParametersChildType getChild(int i) { method_parameters_child(this, i, result) }

  override AstNode getAFieldOrChild() { method_parameters_child(this, _, result) }
}

class ModuleNameType extends @module_name_type, AstNode {
  override string describeQlClass() { result = "ModuleNameType" }
}

class ModuleChildType extends @module_child_type, AstNode {
  override string describeQlClass() { result = "ModuleChildType" }
}

class Module extends @module, AstNode, UnderscorePrimary {
  override string describeQlClass() { result = "Module" }

  override Location getLocation() { module_def(this, _, result) }

  ModuleNameType getName() { module_def(this, result, _) }

  ModuleChildType getChild(int i) { module_child(this, i, result) }

  override AstNode getAFieldOrChild() {
    module_def(this, result, _) or module_child(this, _, result)
  }
}

class Next extends @next, AstNode, ArgumentListChildType, ArrayChildType, AssignmentRightType,
  BinaryLeftType, BinaryRightType, ElementReferenceChildType, IfModifierConditionType,
  OperatorAssignmentRightType, RescueModifierHandlerType, SuperclassChildType, UnaryChildType,
  UnderscorePrimary, UnderscoreStatement, UnlessModifierConditionType, UntilModifierConditionType,
  WhileModifierConditionType {
  override string describeQlClass() { result = "Next" }

  override Location getLocation() { next_def(this, result) }

  ArgumentList getChild() { next_child(this, result) }

  override AstNode getAFieldOrChild() { next_child(this, result) }
}

class Operator extends @operator, AstNode, CallMethodType, UnderscoreMethodName {
  override string describeQlClass() { result = "Operator" }

  override Location getLocation() { operator_def(this, _, result) }

  string getText() { operator_def(this, result, _) }
}

class OperatorAssignmentRightType extends @operator_assignment_right_type, AstNode {
  override string describeQlClass() { result = "OperatorAssignmentRightType" }
}

class OperatorAssignment extends @operator_assignment, AstNode, UnderscoreArg, UnderscoreStatement {
  override string describeQlClass() { result = "OperatorAssignment" }

  override Location getLocation() { operator_assignment_def(this, _, _, result) }

  UnderscoreLhs getLeft() { operator_assignment_def(this, result, _, _) }

  OperatorAssignmentRightType getRight() { operator_assignment_def(this, _, result, _) }

  override AstNode getAFieldOrChild() {
    operator_assignment_def(this, result, _, _) or operator_assignment_def(this, _, result, _)
  }
}

class OptionalParameter extends @optional_parameter, AstNode, BlockParametersChildType,
  DestructuredParameterChildType, LambdaParametersChildType, MethodParametersChildType {
  override string describeQlClass() { result = "OptionalParameter" }

  override Location getLocation() { optional_parameter_def(this, _, _, result) }

  Identifier getName() { optional_parameter_def(this, result, _, _) }

  UnderscoreArg getValue() { optional_parameter_def(this, _, result, _) }

  override AstNode getAFieldOrChild() {
    optional_parameter_def(this, result, _, _) or optional_parameter_def(this, _, result, _)
  }
}

class PairKeyType extends @pair_key_type, AstNode {
  override string describeQlClass() { result = "PairKeyType" }
}

class Pair extends @pair, AstNode, ArgumentListChildType, ArrayChildType, ElementReferenceChildType,
  HashChildType {
  override string describeQlClass() { result = "Pair" }

  override Location getLocation() { pair_def(this, _, _, result) }

  PairKeyType getKey() { pair_def(this, result, _, _) }

  UnderscoreArg getValue() { pair_def(this, _, result, _) }

  override AstNode getAFieldOrChild() {
    pair_def(this, result, _, _) or pair_def(this, _, result, _)
  }
}

class ParenthesizedStatementsChildType extends @parenthesized_statements_child_type, AstNode {
  override string describeQlClass() { result = "ParenthesizedStatementsChildType" }
}

class ParenthesizedStatements extends @parenthesized_statements, AstNode, UnaryChildType,
  UnderscorePrimary {
  override string describeQlClass() { result = "ParenthesizedStatements" }

  override Location getLocation() { parenthesized_statements_def(this, result) }

  ParenthesizedStatementsChildType getChild(int i) {
    parenthesized_statements_child(this, i, result)
  }

  override AstNode getAFieldOrChild() { parenthesized_statements_child(this, _, result) }
}

class PatternChildType extends @pattern_child_type, AstNode {
  override string describeQlClass() { result = "PatternChildType" }
}

class Pattern extends @pattern, AstNode, WhenPatternType {
  override string describeQlClass() { result = "Pattern" }

  override Location getLocation() { pattern_def(this, _, result) }

  PatternChildType getChild() { pattern_def(this, result, _) }

  override AstNode getAFieldOrChild() { pattern_def(this, result, _) }
}

class ProgramChildType extends @program_child_type, AstNode {
  override string describeQlClass() { result = "ProgramChildType" }
}

class Program extends @program, AstNode {
  override string describeQlClass() { result = "Program" }

  override Location getLocation() { program_def(this, result) }

  ProgramChildType getChild(int i) { program_child(this, i, result) }

  override AstNode getAFieldOrChild() { program_child(this, _, result) }
}

class Range extends @range, AstNode, UnderscoreArg {
  override string describeQlClass() { result = "Range" }

  override Location getLocation() { range_def(this, result) }

  UnderscoreArg getChild(int i) { range_child(this, i, result) }

  override AstNode getAFieldOrChild() { range_child(this, _, result) }
}

class Rational extends @rational, AstNode, UnderscorePrimary {
  override string describeQlClass() { result = "Rational" }

  override Location getLocation() { rational_def(this, _, result) }

  Integer getChild() { rational_def(this, result, _) }

  override AstNode getAFieldOrChild() { rational_def(this, result, _) }
}

class Redo extends @redo, AstNode, UnderscorePrimary {
  override string describeQlClass() { result = "Redo" }

  override Location getLocation() { redo_def(this, result) }

  ArgumentList getChild() { redo_child(this, result) }

  override AstNode getAFieldOrChild() { redo_child(this, result) }
}

class RegexChildType extends @regex_child_type, AstNode {
  override string describeQlClass() { result = "RegexChildType" }
}

class Regex extends @regex, AstNode, UnderscorePrimary {
  override string describeQlClass() { result = "Regex" }

  override Location getLocation() { regex_def(this, result) }

  RegexChildType getChild(int i) { regex_child(this, i, result) }

  override AstNode getAFieldOrChild() { regex_child(this, _, result) }
}

class Rescue extends @rescue, AstNode, BeginChildType, ClassChildType, DoBlockChildType,
  MethodChildType, ModuleChildType, SingletonClassChildType, SingletonMethodChildType {
  override string describeQlClass() { result = "Rescue" }

  override Location getLocation() { rescue_def(this, result) }

  Then getBody() { rescue_body(this, result) }

  Exceptions getExceptions() { rescue_exceptions(this, result) }

  ExceptionVariable getVariable() { rescue_variable(this, result) }

  override AstNode getAFieldOrChild() {
    rescue_body(this, result) or rescue_exceptions(this, result) or rescue_variable(this, result)
  }
}

class RescueModifierHandlerType extends @rescue_modifier_handler_type, AstNode {
  override string describeQlClass() { result = "RescueModifierHandlerType" }
}

class RescueModifier extends @rescue_modifier, AstNode, UnderscoreStatement {
  override string describeQlClass() { result = "RescueModifier" }

  override Location getLocation() { rescue_modifier_def(this, _, _, result) }

  UnderscoreStatement getBody() { rescue_modifier_def(this, result, _, _) }

  RescueModifierHandlerType getHandler() { rescue_modifier_def(this, _, result, _) }

  override AstNode getAFieldOrChild() {
    rescue_modifier_def(this, result, _, _) or rescue_modifier_def(this, _, result, _)
  }
}

class RestAssignment extends @rest_assignment, AstNode, DestructuredLeftAssignmentChildType,
  ForPatternType, LeftAssignmentListChildType {
  override string describeQlClass() { result = "RestAssignment" }

  override Location getLocation() { rest_assignment_def(this, result) }

  UnderscoreLhs getChild() { rest_assignment_child(this, result) }

  override AstNode getAFieldOrChild() { rest_assignment_child(this, result) }
}

class Retry extends @retry, AstNode, UnderscorePrimary {
  override string describeQlClass() { result = "Retry" }

  override Location getLocation() { retry_def(this, result) }

  ArgumentList getChild() { retry_child(this, result) }

  override AstNode getAFieldOrChild() { retry_child(this, result) }
}

class Return extends @return, AstNode, ArgumentListChildType, ArrayChildType, AssignmentRightType,
  BinaryLeftType, BinaryRightType, ElementReferenceChildType, IfModifierConditionType,
  OperatorAssignmentRightType, RescueModifierHandlerType, SuperclassChildType, UnaryChildType,
  UnderscorePrimary, UnderscoreStatement, UnlessModifierConditionType, UntilModifierConditionType,
  WhileModifierConditionType {
  override string describeQlClass() { result = "Return" }

  override Location getLocation() { return_def(this, result) }

  ArgumentList getChild() { return_child(this, result) }

  override AstNode getAFieldOrChild() { return_child(this, result) }
}

class RightAssignmentListChildType extends @right_assignment_list_child_type, AstNode {
  override string describeQlClass() { result = "RightAssignmentListChildType" }
}

class RightAssignmentList extends @right_assignment_list, AstNode, AssignmentRightType {
  override string describeQlClass() { result = "RightAssignmentList" }

  override Location getLocation() { right_assignment_list_def(this, result) }

  RightAssignmentListChildType getChild(int i) { right_assignment_list_child(this, i, result) }

  override AstNode getAFieldOrChild() { right_assignment_list_child(this, _, result) }
}

class ScopeResolutionNameType extends @scope_resolution_name_type, AstNode {
  override string describeQlClass() { result = "ScopeResolutionNameType" }
}

class ScopeResolution extends @scope_resolution, AstNode, ClassNameType, MethodCallMethodType,
  ModuleNameType, UnderscoreLhs {
  override string describeQlClass() { result = "ScopeResolution" }

  override Location getLocation() { scope_resolution_def(this, _, result) }

  ScopeResolutionNameType getName() { scope_resolution_def(this, result, _) }

  UnderscorePrimary getScope() { scope_resolution_scope(this, result) }

  override AstNode getAFieldOrChild() {
    scope_resolution_def(this, result, _) or scope_resolution_scope(this, result)
  }
}

class Setter extends @setter, AstNode, UnderscoreMethodName {
  override string describeQlClass() { result = "Setter" }

  override Location getLocation() { setter_def(this, _, result) }

  Identifier getChild() { setter_def(this, result, _) }

  override AstNode getAFieldOrChild() { setter_def(this, result, _) }
}

class SingletonClassChildType extends @singleton_class_child_type, AstNode {
  override string describeQlClass() { result = "SingletonClassChildType" }
}

class SingletonClass extends @singleton_class, AstNode, UnderscorePrimary {
  override string describeQlClass() { result = "SingletonClass" }

  override Location getLocation() { singleton_class_def(this, _, result) }

  UnderscoreArg getValue() { singleton_class_def(this, result, _) }

  SingletonClassChildType getChild(int i) { singleton_class_child(this, i, result) }

  override AstNode getAFieldOrChild() {
    singleton_class_def(this, result, _) or singleton_class_child(this, _, result)
  }
}

class SingletonMethodObjectType extends @singleton_method_object_type, AstNode {
  override string describeQlClass() { result = "SingletonMethodObjectType" }
}

class SingletonMethodChildType extends @singleton_method_child_type, AstNode {
  override string describeQlClass() { result = "SingletonMethodChildType" }
}

class SingletonMethod extends @singleton_method, AstNode, UnderscorePrimary {
  override string describeQlClass() { result = "SingletonMethod" }

  override Location getLocation() { singleton_method_def(this, _, _, result) }

  UnderscoreMethodName getName() { singleton_method_def(this, result, _, _) }

  SingletonMethodObjectType getObject() { singleton_method_def(this, _, result, _) }

  MethodParameters getParameters() { singleton_method_parameters(this, result) }

  SingletonMethodChildType getChild(int i) { singleton_method_child(this, i, result) }

  override AstNode getAFieldOrChild() {
    singleton_method_def(this, result, _, _) or
    singleton_method_def(this, _, result, _) or
    singleton_method_parameters(this, result) or
    singleton_method_child(this, _, result)
  }
}

class SplatArgument extends @splat_argument, AstNode, ArgumentListChildType, ArrayChildType,
  AssignmentRightType, ElementReferenceChildType, ExceptionsChildType, PatternChildType,
  RightAssignmentListChildType {
  override string describeQlClass() { result = "SplatArgument" }

  override Location getLocation() { splat_argument_def(this, _, result) }

  UnderscoreArg getChild() { splat_argument_def(this, result, _) }

  override AstNode getAFieldOrChild() { splat_argument_def(this, result, _) }
}

class SplatParameter extends @splat_parameter, AstNode, BlockParametersChildType,
  DestructuredParameterChildType, LambdaParametersChildType, MethodParametersChildType {
  override string describeQlClass() { result = "SplatParameter" }

  override Location getLocation() { splat_parameter_def(this, result) }

  Identifier getName() { splat_parameter_name(this, result) }

  override AstNode getAFieldOrChild() { splat_parameter_name(this, result) }
}

class StringChildType extends @string_child_type, AstNode {
  override string describeQlClass() { result = "StringChildType" }
}

class String extends @string__, AstNode, PairKeyType, UnderscorePrimary {
  override string describeQlClass() { result = "String" }

  override Location getLocation() { string_def(this, result) }

  StringChildType getChild(int i) { string_child(this, i, result) }

  override AstNode getAFieldOrChild() { string_child(this, _, result) }
}

class StringArray extends @string_array, AstNode, UnderscorePrimary {
  override string describeQlClass() { result = "StringArray" }

  override Location getLocation() { string_array_def(this, result) }

  BareString getChild(int i) { string_array_child(this, i, result) }

  override AstNode getAFieldOrChild() { string_array_child(this, _, result) }
}

class SubshellChildType extends @subshell_child_type, AstNode {
  override string describeQlClass() { result = "SubshellChildType" }
}

class Subshell extends @subshell, AstNode, UnderscorePrimary {
  override string describeQlClass() { result = "Subshell" }

  override Location getLocation() { subshell_def(this, result) }

  SubshellChildType getChild(int i) { subshell_child(this, i, result) }

  override AstNode getAFieldOrChild() { subshell_child(this, _, result) }
}

class SuperclassChildType extends @superclass_child_type, AstNode {
  override string describeQlClass() { result = "SuperclassChildType" }
}

class Superclass extends @superclass, AstNode, ClassChildType {
  override string describeQlClass() { result = "Superclass" }

  override Location getLocation() { superclass_def(this, _, result) }

  SuperclassChildType getChild() { superclass_def(this, result, _) }

  override AstNode getAFieldOrChild() { superclass_def(this, result, _) }
}

class SymbolChildType extends @symbol_child_type, AstNode {
  override string describeQlClass() { result = "SymbolChildType" }
}

class Symbol extends @symbol, AstNode, PairKeyType, UnderscoreMethodName, UnderscorePrimary {
  override string describeQlClass() { result = "Symbol" }

  override Location getLocation() { symbol_def(this, result) }

  SymbolChildType getChild(int i) { symbol_child(this, i, result) }

  override AstNode getAFieldOrChild() { symbol_child(this, _, result) }
}

class SymbolArray extends @symbol_array, AstNode, UnderscorePrimary {
  override string describeQlClass() { result = "SymbolArray" }

  override Location getLocation() { symbol_array_def(this, result) }

  BareSymbol getChild(int i) { symbol_array_child(this, i, result) }

  override AstNode getAFieldOrChild() { symbol_array_child(this, _, result) }
}

class ThenChildType extends @then_child_type, AstNode {
  override string describeQlClass() { result = "ThenChildType" }
}

class Then extends @then, AstNode {
  override string describeQlClass() { result = "Then" }

  override Location getLocation() { then_def(this, result) }

  ThenChildType getChild(int i) { then_child(this, i, result) }

  override AstNode getAFieldOrChild() { then_child(this, _, result) }
}

class UnaryChildType extends @unary_child_type, AstNode {
  override string describeQlClass() { result = "UnaryChildType" }
}

class Unary extends @unary, AstNode, UnderscoreArg, UnderscorePrimary, UnderscoreStatement {
  override string describeQlClass() { result = "Unary" }

  override Location getLocation() { unary_def(this, _, result) }

  UnaryChildType getChild() { unary_def(this, result, _) }

  override AstNode getAFieldOrChild() { unary_def(this, result, _) }
}

class Undef extends @undef, AstNode, UnderscoreStatement {
  override string describeQlClass() { result = "Undef" }

  override Location getLocation() { undef_def(this, result) }

  UnderscoreMethodName getChild(int i) { undef_child(this, i, result) }

  override AstNode getAFieldOrChild() { undef_child(this, _, result) }
}

class UnlessAlternativeType extends @unless_alternative_type, AstNode {
  override string describeQlClass() { result = "UnlessAlternativeType" }
}

class Unless extends @unless, AstNode, UnderscorePrimary {
  override string describeQlClass() { result = "Unless" }

  override Location getLocation() { unless_def(this, _, result) }

  UnlessAlternativeType getAlternative() { unless_alternative(this, result) }

  UnderscoreStatement getCondition() { unless_def(this, result, _) }

  Then getConsequence() { unless_consequence(this, result) }

  override AstNode getAFieldOrChild() {
    unless_alternative(this, result) or
    unless_def(this, result, _) or
    unless_consequence(this, result)
  }
}

class UnlessModifierConditionType extends @unless_modifier_condition_type, AstNode {
  override string describeQlClass() { result = "UnlessModifierConditionType" }
}

class UnlessModifier extends @unless_modifier, AstNode, UnderscoreStatement {
  override string describeQlClass() { result = "UnlessModifier" }

  override Location getLocation() { unless_modifier_def(this, _, _, result) }

  UnderscoreStatement getBody() { unless_modifier_def(this, result, _, _) }

  UnlessModifierConditionType getCondition() { unless_modifier_def(this, _, result, _) }

  override AstNode getAFieldOrChild() {
    unless_modifier_def(this, result, _, _) or unless_modifier_def(this, _, result, _)
  }
}

class Until extends @until, AstNode, UnderscorePrimary {
  override string describeQlClass() { result = "Until" }

  override Location getLocation() { until_def(this, _, _, result) }

  Do getBody() { until_def(this, result, _, _) }

  UnderscoreStatement getCondition() { until_def(this, _, result, _) }

  override AstNode getAFieldOrChild() {
    until_def(this, result, _, _) or until_def(this, _, result, _)
  }
}

class UntilModifierConditionType extends @until_modifier_condition_type, AstNode {
  override string describeQlClass() { result = "UntilModifierConditionType" }
}

class UntilModifier extends @until_modifier, AstNode, UnderscoreStatement {
  override string describeQlClass() { result = "UntilModifier" }

  override Location getLocation() { until_modifier_def(this, _, _, result) }

  UnderscoreStatement getBody() { until_modifier_def(this, result, _, _) }

  UntilModifierConditionType getCondition() { until_modifier_def(this, _, result, _) }

  override AstNode getAFieldOrChild() {
    until_modifier_def(this, result, _, _) or until_modifier_def(this, _, result, _)
  }
}

class WhenPatternType extends @when_pattern_type, AstNode {
  override string describeQlClass() { result = "WhenPatternType" }
}

class When extends @when, AstNode, CaseChildType {
  override string describeQlClass() { result = "When" }

  override Location getLocation() { when_def(this, result) }

  Then getBody() { when_body(this, result) }

  WhenPatternType getPattern(int i) { when_pattern(this, i, result) }

  override AstNode getAFieldOrChild() { when_body(this, result) or when_pattern(this, _, result) }
}

class While extends @while, AstNode, UnderscorePrimary {
  override string describeQlClass() { result = "While" }

  override Location getLocation() { while_def(this, _, _, result) }

  Do getBody() { while_def(this, result, _, _) }

  UnderscoreStatement getCondition() { while_def(this, _, result, _) }

  override AstNode getAFieldOrChild() {
    while_def(this, result, _, _) or while_def(this, _, result, _)
  }
}

class WhileModifierConditionType extends @while_modifier_condition_type, AstNode {
  override string describeQlClass() { result = "WhileModifierConditionType" }
}

class WhileModifier extends @while_modifier, AstNode, UnderscoreStatement {
  override string describeQlClass() { result = "WhileModifier" }

  override Location getLocation() { while_modifier_def(this, _, _, result) }

  UnderscoreStatement getBody() { while_modifier_def(this, result, _, _) }

  WhileModifierConditionType getCondition() { while_modifier_def(this, _, result, _) }

  override AstNode getAFieldOrChild() {
    while_modifier_def(this, result, _, _) or while_modifier_def(this, _, result, _)
  }
}

class Yield extends @yield, AstNode, ArgumentListChildType, ArrayChildType, AssignmentRightType,
  BinaryLeftType, BinaryRightType, ElementReferenceChildType, IfModifierConditionType,
  OperatorAssignmentRightType, RescueModifierHandlerType, SuperclassChildType, UnaryChildType,
  UnderscorePrimary, UnderscoreStatement, UnlessModifierConditionType, UntilModifierConditionType,
  WhileModifierConditionType {
  override string describeQlClass() { result = "Yield" }

  override Location getLocation() { yield_def(this, result) }

  ArgumentList getChild() { yield_child(this, result) }

  override AstNode getAFieldOrChild() { yield_child(this, result) }
}

class BangUnnamed extends @bang_unnamed, AstNode {
  override string describeQlClass() { result = "BangUnnamed" }

  override Location getLocation() { bang_unnamed_def(this, _, result) }

  string getText() { bang_unnamed_def(this, result, _) }
}

class BangequalUnnamed extends @bangequal_unnamed, AstNode, BinaryOperatorType {
  override string describeQlClass() { result = "BangequalUnnamed" }

  override Location getLocation() { bangequal_unnamed_def(this, _, result) }

  string getText() { bangequal_unnamed_def(this, result, _) }
}

class BangtildeUnnamed extends @bangtilde_unnamed, AstNode, BinaryOperatorType {
  override string describeQlClass() { result = "BangtildeUnnamed" }

  override Location getLocation() { bangtilde_unnamed_def(this, _, result) }

  string getText() { bangtilde_unnamed_def(this, result, _) }
}

class DquoteUnnamed extends @dquote_unnamed, AstNode {
  override string describeQlClass() { result = "DquoteUnnamed" }

  override Location getLocation() { dquote_unnamed_def(this, _, result) }

  string getText() { dquote_unnamed_def(this, result, _) }
}

class HashlbraceUnnamed extends @hashlbrace_unnamed, AstNode {
  override string describeQlClass() { result = "HashlbraceUnnamed" }

  override Location getLocation() { hashlbrace_unnamed_def(this, _, result) }

  string getText() { hashlbrace_unnamed_def(this, result, _) }
}

class PercentUnnamed extends @percent_unnamed, AstNode, BinaryOperatorType {
  override string describeQlClass() { result = "PercentUnnamed" }

  override Location getLocation() { percent_unnamed_def(this, _, result) }

  string getText() { percent_unnamed_def(this, result, _) }
}

class PercentequalUnnamed extends @percentequal_unnamed, AstNode {
  override string describeQlClass() { result = "PercentequalUnnamed" }

  override Location getLocation() { percentequal_unnamed_def(this, _, result) }

  string getText() { percentequal_unnamed_def(this, result, _) }
}

class PercentilparenUnnamed extends @percentilparen_unnamed, AstNode {
  override string describeQlClass() { result = "PercentilparenUnnamed" }

  override Location getLocation() { percentilparen_unnamed_def(this, _, result) }

  string getText() { percentilparen_unnamed_def(this, result, _) }
}

class PercentwlparenUnnamed extends @percentwlparen_unnamed, AstNode {
  override string describeQlClass() { result = "PercentwlparenUnnamed" }

  override Location getLocation() { percentwlparen_unnamed_def(this, _, result) }

  string getText() { percentwlparen_unnamed_def(this, result, _) }
}

class AmpersandUnnamed extends @ampersand_unnamed, AstNode, BinaryOperatorType {
  override string describeQlClass() { result = "AmpersandUnnamed" }

  override Location getLocation() { ampersand_unnamed_def(this, _, result) }

  string getText() { ampersand_unnamed_def(this, result, _) }
}

class AmpersandampersandUnnamed extends @ampersandampersand_unnamed, AstNode, BinaryOperatorType {
  override string describeQlClass() { result = "AmpersandampersandUnnamed" }

  override Location getLocation() { ampersandampersand_unnamed_def(this, _, result) }

  string getText() { ampersandampersand_unnamed_def(this, result, _) }
}

class AmpersandampersandequalUnnamed extends @ampersandampersandequal_unnamed, AstNode {
  override string describeQlClass() { result = "AmpersandampersandequalUnnamed" }

  override Location getLocation() { ampersandampersandequal_unnamed_def(this, _, result) }

  string getText() { ampersandampersandequal_unnamed_def(this, result, _) }
}

class AmpersanddotUnnamed extends @ampersanddot_unnamed, AstNode {
  override string describeQlClass() { result = "AmpersanddotUnnamed" }

  override Location getLocation() { ampersanddot_unnamed_def(this, _, result) }

  string getText() { ampersanddot_unnamed_def(this, result, _) }
}

class AmpersandequalUnnamed extends @ampersandequal_unnamed, AstNode {
  override string describeQlClass() { result = "AmpersandequalUnnamed" }

  override Location getLocation() { ampersandequal_unnamed_def(this, _, result) }

  string getText() { ampersandequal_unnamed_def(this, result, _) }
}

class LparenUnnamed extends @lparen_unnamed, AstNode {
  override string describeQlClass() { result = "LparenUnnamed" }

  override Location getLocation() { lparen_unnamed_def(this, _, result) }

  string getText() { lparen_unnamed_def(this, result, _) }
}

class RparenUnnamed extends @rparen_unnamed, AstNode {
  override string describeQlClass() { result = "RparenUnnamed" }

  override Location getLocation() { rparen_unnamed_def(this, _, result) }

  string getText() { rparen_unnamed_def(this, result, _) }
}

class StarUnnamed extends @star_unnamed, AstNode, BinaryOperatorType {
  override string describeQlClass() { result = "StarUnnamed" }

  override Location getLocation() { star_unnamed_def(this, _, result) }

  string getText() { star_unnamed_def(this, result, _) }
}

class StarstarUnnamed extends @starstar_unnamed, AstNode, BinaryOperatorType {
  override string describeQlClass() { result = "StarstarUnnamed" }

  override Location getLocation() { starstar_unnamed_def(this, _, result) }

  string getText() { starstar_unnamed_def(this, result, _) }
}

class StarstarequalUnnamed extends @starstarequal_unnamed, AstNode {
  override string describeQlClass() { result = "StarstarequalUnnamed" }

  override Location getLocation() { starstarequal_unnamed_def(this, _, result) }

  string getText() { starstarequal_unnamed_def(this, result, _) }
}

class StarequalUnnamed extends @starequal_unnamed, AstNode {
  override string describeQlClass() { result = "StarequalUnnamed" }

  override Location getLocation() { starequal_unnamed_def(this, _, result) }

  string getText() { starequal_unnamed_def(this, result, _) }
}

class PlusUnnamed extends @plus_unnamed, AstNode, BinaryOperatorType {
  override string describeQlClass() { result = "PlusUnnamed" }

  override Location getLocation() { plus_unnamed_def(this, _, result) }

  string getText() { plus_unnamed_def(this, result, _) }
}

class PlusequalUnnamed extends @plusequal_unnamed, AstNode {
  override string describeQlClass() { result = "PlusequalUnnamed" }

  override Location getLocation() { plusequal_unnamed_def(this, _, result) }

  string getText() { plusequal_unnamed_def(this, result, _) }
}

class PlusatUnnamed extends @plusat_unnamed, AstNode {
  override string describeQlClass() { result = "PlusatUnnamed" }

  override Location getLocation() { plusat_unnamed_def(this, _, result) }

  string getText() { plusat_unnamed_def(this, result, _) }
}

class CommaUnnamed extends @comma_unnamed, AstNode, WhenPatternType {
  override string describeQlClass() { result = "CommaUnnamed" }

  override Location getLocation() { comma_unnamed_def(this, _, result) }

  string getText() { comma_unnamed_def(this, result, _) }
}

class MinusUnnamed extends @minus_unnamed, AstNode, BinaryOperatorType {
  override string describeQlClass() { result = "MinusUnnamed" }

  override Location getLocation() { minus_unnamed_def(this, _, result) }

  string getText() { minus_unnamed_def(this, result, _) }
}

class MinusequalUnnamed extends @minusequal_unnamed, AstNode {
  override string describeQlClass() { result = "MinusequalUnnamed" }

  override Location getLocation() { minusequal_unnamed_def(this, _, result) }

  string getText() { minusequal_unnamed_def(this, result, _) }
}

class MinusrangleUnnamed extends @minusrangle_unnamed, AstNode {
  override string describeQlClass() { result = "MinusrangleUnnamed" }

  override Location getLocation() { minusrangle_unnamed_def(this, _, result) }

  string getText() { minusrangle_unnamed_def(this, result, _) }
}

class MinusatUnnamed extends @minusat_unnamed, AstNode {
  override string describeQlClass() { result = "MinusatUnnamed" }

  override Location getLocation() { minusat_unnamed_def(this, _, result) }

  string getText() { minusat_unnamed_def(this, result, _) }
}

class DotUnnamed extends @dot_unnamed, AstNode {
  override string describeQlClass() { result = "DotUnnamed" }

  override Location getLocation() { dot_unnamed_def(this, _, result) }

  string getText() { dot_unnamed_def(this, result, _) }
}

class DotdotUnnamed extends @dotdot_unnamed, AstNode {
  override string describeQlClass() { result = "DotdotUnnamed" }

  override Location getLocation() { dotdot_unnamed_def(this, _, result) }

  string getText() { dotdot_unnamed_def(this, result, _) }
}

class DotdotdotUnnamed extends @dotdotdot_unnamed, AstNode {
  override string describeQlClass() { result = "DotdotdotUnnamed" }

  override Location getLocation() { dotdotdot_unnamed_def(this, _, result) }

  string getText() { dotdotdot_unnamed_def(this, result, _) }
}

class SlashUnnamed extends @slash_unnamed, AstNode, BinaryOperatorType {
  override string describeQlClass() { result = "SlashUnnamed" }

  override Location getLocation() { slash_unnamed_def(this, _, result) }

  string getText() { slash_unnamed_def(this, result, _) }
}

class SlashequalUnnamed extends @slashequal_unnamed, AstNode {
  override string describeQlClass() { result = "SlashequalUnnamed" }

  override Location getLocation() { slashequal_unnamed_def(this, _, result) }

  string getText() { slashequal_unnamed_def(this, result, _) }
}

class ColonUnnamed extends @colon_unnamed, AstNode {
  override string describeQlClass() { result = "ColonUnnamed" }

  override Location getLocation() { colon_unnamed_def(this, _, result) }

  string getText() { colon_unnamed_def(this, result, _) }
}

class ColondquoteUnnamed extends @colondquote_unnamed, AstNode {
  override string describeQlClass() { result = "ColondquoteUnnamed" }

  override Location getLocation() { colondquote_unnamed_def(this, _, result) }

  string getText() { colondquote_unnamed_def(this, result, _) }
}

class ColoncolonUnnamed extends @coloncolon_unnamed, AstNode {
  override string describeQlClass() { result = "ColoncolonUnnamed" }

  override Location getLocation() { coloncolon_unnamed_def(this, _, result) }

  string getText() { coloncolon_unnamed_def(this, result, _) }
}

class SemicolonUnnamed extends @semicolon_unnamed, AstNode {
  override string describeQlClass() { result = "SemicolonUnnamed" }

  override Location getLocation() { semicolon_unnamed_def(this, _, result) }

  string getText() { semicolon_unnamed_def(this, result, _) }
}

class LangleUnnamed extends @langle_unnamed, AstNode, BinaryOperatorType {
  override string describeQlClass() { result = "LangleUnnamed" }

  override Location getLocation() { langle_unnamed_def(this, _, result) }

  string getText() { langle_unnamed_def(this, result, _) }
}

class LanglelangleUnnamed extends @langlelangle_unnamed, AstNode, BinaryOperatorType {
  override string describeQlClass() { result = "LanglelangleUnnamed" }

  override Location getLocation() { langlelangle_unnamed_def(this, _, result) }

  string getText() { langlelangle_unnamed_def(this, result, _) }
}

class LanglelangleequalUnnamed extends @langlelangleequal_unnamed, AstNode {
  override string describeQlClass() { result = "LanglelangleequalUnnamed" }

  override Location getLocation() { langlelangleequal_unnamed_def(this, _, result) }

  string getText() { langlelangleequal_unnamed_def(this, result, _) }
}

class LangleequalUnnamed extends @langleequal_unnamed, AstNode, BinaryOperatorType {
  override string describeQlClass() { result = "LangleequalUnnamed" }

  override Location getLocation() { langleequal_unnamed_def(this, _, result) }

  string getText() { langleequal_unnamed_def(this, result, _) }
}

class LangleequalrangleUnnamed extends @langleequalrangle_unnamed, AstNode, BinaryOperatorType {
  override string describeQlClass() { result = "LangleequalrangleUnnamed" }

  override Location getLocation() { langleequalrangle_unnamed_def(this, _, result) }

  string getText() { langleequalrangle_unnamed_def(this, result, _) }
}

class EqualUnnamed extends @equal_unnamed, AstNode {
  override string describeQlClass() { result = "EqualUnnamed" }

  override Location getLocation() { equal_unnamed_def(this, _, result) }

  string getText() { equal_unnamed_def(this, result, _) }
}

class EqualequalUnnamed extends @equalequal_unnamed, AstNode, BinaryOperatorType {
  override string describeQlClass() { result = "EqualequalUnnamed" }

  override Location getLocation() { equalequal_unnamed_def(this, _, result) }

  string getText() { equalequal_unnamed_def(this, result, _) }
}

class EqualequalequalUnnamed extends @equalequalequal_unnamed, AstNode, BinaryOperatorType {
  override string describeQlClass() { result = "EqualequalequalUnnamed" }

  override Location getLocation() { equalequalequal_unnamed_def(this, _, result) }

  string getText() { equalequalequal_unnamed_def(this, result, _) }
}

class EqualrangleUnnamed extends @equalrangle_unnamed, AstNode {
  override string describeQlClass() { result = "EqualrangleUnnamed" }

  override Location getLocation() { equalrangle_unnamed_def(this, _, result) }

  string getText() { equalrangle_unnamed_def(this, result, _) }
}

class EqualtildeUnnamed extends @equaltilde_unnamed, AstNode, BinaryOperatorType {
  override string describeQlClass() { result = "EqualtildeUnnamed" }

  override Location getLocation() { equaltilde_unnamed_def(this, _, result) }

  string getText() { equaltilde_unnamed_def(this, result, _) }
}

class RangleUnnamed extends @rangle_unnamed, AstNode, BinaryOperatorType {
  override string describeQlClass() { result = "RangleUnnamed" }

  override Location getLocation() { rangle_unnamed_def(this, _, result) }

  string getText() { rangle_unnamed_def(this, result, _) }
}

class RangleequalUnnamed extends @rangleequal_unnamed, AstNode, BinaryOperatorType {
  override string describeQlClass() { result = "RangleequalUnnamed" }

  override Location getLocation() { rangleequal_unnamed_def(this, _, result) }

  string getText() { rangleequal_unnamed_def(this, result, _) }
}

class RanglerangleUnnamed extends @ranglerangle_unnamed, AstNode, BinaryOperatorType {
  override string describeQlClass() { result = "RanglerangleUnnamed" }

  override Location getLocation() { ranglerangle_unnamed_def(this, _, result) }

  string getText() { ranglerangle_unnamed_def(this, result, _) }
}

class RanglerangleequalUnnamed extends @ranglerangleequal_unnamed, AstNode {
  override string describeQlClass() { result = "RanglerangleequalUnnamed" }

  override Location getLocation() { ranglerangleequal_unnamed_def(this, _, result) }

  string getText() { ranglerangleequal_unnamed_def(this, result, _) }
}

class QuestionUnnamed extends @question_unnamed, AstNode {
  override string describeQlClass() { result = "QuestionUnnamed" }

  override Location getLocation() { question_unnamed_def(this, _, result) }

  string getText() { question_unnamed_def(this, result, _) }
}

class BEGINUnnamed extends @b_e_g_i_n__unnamed, AstNode {
  override string describeQlClass() { result = "BEGINUnnamed" }

  override Location getLocation() { b_e_g_i_n__unnamed_def(this, _, result) }

  string getText() { b_e_g_i_n__unnamed_def(this, result, _) }
}

class ENDUnnamed extends @e_n_d__unnamed, AstNode {
  override string describeQlClass() { result = "ENDUnnamed" }

  override Location getLocation() { e_n_d__unnamed_def(this, _, result) }

  string getText() { e_n_d__unnamed_def(this, result, _) }
}

class LbracketUnnamed extends @lbracket_unnamed, AstNode {
  override string describeQlClass() { result = "LbracketUnnamed" }

  override Location getLocation() { lbracket_unnamed_def(this, _, result) }

  string getText() { lbracket_unnamed_def(this, result, _) }
}

class LbracketrbracketUnnamed extends @lbracketrbracket_unnamed, AstNode {
  override string describeQlClass() { result = "LbracketrbracketUnnamed" }

  override Location getLocation() { lbracketrbracket_unnamed_def(this, _, result) }

  string getText() { lbracketrbracket_unnamed_def(this, result, _) }
}

class LbracketrbracketequalUnnamed extends @lbracketrbracketequal_unnamed, AstNode {
  override string describeQlClass() { result = "LbracketrbracketequalUnnamed" }

  override Location getLocation() { lbracketrbracketequal_unnamed_def(this, _, result) }

  string getText() { lbracketrbracketequal_unnamed_def(this, result, _) }
}

class RbracketUnnamed extends @rbracket_unnamed, AstNode {
  override string describeQlClass() { result = "RbracketUnnamed" }

  override Location getLocation() { rbracket_unnamed_def(this, _, result) }

  string getText() { rbracket_unnamed_def(this, result, _) }
}

class CaretUnnamed extends @caret_unnamed, AstNode, BinaryOperatorType {
  override string describeQlClass() { result = "CaretUnnamed" }

  override Location getLocation() { caret_unnamed_def(this, _, result) }

  string getText() { caret_unnamed_def(this, result, _) }
}

class CaretequalUnnamed extends @caretequal_unnamed, AstNode {
  override string describeQlClass() { result = "CaretequalUnnamed" }

  override Location getLocation() { caretequal_unnamed_def(this, _, result) }

  string getText() { caretequal_unnamed_def(this, result, _) }
}

class UnderscoreENDUnnamed extends @underscore__e_n_d____unnamed, AstNode {
  override string describeQlClass() { result = "UnderscoreENDUnnamed" }

  override Location getLocation() { underscore__e_n_d____unnamed_def(this, _, result) }

  string getText() { underscore__e_n_d____unnamed_def(this, result, _) }
}

class BacktickUnnamed extends @backtick_unnamed, AstNode {
  override string describeQlClass() { result = "BacktickUnnamed" }

  override Location getLocation() { backtick_unnamed_def(this, _, result) }

  string getText() { backtick_unnamed_def(this, result, _) }
}

class AliasUnnamed extends @alias_unnamed, AstNode {
  override string describeQlClass() { result = "AliasUnnamed" }

  override Location getLocation() { alias_unnamed_def(this, _, result) }

  string getText() { alias_unnamed_def(this, result, _) }
}

class AndUnnamed extends @and_unnamed, AstNode, BinaryOperatorType {
  override string describeQlClass() { result = "AndUnnamed" }

  override Location getLocation() { and_unnamed_def(this, _, result) }

  string getText() { and_unnamed_def(this, result, _) }
}

class BeginUnnamed extends @begin_unnamed, AstNode {
  override string describeQlClass() { result = "BeginUnnamed" }

  override Location getLocation() { begin_unnamed_def(this, _, result) }

  string getText() { begin_unnamed_def(this, result, _) }
}

class BreakUnnamed extends @break_unnamed, AstNode {
  override string describeQlClass() { result = "BreakUnnamed" }

  override Location getLocation() { break_unnamed_def(this, _, result) }

  string getText() { break_unnamed_def(this, result, _) }
}

class CaseUnnamed extends @case_unnamed, AstNode {
  override string describeQlClass() { result = "CaseUnnamed" }

  override Location getLocation() { case_unnamed_def(this, _, result) }

  string getText() { case_unnamed_def(this, result, _) }
}

class Character extends @character, AstNode, UnderscorePrimary {
  override string describeQlClass() { result = "Character" }

  override Location getLocation() { character_def(this, _, result) }

  string getText() { character_def(this, result, _) }
}

class ClassUnnamed extends @class_unnamed, AstNode {
  override string describeQlClass() { result = "ClassUnnamed" }

  override Location getLocation() { class_unnamed_def(this, _, result) }

  string getText() { class_unnamed_def(this, result, _) }
}

class ClassVariable extends @class_variable, AstNode, UnderscoreMethodName, UnderscoreVariable {
  override string describeQlClass() { result = "ClassVariable" }

  override Location getLocation() { class_variable_def(this, _, result) }

  string getText() { class_variable_def(this, result, _) }
}

class Comment extends @comment, AstNode {
  override string describeQlClass() { result = "Comment" }

  override Location getLocation() { comment_def(this, _, result) }

  string getText() { comment_def(this, result, _) }
}

class Complex extends @complex, AstNode, UnderscorePrimary {
  override string describeQlClass() { result = "Complex" }

  override Location getLocation() { complex_def(this, _, result) }

  string getText() { complex_def(this, result, _) }
}

class Constant extends @constant, AstNode, CallMethodType, ClassNameType, ModuleNameType,
  ScopeResolutionNameType, UnderscoreMethodName, UnderscoreVariable {
  override string describeQlClass() { result = "Constant" }

  override Location getLocation() { constant_def(this, _, result) }

  string getText() { constant_def(this, result, _) }
}

class DefUnnamed extends @def_unnamed, AstNode {
  override string describeQlClass() { result = "DefUnnamed" }

  override Location getLocation() { def_unnamed_def(this, _, result) }

  string getText() { def_unnamed_def(this, result, _) }
}

class DefinedquestionUnnamed extends @definedquestion_unnamed, AstNode {
  override string describeQlClass() { result = "DefinedquestionUnnamed" }

  override Location getLocation() { definedquestion_unnamed_def(this, _, result) }

  string getText() { definedquestion_unnamed_def(this, result, _) }
}

class DoUnnamed extends @do_unnamed, AstNode {
  override string describeQlClass() { result = "DoUnnamed" }

  override Location getLocation() { do_unnamed_def(this, _, result) }

  string getText() { do_unnamed_def(this, result, _) }
}

class ElseUnnamed extends @else_unnamed, AstNode {
  override string describeQlClass() { result = "ElseUnnamed" }

  override Location getLocation() { else_unnamed_def(this, _, result) }

  string getText() { else_unnamed_def(this, result, _) }
}

class ElsifUnnamed extends @elsif_unnamed, AstNode {
  override string describeQlClass() { result = "ElsifUnnamed" }

  override Location getLocation() { elsif_unnamed_def(this, _, result) }

  string getText() { elsif_unnamed_def(this, result, _) }
}

class EndUnnamed extends @end_unnamed, AstNode {
  override string describeQlClass() { result = "EndUnnamed" }

  override Location getLocation() { end_unnamed_def(this, _, result) }

  string getText() { end_unnamed_def(this, result, _) }
}

class EnsureUnnamed extends @ensure_unnamed, AstNode {
  override string describeQlClass() { result = "EnsureUnnamed" }

  override Location getLocation() { ensure_unnamed_def(this, _, result) }

  string getText() { ensure_unnamed_def(this, result, _) }
}

class EscapeSequence extends @escape_sequence, AstNode, BareStringChildType, BareSymbolChildType,
  HeredocBodyChildType, RegexChildType, StringChildType, SubshellChildType, SymbolChildType {
  override string describeQlClass() { result = "EscapeSequence" }

  override Location getLocation() { escape_sequence_def(this, _, result) }

  string getText() { escape_sequence_def(this, result, _) }
}

class False extends @false, AstNode, UnderscoreLhs {
  override string describeQlClass() { result = "False" }

  override Location getLocation() { false_def(this, _, result) }

  string getText() { false_def(this, result, _) }
}

class Float extends @float__, AstNode, UnaryChildType, UnderscorePrimary {
  override string describeQlClass() { result = "Float" }

  override Location getLocation() { float_def(this, _, result) }

  string getText() { float_def(this, result, _) }
}

class ForUnnamed extends @for_unnamed, AstNode {
  override string describeQlClass() { result = "ForUnnamed" }

  override Location getLocation() { for_unnamed_def(this, _, result) }

  string getText() { for_unnamed_def(this, result, _) }
}

class GlobalVariable extends @global_variable, AstNode, UnderscoreMethodName, UnderscoreVariable {
  override string describeQlClass() { result = "GlobalVariable" }

  override Location getLocation() { global_variable_def(this, _, result) }

  string getText() { global_variable_def(this, result, _) }
}

class HeredocBeginning extends @heredoc_beginning, AstNode, UnderscorePrimary {
  override string describeQlClass() { result = "HeredocBeginning" }

  override Location getLocation() { heredoc_beginning_def(this, _, result) }

  string getText() { heredoc_beginning_def(this, result, _) }
}

class HeredocEnd extends @heredoc_end, AstNode, HeredocBodyChildType {
  override string describeQlClass() { result = "HeredocEnd" }

  override Location getLocation() { heredoc_end_def(this, _, result) }

  string getText() { heredoc_end_def(this, result, _) }
}

class Identifier extends @identifier, AstNode, BlockParametersChildType, CallMethodType,
  DestructuredParameterChildType, LambdaParametersChildType, MethodParametersChildType,
  ScopeResolutionNameType, UnderscoreMethodName, UnderscoreVariable {
  override string describeQlClass() { result = "Identifier" }

  override Location getLocation() { identifier_def(this, _, result) }

  string getText() { identifier_def(this, result, _) }
}

class IfUnnamed extends @if_unnamed, AstNode {
  override string describeQlClass() { result = "IfUnnamed" }

  override Location getLocation() { if_unnamed_def(this, _, result) }

  string getText() { if_unnamed_def(this, result, _) }
}

class InUnnamed extends @in_unnamed, AstNode {
  override string describeQlClass() { result = "InUnnamed" }

  override Location getLocation() { in_unnamed_def(this, _, result) }

  string getText() { in_unnamed_def(this, result, _) }
}

class InstanceVariable extends @instance_variable, AstNode, UnderscoreMethodName, UnderscoreVariable {
  override string describeQlClass() { result = "InstanceVariable" }

  override Location getLocation() { instance_variable_def(this, _, result) }

  string getText() { instance_variable_def(this, result, _) }
}

class Integer extends @integer, AstNode, UnaryChildType, UnderscorePrimary {
  override string describeQlClass() { result = "Integer" }

  override Location getLocation() { integer_def(this, _, result) }

  string getText() { integer_def(this, result, _) }
}

class ModuleUnnamed extends @module_unnamed, AstNode {
  override string describeQlClass() { result = "ModuleUnnamed" }

  override Location getLocation() { module_unnamed_def(this, _, result) }

  string getText() { module_unnamed_def(this, result, _) }
}

class NextUnnamed extends @next_unnamed, AstNode {
  override string describeQlClass() { result = "NextUnnamed" }

  override Location getLocation() { next_unnamed_def(this, _, result) }

  string getText() { next_unnamed_def(this, result, _) }
}

class Nil extends @nil, AstNode, UnderscoreLhs {
  override string describeQlClass() { result = "Nil" }

  override Location getLocation() { nil_def(this, _, result) }

  string getText() { nil_def(this, result, _) }
}

class NotUnnamed extends @not_unnamed, AstNode {
  override string describeQlClass() { result = "NotUnnamed" }

  override Location getLocation() { not_unnamed_def(this, _, result) }

  string getText() { not_unnamed_def(this, result, _) }
}

class OrUnnamed extends @or_unnamed, AstNode, BinaryOperatorType {
  override string describeQlClass() { result = "OrUnnamed" }

  override Location getLocation() { or_unnamed_def(this, _, result) }

  string getText() { or_unnamed_def(this, result, _) }
}

class RUnnamed extends @r_unnamed, AstNode {
  override string describeQlClass() { result = "RUnnamed" }

  override Location getLocation() { r_unnamed_def(this, _, result) }

  string getText() { r_unnamed_def(this, result, _) }
}

class RedoUnnamed extends @redo_unnamed, AstNode {
  override string describeQlClass() { result = "RedoUnnamed" }

  override Location getLocation() { redo_unnamed_def(this, _, result) }

  string getText() { redo_unnamed_def(this, result, _) }
}

class RescueUnnamed extends @rescue_unnamed, AstNode {
  override string describeQlClass() { result = "RescueUnnamed" }

  override Location getLocation() { rescue_unnamed_def(this, _, result) }

  string getText() { rescue_unnamed_def(this, result, _) }
}

class RetryUnnamed extends @retry_unnamed, AstNode {
  override string describeQlClass() { result = "RetryUnnamed" }

  override Location getLocation() { retry_unnamed_def(this, _, result) }

  string getText() { retry_unnamed_def(this, result, _) }
}

class ReturnUnnamed extends @return_unnamed, AstNode {
  override string describeQlClass() { result = "ReturnUnnamed" }

  override Location getLocation() { return_unnamed_def(this, _, result) }

  string getText() { return_unnamed_def(this, result, _) }
}

class Self extends @self, AstNode, UnderscoreVariable {
  override string describeQlClass() { result = "Self" }

  override Location getLocation() { self_def(this, _, result) }

  string getText() { self_def(this, result, _) }
}

class Super extends @super, AstNode, UnderscoreVariable {
  override string describeQlClass() { result = "Super" }

  override Location getLocation() { super_def(this, _, result) }

  string getText() { super_def(this, result, _) }
}

class ThenUnnamed extends @then_unnamed, AstNode {
  override string describeQlClass() { result = "ThenUnnamed" }

  override Location getLocation() { then_unnamed_def(this, _, result) }

  string getText() { then_unnamed_def(this, result, _) }
}

class True extends @true, AstNode, UnderscoreLhs {
  override string describeQlClass() { result = "True" }

  override Location getLocation() { true_def(this, _, result) }

  string getText() { true_def(this, result, _) }
}

class UndefUnnamed extends @undef_unnamed, AstNode {
  override string describeQlClass() { result = "UndefUnnamed" }

  override Location getLocation() { undef_unnamed_def(this, _, result) }

  string getText() { undef_unnamed_def(this, result, _) }
}

class Uninterpreted extends @uninterpreted, AstNode, ProgramChildType {
  override string describeQlClass() { result = "Uninterpreted" }

  override Location getLocation() { uninterpreted_def(this, _, result) }

  string getText() { uninterpreted_def(this, result, _) }
}

class UnlessUnnamed extends @unless_unnamed, AstNode {
  override string describeQlClass() { result = "UnlessUnnamed" }

  override Location getLocation() { unless_unnamed_def(this, _, result) }

  string getText() { unless_unnamed_def(this, result, _) }
}

class UntilUnnamed extends @until_unnamed, AstNode {
  override string describeQlClass() { result = "UntilUnnamed" }

  override Location getLocation() { until_unnamed_def(this, _, result) }

  string getText() { until_unnamed_def(this, result, _) }
}

class WhenUnnamed extends @when_unnamed, AstNode {
  override string describeQlClass() { result = "WhenUnnamed" }

  override Location getLocation() { when_unnamed_def(this, _, result) }

  string getText() { when_unnamed_def(this, result, _) }
}

class WhileUnnamed extends @while_unnamed, AstNode {
  override string describeQlClass() { result = "WhileUnnamed" }

  override Location getLocation() { while_unnamed_def(this, _, result) }

  string getText() { while_unnamed_def(this, result, _) }
}

class YieldUnnamed extends @yield_unnamed, AstNode {
  override string describeQlClass() { result = "YieldUnnamed" }

  override Location getLocation() { yield_unnamed_def(this, _, result) }

  string getText() { yield_unnamed_def(this, result, _) }
}

class LbraceUnnamed extends @lbrace_unnamed, AstNode {
  override string describeQlClass() { result = "LbraceUnnamed" }

  override Location getLocation() { lbrace_unnamed_def(this, _, result) }

  string getText() { lbrace_unnamed_def(this, result, _) }
}

class PipeUnnamed extends @pipe_unnamed, AstNode, BinaryOperatorType {
  override string describeQlClass() { result = "PipeUnnamed" }

  override Location getLocation() { pipe_unnamed_def(this, _, result) }

  string getText() { pipe_unnamed_def(this, result, _) }
}

class PipeequalUnnamed extends @pipeequal_unnamed, AstNode {
  override string describeQlClass() { result = "PipeequalUnnamed" }

  override Location getLocation() { pipeequal_unnamed_def(this, _, result) }

  string getText() { pipeequal_unnamed_def(this, result, _) }
}

class PipepipeUnnamed extends @pipepipe_unnamed, AstNode, BinaryOperatorType {
  override string describeQlClass() { result = "PipepipeUnnamed" }

  override Location getLocation() { pipepipe_unnamed_def(this, _, result) }

  string getText() { pipepipe_unnamed_def(this, result, _) }
}

class PipepipeequalUnnamed extends @pipepipeequal_unnamed, AstNode {
  override string describeQlClass() { result = "PipepipeequalUnnamed" }

  override Location getLocation() { pipepipeequal_unnamed_def(this, _, result) }

  string getText() { pipepipeequal_unnamed_def(this, result, _) }
}

class RbraceUnnamed extends @rbrace_unnamed, AstNode {
  override string describeQlClass() { result = "RbraceUnnamed" }

  override Location getLocation() { rbrace_unnamed_def(this, _, result) }

  string getText() { rbrace_unnamed_def(this, result, _) }
}

class TildeUnnamed extends @tilde_unnamed, AstNode {
  override string describeQlClass() { result = "TildeUnnamed" }

  override Location getLocation() { tilde_unnamed_def(this, _, result) }

  string getText() { tilde_unnamed_def(this, result, _) }
}
