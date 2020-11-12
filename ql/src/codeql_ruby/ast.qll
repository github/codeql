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

class Token extends @token, AstNode {
  string getValue() { tokeninfo(this, _, _, _, result, _) }

  override Location getLocation() { tokeninfo(this, _, _, _, _, result) }

  override string toString() { result = getValue() }

  override string describeQlClass() { result = "Token" }
}

class ReservedWord extends Token, @reserved_word {
  override string describeQlClass() { result = "ReservedWord" }
}

class UnderscoreArg extends @underscore_arg, AstNode, ArgumentListChildType, ArrayChildType,
  AssignmentRightType, BinaryLeftType, BinaryRightType, ElementReferenceChildType,
  ExceptionsChildType, IfModifierConditionType, OperatorAssignmentRightType, PairKeyType,
  PatternChildType, RescueModifierHandlerType, RightAssignmentListChildType,
  SingletonMethodObjectType, SuperclassChildType, UnaryOperandType, UnderscoreStatement,
  UnlessModifierConditionType, UntilModifierConditionType, WhileModifierConditionType { }

class UnderscoreLhs extends @underscore_lhs, AstNode, AssignmentLeftType,
  DestructuredLeftAssignmentChildType, ForPatternType, LeftAssignmentListChildType,
  UnderscorePrimary { }

class UnderscoreMethodName extends @underscore_method_name, AstNode { }

class UnderscorePrimary extends @underscore_primary, AstNode, CallReceiverType, UnderscoreArg { }

class UnderscoreStatement extends @underscore_statement, AstNode, BeginBlockChildType,
  BeginChildType, BlockChildType, ClassChildType, DoBlockChildType, DoChildType, ElseChildType,
  EndBlockChildType, EnsureChildType, MethodChildType, ModuleChildType,
  ParenthesizedStatementsChildType, ProgramChildType, SingletonClassChildType,
  SingletonMethodChildType, ThenChildType { }

class UnderscoreVariable extends @underscore_variable, AstNode, MethodCallMethodType,
  SingletonMethodObjectType, UnderscoreLhs { }

class Alias extends @alias, AstNode, UnderscoreStatement {
  override string describeQlClass() { result = "Alias" }

  override Location getLocation() { alias_def(this, _, _, result) }

  UnderscoreMethodName getAlias() { alias_def(this, result, _, _) }

  UnderscoreMethodName getName() { alias_def(this, _, result, _) }

  override AstNode getAFieldOrChild() {
    alias_def(this, result, _, _) or alias_def(this, _, result, _)
  }
}

class ArgumentListChildType extends @argument_list_child_type, AstNode { }

class ArgumentList extends @argument_list, AstNode, CallMethodType {
  override string describeQlClass() { result = "ArgumentList" }

  override Location getLocation() { argument_list_def(this, result) }

  ArgumentListChildType getChild(int i) { argument_list_child(this, i, result) }

  override AstNode getAFieldOrChild() { argument_list_child(this, _, result) }
}

class ArrayChildType extends @array_child_type, AstNode { }

class Array extends @array, AstNode, UnderscorePrimary {
  override string describeQlClass() { result = "Array" }

  override Location getLocation() { array_def(this, result) }

  ArrayChildType getChild(int i) { array_child(this, i, result) }

  override AstNode getAFieldOrChild() { array_child(this, _, result) }
}

class AssignmentLeftType extends @assignment_left_type, AstNode { }

class AssignmentRightType extends @assignment_right_type, AstNode { }

class Assignment extends @assignment, AstNode, UnderscoreArg, UnderscoreStatement {
  override string describeQlClass() { result = "Assignment" }

  override Location getLocation() { assignment_def(this, _, _, result) }

  AssignmentLeftType getLeft() { assignment_def(this, result, _, _) }

  AssignmentRightType getRight() { assignment_def(this, _, result, _) }

  override AstNode getAFieldOrChild() {
    assignment_def(this, result, _, _) or assignment_def(this, _, result, _)
  }
}

class BareStringChildType extends @bare_string_child_type, AstNode { }

class BareString extends @bare_string, AstNode {
  override string describeQlClass() { result = "BareString" }

  override Location getLocation() { bare_string_def(this, result) }

  BareStringChildType getChild(int i) { bare_string_child(this, i, result) }

  override AstNode getAFieldOrChild() { bare_string_child(this, _, result) }
}

