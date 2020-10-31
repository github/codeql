/*
 * CodeQL library for Ruby
 * Automatically generated from the tree-sitter grammar; do not edit
 */

import codeql.files.FileSystem
import codeql.Locations

class Top extends @top {
  string toString() { none() }

  Location getLocation() { none() }

  Top getAFieldOrChild() { none() }
}

class UnderscoreArg extends @underscore_arg, Top, ArgumentListChildType, ArrayChildType,
  AssignmentRightType, BinaryLeftType, BinaryRightType, ElementReferenceChildType,
  ExceptionsChildType, IfModifierConditionType, OperatorAssignmentRightType, PairKeyType,
  PatternChildType, RescueModifierHandlerType, RightAssignmentListChildType,
  SingletonMethodObjectType, SuperclassChildType, UnaryChildType, UnderscoreStatement,
  UnlessModifierConditionType, UntilModifierConditionType, WhileModifierConditionType { }

class UnderscoreLhs extends @underscore_lhs, Top, AssignmentLeftType,
  DestructuredLeftAssignmentChildType, ForPatternType, LeftAssignmentListChildType,
  UnderscorePrimary { }

class UnderscoreMethodName extends @underscore_method_name, Top { }

class UnderscorePrimary extends @underscore_primary, Top, CallReceiverType, UnderscoreArg { }

class UnderscoreStatement extends @underscore_statement, Top, BeginBlockChildType, BeginChildType,
  BlockChildType, ClassChildType, DoBlockChildType, DoChildType, ElseChildType, EndBlockChildType,
  EnsureChildType, MethodChildType, ModuleChildType, ParenthesizedStatementsChildType,
  ProgramChildType, SingletonClassChildType, SingletonMethodChildType, ThenChildType { }

class UnderscoreVariable extends @underscore_variable, Top, MethodCallMethodType,
  SingletonMethodObjectType, UnderscoreLhs { }

class Alias extends @alias, Top, UnderscoreStatement {
  override string toString() { result = "Alias" }

  override Location getLocation() { alias_def(this, _, _, result) }

  UnderscoreMethodName getAlias() { alias_def(this, result, _, _) }

  UnderscoreMethodName getName() { alias_def(this, _, result, _) }

  override Top getAFieldOrChild() { alias_def(this, result, _, _) or alias_def(this, _, result, _) }
}

class ArgumentListChildType extends @argument_list_child_type, Top { }

class ArgumentList extends @argument_list, Top, CallMethodType {
  override string toString() { result = "ArgumentList" }

  override Location getLocation() { argument_list_def(this, result) }

  ArgumentListChildType getChild(int i) { argument_list_child(this, i, result) }

  override Top getAFieldOrChild() { argument_list_child(this, _, result) }
}

class ArrayChildType extends @array_child_type, Top { }

class Array extends @array, Top, UnderscorePrimary {
  override string toString() { result = "Array" }

  override Location getLocation() { array_def(this, result) }

  ArrayChildType getChild(int i) { array_child(this, i, result) }

  override Top getAFieldOrChild() { array_child(this, _, result) }
}

class AssignmentLeftType extends @assignment_left_type, Top { }

class AssignmentRightType extends @assignment_right_type, Top { }

class Assignment extends @assignment, Top, UnderscoreArg, UnderscoreStatement {
  override string toString() { result = "Assignment" }

  override Location getLocation() { assignment_def(this, _, _, result) }

  AssignmentLeftType getLeft() { assignment_def(this, result, _, _) }

  AssignmentRightType getRight() { assignment_def(this, _, result, _) }

  override Top getAFieldOrChild() {
    assignment_def(this, result, _, _) or assignment_def(this, _, result, _)
  }
}

class BareStringChildType extends @bare_string_child_type, Top { }

class BareString extends @bare_string, Top {
  override string toString() { result = "BareString" }

  override Location getLocation() { bare_string_def(this, result) }

  BareStringChildType getChild(int i) { bare_string_child(this, i, result) }

  override Top getAFieldOrChild() { bare_string_child(this, _, result) }
}

class BareSymbolChildType extends @bare_symbol_child_type, Top { }

class BareSymbol extends @bare_symbol, Top {
  override string toString() { result = "BareSymbol" }

  override Location getLocation() { bare_symbol_def(this, result) }

  BareSymbolChildType getChild(int i) { bare_symbol_child(this, i, result) }

  override Top getAFieldOrChild() { bare_symbol_child(this, _, result) }
}

class BeginChildType extends @begin_child_type, Top { }

class Begin extends @begin, Top, UnderscorePrimary {
  override string toString() { result = "Begin" }

  override Location getLocation() { begin_def(this, result) }

  BeginChildType getChild(int i) { begin_child(this, i, result) }

  override Top getAFieldOrChild() { begin_child(this, _, result) }
}

class BeginBlockChildType extends @begin_block_child_type, Top { }

class BeginBlock extends @begin_block, Top, UnderscoreStatement {
  override string toString() { result = "BeginBlock" }

  override Location getLocation() { begin_block_def(this, result) }

  BeginBlockChildType getChild(int i) { begin_block_child(this, i, result) }

  override Top getAFieldOrChild() { begin_block_child(this, _, result) }
}

class BinaryLeftType extends @binary_left_type, Top { }

class BinaryOperatorType extends @binary_operator_type, Top { }

class BinaryRightType extends @binary_right_type, Top { }

class Binary extends @binary, Top, UnderscoreArg, UnderscoreStatement {
  override string toString() { result = "Binary" }

  override Location getLocation() { binary_def(this, _, _, _, result) }

  BinaryLeftType getLeft() { binary_def(this, result, _, _, _) }

  BinaryOperatorType getOperator() { binary_def(this, _, result, _, _) }

  BinaryRightType getRight() { binary_def(this, _, _, result, _) }

  override Top getAFieldOrChild() {
    binary_def(this, result, _, _, _) or
    binary_def(this, _, result, _, _) or
    binary_def(this, _, _, result, _)
  }
}

class BlockChildType extends @block_child_type, Top { }

class Block extends @block, Top, LambdaBodyType, MethodCallBlockType {
  override string toString() { result = "Block" }

  override Location getLocation() { block_def(this, result) }

  BlockChildType getChild(int i) { block_child(this, i, result) }

  override Top getAFieldOrChild() { block_child(this, _, result) }
}

class BlockArgument extends @block_argument, Top, ArgumentListChildType, ArrayChildType,
  ElementReferenceChildType {
  override string toString() { result = "BlockArgument" }

  override Location getLocation() { block_argument_def(this, _, result) }

  UnderscoreArg getChild() { block_argument_def(this, result, _) }

  override Top getAFieldOrChild() { block_argument_def(this, result, _) }
}

class BlockParameter extends @block_parameter, Top, BlockParametersChildType,
  DestructuredParameterChildType, LambdaParametersChildType, MethodParametersChildType {
  override string toString() { result = "BlockParameter" }

  override Location getLocation() { block_parameter_def(this, _, result) }

  Identifier getName() { block_parameter_def(this, result, _) }

  override Top getAFieldOrChild() { block_parameter_def(this, result, _) }
}

class BlockParametersChildType extends @block_parameters_child_type, Top { }

class BlockParameters extends @block_parameters, Top, BlockChildType, DoBlockChildType {
  override string toString() { result = "BlockParameters" }

  override Location getLocation() { block_parameters_def(this, result) }

  BlockParametersChildType getChild(int i) { block_parameters_child(this, i, result) }

  override Top getAFieldOrChild() { block_parameters_child(this, _, result) }
}

class Break extends @break, Top, ArgumentListChildType, ArrayChildType, AssignmentRightType,
  BinaryLeftType, BinaryRightType, ElementReferenceChildType, IfModifierConditionType,
  OperatorAssignmentRightType, RescueModifierHandlerType, SuperclassChildType, UnaryChildType,
  UnderscorePrimary, UnderscoreStatement, UnlessModifierConditionType, UntilModifierConditionType,
  WhileModifierConditionType {
  override string toString() { result = "Break" }

  override Location getLocation() { break_def(this, result) }

  ArgumentList getChild() { break_child(this, result) }

  override Top getAFieldOrChild() { break_child(this, result) }
}

class CallMethodType extends @call_method_type, Top { }

class CallReceiverType extends @call_receiver_type, Top { }

class Call extends @call, Top, ArgumentListChildType, ArrayChildType, AssignmentRightType,
  BinaryLeftType, BinaryRightType, ElementReferenceChildType, IfModifierConditionType,
  MethodCallMethodType, OperatorAssignmentRightType, RescueModifierHandlerType, SuperclassChildType,
  UnaryChildType, UnderscoreLhs, UnderscoreStatement, UnlessModifierConditionType,
  UntilModifierConditionType, WhileModifierConditionType {
  override string toString() { result = "Call" }

  override Location getLocation() { call_def(this, _, _, result) }

  CallMethodType getMethod() { call_def(this, result, _, _) }

  CallReceiverType getReceiver() { call_def(this, _, result, _) }

  override Top getAFieldOrChild() { call_def(this, result, _, _) or call_def(this, _, result, _) }
}

class CaseChildType extends @case_child_type, Top { }

class Case extends @case__, Top, UnderscorePrimary {
  override string toString() { result = "Case" }

  override Location getLocation() { case_def(this, result) }

  UnderscoreStatement getValue() { case_value(this, result) }

  CaseChildType getChild(int i) { case_child(this, i, result) }

  override Top getAFieldOrChild() { case_value(this, result) or case_child(this, _, result) }
}

class ChainedString extends @chained_string, Top, UnderscorePrimary {
  override string toString() { result = "ChainedString" }

  override Location getLocation() { chained_string_def(this, result) }

  String getChild(int i) { chained_string_child(this, i, result) }

  override Top getAFieldOrChild() { chained_string_child(this, _, result) }
}

class ClassNameType extends @class_name_type, Top { }

class ClassChildType extends @class_child_type, Top { }

class Class extends @class, Top, UnderscorePrimary {
  override string toString() { result = "Class" }

  override Location getLocation() { class_def(this, _, result) }

  ClassNameType getName() { class_def(this, result, _) }

  ClassChildType getChild(int i) { class_child(this, i, result) }

  override Top getAFieldOrChild() { class_def(this, result, _) or class_child(this, _, result) }
}

class Conditional extends @conditional, Top, UnderscoreArg {
  override string toString() { result = "Conditional" }

  override Location getLocation() { conditional_def(this, _, _, _, result) }

  UnderscoreArg getAlternative() { conditional_def(this, result, _, _, _) }

  UnderscoreArg getCondition() { conditional_def(this, _, result, _, _) }

  UnderscoreArg getConsequence() { conditional_def(this, _, _, result, _) }

  override Top getAFieldOrChild() {
    conditional_def(this, result, _, _, _) or
    conditional_def(this, _, result, _, _) or
    conditional_def(this, _, _, result, _)
  }
}

class DestructuredLeftAssignmentChildType extends @destructured_left_assignment_child_type, Top { }

class DestructuredLeftAssignment extends @destructured_left_assignment, Top,
  DestructuredLeftAssignmentChildType, ForPatternType, LeftAssignmentListChildType {
  override string toString() { result = "DestructuredLeftAssignment" }

  override Location getLocation() { destructured_left_assignment_def(this, result) }

  DestructuredLeftAssignmentChildType getChild(int i) {
    destructured_left_assignment_child(this, i, result)
  }

  override Top getAFieldOrChild() { destructured_left_assignment_child(this, _, result) }
}

class DestructuredParameterChildType extends @destructured_parameter_child_type, Top { }

class DestructuredParameter extends @destructured_parameter, Top, BlockParametersChildType,
  DestructuredParameterChildType, LambdaParametersChildType, MethodParametersChildType {
  override string toString() { result = "DestructuredParameter" }

  override Location getLocation() { destructured_parameter_def(this, result) }

  DestructuredParameterChildType getChild(int i) { destructured_parameter_child(this, i, result) }

  override Top getAFieldOrChild() { destructured_parameter_child(this, _, result) }
}

class DoChildType extends @do_child_type, Top { }

class Do extends @do, Top {
  override string toString() { result = "Do" }

  override Location getLocation() { do_def(this, result) }

  DoChildType getChild(int i) { do_child(this, i, result) }

  override Top getAFieldOrChild() { do_child(this, _, result) }
}

class DoBlockChildType extends @do_block_child_type, Top { }

class DoBlock extends @do_block, Top, LambdaBodyType, MethodCallBlockType {
  override string toString() { result = "DoBlock" }

  override Location getLocation() { do_block_def(this, result) }

  DoBlockChildType getChild(int i) { do_block_child(this, i, result) }

  override Top getAFieldOrChild() { do_block_child(this, _, result) }
}

class ElementReferenceChildType extends @element_reference_child_type, Top { }

class ElementReference extends @element_reference, Top, UnderscoreLhs {
  override string toString() { result = "ElementReference" }

  override Location getLocation() { element_reference_def(this, _, result) }

  UnderscorePrimary getObject() { element_reference_def(this, result, _) }

  ElementReferenceChildType getChild(int i) { element_reference_child(this, i, result) }

  override Top getAFieldOrChild() {
    element_reference_def(this, result, _) or element_reference_child(this, _, result)
  }
}

class ElseChildType extends @else_child_type, Top { }

class Else extends @else, Top, BeginChildType, CaseChildType, ClassChildType, DoBlockChildType,
  ElsifAlternativeType, IfAlternativeType, MethodChildType, ModuleChildType,
  SingletonClassChildType, SingletonMethodChildType, UnlessAlternativeType {
  override string toString() { result = "Else" }

  override Location getLocation() { else_def(this, result) }

  SemicolonUnnamed getCondition() { else_condition(this, result) }

  ElseChildType getChild(int i) { else_child(this, i, result) }

  override Top getAFieldOrChild() { else_condition(this, result) or else_child(this, _, result) }
}

class ElsifAlternativeType extends @elsif_alternative_type, Top { }

class Elsif extends @elsif, Top, ElsifAlternativeType, IfAlternativeType, UnlessAlternativeType {
  override string toString() { result = "Elsif" }

  override Location getLocation() { elsif_def(this, _, result) }

  ElsifAlternativeType getAlternative() { elsif_alternative(this, result) }

  UnderscoreStatement getCondition() { elsif_def(this, result, _) }

  Then getConsequence() { elsif_consequence(this, result) }

  override Top getAFieldOrChild() {
    elsif_alternative(this, result) or elsif_def(this, result, _) or elsif_consequence(this, result)
  }
}

class EmptyStatement extends @empty_statement, Top, BeginBlockChildType, BeginChildType,
  BlockChildType, ClassChildType, DoBlockChildType, DoChildType, ElseChildType, EndBlockChildType,
  EnsureChildType, MethodChildType, ModuleChildType, ParenthesizedStatementsChildType,
  ProgramChildType, SingletonClassChildType, SingletonMethodChildType, ThenChildType {
  override string toString() { result = "EmptyStatement" }

  override Location getLocation() { empty_statement_def(this, _, result) }

  string getText() { empty_statement_def(this, result, _) }
}

class EndBlockChildType extends @end_block_child_type, Top { }

class EndBlock extends @end_block, Top, UnderscoreStatement {
  override string toString() { result = "EndBlock" }

  override Location getLocation() { end_block_def(this, result) }

  EndBlockChildType getChild(int i) { end_block_child(this, i, result) }

  override Top getAFieldOrChild() { end_block_child(this, _, result) }
}

class EnsureChildType extends @ensure_child_type, Top { }

class Ensure extends @ensure, Top, BeginChildType, ClassChildType, DoBlockChildType,
  MethodChildType, ModuleChildType, SingletonClassChildType, SingletonMethodChildType {
  override string toString() { result = "Ensure" }

  override Location getLocation() { ensure_def(this, result) }

  EnsureChildType getChild(int i) { ensure_child(this, i, result) }

  override Top getAFieldOrChild() { ensure_child(this, _, result) }
}

class ExceptionVariable extends @exception_variable, Top {
  override string toString() { result = "ExceptionVariable" }

  override Location getLocation() { exception_variable_def(this, _, result) }

  UnderscoreLhs getChild() { exception_variable_def(this, result, _) }

  override Top getAFieldOrChild() { exception_variable_def(this, result, _) }
}

class ExceptionsChildType extends @exceptions_child_type, Top { }

class Exceptions extends @exceptions, Top {
  override string toString() { result = "Exceptions" }

  override Location getLocation() { exceptions_def(this, result) }

  ExceptionsChildType getChild(int i) { exceptions_child(this, i, result) }

  override Top getAFieldOrChild() { exceptions_child(this, _, result) }
}

class ForPatternType extends @for_pattern_type, Top { }

class For extends @for, Top, UnderscorePrimary {
  override string toString() { result = "For" }

  override Location getLocation() { for_def(this, _, _, result) }

  Do getBody() { for_def(this, result, _, _) }

  ForPatternType getPattern(int i) { for_pattern(this, i, result) }

  In getValue() { for_def(this, _, result, _) }

  override Top getAFieldOrChild() {
    for_def(this, result, _, _) or for_pattern(this, _, result) or for_def(this, _, result, _)
  }
}

class HashChildType extends @hash_child_type, Top { }

class Hash extends @hash, Top, UnderscorePrimary {
  override string toString() { result = "Hash" }

  override Location getLocation() { hash_def(this, result) }

  HashChildType getChild(int i) { hash_child(this, i, result) }

  override Top getAFieldOrChild() { hash_child(this, _, result) }
}

class HashSplatArgument extends @hash_splat_argument, Top, ArgumentListChildType, ArrayChildType,
  ElementReferenceChildType, HashChildType {
  override string toString() { result = "HashSplatArgument" }

  override Location getLocation() { hash_splat_argument_def(this, _, result) }

  UnderscoreArg getChild() { hash_splat_argument_def(this, result, _) }

  override Top getAFieldOrChild() { hash_splat_argument_def(this, result, _) }
}

class HashSplatParameter extends @hash_splat_parameter, Top, BlockParametersChildType,
  DestructuredParameterChildType, LambdaParametersChildType, MethodParametersChildType {
  override string toString() { result = "HashSplatParameter" }

  override Location getLocation() { hash_splat_parameter_def(this, result) }

  Identifier getName() { hash_splat_parameter_name(this, result) }

  override Top getAFieldOrChild() { hash_splat_parameter_name(this, result) }
}

class IfAlternativeType extends @if_alternative_type, Top { }

class If extends @if, Top, UnderscorePrimary {
  override string toString() { result = "If" }

  override Location getLocation() { if_def(this, _, result) }