class BareSymbolChildType extends @bare_symbol_child_type, AstNode { }

class BareSymbol extends @bare_symbol, AstNode {
  override string describeQlClass() { result = "BareSymbol" }

  override Location getLocation() { bare_symbol_def(this, result) }

  BareSymbolChildType getChild(int i) { bare_symbol_child(this, i, result) }

  override AstNode getAFieldOrChild() { bare_symbol_child(this, _, result) }
}

class BeginChildType extends @begin_child_type, AstNode { }

class Begin extends @begin, AstNode, UnderscorePrimary {
  override string describeQlClass() { result = "Begin" }

  override Location getLocation() { begin_def(this, result) }

  BeginChildType getChild(int i) { begin_child(this, i, result) }

  override AstNode getAFieldOrChild() { begin_child(this, _, result) }
}

class BeginBlockChildType extends @begin_block_child_type, AstNode { }

class BeginBlock extends @begin_block, AstNode, UnderscoreStatement {
  override string describeQlClass() { result = "BeginBlock" }

  override Location getLocation() { begin_block_def(this, result) }

  BeginBlockChildType getChild(int i) { begin_block_child(this, i, result) }

  override AstNode getAFieldOrChild() { begin_block_child(this, _, result) }
}

class BinaryLeftType extends @binary_left_type, AstNode { }

class BinaryOperatorType extends @binary_operator_type, AstNode { }

class BinaryRightType extends @binary_right_type, AstNode { }

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

class BlockChildType extends @block_child_type, AstNode { }

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

  Token getName() { block_parameter_def(this, result, _) }

  override AstNode getAFieldOrChild() { block_parameter_def(this, result, _) }
}

class BlockParametersChildType extends @block_parameters_child_type, AstNode { }

class BlockParameters extends @block_parameters, AstNode, BlockChildType, DoBlockChildType {
  override string describeQlClass() { result = "BlockParameters" }

  override Location getLocation() { block_parameters_def(this, result) }

  BlockParametersChildType getChild(int i) { block_parameters_child(this, i, result) }

  override AstNode getAFieldOrChild() { block_parameters_child(this, _, result) }
}

class Break extends @break, AstNode, ArgumentListChildType, ArrayChildType, AssignmentRightType,
  BinaryLeftType, BinaryRightType, ElementReferenceChildType, IfModifierConditionType,
  OperatorAssignmentRightType, RescueModifierHandlerType, SuperclassChildType, UnaryOperandType,
  UnderscorePrimary, UnderscoreStatement, UnlessModifierConditionType, UntilModifierConditionType,
  WhileModifierConditionType {
  override string describeQlClass() { result = "Break" }

  override Location getLocation() { break_def(this, result) }

  ArgumentList getChild() { break_child(this, result) }

  override AstNode getAFieldOrChild() { break_child(this, result) }
}

class CallMethodType extends @call_method_type, AstNode { }

class CallReceiverType extends @call_receiver_type, AstNode { }

class Call extends @call, AstNode, ArgumentListChildType, ArrayChildType, AssignmentRightType,
  BinaryLeftType, BinaryRightType, ElementReferenceChildType, IfModifierConditionType,
  MethodCallMethodType, OperatorAssignmentRightType, RescueModifierHandlerType, SuperclassChildType,
  UnaryOperandType, UnderscoreLhs, UnderscoreStatement, UnlessModifierConditionType,
  UntilModifierConditionType, WhileModifierConditionType {
  override string describeQlClass() { result = "Call" }

  override Location getLocation() { call_def(this, _, _, result) }

  CallMethodType getMethod() { call_def(this, result, _, _) }

  CallReceiverType getReceiver() { call_def(this, _, result, _) }

  override AstNode getAFieldOrChild() {
    call_def(this, result, _, _) or call_def(this, _, result, _)
  }
}

class CaseChildType extends @case_child_type, AstNode { }

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

class ClassNameType extends @class_name_type, AstNode { }

class ClassChildType extends @class_child_type, AstNode { }

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

class DestructuredParameterChildType extends @destructured_parameter_child_type, AstNode { }

class DestructuredParameter extends @destructured_parameter, AstNode, BlockParametersChildType,
  DestructuredParameterChildType, LambdaParametersChildType, MethodParametersChildType {
  override string describeQlClass() { result = "DestructuredParameter" }

  override Location getLocation() { destructured_parameter_def(this, result) }

  DestructuredParameterChildType getChild(int i) { destructured_parameter_child(this, i, result) }

  override AstNode getAFieldOrChild() { destructured_parameter_child(this, _, result) }
}