  IfAlternativeType getAlternative() { if_alternative(this, result) }

  UnderscoreStatement getCondition() { if_def(this, result, _) }

  Then getConsequence() { if_consequence(this, result) }

  override Top getAFieldOrChild() {
    if_alternative(this, result) or if_def(this, result, _) or if_consequence(this, result)
  }
}

class IfModifierConditionType extends @if_modifier_condition_type, Top { }

class IfModifier extends @if_modifier, Top, UnderscoreStatement {
  override string toString() { result = "IfModifier" }

  override Location getLocation() { if_modifier_def(this, _, _, result) }

  UnderscoreStatement getBody() { if_modifier_def(this, result, _, _) }

  IfModifierConditionType getCondition() { if_modifier_def(this, _, result, _) }

  override Top getAFieldOrChild() {
    if_modifier_def(this, result, _, _) or if_modifier_def(this, _, result, _)
  }
}

class In extends @in, Top {
  override string toString() { result = "In" }

  override Location getLocation() { in_def(this, _, result) }

  UnderscoreArg getChild() { in_def(this, result, _) }

  override Top getAFieldOrChild() { in_def(this, result, _) }
}

class Interpolation extends @interpolation, Top, BareStringChildType, BareSymbolChildType,
  RegexChildType, StringChildType, SubshellChildType, SymbolChildType {
  override string toString() { result = "Interpolation" }

  override Location getLocation() { interpolation_def(this, _, result) }

  UnderscoreStatement getChild() { interpolation_def(this, result, _) }

  override Top getAFieldOrChild() { interpolation_def(this, result, _) }
}

class KeywordParameter extends @keyword_parameter, Top, BlockParametersChildType,
  DestructuredParameterChildType, LambdaParametersChildType, MethodParametersChildType {
  override string toString() { result = "KeywordParameter" }

  override Location getLocation() { keyword_parameter_def(this, _, result) }

  Identifier getName() { keyword_parameter_def(this, result, _) }

  UnderscoreArg getValue() { keyword_parameter_value(this, result) }

  override Top getAFieldOrChild() {
    keyword_parameter_def(this, result, _) or keyword_parameter_value(this, result)
  }
}

class LambdaBodyType extends @lambda_body_type, Top { }

class Lambda extends @lambda, Top, UnderscorePrimary {
  override string toString() { result = "Lambda" }

  override Location getLocation() { lambda_def(this, _, result) }

  LambdaBodyType getBody() { lambda_def(this, result, _) }

  LambdaParameters getParameters() { lambda_parameters(this, result) }

  override Top getAFieldOrChild() { lambda_def(this, result, _) or lambda_parameters(this, result) }
}

class LambdaParametersChildType extends @lambda_parameters_child_type, Top { }

class LambdaParameters extends @lambda_parameters, Top {
  override string toString() { result = "LambdaParameters" }

  override Location getLocation() { lambda_parameters_def(this, result) }

  LambdaParametersChildType getChild(int i) { lambda_parameters_child(this, i, result) }

  override Top getAFieldOrChild() { lambda_parameters_child(this, _, result) }
}

class LeftAssignmentListChildType extends @left_assignment_list_child_type, Top { }

class LeftAssignmentList extends @left_assignment_list, Top, AssignmentLeftType {
  override string toString() { result = "LeftAssignmentList" }

  override Location getLocation() { left_assignment_list_def(this, result) }

  LeftAssignmentListChildType getChild(int i) { left_assignment_list_child(this, i, result) }

  override Top getAFieldOrChild() { left_assignment_list_child(this, _, result) }
}

class MethodChildType extends @method_child_type, Top { }

class Method extends @method, Top, UnderscorePrimary {
  override string toString() { result = "Method" }

  override Location getLocation() { method_def(this, _, result) }

  UnderscoreMethodName getName() { method_def(this, result, _) }

  MethodParameters getParameters() { method_parameters(this, result) }

  MethodChildType getChild(int i) { method_child(this, i, result) }

  override Top getAFieldOrChild() {
    method_def(this, result, _) or method_parameters(this, result) or method_child(this, _, result)
  }
}

class MethodCallBlockType extends @method_call_block_type, Top { }

class MethodCallMethodType extends @method_call_method_type, Top { }

class MethodCall extends @method_call, Top, ArgumentListChildType, ArrayChildType,
  AssignmentRightType, BinaryLeftType, BinaryRightType, CallReceiverType, ElementReferenceChildType,
  IfModifierConditionType, OperatorAssignmentRightType, RescueModifierHandlerType,
  SuperclassChildType, UnaryChildType, UnderscoreLhs, UnderscoreStatement,
  UnlessModifierConditionType, UntilModifierConditionType, WhileModifierConditionType {
  override string toString() { result = "MethodCall" }

  override Location getLocation() { method_call_def(this, _, result) }

  ArgumentList getArguments() { method_call_arguments(this, result) }

  MethodCallBlockType getBlock() { method_call_block(this, result) }

  MethodCallMethodType getMethod() { method_call_def(this, result, _) }

  override Top getAFieldOrChild() {
    method_call_arguments(this, result) or
    method_call_block(this, result) or
    method_call_def(this, result, _)
  }
}

class MethodParametersChildType extends @method_parameters_child_type, Top { }

class MethodParameters extends @method_parameters, Top {
  override string toString() { result = "MethodParameters" }

  override Location getLocation() { method_parameters_def(this, result) }

  MethodParametersChildType getChild(int i) { method_parameters_child(this, i, result) }

  override Top getAFieldOrChild() { method_parameters_child(this, _, result) }
}

class ModuleNameType extends @module_name_type, Top { }

class ModuleChildType extends @module_child_type, Top { }

class Module extends @module, Top, UnderscorePrimary {
  override string toString() { result = "Module" }

  override Location getLocation() { module_def(this, _, result) }

  ModuleNameType getName() { module_def(this, result, _) }

  ModuleChildType getChild(int i) { module_child(this, i, result) }

  override Top getAFieldOrChild() { module_def(this, result, _) or module_child(this, _, result) }
}

class Next extends @next, Top, ArgumentListChildType, ArrayChildType, AssignmentRightType,
  BinaryLeftType, BinaryRightType, ElementReferenceChildType, IfModifierConditionType,
  OperatorAssignmentRightType, RescueModifierHandlerType, SuperclassChildType, UnaryChildType,
  UnderscorePrimary, UnderscoreStatement, UnlessModifierConditionType, UntilModifierConditionType,
  WhileModifierConditionType {
  override string toString() { result = "Next" }

  override Location getLocation() { next_def(this, result) }

  ArgumentList getChild() { next_child(this, result) }

  override Top getAFieldOrChild() { next_child(this, result) }
}

class Operator extends @operator, Top, CallMethodType, UnderscoreMethodName {
  override string toString() { result = "Operator" }

  override Location getLocation() { operator_def(this, _, result) }

  string getText() { operator_def(this, result, _) }
}

class OperatorAssignmentRightType extends @operator_assignment_right_type, Top { }

class OperatorAssignment extends @operator_assignment, Top, UnderscoreArg, UnderscoreStatement {
  override string toString() { result = "OperatorAssignment" }

  override Location getLocation() { operator_assignment_def(this, _, _, result) }

  UnderscoreLhs getLeft() { operator_assignment_def(this, result, _, _) }

  OperatorAssignmentRightType getRight() { operator_assignment_def(this, _, result, _) }

  override Top getAFieldOrChild() {
    operator_assignment_def(this, result, _, _) or operator_assignment_def(this, _, result, _)
  }
}

class OptionalParameter extends @optional_parameter, Top, BlockParametersChildType,
  DestructuredParameterChildType, LambdaParametersChildType, MethodParametersChildType {
  override string toString() { result = "OptionalParameter" }

  override Location getLocation() { optional_parameter_def(this, _, _, result) }

  Identifier getName() { optional_parameter_def(this, result, _, _) }

  UnderscoreArg getValue() { optional_parameter_def(this, _, result, _) }

  override Top getAFieldOrChild() {
    optional_parameter_def(this, result, _, _) or optional_parameter_def(this, _, result, _)
  }
}

class PairKeyType extends @pair_key_type, Top { }

class Pair extends @pair, Top, ArgumentListChildType, ArrayChildType, ElementReferenceChildType,
  HashChildType {
  override string toString() { result = "Pair" }

  override Location getLocation() { pair_def(this, _, _, result) }

  PairKeyType getKey() { pair_def(this, result, _, _) }

  UnderscoreArg getValue() { pair_def(this, _, result, _) }

  override Top getAFieldOrChild() { pair_def(this, result, _, _) or pair_def(this, _, result, _) }
}

class ParenthesizedStatementsChildType extends @parenthesized_statements_child_type, Top { }

class ParenthesizedStatements extends @parenthesized_statements, Top, UnaryChildType,
  UnderscorePrimary {
  override string toString() { result = "ParenthesizedStatements" }

  override Location getLocation() { parenthesized_statements_def(this, result) }

  ParenthesizedStatementsChildType getChild(int i) {
    parenthesized_statements_child(this, i, result)
  }

  override Top getAFieldOrChild() { parenthesized_statements_child(this, _, result) }
}

class PatternChildType extends @pattern_child_type, Top { }

class Pattern extends @pattern, Top, WhenPatternType {
  override string toString() { result = "Pattern" }

  override Location getLocation() { pattern_def(this, _, result) }

  PatternChildType getChild() { pattern_def(this, result, _) }

  override Top getAFieldOrChild() { pattern_def(this, result, _) }
}

class ProgramChildType extends @program_child_type, Top { }

class Program extends @program, Top {
  override string toString() { result = "Program" }

  override Location getLocation() { program_def(this, result) }

  ProgramChildType getChild(int i) { program_child(this, i, result) }

  override Top getAFieldOrChild() { program_child(this, _, result) }
}

class Range extends @range, Top, UnderscoreArg {
  override string toString() { result = "Range" }

  override Location getLocation() { range_def(this, result) }

  UnderscoreArg getChild(int i) { range_child(this, i, result) }

  override Top getAFieldOrChild() { range_child(this, _, result) }
}

class Rational extends @rational, Top, UnderscorePrimary {
  override string toString() { result = "Rational" }

  override Location getLocation() { rational_def(this, _, result) }

  Integer getChild() { rational_def(this, result, _) }

  override Top getAFieldOrChild() { rational_def(this, result, _) }
}

class Redo extends @redo, Top, UnderscorePrimary {
  override string toString() { result = "Redo" }

  override Location getLocation() { redo_def(this, result) }

  ArgumentList getChild() { redo_child(this, result) }

  override Top getAFieldOrChild() { redo_child(this, result) }
}

class RegexChildType extends @regex_child_type, Top { }

class Regex extends @regex, Top, UnderscorePrimary {
  override string toString() { result = "Regex" }

  override Location getLocation() { regex_def(this, result) }

  RegexChildType getChild(int i) { regex_child(this, i, result) }

  override Top getAFieldOrChild() { regex_child(this, _, result) }
}

class Rescue extends @rescue, Top, BeginChildType, ClassChildType, DoBlockChildType,
  MethodChildType, ModuleChildType, SingletonClassChildType, SingletonMethodChildType {
  override string toString() { result = "Rescue" }

  override Location getLocation() { rescue_def(this, result) }

  Then getBody() { rescue_body(this, result) }

  Exceptions getExceptions() { rescue_exceptions(this, result) }

  ExceptionVariable getVariable() { rescue_variable(this, result) }

  override Top getAFieldOrChild() {
    rescue_body(this, result) or rescue_exceptions(this, result) or rescue_variable(this, result)
  }
}

class RescueModifierHandlerType extends @rescue_modifier_handler_type, Top { }

class RescueModifier extends @rescue_modifier, Top, UnderscoreStatement {
  override string toString() { result = "RescueModifier" }

  override Location getLocation() { rescue_modifier_def(this, _, _, result) }

  UnderscoreStatement getBody() { rescue_modifier_def(this, result, _, _) }

  RescueModifierHandlerType getHandler() { rescue_modifier_def(this, _, result, _) }

  override Top getAFieldOrChild() {
    rescue_modifier_def(this, result, _, _) or rescue_modifier_def(this, _, result, _)
  }
}

class RestAssignment extends @rest_assignment, Top, DestructuredLeftAssignmentChildType,
  ForPatternType, LeftAssignmentListChildType {
  override string toString() { result = "RestAssignment" }

  override Location getLocation() { rest_assignment_def(this, result) }

  UnderscoreLhs getChild() { rest_assignment_child(this, result) }

  override Top getAFieldOrChild() { rest_assignment_child(this, result) }
}

class Retry extends @retry, Top, UnderscorePrimary {
  override string toString() { result = "Retry" }

  override Location getLocation() { retry_def(this, result) }

  ArgumentList getChild() { retry_child(this, result) }

  override Top getAFieldOrChild() { retry_child(this, result) }
}

class Return extends @return, Top, ArgumentListChildType, ArrayChildType, AssignmentRightType,
  BinaryLeftType, BinaryRightType, ElementReferenceChildType, IfModifierConditionType,
  OperatorAssignmentRightType, RescueModifierHandlerType, SuperclassChildType, UnaryChildType,
  UnderscorePrimary, UnderscoreStatement, UnlessModifierConditionType, UntilModifierConditionType,
  WhileModifierConditionType {
  override string toString() { result = "Return" }

  override Location getLocation() { return_def(this, result) }

  ArgumentList getChild() { return_child(this, result) }

  override Top getAFieldOrChild() { return_child(this, result) }
}

class RightAssignmentListChildType extends @right_assignment_list_child_type, Top { }

class RightAssignmentList extends @right_assignment_list, Top, AssignmentRightType {
  override string toString() { result = "RightAssignmentList" }

  override Location getLocation() { right_assignment_list_def(this, result) }

  RightAssignmentListChildType getChild(int i) { right_assignment_list_child(this, i, result) }

  override Top getAFieldOrChild() { right_assignment_list_child(this, _, result) }
}

class ScopeResolutionNameType extends @scope_resolution_name_type, Top { }

class ScopeResolution extends @scope_resolution, Top, ClassNameType, MethodCallMethodType,
  ModuleNameType, UnderscoreLhs {
  override string toString() { result = "ScopeResolution" }

  override Location getLocation() { scope_resolution_def(this, _, result) }

  ScopeResolutionNameType getName() { scope_resolution_def(this, result, _) }

  UnderscorePrimary getScope() { scope_resolution_scope(this, result) }

  override Top getAFieldOrChild() {
    scope_resolution_def(this, result, _) or scope_resolution_scope(this, result)
  }
}

class Setter extends @setter, Top, UnderscoreMethodName {
  override string toString() { result = "Setter" }

  override Location getLocation() { setter_def(this, _, result) }

  Identifier getChild() { setter_def(this, result, _) }

  override Top getAFieldOrChild() { setter_def(this, result, _) }
}

class SingletonClassChildType extends @singleton_class_child_type, Top { }

class SingletonClass extends @singleton_class, Top, UnderscorePrimary {
  override string toString() { result = "SingletonClass" }

  override Location getLocation() { singleton_class_def(this, _, result) }

  UnderscoreArg getValue() { singleton_class_def(this, result, _) }

  SingletonClassChildType getChild(int i) { singleton_class_child(this, i, result) }

  override Top getAFieldOrChild() {
    singleton_class_def(this, result, _) or singleton_class_child(this, _, result)
  }
}

class SingletonMethodObjectType extends @singleton_method_object_type, Top { }

class SingletonMethodChildType extends @singleton_method_child_type, Top { }

class SingletonMethod extends @singleton_method, Top, UnderscorePrimary {
  override string toString() { result = "SingletonMethod" }

  override Location getLocation() { singleton_method_def(this, _, _, result) }

  UnderscoreMethodName getName() { singleton_method_def(this, result, _, _) }

  SingletonMethodObjectType getObject() { singleton_method_def(this, _, result, _) }

  MethodParameters getParameters() { singleton_method_parameters(this, result) }

  SingletonMethodChildType getChild(int i) { singleton_method_child(this, i, result) }

  override Top getAFieldOrChild() {
    singleton_method_def(this, result, _, _) or
    singleton_method_def(this, _, result, _) or
    singleton_method_parameters(this, result) or
    singleton_method_child(this, _, result)
  }
}

class SplatArgument extends @splat_argument, Top, ArgumentListChildType, ArrayChildType,
  AssignmentRightType, ElementReferenceChildType, ExceptionsChildType, PatternChildType,
  RightAssignmentListChildType {
  override string toString() { result = "SplatArgument" }

  override Location getLocation() { splat_argument_def(this, _, result) }

  UnderscoreArg getChild() { splat_argument_def(this, result, _) }

  override Top getAFieldOrChild() { splat_argument_def(this, result, _) }
}

class SplatParameter extends @splat_parameter, Top, BlockParametersChildType,
  DestructuredParameterChildType, LambdaParametersChildType, MethodParametersChildType {
  override string toString() { result = "SplatParameter" }

  override Location getLocation() { splat_parameter_def(this, result) }

  Identifier getName() { splat_parameter_name(this, result) }

  override Top getAFieldOrChild() { splat_parameter_name(this, result) }
}

class StringChildType extends @string_child_type, Top { }

class String extends @string__, Top, PairKeyType, UnderscorePrimary {
  override string toString() { result = "String" }

  override Location getLocation() { string_def(this, result) }

  StringChildType getChild(int i) { string_child(this, i, result) }

  override Top getAFieldOrChild() { string_child(this, _, result) }
}

class StringArray extends @string_array, Top, UnderscorePrimary {
  override string toString() { result = "StringArray" }

  override Location getLocation() { string_array_def(this, result) }

  BareString getChild(int i) { string_array_child(this, i, result) }

  override Top getAFieldOrChild() { string_array_child(this, _, result) }
}

class SubshellChildType extends @subshell_child_type, Top { }

class Subshell extends @subshell, Top, UnderscorePrimary {
  override string toString() { result = "Subshell" }

  override Location getLocation() { subshell_def(this, result) }

  SubshellChildType getChild(int i) { subshell_child(this, i, result) }

  override Top getAFieldOrChild() { subshell_child(this, _, result) }
}

class SuperclassChildType extends @superclass_child_type, Top { }

class Superclass extends @superclass, Top, ClassChildType {
  override string toString() { result = "Superclass" }

  override Location getLocation() { superclass_def(this, _, result) }

  SuperclassChildType getChild() { superclass_def(this, result, _) }

  override Top getAFieldOrChild() { superclass_def(this, result, _) }
}

class SymbolChildType extends @symbol_child_type, Top { }