class DoChildType extends @do_child_type, AstNode { }

class Do extends @do, AstNode {
  override string describeQlClass() { result = "Do" }

  override Location getLocation() { do_def(this, result) }

  DoChildType getChild(int i) { do_child(this, i, result) }

  override AstNode getAFieldOrChild() { do_child(this, _, result) }
}

class DoBlockChildType extends @do_block_child_type, AstNode { }

class DoBlock extends @do_block, AstNode, LambdaBodyType, MethodCallBlockType {
  override string describeQlClass() { result = "DoBlock" }

  override Location getLocation() { do_block_def(this, result) }

  DoBlockChildType getChild(int i) { do_block_child(this, i, result) }

  override AstNode getAFieldOrChild() { do_block_child(this, _, result) }
}

class ElementReferenceChildType extends @element_reference_child_type, AstNode { }

class ElementReference extends @element_reference, AstNode, UnderscoreLhs {
  override string describeQlClass() { result = "ElementReference" }

  override Location getLocation() { element_reference_def(this, _, result) }

  UnderscorePrimary getObject() { element_reference_def(this, result, _) }

  ElementReferenceChildType getChild(int i) { element_reference_child(this, i, result) }

  override AstNode getAFieldOrChild() {
    element_reference_def(this, result, _) or element_reference_child(this, _, result)
  }
}

class ElseChildType extends @else_child_type, AstNode { }

class Else extends @else, AstNode, BeginChildType, CaseChildType, ClassChildType, DoBlockChildType,
  ElsifAlternativeType, IfAlternativeType, MethodChildType, ModuleChildType,
  SingletonClassChildType, SingletonMethodChildType, UnlessAlternativeType {
  override string describeQlClass() { result = "Else" }

  override Location getLocation() { else_def(this, result) }

  ElseChildType getChild(int i) { else_child(this, i, result) }

  override AstNode getAFieldOrChild() { else_child(this, _, result) }
}

class ElsifAlternativeType extends @elsif_alternative_type, AstNode { }

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

class EndBlockChildType extends @end_block_child_type, AstNode { }

class EndBlock extends @end_block, AstNode, UnderscoreStatement {
  override string describeQlClass() { result = "EndBlock" }

  override Location getLocation() { end_block_def(this, result) }

  EndBlockChildType getChild(int i) { end_block_child(this, i, result) }

  override AstNode getAFieldOrChild() { end_block_child(this, _, result) }
}

class EnsureChildType extends @ensure_child_type, AstNode { }

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

class ExceptionsChildType extends @exceptions_child_type, AstNode { }

class Exceptions extends @exceptions, AstNode {
  override string describeQlClass() { result = "Exceptions" }

  override Location getLocation() { exceptions_def(this, result) }

  ExceptionsChildType getChild(int i) { exceptions_child(this, i, result) }

  override AstNode getAFieldOrChild() { exceptions_child(this, _, result) }
}

class ForPatternType extends @for_pattern_type, AstNode { }

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

class HashChildType extends @hash_child_type, AstNode { }

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

  Token getName() { hash_splat_parameter_name(this, result) }

  override AstNode getAFieldOrChild() { hash_splat_parameter_name(this, result) }
}

class HeredocBodyChildType extends @heredoc_body_child_type, AstNode { }

class HeredocBody extends @heredoc_body, AstNode {
  override string describeQlClass() { result = "HeredocBody" }

  override Location getLocation() { heredoc_body_def(this, result) }

  HeredocBodyChildType getChild(int i) { heredoc_body_child(this, i, result) }

  override AstNode getAFieldOrChild() { heredoc_body_child(this, _, result) }
}

class IfAlternativeType extends @if_alternative_type, AstNode { }

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

class IfModifierConditionType extends @if_modifier_condition_type, AstNode { }

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

  Token getName() { keyword_parameter_def(this, result, _) }

  UnderscoreArg getValue() { keyword_parameter_value(this, result) }

  override AstNode getAFieldOrChild() {
    keyword_parameter_def(this, result, _) or keyword_parameter_value(this, result)
  }
}

class LambdaBodyType extends @lambda_body_type, AstNode { }

class Lambda extends @lambda, AstNode, UnderscorePrimary {
  override string describeQlClass() { result = "Lambda" }