class Symbol extends @symbol, Top, PairKeyType, UnderscoreMethodName, UnderscorePrimary {
  override string toString() { result = "Symbol" }

  override Location getLocation() { symbol_def(this, result) }

  SymbolChildType getChild(int i) { symbol_child(this, i, result) }

  override Top getAFieldOrChild() { symbol_child(this, _, result) }
}

class SymbolArray extends @symbol_array, Top, UnderscorePrimary {
  override string toString() { result = "SymbolArray" }

  override Location getLocation() { symbol_array_def(this, result) }

  BareSymbol getChild(int i) { symbol_array_child(this, i, result) }

  override Top getAFieldOrChild() { symbol_array_child(this, _, result) }
}

class ThenChildType extends @then_child_type, Top { }

class Then extends @then, Top {
  override string toString() { result = "Then" }

  override Location getLocation() { then_def(this, result) }

  ThenChildType getChild(int i) { then_child(this, i, result) }

  override Top getAFieldOrChild() { then_child(this, _, result) }
}

class UnaryChildType extends @unary_child_type, Top { }

class Unary extends @unary, Top, UnderscoreArg, UnderscorePrimary, UnderscoreStatement {
  override string toString() { result = "Unary" }

  override Location getLocation() { unary_def(this, _, result) }

  UnaryChildType getChild() { unary_def(this, result, _) }

  override Top getAFieldOrChild() { unary_def(this, result, _) }
}

class Undef extends @undef, Top, UnderscoreStatement {
  override string toString() { result = "Undef" }

  override Location getLocation() { undef_def(this, result) }

  UnderscoreMethodName getChild(int i) { undef_child(this, i, result) }

  override Top getAFieldOrChild() { undef_child(this, _, result) }
}

class UnlessAlternativeType extends @unless_alternative_type, Top { }

class Unless extends @unless, Top, UnderscorePrimary {
  override string toString() { result = "Unless" }

  override Location getLocation() { unless_def(this, _, result) }

  UnlessAlternativeType getAlternative() { unless_alternative(this, result) }

  UnderscoreStatement getCondition() { unless_def(this, result, _) }

  Then getConsequence() { unless_consequence(this, result) }

  override Top getAFieldOrChild() {
    unless_alternative(this, result) or
    unless_def(this, result, _) or
    unless_consequence(this, result)
  }
}

class UnlessModifierConditionType extends @unless_modifier_condition_type, Top { }

class UnlessModifier extends @unless_modifier, Top, UnderscoreStatement {
  override string toString() { result = "UnlessModifier" }

  override Location getLocation() { unless_modifier_def(this, _, _, result) }

  UnderscoreStatement getBody() { unless_modifier_def(this, result, _, _) }

  UnlessModifierConditionType getCondition() { unless_modifier_def(this, _, result, _) }

  override Top getAFieldOrChild() {
    unless_modifier_def(this, result, _, _) or unless_modifier_def(this, _, result, _)
  }
}

class Until extends @until, Top, UnderscorePrimary {
  override string toString() { result = "Until" }

  override Location getLocation() { until_def(this, _, _, result) }

  Do getBody() { until_def(this, result, _, _) }

  UnderscoreStatement getCondition() { until_def(this, _, result, _) }

  override Top getAFieldOrChild() { until_def(this, result, _, _) or until_def(this, _, result, _) }
}

class UntilModifierConditionType extends @until_modifier_condition_type, Top { }

class UntilModifier extends @until_modifier, Top, UnderscoreStatement {
  override string toString() { result = "UntilModifier" }

  override Location getLocation() { until_modifier_def(this, _, _, result) }

  UnderscoreStatement getBody() { until_modifier_def(this, result, _, _) }

  UntilModifierConditionType getCondition() { until_modifier_def(this, _, result, _) }

  override Top getAFieldOrChild() {
    until_modifier_def(this, result, _, _) or until_modifier_def(this, _, result, _)
  }
}

class WhenPatternType extends @when_pattern_type, Top { }

class When extends @when, Top, CaseChildType {
  override string toString() { result = "When" }

  override Location getLocation() { when_def(this, result) }

  Then getBody() { when_body(this, result) }

  WhenPatternType getPattern(int i) { when_pattern(this, i, result) }

  override Top getAFieldOrChild() { when_body(this, result) or when_pattern(this, _, result) }
}

class While extends @while, Top, UnderscorePrimary {
  override string toString() { result = "While" }

  override Location getLocation() { while_def(this, _, _, result) }

  Do getBody() { while_def(this, result, _, _) }

  UnderscoreStatement getCondition() { while_def(this, _, result, _) }

  override Top getAFieldOrChild() { while_def(this, result, _, _) or while_def(this, _, result, _) }
}

class WhileModifierConditionType extends @while_modifier_condition_type, Top { }

class WhileModifier extends @while_modifier, Top, UnderscoreStatement {
  override string toString() { result = "WhileModifier" }

  override Location getLocation() { while_modifier_def(this, _, _, result) }

  UnderscoreStatement getBody() { while_modifier_def(this, result, _, _) }

  WhileModifierConditionType getCondition() { while_modifier_def(this, _, result, _) }

  override Top getAFieldOrChild() {
    while_modifier_def(this, result, _, _) or while_modifier_def(this, _, result, _)
  }
}

class Yield extends @yield, Top, ArgumentListChildType, ArrayChildType, AssignmentRightType,
  BinaryLeftType, BinaryRightType, ElementReferenceChildType, IfModifierConditionType,
  OperatorAssignmentRightType, RescueModifierHandlerType, SuperclassChildType, UnaryChildType,
  UnderscorePrimary, UnderscoreStatement, UnlessModifierConditionType, UntilModifierConditionType,
  WhileModifierConditionType {
  override string toString() { result = "Yield" }

  override Location getLocation() { yield_def(this, result) }

  ArgumentList getChild() { yield_child(this, result) }

  override Top getAFieldOrChild() { yield_child(this, result) }
}

class BangUnnamed extends @bang_unnamed, Top {
  override string toString() { result = "BangUnnamed" }

  override Location getLocation() { bang_unnamed_def(this, _, result) }

  string getText() { bang_unnamed_def(this, result, _) }
}

class BangequalUnnamed extends @bangequal_unnamed, Top, BinaryOperatorType {
  override string toString() { result = "BangequalUnnamed" }

  override Location getLocation() { bangequal_unnamed_def(this, _, result) }

  string getText() { bangequal_unnamed_def(this, result, _) }
}

class BangtildeUnnamed extends @bangtilde_unnamed, Top, BinaryOperatorType {
  override string toString() { result = "BangtildeUnnamed" }

  override Location getLocation() { bangtilde_unnamed_def(this, _, result) }

  string getText() { bangtilde_unnamed_def(this, result, _) }
}

class DquoteUnnamed extends @dquote_unnamed, Top {
  override string toString() { result = "DquoteUnnamed" }

  override Location getLocation() { dquote_unnamed_def(this, _, result) }

  string getText() { dquote_unnamed_def(this, result, _) }
}

class HashlbraceUnnamed extends @hashlbrace_unnamed, Top {
  override string toString() { result = "HashlbraceUnnamed" }

  override Location getLocation() { hashlbrace_unnamed_def(this, _, result) }

  string getText() { hashlbrace_unnamed_def(this, result, _) }
}

class PercentUnnamed extends @percent_unnamed, Top, BinaryOperatorType {
  override string toString() { result = "PercentUnnamed" }

  override Location getLocation() { percent_unnamed_def(this, _, result) }

  string getText() { percent_unnamed_def(this, result, _) }
}

class PercentequalUnnamed extends @percentequal_unnamed, Top {
  override string toString() { result = "PercentequalUnnamed" }

  override Location getLocation() { percentequal_unnamed_def(this, _, result) }

  string getText() { percentequal_unnamed_def(this, result, _) }
}

class PercentilparenUnnamed extends @percentilparen_unnamed, Top {
  override string toString() { result = "PercentilparenUnnamed" }

  override Location getLocation() { percentilparen_unnamed_def(this, _, result) }

  string getText() { percentilparen_unnamed_def(this, result, _) }
}

class PercentwlparenUnnamed extends @percentwlparen_unnamed, Top {
  override string toString() { result = "PercentwlparenUnnamed" }

  override Location getLocation() { percentwlparen_unnamed_def(this, _, result) }

  string getText() { percentwlparen_unnamed_def(this, result, _) }
}

class AmpersandUnnamed extends @ampersand_unnamed, Top, BinaryOperatorType {
  override string toString() { result = "AmpersandUnnamed" }

  override Location getLocation() { ampersand_unnamed_def(this, _, result) }

  string getText() { ampersand_unnamed_def(this, result, _) }
}

class AmpersandampersandUnnamed extends @ampersandampersand_unnamed, Top, BinaryOperatorType {
  override string toString() { result = "AmpersandampersandUnnamed" }

  override Location getLocation() { ampersandampersand_unnamed_def(this, _, result) }

  string getText() { ampersandampersand_unnamed_def(this, result, _) }
}

class AmpersandampersandequalUnnamed extends @ampersandampersandequal_unnamed, Top {
  override string toString() { result = "AmpersandampersandequalUnnamed" }

  override Location getLocation() { ampersandampersandequal_unnamed_def(this, _, result) }

  string getText() { ampersandampersandequal_unnamed_def(this, result, _) }
}

class AmpersanddotUnnamed extends @ampersanddot_unnamed, Top {
  override string toString() { result = "AmpersanddotUnnamed" }

  override Location getLocation() { ampersanddot_unnamed_def(this, _, result) }

  string getText() { ampersanddot_unnamed_def(this, result, _) }
}

class AmpersandequalUnnamed extends @ampersandequal_unnamed, Top {
  override string toString() { result = "AmpersandequalUnnamed" }

  override Location getLocation() { ampersandequal_unnamed_def(this, _, result) }

  string getText() { ampersandequal_unnamed_def(this, result, _) }
}

class LparenUnnamed extends @lparen_unnamed, Top {
  override string toString() { result = "LparenUnnamed" }

  override Location getLocation() { lparen_unnamed_def(this, _, result) }

  string getText() { lparen_unnamed_def(this, result, _) }
}

class RparenUnnamed extends @rparen_unnamed, Top {
  override string toString() { result = "RparenUnnamed" }

  override Location getLocation() { rparen_unnamed_def(this, _, result) }

  string getText() { rparen_unnamed_def(this, result, _) }
}

class StarUnnamed extends @star_unnamed, Top, BinaryOperatorType {
  override string toString() { result = "StarUnnamed" }

  override Location getLocation() { star_unnamed_def(this, _, result) }

  string getText() { star_unnamed_def(this, result, _) }
}

class StarstarUnnamed extends @starstar_unnamed, Top, BinaryOperatorType {
  override string toString() { result = "StarstarUnnamed" }

  override Location getLocation() { starstar_unnamed_def(this, _, result) }

  string getText() { starstar_unnamed_def(this, result, _) }
}

class StarstarequalUnnamed extends @starstarequal_unnamed, Top {
  override string toString() { result = "StarstarequalUnnamed" }

  override Location getLocation() { starstarequal_unnamed_def(this, _, result) }

  string getText() { starstarequal_unnamed_def(this, result, _) }
}

class StarequalUnnamed extends @starequal_unnamed, Top {
  override string toString() { result = "StarequalUnnamed" }

  override Location getLocation() { starequal_unnamed_def(this, _, result) }

  string getText() { starequal_unnamed_def(this, result, _) }
}

class PlusUnnamed extends @plus_unnamed, Top, BinaryOperatorType {
  override string toString() { result = "PlusUnnamed" }

  override Location getLocation() { plus_unnamed_def(this, _, result) }

  string getText() { plus_unnamed_def(this, result, _) }
}

class PlusequalUnnamed extends @plusequal_unnamed, Top {
  override string toString() { result = "PlusequalUnnamed" }

  override Location getLocation() { plusequal_unnamed_def(this, _, result) }

  string getText() { plusequal_unnamed_def(this, result, _) }
}

class PlusatUnnamed extends @plusat_unnamed, Top {
  override string toString() { result = "PlusatUnnamed" }

  override Location getLocation() { plusat_unnamed_def(this, _, result) }

  string getText() { plusat_unnamed_def(this, result, _) }
}

class CommaUnnamed extends @comma_unnamed, Top, WhenPatternType {
  override string toString() { result = "CommaUnnamed" }

  override Location getLocation() { comma_unnamed_def(this, _, result) }

  string getText() { comma_unnamed_def(this, result, _) }
}

class MinusUnnamed extends @minus_unnamed, Top, BinaryOperatorType {
  override string toString() { result = "MinusUnnamed" }

  override Location getLocation() { minus_unnamed_def(this, _, result) }

  string getText() { minus_unnamed_def(this, result, _) }
}

class MinusequalUnnamed extends @minusequal_unnamed, Top {
  override string toString() { result = "MinusequalUnnamed" }

  override Location getLocation() { minusequal_unnamed_def(this, _, result) }

  string getText() { minusequal_unnamed_def(this, result, _) }
}

class MinusrangleUnnamed extends @minusrangle_unnamed, Top {
  override string toString() { result = "MinusrangleUnnamed" }

  override Location getLocation() { minusrangle_unnamed_def(this, _, result) }

  string getText() { minusrangle_unnamed_def(this, result, _) }
}

class MinusatUnnamed extends @minusat_unnamed, Top {
  override string toString() { result = "MinusatUnnamed" }

  override Location getLocation() { minusat_unnamed_def(this, _, result) }

  string getText() { minusat_unnamed_def(this, result, _) }
}

class DotUnnamed extends @dot_unnamed, Top {
  override string toString() { result = "DotUnnamed" }

  override Location getLocation() { dot_unnamed_def(this, _, result) }

  string getText() { dot_unnamed_def(this, result, _) }
}

class DotdotUnnamed extends @dotdot_unnamed, Top {
  override string toString() { result = "DotdotUnnamed" }

  override Location getLocation() { dotdot_unnamed_def(this, _, result) }

  string getText() { dotdot_unnamed_def(this, result, _) }
}

class DotdotdotUnnamed extends @dotdotdot_unnamed, Top {
  override string toString() { result = "DotdotdotUnnamed" }

  override Location getLocation() { dotdotdot_unnamed_def(this, _, result) }

  string getText() { dotdotdot_unnamed_def(this, result, _) }
}

class SlashUnnamed extends @slash_unnamed, Top, BinaryOperatorType {
  override string toString() { result = "SlashUnnamed" }

  override Location getLocation() { slash_unnamed_def(this, _, result) }

  string getText() { slash_unnamed_def(this, result, _) }
}

class SlashequalUnnamed extends @slashequal_unnamed, Top {
  override string toString() { result = "SlashequalUnnamed" }

  override Location getLocation() { slashequal_unnamed_def(this, _, result) }

  string getText() { slashequal_unnamed_def(this, result, _) }
}

class ColonUnnamed extends @colon_unnamed, Top {
  override string toString() { result = "ColonUnnamed" }

  override Location getLocation() { colon_unnamed_def(this, _, result) }

  string getText() { colon_unnamed_def(this, result, _) }
}

class ColondquoteUnnamed extends @colondquote_unnamed, Top {
  override string toString() { result = "ColondquoteUnnamed" }

  override Location getLocation() { colondquote_unnamed_def(this, _, result) }

  string getText() { colondquote_unnamed_def(this, result, _) }
}

class ColoncolonUnnamed extends @coloncolon_unnamed, Top {
  override string toString() { result = "ColoncolonUnnamed" }

  override Location getLocation() { coloncolon_unnamed_def(this, _, result) }

  string getText() { coloncolon_unnamed_def(this, result, _) }
}

class SemicolonUnnamed extends @semicolon_unnamed, Top {
  override string toString() { result = "SemicolonUnnamed" }

  override Location getLocation() { semicolon_unnamed_def(this, _, result) }

  string getText() { semicolon_unnamed_def(this, result, _) }
}

class LangleUnnamed extends @langle_unnamed, Top, BinaryOperatorType {
  override string toString() { result = "LangleUnnamed" }

  override Location getLocation() { langle_unnamed_def(this, _, result) }

  string getText() { langle_unnamed_def(this, result, _) }
}

class LanglelangleUnnamed extends @langlelangle_unnamed, Top, BinaryOperatorType {
  override string toString() { result = "LanglelangleUnnamed" }

  override Location getLocation() { langlelangle_unnamed_def(this, _, result) }

  string getText() { langlelangle_unnamed_def(this, result, _) }
}

class LanglelangleequalUnnamed extends @langlelangleequal_unnamed, Top {
  override string toString() { result = "LanglelangleequalUnnamed" }

  override Location getLocation() { langlelangleequal_unnamed_def(this, _, result) }

  string getText() { langlelangleequal_unnamed_def(this, result, _) }
}

class LangleequalUnnamed extends @langleequal_unnamed, Top, BinaryOperatorType {
  override string toString() { result = "LangleequalUnnamed" }

  override Location getLocation() { langleequal_unnamed_def(this, _, result) }

  string getText() { langleequal_unnamed_def(this, result, _) }
}

class LangleequalrangleUnnamed extends @langleequalrangle_unnamed, Top, BinaryOperatorType {
  override string toString() { result = "LangleequalrangleUnnamed" }

  override Location getLocation() { langleequalrangle_unnamed_def(this, _, result) }

  string getText() { langleequalrangle_unnamed_def(this, result, _) }
}

class EqualUnnamed extends @equal_unnamed, Top {
  override string toString() { result = "EqualUnnamed" }

  override Location getLocation() { equal_unnamed_def(this, _, result) }

  string getText() { equal_unnamed_def(this, result, _) }
}

class EqualequalUnnamed extends @equalequal_unnamed, Top, BinaryOperatorType {
  override string toString() { result = "EqualequalUnnamed" }

  override Location getLocation() { equalequal_unnamed_def(this, _, result) }

  string getText() { equalequal_unnamed_def(this, result, _) }
}

class EqualequalequalUnnamed extends @equalequalequal_unnamed, Top, BinaryOperatorType {
  override string toString() { result = "EqualequalequalUnnamed" }

  override Location getLocation() { equalequalequal_unnamed_def(this, _, result) }

  string getText() { equalequalequal_unnamed_def(this, result, _) }
}

class EqualrangleUnnamed extends @equalrangle_unnamed, Top {
  override string toString() { result = "EqualrangleUnnamed" }

  override Location getLocation() { equalrangle_unnamed_def(this, _, result) }

  string getText() { equalrangle_unnamed_def(this, result, _) }
}