  override Location getLocation() { lambda_def(this, _, result) }

  LambdaBodyType getBody() { lambda_def(this, result, _) }

  LambdaParameters getParameters() { lambda_parameters(this, result) }

  override AstNode getAFieldOrChild() {
    lambda_def(this, result, _) or lambda_parameters(this, result)
  }
}

class LambdaParametersChildType extends @lambda_parameters_child_type, AstNode { }

class LambdaParameters extends @lambda_parameters, AstNode {
  override string describeQlClass() { result = "LambdaParameters" }

  override Location getLocation() { lambda_parameters_def(this, result) }

  LambdaParametersChildType getChild(int i) { lambda_parameters_child(this, i, result) }

  override AstNode getAFieldOrChild() { lambda_parameters_child(this, _, result) }
}

class LeftAssignmentListChildType extends @left_assignment_list_child_type, AstNode { }

class LeftAssignmentList extends @left_assignment_list, AstNode, AssignmentLeftType {
  override string describeQlClass() { result = "LeftAssignmentList" }

  override Location getLocation() { left_assignment_list_def(this, result) }

  LeftAssignmentListChildType getChild(int i) { left_assignment_list_child(this, i, result) }

  override AstNode getAFieldOrChild() { left_assignment_list_child(this, _, result) }
}

class MethodChildType extends @method_child_type, AstNode { }

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

class MethodCallBlockType extends @method_call_block_type, AstNode { }

class MethodCallMethodType extends @method_call_method_type, AstNode { }

class MethodCall extends @method_call, AstNode, ArgumentListChildType, ArrayChildType,
  AssignmentRightType, BinaryLeftType, BinaryRightType, CallReceiverType, ElementReferenceChildType,
  IfModifierConditionType, OperatorAssignmentRightType, RescueModifierHandlerType,
  SuperclassChildType, UnaryOperandType, UnderscoreLhs, UnderscoreStatement,
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

class MethodParametersChildType extends @method_parameters_child_type, AstNode { }

class MethodParameters extends @method_parameters, AstNode {
  override string describeQlClass() { result = "MethodParameters" }

  override Location getLocation() { method_parameters_def(this, result) }

  MethodParametersChildType getChild(int i) { method_parameters_child(this, i, result) }

  override AstNode getAFieldOrChild() { method_parameters_child(this, _, result) }
}

class ModuleNameType extends @module_name_type, AstNode { }

class ModuleChildType extends @module_child_type, AstNode { }

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
  OperatorAssignmentRightType, RescueModifierHandlerType, SuperclassChildType, UnaryOperandType,
  UnderscorePrimary, UnderscoreStatement, UnlessModifierConditionType, UntilModifierConditionType,
  WhileModifierConditionType {
  override string describeQlClass() { result = "Next" }

  override Location getLocation() { next_def(this, result) }

  ArgumentList getChild() { next_child(this, result) }

  override AstNode getAFieldOrChild() { next_child(this, result) }
}

class OperatorAssignmentRightType extends @operator_assignment_right_type, AstNode { }

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

  Token getName() { optional_parameter_def(this, result, _, _) }

  UnderscoreArg getValue() { optional_parameter_def(this, _, result, _) }

  override AstNode getAFieldOrChild() {
    optional_parameter_def(this, result, _, _) or optional_parameter_def(this, _, result, _)
  }
}

class PairKeyType extends @pair_key_type, AstNode { }

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

class ParenthesizedStatementsChildType extends @parenthesized_statements_child_type, AstNode { }

class ParenthesizedStatements extends @parenthesized_statements, AstNode, UnaryOperandType,
  UnderscorePrimary {
  override string describeQlClass() { result = "ParenthesizedStatements" }

  override Location getLocation() { parenthesized_statements_def(this, result) }

  ParenthesizedStatementsChildType getChild(int i) {
    parenthesized_statements_child(this, i, result)
  }

  override AstNode getAFieldOrChild() { parenthesized_statements_child(this, _, result) }
}

class PatternChildType extends @pattern_child_type, AstNode { }

class Pattern extends @pattern, AstNode, WhenPatternType {
  override string describeQlClass() { result = "Pattern" }

  override Location getLocation() { pattern_def(this, _, result) }

  PatternChildType getChild() { pattern_def(this, result, _) }

  override AstNode getAFieldOrChild() { pattern_def(this, result, _) }
}

class ProgramChildType extends @program_child_type, AstNode { }

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

  Token getChild() { rational_def(this, result, _) }

  override AstNode getAFieldOrChild() { rational_def(this, result, _) }
}

class Redo extends @redo, AstNode, UnderscorePrimary {
  override string describeQlClass() { result = "Redo" }

  override Location getLocation() { redo_def(this, result) }

  ArgumentList getChild() { redo_child(this, result) }

  override AstNode getAFieldOrChild() { redo_child(this, result) }
}

class RegexChildType extends @regex_child_type, AstNode { }

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

class RescueModifierHandlerType extends @rescue_modifier_handler_type, AstNode { }

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
  OperatorAssignmentRightType, RescueModifierHandlerType, SuperclassChildType, UnaryOperandType,
  UnderscorePrimary, UnderscoreStatement, UnlessModifierConditionType, UntilModifierConditionType,
  WhileModifierConditionType {
  override string describeQlClass() { result = "Return" }

  override Location getLocation() { return_def(this, result) }

  ArgumentList getChild() { return_child(this, result) }

  override AstNode getAFieldOrChild() { return_child(this, result) }
}

class RightAssignmentListChildType extends @right_assignment_list_child_type, AstNode { }

class RightAssignmentList extends @right_assignment_list, AstNode, AssignmentRightType {
  override string describeQlClass() { result = "RightAssignmentList" }

  override Location getLocation() { right_assignment_list_def(this, result) }

  RightAssignmentListChildType getChild(int i) { right_assignment_list_child(this, i, result) }

  override AstNode getAFieldOrChild() { right_assignment_list_child(this, _, result) }
}

class ScopeResolutionNameType extends @scope_resolution_name_type, AstNode { }

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

  Token getChild() { setter_def(this, result, _) }

  override AstNode getAFieldOrChild() { setter_def(this, result, _) }
}

class SingletonClassChildType extends @singleton_class_child_type, AstNode { }

class SingletonClass extends @singleton_class, AstNode, UnderscorePrimary {
  override string describeQlClass() { result = "SingletonClass" }

  override Location getLocation() { singleton_class_def(this, _, result) }

  UnderscoreArg getValue() { singleton_class_def(this, result, _) }

  SingletonClassChildType getChild(int i) { singleton_class_child(this, i, result) }

  override AstNode getAFieldOrChild() {
    singleton_class_def(this, result, _) or singleton_class_child(this, _, result)
  }
}

class SingletonMethodObjectType extends @singleton_method_object_type, AstNode { }

class SingletonMethodChildType extends @singleton_method_child_type, AstNode { }

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

  Token getName() { splat_parameter_name(this, result) }

  override AstNode getAFieldOrChild() { splat_parameter_name(this, result) }
}

class StringChildType extends @string_child_type, AstNode { }

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

class SubshellChildType extends @subshell_child_type, AstNode { }

class Subshell extends @subshell, AstNode, UnderscorePrimary {
  override string describeQlClass() { result = "Subshell" }

  override Location getLocation() { subshell_def(this, result) }

  SubshellChildType getChild(int i) { subshell_child(this, i, result) }

  override AstNode getAFieldOrChild() { subshell_child(this, _, result) }
}

class SuperclassChildType extends @superclass_child_type, AstNode { }

class Superclass extends @superclass, AstNode, ClassChildType {
  override string describeQlClass() { result = "Superclass" }

  override Location getLocation() { superclass_def(this, _, result) }

  SuperclassChildType getChild() { superclass_def(this, result, _) }

  override AstNode getAFieldOrChild() { superclass_def(this, result, _) }
}

class SymbolChildType extends @symbol_child_type, AstNode { }

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

class ThenChildType extends @then_child_type, AstNode { }

class Then extends @then, AstNode {
  override string describeQlClass() { result = "Then" }

  override Location getLocation() { then_def(this, result) }

  ThenChildType getChild(int i) { then_child(this, i, result) }

  override AstNode getAFieldOrChild() { then_child(this, _, result) }
}

class UnaryOperandType extends @unary_operand_type, AstNode { }

class UnaryOperatorType extends @unary_operator_type, AstNode { }

class Unary extends @unary, AstNode, UnderscoreArg, UnderscorePrimary, UnderscoreStatement {
  override string describeQlClass() { result = "Unary" }

  override Location getLocation() { unary_def(this, _, _, result) }

  UnaryOperandType getOperand() { unary_def(this, result, _, _) }