class EqualtildeUnnamed extends @equaltilde_unnamed, Top, BinaryOperatorType {
  override string toString() { result = "EqualtildeUnnamed" }

  override Location getLocation() { equaltilde_unnamed_def(this, _, result) }

  string getText() { equaltilde_unnamed_def(this, result, _) }
}

class RangleUnnamed extends @rangle_unnamed, Top, BinaryOperatorType {
  override string toString() { result = "RangleUnnamed" }

  override Location getLocation() { rangle_unnamed_def(this, _, result) }

  string getText() { rangle_unnamed_def(this, result, _) }
}

class RangleequalUnnamed extends @rangleequal_unnamed, Top, BinaryOperatorType {
  override string toString() { result = "RangleequalUnnamed" }

  override Location getLocation() { rangleequal_unnamed_def(this, _, result) }

  string getText() { rangleequal_unnamed_def(this, result, _) }
}

class RanglerangleUnnamed extends @ranglerangle_unnamed, Top, BinaryOperatorType {
  override string toString() { result = "RanglerangleUnnamed" }

  override Location getLocation() { ranglerangle_unnamed_def(this, _, result) }

  string getText() { ranglerangle_unnamed_def(this, result, _) }
}

class RanglerangleequalUnnamed extends @ranglerangleequal_unnamed, Top {
  override string toString() { result = "RanglerangleequalUnnamed" }

  override Location getLocation() { ranglerangleequal_unnamed_def(this, _, result) }

  string getText() { ranglerangleequal_unnamed_def(this, result, _) }
}

class QuestionUnnamed extends @question_unnamed, Top {
  override string toString() { result = "QuestionUnnamed" }

  override Location getLocation() { question_unnamed_def(this, _, result) }

  string getText() { question_unnamed_def(this, result, _) }
}

class BEGINUnnamed extends @b_e_g_i_n__unnamed, Top {
  override string toString() { result = "BEGINUnnamed" }

  override Location getLocation() { b_e_g_i_n__unnamed_def(this, _, result) }

  string getText() { b_e_g_i_n__unnamed_def(this, result, _) }
}

class ENDUnnamed extends @e_n_d__unnamed, Top {
  override string toString() { result = "ENDUnnamed" }

  override Location getLocation() { e_n_d__unnamed_def(this, _, result) }

  string getText() { e_n_d__unnamed_def(this, result, _) }
}

class LbracketUnnamed extends @lbracket_unnamed, Top {
  override string toString() { result = "LbracketUnnamed" }

  override Location getLocation() { lbracket_unnamed_def(this, _, result) }

  string getText() { lbracket_unnamed_def(this, result, _) }
}

class LbracketrbracketUnnamed extends @lbracketrbracket_unnamed, Top {
  override string toString() { result = "LbracketrbracketUnnamed" }

  override Location getLocation() { lbracketrbracket_unnamed_def(this, _, result) }

  string getText() { lbracketrbracket_unnamed_def(this, result, _) }
}

class LbracketrbracketequalUnnamed extends @lbracketrbracketequal_unnamed, Top {
  override string toString() { result = "LbracketrbracketequalUnnamed" }

  override Location getLocation() { lbracketrbracketequal_unnamed_def(this, _, result) }

  string getText() { lbracketrbracketequal_unnamed_def(this, result, _) }
}

class RbracketUnnamed extends @rbracket_unnamed, Top {
  override string toString() { result = "RbracketUnnamed" }

  override Location getLocation() { rbracket_unnamed_def(this, _, result) }

  string getText() { rbracket_unnamed_def(this, result, _) }
}

class CaretUnnamed extends @caret_unnamed, Top, BinaryOperatorType {
  override string toString() { result = "CaretUnnamed" }

  override Location getLocation() { caret_unnamed_def(this, _, result) }

  string getText() { caret_unnamed_def(this, result, _) }
}

class CaretequalUnnamed extends @caretequal_unnamed, Top {
  override string toString() { result = "CaretequalUnnamed" }

  override Location getLocation() { caretequal_unnamed_def(this, _, result) }

  string getText() { caretequal_unnamed_def(this, result, _) }
}

class UnderscoreENDUnnamed extends @underscore__e_n_d____unnamed, Top {
  override string toString() { result = "UnderscoreENDUnnamed" }

  override Location getLocation() { underscore__e_n_d____unnamed_def(this, _, result) }

  string getText() { underscore__e_n_d____unnamed_def(this, result, _) }
}

class BacktickUnnamed extends @backtick_unnamed, Top {
  override string toString() { result = "BacktickUnnamed" }

  override Location getLocation() { backtick_unnamed_def(this, _, result) }

  string getText() { backtick_unnamed_def(this, result, _) }
}

class AliasUnnamed extends @alias_unnamed, Top {
  override string toString() { result = "AliasUnnamed" }

  override Location getLocation() { alias_unnamed_def(this, _, result) }

  string getText() { alias_unnamed_def(this, result, _) }
}

class AndUnnamed extends @and_unnamed, Top, BinaryOperatorType {
  override string toString() { result = "AndUnnamed" }

  override Location getLocation() { and_unnamed_def(this, _, result) }

  string getText() { and_unnamed_def(this, result, _) }
}

class BeginUnnamed extends @begin_unnamed, Top {
  override string toString() { result = "BeginUnnamed" }

  override Location getLocation() { begin_unnamed_def(this, _, result) }

  string getText() { begin_unnamed_def(this, result, _) }
}

class BreakUnnamed extends @break_unnamed, Top {
  override string toString() { result = "BreakUnnamed" }

  override Location getLocation() { break_unnamed_def(this, _, result) }

  string getText() { break_unnamed_def(this, result, _) }
}

class CaseUnnamed extends @case_unnamed, Top {
  override string toString() { result = "CaseUnnamed" }

  override Location getLocation() { case_unnamed_def(this, _, result) }

  string getText() { case_unnamed_def(this, result, _) }
}

class Character extends @character, Top, UnderscorePrimary {
  override string toString() { result = "Character" }

  override Location getLocation() { character_def(this, _, result) }

  string getText() { character_def(this, result, _) }
}

class ClassUnnamed extends @class_unnamed, Top {
  override string toString() { result = "ClassUnnamed" }

  override Location getLocation() { class_unnamed_def(this, _, result) }

  string getText() { class_unnamed_def(this, result, _) }
}

class ClassVariable extends @class_variable, Top, UnderscoreMethodName, UnderscoreVariable {
  override string toString() { result = "ClassVariable" }

  override Location getLocation() { class_variable_def(this, _, result) }

  string getText() { class_variable_def(this, result, _) }
}

class Complex extends @complex, Top, UnderscorePrimary {
  override string toString() { result = "Complex" }

  override Location getLocation() { complex_def(this, _, result) }

  string getText() { complex_def(this, result, _) }
}

class Constant extends @constant, Top, CallMethodType, ClassNameType, ModuleNameType,
  ScopeResolutionNameType, UnderscoreMethodName, UnderscoreVariable {
  override string toString() { result = "Constant" }

  override Location getLocation() { constant_def(this, _, result) }

  string getText() { constant_def(this, result, _) }
}

class DefUnnamed extends @def_unnamed, Top {
  override string toString() { result = "DefUnnamed" }

  override Location getLocation() { def_unnamed_def(this, _, result) }

  string getText() { def_unnamed_def(this, result, _) }
}

class DefinedquestionUnnamed extends @definedquestion_unnamed, Top {
  override string toString() { result = "DefinedquestionUnnamed" }

  override Location getLocation() { definedquestion_unnamed_def(this, _, result) }

  string getText() { definedquestion_unnamed_def(this, result, _) }
}

class DoUnnamed extends @do_unnamed, Top {
  override string toString() { result = "DoUnnamed" }

  override Location getLocation() { do_unnamed_def(this, _, result) }

  string getText() { do_unnamed_def(this, result, _) }
}

class ElseUnnamed extends @else_unnamed, Top {
  override string toString() { result = "ElseUnnamed" }

  override Location getLocation() { else_unnamed_def(this, _, result) }

  string getText() { else_unnamed_def(this, result, _) }
}

class ElsifUnnamed extends @elsif_unnamed, Top {
  override string toString() { result = "ElsifUnnamed" }

  override Location getLocation() { elsif_unnamed_def(this, _, result) }

  string getText() { elsif_unnamed_def(this, result, _) }
}

class EndUnnamed extends @end_unnamed, Top {
  override string toString() { result = "EndUnnamed" }

  override Location getLocation() { end_unnamed_def(this, _, result) }

  string getText() { end_unnamed_def(this, result, _) }
}

class EnsureUnnamed extends @ensure_unnamed, Top {
  override string toString() { result = "EnsureUnnamed" }

  override Location getLocation() { ensure_unnamed_def(this, _, result) }

  string getText() { ensure_unnamed_def(this, result, _) }
}

class EscapeSequence extends @escape_sequence, Top, BareStringChildType, BareSymbolChildType,
  RegexChildType, StringChildType, SubshellChildType, SymbolChildType {
  override string toString() { result = "EscapeSequence" }

  override Location getLocation() { escape_sequence_def(this, _, result) }

  string getText() { escape_sequence_def(this, result, _) }
}

class False extends @false, Top, UnderscoreLhs {
  override string toString() { result = "False" }

  override Location getLocation() { false_def(this, _, result) }

  string getText() { false_def(this, result, _) }
}

class Float extends @float__, Top, UnaryChildType, UnderscorePrimary {
  override string toString() { result = "Float" }