  UnaryOperatorType getOperator() { unary_def(this, _, result, _) }

  override AstNode getAFieldOrChild() {
    unary_def(this, result, _, _) or unary_def(this, _, result, _)
  }
}

class Undef extends @undef, AstNode, UnderscoreStatement {
  override string describeQlClass() { result = "Undef" }

  override Location getLocation() { undef_def(this, result) }

  UnderscoreMethodName getChild(int i) { undef_child(this, i, result) }

  override AstNode getAFieldOrChild() { undef_child(this, _, result) }
}

class UnlessAlternativeType extends @unless_alternative_type, AstNode { }

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

class UnlessModifierConditionType extends @unless_modifier_condition_type, AstNode { }

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

class UntilModifierConditionType extends @until_modifier_condition_type, AstNode { }

class UntilModifier extends @until_modifier, AstNode, UnderscoreStatement {
  override string describeQlClass() { result = "UntilModifier" }

  override Location getLocation() { until_modifier_def(this, _, _, result) }

  UnderscoreStatement getBody() { until_modifier_def(this, result, _, _) }

  UntilModifierConditionType getCondition() { until_modifier_def(this, _, result, _) }

  override AstNode getAFieldOrChild() {
    until_modifier_def(this, result, _, _) or until_modifier_def(this, _, result, _)
  }
}

class WhenPatternType extends @when_pattern_type, AstNode { }

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

class WhileModifierConditionType extends @while_modifier_condition_type, AstNode { }

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
  OperatorAssignmentRightType, RescueModifierHandlerType, SuperclassChildType, UnaryOperandType,
  UnderscorePrimary, UnderscoreStatement, UnlessModifierConditionType, UntilModifierConditionType,
  WhileModifierConditionType {
  override string describeQlClass() { result = "Yield" }

  override Location getLocation() { yield_def(this, result) }

  ArgumentList getChild() { yield_child(this, result) }

  override AstNode getAFieldOrChild() { yield_child(this, result) }
}

class Character extends Token, @token_character {
  override string describeQlClass() { result = "Character" }
}

class ClassVariable extends Token, @token_class_variable {
  override string describeQlClass() { result = "ClassVariable" }
}

class Comment extends Token, @token_comment {
  override string describeQlClass() { result = "Comment" }
}

class Complex extends Token, @token_complex {
  override string describeQlClass() { result = "Complex" }
}

class Constant extends Token, @token_constant {
  override string describeQlClass() { result = "Constant" }
}

class EmptyStatement extends Token, @token_empty_statement {
  override string describeQlClass() { result = "EmptyStatement" }
}

class EscapeSequence extends Token, @token_escape_sequence {
  override string describeQlClass() { result = "EscapeSequence" }
}

class False extends Token, @token_false {
  override string describeQlClass() { result = "False" }
}

class Float extends Token, @token_float {
  override string describeQlClass() { result = "Float" }
}

class GlobalVariable extends Token, @token_global_variable {
  override string describeQlClass() { result = "GlobalVariable" }
}

class HeredocBeginning extends Token, @token_heredoc_beginning {
  override string describeQlClass() { result = "HeredocBeginning" }
}

class HeredocContent extends Token, @token_heredoc_content {
  override string describeQlClass() { result = "HeredocContent" }
}

class HeredocEnd extends Token, @token_heredoc_end {
  override string describeQlClass() { result = "HeredocEnd" }
}

class Identifier extends Token, @token_identifier {
  override string describeQlClass() { result = "Identifier" }
}

class InstanceVariable extends Token, @token_instance_variable {
  override string describeQlClass() { result = "InstanceVariable" }
}

class Integer extends Token, @token_integer {
  override string describeQlClass() { result = "Integer" }
}

class Nil extends Token, @token_nil {
  override string describeQlClass() { result = "Nil" }
}

class Operator extends Token, @token_operator {
  override string describeQlClass() { result = "Operator" }
}

class Self extends Token, @token_self {
  override string describeQlClass() { result = "Self" }
}

class StringContent extends Token, @token_string_content {
  override string describeQlClass() { result = "StringContent" }
}

class Super extends Token, @token_super {
  override string describeQlClass() { result = "Super" }
}

class True extends Token, @token_true {
  override string describeQlClass() { result = "True" }
}

class Uninterpreted extends Token, @token_uninterpreted {
  override string describeQlClass() { result = "Uninterpreted" }
}