  override Location getLocation() { float_def(this, _, result) }

  string getText() { float_def(this, result, _) }
}

class ForUnnamed extends @for_unnamed, Top {
  override string toString() { result = "ForUnnamed" }

  override Location getLocation() { for_unnamed_def(this, _, result) }

  string getText() { for_unnamed_def(this, result, _) }
}

class GlobalVariable extends @global_variable, Top, UnderscoreMethodName, UnderscoreVariable {
  override string toString() { result = "GlobalVariable" }

  override Location getLocation() { global_variable_def(this, _, result) }

  string getText() { global_variable_def(this, result, _) }
}

class HeredocBeginning extends @heredoc_beginning, Top, UnderscorePrimary {
  override string toString() { result = "HeredocBeginning" }

  override Location getLocation() { heredoc_beginning_def(this, _, result) }

  string getText() { heredoc_beginning_def(this, result, _) }
}

class HeredocEnd extends @heredoc_end, Top {
  override string toString() { result = "HeredocEnd" }

  override Location getLocation() { heredoc_end_def(this, _, result) }

  string getText() { heredoc_end_def(this, result, _) }
}

class Identifier extends @identifier, Top, BlockParametersChildType, CallMethodType,
  DestructuredParameterChildType, LambdaParametersChildType, MethodParametersChildType,
  ScopeResolutionNameType, UnderscoreMethodName, UnderscoreVariable {
  override string toString() { result = "Identifier" }

  override Location getLocation() { identifier_def(this, _, result) }

  string getText() { identifier_def(this, result, _) }
}

class IfUnnamed extends @if_unnamed, Top {
  override string toString() { result = "IfUnnamed" }

  override Location getLocation() { if_unnamed_def(this, _, result) }

  string getText() { if_unnamed_def(this, result, _) }
}

class InUnnamed extends @in_unnamed, Top {
  override string toString() { result = "InUnnamed" }

  override Location getLocation() { in_unnamed_def(this, _, result) }

  string getText() { in_unnamed_def(this, result, _) }
}

class InstanceVariable extends @instance_variable, Top, UnderscoreMethodName, UnderscoreVariable {
  override string toString() { result = "InstanceVariable" }

  override Location getLocation() { instance_variable_def(this, _, result) }

  string getText() { instance_variable_def(this, result, _) }
}

class Integer extends @integer, Top, UnaryChildType, UnderscorePrimary {
  override string toString() { result = "Integer" }

  override Location getLocation() { integer_def(this, _, result) }

  string getText() { integer_def(this, result, _) }
}

class ModuleUnnamed extends @module_unnamed, Top {
  override string toString() { result = "ModuleUnnamed" }

  override Location getLocation() { module_unnamed_def(this, _, result) }

  string getText() { module_unnamed_def(this, result, _) }
}

class NextUnnamed extends @next_unnamed, Top {
  override string toString() { result = "NextUnnamed" }

  override Location getLocation() { next_unnamed_def(this, _, result) }

  string getText() { next_unnamed_def(this, result, _) }
}

class Nil extends @nil, Top, UnderscoreLhs {
  override string toString() { result = "Nil" }

  override Location getLocation() { nil_def(this, _, result) }

  string getText() { nil_def(this, result, _) }
}

class NotUnnamed extends @not_unnamed, Top {
  override string toString() { result = "NotUnnamed" }

  override Location getLocation() { not_unnamed_def(this, _, result) }

  string getText() { not_unnamed_def(this, result, _) }
}

class OrUnnamed extends @or_unnamed, Top, BinaryOperatorType {
  override string toString() { result = "OrUnnamed" }

  override Location getLocation() { or_unnamed_def(this, _, result) }

  string getText() { or_unnamed_def(this, result, _) }
}

class RUnnamed extends @r_unnamed, Top {
  override string toString() { result = "RUnnamed" }

  override Location getLocation() { r_unnamed_def(this, _, result) }

  string getText() { r_unnamed_def(this, result, _) }
}

class RedoUnnamed extends @redo_unnamed, Top {
  override string toString() { result = "RedoUnnamed" }

  override Location getLocation() { redo_unnamed_def(this, _, result) }

  string getText() { redo_unnamed_def(this, result, _) }
}

class RescueUnnamed extends @rescue_unnamed, Top {
  override string toString() { result = "RescueUnnamed" }

  override Location getLocation() { rescue_unnamed_def(this, _, result) }

  string getText() { rescue_unnamed_def(this, result, _) }
}

class RetryUnnamed extends @retry_unnamed, Top {
  override string toString() { result = "RetryUnnamed" }

  override Location getLocation() { retry_unnamed_def(this, _, result) }

  string getText() { retry_unnamed_def(this, result, _) }
}

class ReturnUnnamed extends @return_unnamed, Top {
  override string toString() { result = "ReturnUnnamed" }

  override Location getLocation() { return_unnamed_def(this, _, result) }

  string getText() { return_unnamed_def(this, result, _) }
}

class Self extends @self, Top, UnderscoreVariable {
  override string toString() { result = "Self" }

  override Location getLocation() { self_def(this, _, result) }

  string getText() { self_def(this, result, _) }
}

class Super extends @super, Top, UnderscoreVariable {
  override string toString() { result = "Super" }

  override Location getLocation() { super_def(this, _, result) }

  string getText() { super_def(this, result, _) }
}

class ThenUnnamed extends @then_unnamed, Top {
  override string toString() { result = "ThenUnnamed" }

  override Location getLocation() { then_unnamed_def(this, _, result) }

  string getText() { then_unnamed_def(this, result, _) }
}

class True extends @true, Top, UnderscoreLhs {
  override string toString() { result = "True" }

  override Location getLocation() { true_def(this, _, result) }

  string getText() { true_def(this, result, _) }
}

class UndefUnnamed extends @undef_unnamed, Top {
  override string toString() { result = "UndefUnnamed" }

  override Location getLocation() { undef_unnamed_def(this, _, result) }

  string getText() { undef_unnamed_def(this, result, _) }
}

class Uninterpreted extends @uninterpreted, Top, ProgramChildType {
  override string toString() { result = "Uninterpreted" }

  override Location getLocation() { uninterpreted_def(this, _, result) }

  string getText() { uninterpreted_def(this, result, _) }
}

class UnlessUnnamed extends @unless_unnamed, Top {
  override string toString() { result = "UnlessUnnamed" }

  override Location getLocation() { unless_unnamed_def(this, _, result) }

  string getText() { unless_unnamed_def(this, result, _) }
}

class UntilUnnamed extends @until_unnamed, Top {
  override string toString() { result = "UntilUnnamed" }

  override Location getLocation() { until_unnamed_def(this, _, result) }

  string getText() { until_unnamed_def(this, result, _) }
}

class WhenUnnamed extends @when_unnamed, Top {
  override string toString() { result = "WhenUnnamed" }

  override Location getLocation() { when_unnamed_def(this, _, result) }

  string getText() { when_unnamed_def(this, result, _) }
}

class WhileUnnamed extends @while_unnamed, Top {
  override string toString() { result = "WhileUnnamed" }

  override Location getLocation() { while_unnamed_def(this, _, result) }

  string getText() { while_unnamed_def(this, result, _) }
}

class YieldUnnamed extends @yield_unnamed, Top {
  override string toString() { result = "YieldUnnamed" }

  override Location getLocation() { yield_unnamed_def(this, _, result) }

  string getText() { yield_unnamed_def(this, result, _) }
}

class LbraceUnnamed extends @lbrace_unnamed, Top {
  override string toString() { result = "LbraceUnnamed" }

  override Location getLocation() { lbrace_unnamed_def(this, _, result) }

  string getText() { lbrace_unnamed_def(this, result, _) }
}

class PipeUnnamed extends @pipe_unnamed, Top, BinaryOperatorType {
  override string toString() { result = "PipeUnnamed" }

  override Location getLocation() { pipe_unnamed_def(this, _, result) }

  string getText() { pipe_unnamed_def(this, result, _) }
}

class PipeequalUnnamed extends @pipeequal_unnamed, Top {
  override string toString() { result = "PipeequalUnnamed" }

  override Location getLocation() { pipeequal_unnamed_def(this, _, result) }

  string getText() { pipeequal_unnamed_def(this, result, _) }
}

class PipepipeUnnamed extends @pipepipe_unnamed, Top, BinaryOperatorType {
  override string toString() { result = "PipepipeUnnamed" }

  override Location getLocation() { pipepipe_unnamed_def(this, _, result) }

  string getText() { pipepipe_unnamed_def(this, result, _) }
}

class PipepipeequalUnnamed extends @pipepipeequal_unnamed, Top {
  override string toString() { result = "PipepipeequalUnnamed" }

  override Location getLocation() { pipepipeequal_unnamed_def(this, _, result) }

  string getText() { pipepipeequal_unnamed_def(this, result, _) }
}

class RbraceUnnamed extends @rbrace_unnamed, Top {
  override string toString() { result = "RbraceUnnamed" }

  override Location getLocation() { rbrace_unnamed_def(this, _, result) }

  string getText() { rbrace_unnamed_def(this, result, _) }
}

class TildeUnnamed extends @tilde_unnamed, Top {
  override string toString() { result = "TildeUnnamed" }

  override Location getLocation() { tilde_unnamed_def(this, _, result) }

  string getText() { tilde_unnamed_def(this, result, _) }
}
