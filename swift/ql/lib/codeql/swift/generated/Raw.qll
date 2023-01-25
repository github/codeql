module Raw {
  class Element extends @element {
    string toString() { none() }

    predicate isUnknown() { element_is_unknown(this) }
  }

  class Callable extends @callable, Element {
    string getName() { callable_names(this, result) }

    ParamDecl getSelfParam() { callable_self_params(this, result) }

    ParamDecl getParam(int index) { callable_params(this, index, result) }

    BraceStmt getBody() { callable_bodies(this, result) }
  }

  class File extends @file, Element {
    string getName() { files(this, result) }
  }

  class Locatable extends @locatable, Element {
    Location getLocation() { locatable_locations(this, result) }
  }

  class Location extends @location, Element {
    File getFile() { locations(this, result, _, _, _, _) }

    int getStartLine() { locations(this, _, result, _, _, _) }

    int getStartColumn() { locations(this, _, _, result, _, _) }

    int getEndLine() { locations(this, _, _, _, result, _) }

    int getEndColumn() { locations(this, _, _, _, _, result) }
  }

  class AstNode extends @ast_node, Locatable { }

  class Comment extends @comment, Locatable {
    override string toString() { result = "Comment" }

    string getText() { comments(this, result) }
  }

  class DbFile extends @db_file, File {
    override string toString() { result = "DbFile" }
  }

  class DbLocation extends @db_location, Location {
    override string toString() { result = "DbLocation" }
  }

  class Diagnostics extends @diagnostics, Locatable {
    override string toString() { result = "Diagnostics" }

    string getText() { diagnostics(this, result, _) }

    int getKind() { diagnostics(this, _, result) }
  }

  class ErrorElement extends @error_element, Locatable { }

  class UnspecifiedElement extends @unspecified_element, ErrorElement {
    override string toString() { result = "UnspecifiedElement" }

    Element getParent() { unspecified_element_parents(this, result) }

    string getProperty() { unspecified_elements(this, result, _) }

    int getIndex() { unspecified_element_indices(this, result) }

    string getError() { unspecified_elements(this, _, result) }
  }

  class Decl extends @decl, AstNode {
    ModuleDecl getModule() { decls(this, result) }
  }

  class GenericContext extends @generic_context, Element {
    GenericTypeParamDecl getGenericTypeParam(int index) {
      generic_context_generic_type_params(this, index, result)
    }
  }

  class IterableDeclContext extends @iterable_decl_context, Element {
    Decl getMember(int index) { iterable_decl_context_members(this, index, result) }
  }

  class EnumCaseDecl extends @enum_case_decl, Decl {
    override string toString() { result = "EnumCaseDecl" }

    EnumElementDecl getElement(int index) { enum_case_decl_elements(this, index, result) }
  }

  class ExtensionDecl extends @extension_decl, GenericContext, IterableDeclContext, Decl {
    override string toString() { result = "ExtensionDecl" }

    NominalTypeDecl getExtendedTypeDecl() { extension_decls(this, result) }

    ProtocolDecl getProtocol(int index) { extension_decl_protocols(this, index, result) }
  }

  class IfConfigDecl extends @if_config_decl, Decl {
    override string toString() { result = "IfConfigDecl" }

    AstNode getActiveElement(int index) { if_config_decl_active_elements(this, index, result) }
  }

  class ImportDecl extends @import_decl, Decl {
    override string toString() { result = "ImportDecl" }

    predicate isExported() { import_decl_is_exported(this) }

    ModuleDecl getImportedModule() { import_decl_imported_modules(this, result) }

    ValueDecl getDeclaration(int index) { import_decl_declarations(this, index, result) }
  }

  class MissingMemberDecl extends @missing_member_decl, Decl {
    override string toString() { result = "MissingMemberDecl" }

    string getName() { missing_member_decls(this, result) }
  }

  class OperatorDecl extends @operator_decl, Decl {
    string getName() { operator_decls(this, result) }
  }

  class PatternBindingDecl extends @pattern_binding_decl, Decl {
    override string toString() { result = "PatternBindingDecl" }

    Expr getInit(int index) { pattern_binding_decl_inits(this, index, result) }

    Pattern getPattern(int index) { pattern_binding_decl_patterns(this, index, result) }
  }

  class PoundDiagnosticDecl extends @pound_diagnostic_decl, Decl {
    override string toString() { result = "PoundDiagnosticDecl" }

    int getKind() { pound_diagnostic_decls(this, result, _) }

    StringLiteralExpr getMessage() { pound_diagnostic_decls(this, _, result) }
  }

  class PrecedenceGroupDecl extends @precedence_group_decl, Decl {
    override string toString() { result = "PrecedenceGroupDecl" }
  }

  class TopLevelCodeDecl extends @top_level_code_decl, Decl {
    override string toString() { result = "TopLevelCodeDecl" }

    BraceStmt getBody() { top_level_code_decls(this, result) }
  }

  class ValueDecl extends @value_decl, Decl {
    Type getInterfaceType() { value_decls(this, result) }
  }

  class AbstractFunctionDecl extends @abstract_function_decl, GenericContext, ValueDecl, Callable {
  }

  class AbstractStorageDecl extends @abstract_storage_decl, ValueDecl {
    AccessorDecl getAccessorDecl(int index) {
      abstract_storage_decl_accessor_decls(this, index, result)
    }
  }

  class EnumElementDecl extends @enum_element_decl, ValueDecl {
    override string toString() { result = "EnumElementDecl" }

    string getName() { enum_element_decls(this, result) }

    ParamDecl getParam(int index) { enum_element_decl_params(this, index, result) }
  }

  class InfixOperatorDecl extends @infix_operator_decl, OperatorDecl {
    override string toString() { result = "InfixOperatorDecl" }

    PrecedenceGroupDecl getPrecedenceGroup() { infix_operator_decl_precedence_groups(this, result) }
  }

  class PostfixOperatorDecl extends @postfix_operator_decl, OperatorDecl {
    override string toString() { result = "PostfixOperatorDecl" }
  }

  class PrefixOperatorDecl extends @prefix_operator_decl, OperatorDecl {
    override string toString() { result = "PrefixOperatorDecl" }
  }

  class TypeDecl extends @type_decl, ValueDecl {
    string getName() { type_decls(this, result) }

    Type getBaseType(int index) { type_decl_base_types(this, index, result) }
  }

  class AbstractTypeParamDecl extends @abstract_type_param_decl, TypeDecl { }

  class ConstructorDecl extends @constructor_decl, AbstractFunctionDecl {
    override string toString() { result = "ConstructorDecl" }
  }

  class DestructorDecl extends @destructor_decl, AbstractFunctionDecl {
    override string toString() { result = "DestructorDecl" }
  }

  class FuncDecl extends @func_decl, AbstractFunctionDecl { }

  class GenericTypeDecl extends @generic_type_decl, GenericContext, TypeDecl { }

  class ModuleDecl extends @module_decl, TypeDecl {
    override string toString() { result = "ModuleDecl" }

    predicate isBuiltinModule() { module_decl_is_builtin_module(this) }

    predicate isSystemModule() { module_decl_is_system_module(this) }

    ModuleDecl getImportedModule(int index) { module_decl_imported_modules(this, index, result) }

    ModuleDecl getExportedModule(int index) { module_decl_exported_modules(this, index, result) }
  }

  class SubscriptDecl extends @subscript_decl, AbstractStorageDecl, GenericContext {
    override string toString() { result = "SubscriptDecl" }

    ParamDecl getParam(int index) { subscript_decl_params(this, index, result) }

    Type getElementType() { subscript_decls(this, result) }
  }

  class VarDecl extends @var_decl, AbstractStorageDecl {
    string getName() { var_decls(this, result, _) }

    Type getType() { var_decls(this, _, result) }

    Type getAttachedPropertyWrapperType() { var_decl_attached_property_wrapper_types(this, result) }

    Pattern getParentPattern() { var_decl_parent_patterns(this, result) }

    Expr getParentInitializer() { var_decl_parent_initializers(this, result) }

    PatternBindingDecl getPropertyWrapperBackingVarBinding() {
      var_decl_property_wrapper_backing_var_bindings(this, result)
    }

    VarDecl getPropertyWrapperBackingVar() { var_decl_property_wrapper_backing_vars(this, result) }

    PatternBindingDecl getPropertyWrapperProjectionVarBinding() {
      var_decl_property_wrapper_projection_var_bindings(this, result)
    }

    VarDecl getPropertyWrapperProjectionVar() {
      var_decl_property_wrapper_projection_vars(this, result)
    }
  }

  class AccessorDecl extends @accessor_decl, FuncDecl {
    override string toString() { result = "AccessorDecl" }

    predicate isGetter() { accessor_decl_is_getter(this) }

    predicate isSetter() { accessor_decl_is_setter(this) }

    predicate isWillSet() { accessor_decl_is_will_set(this) }

    predicate isDidSet() { accessor_decl_is_did_set(this) }

    predicate isRead() { accessor_decl_is_read(this) }

    predicate isModify() { accessor_decl_is_modify(this) }

    predicate isUnsafeAddress() { accessor_decl_is_unsafe_address(this) }

    predicate isUnsafeMutableAddress() { accessor_decl_is_unsafe_mutable_address(this) }
  }

  class AssociatedTypeDecl extends @associated_type_decl, AbstractTypeParamDecl {
    override string toString() { result = "AssociatedTypeDecl" }
  }

  class ConcreteFuncDecl extends @concrete_func_decl, FuncDecl {
    override string toString() { result = "ConcreteFuncDecl" }
  }

  class ConcreteVarDecl extends @concrete_var_decl, VarDecl {
    override string toString() { result = "ConcreteVarDecl" }

    int getIntroducerInt() { concrete_var_decls(this, result) }
  }

  class GenericTypeParamDecl extends @generic_type_param_decl, AbstractTypeParamDecl {
    override string toString() { result = "GenericTypeParamDecl" }
  }

  class NominalTypeDecl extends @nominal_type_decl, GenericTypeDecl, IterableDeclContext {
    Type getType() { nominal_type_decls(this, result) }
  }

  class OpaqueTypeDecl extends @opaque_type_decl, GenericTypeDecl {
    override string toString() { result = "OpaqueTypeDecl" }

    ValueDecl getNamingDeclaration() { opaque_type_decls(this, result) }

    GenericTypeParamType getOpaqueGenericParam(int index) {
      opaque_type_decl_opaque_generic_params(this, index, result)
    }
  }

  class ParamDecl extends @param_decl, VarDecl {
    override string toString() { result = "ParamDecl" }

    predicate isInout() { param_decl_is_inout(this) }

    PatternBindingDecl getPropertyWrapperLocalWrappedVarBinding() {
      param_decl_property_wrapper_local_wrapped_var_bindings(this, result)
    }

    VarDecl getPropertyWrapperLocalWrappedVar() {
      param_decl_property_wrapper_local_wrapped_vars(this, result)
    }
  }

  class TypeAliasDecl extends @type_alias_decl, GenericTypeDecl {
    override string toString() { result = "TypeAliasDecl" }
  }

  class ClassDecl extends @class_decl, NominalTypeDecl {
    override string toString() { result = "ClassDecl" }
  }

  class EnumDecl extends @enum_decl, NominalTypeDecl {
    override string toString() { result = "EnumDecl" }
  }

  class ProtocolDecl extends @protocol_decl, NominalTypeDecl {
    override string toString() { result = "ProtocolDecl" }
  }

  class StructDecl extends @struct_decl, NominalTypeDecl {
    override string toString() { result = "StructDecl" }
  }

  class Argument extends @argument, Locatable {
    override string toString() { result = "Argument" }

    string getLabel() { arguments(this, result, _) }

    Expr getExpr() { arguments(this, _, result) }
  }

  class Expr extends @expr, AstNode {
    Type getType() { expr_types(this, result) }
  }

  class AbstractClosureExpr extends @abstract_closure_expr, Expr, Callable { }

  class AnyTryExpr extends @any_try_expr, Expr {
    Expr getSubExpr() { any_try_exprs(this, result) }
  }

  class AppliedPropertyWrapperExpr extends @applied_property_wrapper_expr, Expr {
    override string toString() { result = "AppliedPropertyWrapperExpr" }

    int getKind() { applied_property_wrapper_exprs(this, result, _, _) }

    Expr getValue() { applied_property_wrapper_exprs(this, _, result, _) }

    ParamDecl getParam() { applied_property_wrapper_exprs(this, _, _, result) }
  }

  class ApplyExpr extends @apply_expr, Expr {
    Expr getFunction() { apply_exprs(this, result) }

    Argument getArgument(int index) { apply_expr_arguments(this, index, result) }
  }

  class AssignExpr extends @assign_expr, Expr {
    override string toString() { result = "AssignExpr" }

    Expr getDest() { assign_exprs(this, result, _) }

    Expr getSource() { assign_exprs(this, _, result) }
  }

  class BindOptionalExpr extends @bind_optional_expr, Expr {
    override string toString() { result = "BindOptionalExpr" }

    Expr getSubExpr() { bind_optional_exprs(this, result) }
  }

  class CaptureListExpr extends @capture_list_expr, Expr {
    override string toString() { result = "CaptureListExpr" }

    PatternBindingDecl getBindingDecl(int index) {
      capture_list_expr_binding_decls(this, index, result)
    }

    ClosureExpr getClosureBody() { capture_list_exprs(this, result) }
  }

  class CollectionExpr extends @collection_expr, Expr { }

  class DeclRefExpr extends @decl_ref_expr, Expr {
    override string toString() { result = "DeclRefExpr" }

    Decl getDecl() { decl_ref_exprs(this, result) }

    Type getReplacementType(int index) { decl_ref_expr_replacement_types(this, index, result) }

    predicate hasDirectToStorageSemantics() { decl_ref_expr_has_direct_to_storage_semantics(this) }

    predicate hasDirectToImplementationSemantics() {
      decl_ref_expr_has_direct_to_implementation_semantics(this)
    }

    predicate hasOrdinarySemantics() { decl_ref_expr_has_ordinary_semantics(this) }

    predicate hasDistributedThunkSemantics() { decl_ref_expr_has_distributed_thunk_semantics(this) }
  }

  class DefaultArgumentExpr extends @default_argument_expr, Expr {
    override string toString() { result = "DefaultArgumentExpr" }

    ParamDecl getParamDecl() { default_argument_exprs(this, result, _) }

    int getParamIndex() { default_argument_exprs(this, _, result) }

    Expr getCallerSideDefault() { default_argument_expr_caller_side_defaults(this, result) }
  }

  class DiscardAssignmentExpr extends @discard_assignment_expr, Expr {
    override string toString() { result = "DiscardAssignmentExpr" }
  }

  class DotSyntaxBaseIgnoredExpr extends @dot_syntax_base_ignored_expr, Expr {
    override string toString() { result = "DotSyntaxBaseIgnoredExpr" }

    Expr getQualifier() { dot_syntax_base_ignored_exprs(this, result, _) }

    Expr getSubExpr() { dot_syntax_base_ignored_exprs(this, _, result) }
  }

  class DynamicTypeExpr extends @dynamic_type_expr, Expr {
    override string toString() { result = "DynamicTypeExpr" }

    Expr getBase() { dynamic_type_exprs(this, result) }
  }

  class EnumIsCaseExpr extends @enum_is_case_expr, Expr {
    override string toString() { result = "EnumIsCaseExpr" }

    Expr getSubExpr() { enum_is_case_exprs(this, result, _) }

    EnumElementDecl getElement() { enum_is_case_exprs(this, _, result) }
  }

  class ErrorExpr extends @error_expr, Expr, ErrorElement {
    override string toString() { result = "ErrorExpr" }
  }

  class ExplicitCastExpr extends @explicit_cast_expr, Expr {
    Expr getSubExpr() { explicit_cast_exprs(this, result) }
  }

  class ForceValueExpr extends @force_value_expr, Expr {
    override string toString() { result = "ForceValueExpr" }

    Expr getSubExpr() { force_value_exprs(this, result) }
  }

  class IdentityExpr extends @identity_expr, Expr {
    Expr getSubExpr() { identity_exprs(this, result) }
  }

  class IfExpr extends @if_expr, Expr {
    override string toString() { result = "IfExpr" }

    Expr getCondition() { if_exprs(this, result, _, _) }

    Expr getThenExpr() { if_exprs(this, _, result, _) }

    Expr getElseExpr() { if_exprs(this, _, _, result) }
  }

  class ImplicitConversionExpr extends @implicit_conversion_expr, Expr {
    Expr getSubExpr() { implicit_conversion_exprs(this, result) }
  }

  class InOutExpr extends @in_out_expr, Expr {
    override string toString() { result = "InOutExpr" }

    Expr getSubExpr() { in_out_exprs(this, result) }
  }

  class KeyPathApplicationExpr extends @key_path_application_expr, Expr {
    override string toString() { result = "KeyPathApplicationExpr" }

    Expr getBase() { key_path_application_exprs(this, result, _) }

    Expr getKeyPath() { key_path_application_exprs(this, _, result) }
  }

  class KeyPathDotExpr extends @key_path_dot_expr, Expr {
    override string toString() { result = "KeyPathDotExpr" }
  }

  class KeyPathExpr extends @key_path_expr, Expr {
    override string toString() { result = "KeyPathExpr" }

    TypeRepr getRoot() { key_path_expr_roots(this, result) }

    Expr getParsedPath() { key_path_expr_parsed_paths(this, result) }
  }

  class LazyInitializerExpr extends @lazy_initializer_expr, Expr {
    override string toString() { result = "LazyInitializerExpr" }

    Expr getSubExpr() { lazy_initializer_exprs(this, result) }
  }

  class LiteralExpr extends @literal_expr, Expr { }

  class LookupExpr extends @lookup_expr, Expr {
    Expr getBase() { lookup_exprs(this, result) }

    Decl getMember() { lookup_expr_members(this, result) }
  }

  class MakeTemporarilyEscapableExpr extends @make_temporarily_escapable_expr, Expr {
    override string toString() { result = "MakeTemporarilyEscapableExpr" }

    OpaqueValueExpr getEscapingClosure() { make_temporarily_escapable_exprs(this, result, _, _) }

    Expr getNonescapingClosure() { make_temporarily_escapable_exprs(this, _, result, _) }

    Expr getSubExpr() { make_temporarily_escapable_exprs(this, _, _, result) }
  }

  class ObjCSelectorExpr extends @obj_c_selector_expr, Expr {
    override string toString() { result = "ObjCSelectorExpr" }

    Expr getSubExpr() { obj_c_selector_exprs(this, result, _) }

    AbstractFunctionDecl getMethod() { obj_c_selector_exprs(this, _, result) }
  }

  class OneWayExpr extends @one_way_expr, Expr {
    override string toString() { result = "OneWayExpr" }

    Expr getSubExpr() { one_way_exprs(this, result) }
  }

  class OpaqueValueExpr extends @opaque_value_expr, Expr {
    override string toString() { result = "OpaqueValueExpr" }
  }

  class OpenExistentialExpr extends @open_existential_expr, Expr {
    override string toString() { result = "OpenExistentialExpr" }

    Expr getSubExpr() { open_existential_exprs(this, result, _, _) }

    Expr getExistential() { open_existential_exprs(this, _, result, _) }

    OpaqueValueExpr getOpaqueExpr() { open_existential_exprs(this, _, _, result) }
  }

  class OptionalEvaluationExpr extends @optional_evaluation_expr, Expr {
    override string toString() { result = "OptionalEvaluationExpr" }

    Expr getSubExpr() { optional_evaluation_exprs(this, result) }
  }

  class OtherConstructorDeclRefExpr extends @other_constructor_decl_ref_expr, Expr {
    override string toString() { result = "OtherConstructorDeclRefExpr" }

    ConstructorDecl getConstructorDecl() { other_constructor_decl_ref_exprs(this, result) }
  }

  class OverloadedDeclRefExpr extends @overloaded_decl_ref_expr, Expr, ErrorElement {
    override string toString() { result = "OverloadedDeclRefExpr" }

    ValueDecl getPossibleDeclaration(int index) {
      overloaded_decl_ref_expr_possible_declarations(this, index, result)
    }
  }

  class PropertyWrapperValuePlaceholderExpr extends @property_wrapper_value_placeholder_expr, Expr {
    override string toString() { result = "PropertyWrapperValuePlaceholderExpr" }

    Expr getWrappedValue() { property_wrapper_value_placeholder_expr_wrapped_values(this, result) }

    OpaqueValueExpr getPlaceholder() { property_wrapper_value_placeholder_exprs(this, result) }
  }

  class RebindSelfInConstructorExpr extends @rebind_self_in_constructor_expr, Expr {
    override string toString() { result = "RebindSelfInConstructorExpr" }

    Expr getSubExpr() { rebind_self_in_constructor_exprs(this, result, _) }

    VarDecl getSelf() { rebind_self_in_constructor_exprs(this, _, result) }
  }

  class SequenceExpr extends @sequence_expr, Expr {
    override string toString() { result = "SequenceExpr" }

    Expr getElement(int index) { sequence_expr_elements(this, index, result) }
  }

  class SuperRefExpr extends @super_ref_expr, Expr {
    override string toString() { result = "SuperRefExpr" }

    VarDecl getSelf() { super_ref_exprs(this, result) }
  }

  class TapExpr extends @tap_expr, Expr {
    override string toString() { result = "TapExpr" }

    Expr getSubExpr() { tap_expr_sub_exprs(this, result) }

    BraceStmt getBody() { tap_exprs(this, result, _) }

    VarDecl getVar() { tap_exprs(this, _, result) }
  }

  class TupleElementExpr extends @tuple_element_expr, Expr {
    override string toString() { result = "TupleElementExpr" }

    Expr getSubExpr() { tuple_element_exprs(this, result, _) }

    int getIndex() { tuple_element_exprs(this, _, result) }
  }

  class TupleExpr extends @tuple_expr, Expr {
    override string toString() { result = "TupleExpr" }

    Expr getElement(int index) { tuple_expr_elements(this, index, result) }
  }

  class TypeExpr extends @type_expr, Expr {
    override string toString() { result = "TypeExpr" }

    TypeRepr getTypeRepr() { type_expr_type_reprs(this, result) }
  }

  class UnresolvedDeclRefExpr extends @unresolved_decl_ref_expr, Expr, ErrorElement {
    override string toString() { result = "UnresolvedDeclRefExpr" }

    string getName() { unresolved_decl_ref_expr_names(this, result) }
  }

  class UnresolvedDotExpr extends @unresolved_dot_expr, Expr, ErrorElement {
    override string toString() { result = "UnresolvedDotExpr" }

    Expr getBase() { unresolved_dot_exprs(this, result, _) }

    string getName() { unresolved_dot_exprs(this, _, result) }
  }

  class UnresolvedMemberExpr extends @unresolved_member_expr, Expr, ErrorElement {
    override string toString() { result = "UnresolvedMemberExpr" }

    string getName() { unresolved_member_exprs(this, result) }
  }

  class UnresolvedPatternExpr extends @unresolved_pattern_expr, Expr, ErrorElement {
    override string toString() { result = "UnresolvedPatternExpr" }

    Pattern getSubPattern() { unresolved_pattern_exprs(this, result) }
  }

  class UnresolvedSpecializeExpr extends @unresolved_specialize_expr, Expr, ErrorElement {
    override string toString() { result = "UnresolvedSpecializeExpr" }

    Expr getSubExpr() { unresolved_specialize_exprs(this, result) }
  }

  class VarargExpansionExpr extends @vararg_expansion_expr, Expr {
    override string toString() { result = "VarargExpansionExpr" }

    Expr getSubExpr() { vararg_expansion_exprs(this, result) }
  }

  class AbiSafeConversionExpr extends @abi_safe_conversion_expr, ImplicitConversionExpr {
    override string toString() { result = "AbiSafeConversionExpr" }
  }

  class AnyHashableErasureExpr extends @any_hashable_erasure_expr, ImplicitConversionExpr {
    override string toString() { result = "AnyHashableErasureExpr" }
  }

  class ArchetypeToSuperExpr extends @archetype_to_super_expr, ImplicitConversionExpr {
    override string toString() { result = "ArchetypeToSuperExpr" }
  }

  class ArrayExpr extends @array_expr, CollectionExpr {
    override string toString() { result = "ArrayExpr" }

    Expr getElement(int index) { array_expr_elements(this, index, result) }
  }

  class ArrayToPointerExpr extends @array_to_pointer_expr, ImplicitConversionExpr {
    override string toString() { result = "ArrayToPointerExpr" }
  }

  class AutoClosureExpr extends @auto_closure_expr, AbstractClosureExpr {
    override string toString() { result = "AutoClosureExpr" }
  }

  class AwaitExpr extends @await_expr, IdentityExpr {
    override string toString() { result = "AwaitExpr" }
  }

  class BinaryExpr extends @binary_expr, ApplyExpr {
    override string toString() { result = "BinaryExpr" }
  }

  class BridgeFromObjCExpr extends @bridge_from_obj_c_expr, ImplicitConversionExpr {
    override string toString() { result = "BridgeFromObjCExpr" }
  }

  class BridgeToObjCExpr extends @bridge_to_obj_c_expr, ImplicitConversionExpr {
    override string toString() { result = "BridgeToObjCExpr" }
  }

  class BuiltinLiteralExpr extends @builtin_literal_expr, LiteralExpr { }

  class CallExpr extends @call_expr, ApplyExpr {
    override string toString() { result = "CallExpr" }
  }

  class CheckedCastExpr extends @checked_cast_expr, ExplicitCastExpr { }

  class ClassMetatypeToObjectExpr extends @class_metatype_to_object_expr, ImplicitConversionExpr {
    override string toString() { result = "ClassMetatypeToObjectExpr" }
  }

  class ClosureExpr extends @closure_expr, AbstractClosureExpr {
    override string toString() { result = "ClosureExpr" }
  }

  class CoerceExpr extends @coerce_expr, ExplicitCastExpr {
    override string toString() { result = "CoerceExpr" }
  }

  class CollectionUpcastConversionExpr extends @collection_upcast_conversion_expr,
    ImplicitConversionExpr {
    override string toString() { result = "CollectionUpcastConversionExpr" }
  }

  class ConditionalBridgeFromObjCExpr extends @conditional_bridge_from_obj_c_expr,
    ImplicitConversionExpr {
    override string toString() { result = "ConditionalBridgeFromObjCExpr" }
  }

  class CovariantFunctionConversionExpr extends @covariant_function_conversion_expr,
    ImplicitConversionExpr {
    override string toString() { result = "CovariantFunctionConversionExpr" }
  }

  class CovariantReturnConversionExpr extends @covariant_return_conversion_expr,
    ImplicitConversionExpr {
    override string toString() { result = "CovariantReturnConversionExpr" }
  }

  class DerivedToBaseExpr extends @derived_to_base_expr, ImplicitConversionExpr {
    override string toString() { result = "DerivedToBaseExpr" }
  }

  class DestructureTupleExpr extends @destructure_tuple_expr, ImplicitConversionExpr {
    override string toString() { result = "DestructureTupleExpr" }
  }

  class DictionaryExpr extends @dictionary_expr, CollectionExpr {
    override string toString() { result = "DictionaryExpr" }

    Expr getElement(int index) { dictionary_expr_elements(this, index, result) }
  }

  class DifferentiableFunctionExpr extends @differentiable_function_expr, ImplicitConversionExpr {
    override string toString() { result = "DifferentiableFunctionExpr" }
  }

  class DifferentiableFunctionExtractOriginalExpr extends @differentiable_function_extract_original_expr,
    ImplicitConversionExpr {
    override string toString() { result = "DifferentiableFunctionExtractOriginalExpr" }
  }

  class DotSelfExpr extends @dot_self_expr, IdentityExpr {
    override string toString() { result = "DotSelfExpr" }
  }

  class DynamicLookupExpr extends @dynamic_lookup_expr, LookupExpr { }

  class ErasureExpr extends @erasure_expr, ImplicitConversionExpr {
    override string toString() { result = "ErasureExpr" }
  }

  class ExistentialMetatypeToObjectExpr extends @existential_metatype_to_object_expr,
    ImplicitConversionExpr {
    override string toString() { result = "ExistentialMetatypeToObjectExpr" }
  }

  class ForceTryExpr extends @force_try_expr, AnyTryExpr {
    override string toString() { result = "ForceTryExpr" }
  }

  class ForeignObjectConversionExpr extends @foreign_object_conversion_expr, ImplicitConversionExpr {
    override string toString() { result = "ForeignObjectConversionExpr" }
  }

  class FunctionConversionExpr extends @function_conversion_expr, ImplicitConversionExpr {
    override string toString() { result = "FunctionConversionExpr" }
  }

  class InOutToPointerExpr extends @in_out_to_pointer_expr, ImplicitConversionExpr {
    override string toString() { result = "InOutToPointerExpr" }
  }

  class InjectIntoOptionalExpr extends @inject_into_optional_expr, ImplicitConversionExpr {
    override string toString() { result = "InjectIntoOptionalExpr" }
  }

  class InterpolatedStringLiteralExpr extends @interpolated_string_literal_expr, LiteralExpr {
    override string toString() { result = "InterpolatedStringLiteralExpr" }

    OpaqueValueExpr getInterpolationExpr() {
      interpolated_string_literal_expr_interpolation_exprs(this, result)
    }

    Expr getInterpolationCountExpr() {
      interpolated_string_literal_expr_interpolation_count_exprs(this, result)
    }

    Expr getLiteralCapacityExpr() {
      interpolated_string_literal_expr_literal_capacity_exprs(this, result)
    }

    TapExpr getAppendingExpr() { interpolated_string_literal_expr_appending_exprs(this, result) }
  }

  class LinearFunctionExpr extends @linear_function_expr, ImplicitConversionExpr {
    override string toString() { result = "LinearFunctionExpr" }
  }

  class LinearFunctionExtractOriginalExpr extends @linear_function_extract_original_expr,
    ImplicitConversionExpr {
    override string toString() { result = "LinearFunctionExtractOriginalExpr" }
  }

  class LinearToDifferentiableFunctionExpr extends @linear_to_differentiable_function_expr,
    ImplicitConversionExpr {
    override string toString() { result = "LinearToDifferentiableFunctionExpr" }
  }

  class LoadExpr extends @load_expr, ImplicitConversionExpr {
    override string toString() { result = "LoadExpr" }
  }

  class MemberRefExpr extends @member_ref_expr, LookupExpr {
    override string toString() { result = "MemberRefExpr" }

    predicate hasDirectToStorageSemantics() {
      member_ref_expr_has_direct_to_storage_semantics(this)
    }

    predicate hasDirectToImplementationSemantics() {
      member_ref_expr_has_direct_to_implementation_semantics(this)
    }

    predicate hasOrdinarySemantics() { member_ref_expr_has_ordinary_semantics(this) }

    predicate hasDistributedThunkSemantics() {
      member_ref_expr_has_distributed_thunk_semantics(this)
    }
  }

  class MetatypeConversionExpr extends @metatype_conversion_expr, ImplicitConversionExpr {
    override string toString() { result = "MetatypeConversionExpr" }
  }

  class NilLiteralExpr extends @nil_literal_expr, LiteralExpr {
    override string toString() { result = "NilLiteralExpr" }
  }

  class ObjectLiteralExpr extends @object_literal_expr, LiteralExpr {
    override string toString() { result = "ObjectLiteralExpr" }

    int getKind() { object_literal_exprs(this, result) }

    Argument getArgument(int index) { object_literal_expr_arguments(this, index, result) }
  }

  class OptionalTryExpr extends @optional_try_expr, AnyTryExpr {
    override string toString() { result = "OptionalTryExpr" }
  }

  class ParenExpr extends @paren_expr, IdentityExpr {
    override string toString() { result = "ParenExpr" }
  }

  class PointerToPointerExpr extends @pointer_to_pointer_expr, ImplicitConversionExpr {
    override string toString() { result = "PointerToPointerExpr" }
  }

  class PostfixUnaryExpr extends @postfix_unary_expr, ApplyExpr {
    override string toString() { result = "PostfixUnaryExpr" }
  }

  class PrefixUnaryExpr extends @prefix_unary_expr, ApplyExpr {
    override string toString() { result = "PrefixUnaryExpr" }
  }

  class ProtocolMetatypeToObjectExpr extends @protocol_metatype_to_object_expr,
    ImplicitConversionExpr {
    override string toString() { result = "ProtocolMetatypeToObjectExpr" }
  }

  class RegexLiteralExpr extends @regex_literal_expr, LiteralExpr {
    override string toString() { result = "RegexLiteralExpr" }
  }

  class SelfApplyExpr extends @self_apply_expr, ApplyExpr {
    Expr getBase() { self_apply_exprs(this, result) }
  }

  class StringToPointerExpr extends @string_to_pointer_expr, ImplicitConversionExpr {
    override string toString() { result = "StringToPointerExpr" }
  }

  class SubscriptExpr extends @subscript_expr, LookupExpr {
    override string toString() { result = "SubscriptExpr" }

    Argument getArgument(int index) { subscript_expr_arguments(this, index, result) }

    predicate hasDirectToStorageSemantics() { subscript_expr_has_direct_to_storage_semantics(this) }

    predicate hasDirectToImplementationSemantics() {
      subscript_expr_has_direct_to_implementation_semantics(this)
    }

    predicate hasOrdinarySemantics() { subscript_expr_has_ordinary_semantics(this) }

    predicate hasDistributedThunkSemantics() {
      subscript_expr_has_distributed_thunk_semantics(this)
    }
  }

  class TryExpr extends @try_expr, AnyTryExpr {
    override string toString() { result = "TryExpr" }
  }

  class UnderlyingToOpaqueExpr extends @underlying_to_opaque_expr, ImplicitConversionExpr {
    override string toString() { result = "UnderlyingToOpaqueExpr" }
  }

  class UnevaluatedInstanceExpr extends @unevaluated_instance_expr, ImplicitConversionExpr {
    override string toString() { result = "UnevaluatedInstanceExpr" }
  }

  class UnresolvedMemberChainResultExpr extends @unresolved_member_chain_result_expr, IdentityExpr,
    ErrorElement {
    override string toString() { result = "UnresolvedMemberChainResultExpr" }
  }

  class UnresolvedTypeConversionExpr extends @unresolved_type_conversion_expr,
    ImplicitConversionExpr, ErrorElement {
    override string toString() { result = "UnresolvedTypeConversionExpr" }
  }

  class BooleanLiteralExpr extends @boolean_literal_expr, BuiltinLiteralExpr {
    override string toString() { result = "BooleanLiteralExpr" }

    boolean getValue() { boolean_literal_exprs(this, result) }
  }

  class ConditionalCheckedCastExpr extends @conditional_checked_cast_expr, CheckedCastExpr {
    override string toString() { result = "ConditionalCheckedCastExpr" }
  }

  class ConstructorRefCallExpr extends @constructor_ref_call_expr, SelfApplyExpr {
    override string toString() { result = "ConstructorRefCallExpr" }
  }

  class DotSyntaxCallExpr extends @dot_syntax_call_expr, SelfApplyExpr {
    override string toString() { result = "DotSyntaxCallExpr" }
  }

  class DynamicMemberRefExpr extends @dynamic_member_ref_expr, DynamicLookupExpr {
    override string toString() { result = "DynamicMemberRefExpr" }
  }

  class DynamicSubscriptExpr extends @dynamic_subscript_expr, DynamicLookupExpr {
    override string toString() { result = "DynamicSubscriptExpr" }
  }

  class ForcedCheckedCastExpr extends @forced_checked_cast_expr, CheckedCastExpr {
    override string toString() { result = "ForcedCheckedCastExpr" }
  }

  class IsExpr extends @is_expr, CheckedCastExpr {
    override string toString() { result = "IsExpr" }
  }

  class MagicIdentifierLiteralExpr extends @magic_identifier_literal_expr, BuiltinLiteralExpr {
    override string toString() { result = "MagicIdentifierLiteralExpr" }

    string getKind() { magic_identifier_literal_exprs(this, result) }
  }

  class NumberLiteralExpr extends @number_literal_expr, BuiltinLiteralExpr { }

  class StringLiteralExpr extends @string_literal_expr, BuiltinLiteralExpr {
    override string toString() { result = "StringLiteralExpr" }

    string getValue() { string_literal_exprs(this, result) }
  }

  class FloatLiteralExpr extends @float_literal_expr, NumberLiteralExpr {
    override string toString() { result = "FloatLiteralExpr" }

    string getStringValue() { float_literal_exprs(this, result) }
  }

  class IntegerLiteralExpr extends @integer_literal_expr, NumberLiteralExpr {
    override string toString() { result = "IntegerLiteralExpr" }

    string getStringValue() { integer_literal_exprs(this, result) }
  }

  class Pattern extends @pattern, AstNode { }

  class AnyPattern extends @any_pattern, Pattern {
    override string toString() { result = "AnyPattern" }
  }

  class BindingPattern extends @binding_pattern, Pattern {
    override string toString() { result = "BindingPattern" }

    Pattern getSubPattern() { binding_patterns(this, result) }
  }

  class BoolPattern extends @bool_pattern, Pattern {
    override string toString() { result = "BoolPattern" }

    boolean getValue() { bool_patterns(this, result) }
  }

  class EnumElementPattern extends @enum_element_pattern, Pattern {
    override string toString() { result = "EnumElementPattern" }

    EnumElementDecl getElement() { enum_element_patterns(this, result) }

    Pattern getSubPattern() { enum_element_pattern_sub_patterns(this, result) }
  }

  class ExprPattern extends @expr_pattern, Pattern {
    override string toString() { result = "ExprPattern" }

    Expr getSubExpr() { expr_patterns(this, result) }
  }

  class IsPattern extends @is_pattern, Pattern {
    override string toString() { result = "IsPattern" }

    TypeRepr getCastTypeRepr() { is_pattern_cast_type_reprs(this, result) }

    Pattern getSubPattern() { is_pattern_sub_patterns(this, result) }
  }

  class NamedPattern extends @named_pattern, Pattern {
    override string toString() { result = "NamedPattern" }

    string getName() { named_patterns(this, result) }
  }

  class OptionalSomePattern extends @optional_some_pattern, Pattern {
    override string toString() { result = "OptionalSomePattern" }

    Pattern getSubPattern() { optional_some_patterns(this, result) }
  }

  class ParenPattern extends @paren_pattern, Pattern {
    override string toString() { result = "ParenPattern" }

    Pattern getSubPattern() { paren_patterns(this, result) }
  }

  class TuplePattern extends @tuple_pattern, Pattern {
    override string toString() { result = "TuplePattern" }

    Pattern getElement(int index) { tuple_pattern_elements(this, index, result) }
  }

  class TypedPattern extends @typed_pattern, Pattern {
    override string toString() { result = "TypedPattern" }

    Pattern getSubPattern() { typed_patterns(this, result) }

    TypeRepr getTypeRepr() { typed_pattern_type_reprs(this, result) }
  }

  class CaseLabelItem extends @case_label_item, AstNode {
    override string toString() { result = "CaseLabelItem" }

    Pattern getPattern() { case_label_items(this, result) }

    Expr getGuard() { case_label_item_guards(this, result) }
  }

  class ConditionElement extends @condition_element, AstNode {
    override string toString() { result = "ConditionElement" }

    Expr getBoolean() { condition_element_booleans(this, result) }

    Pattern getPattern() { condition_element_patterns(this, result) }

    Expr getInitializer() { condition_element_initializers(this, result) }
  }

  class Stmt extends @stmt, AstNode { }

  class StmtCondition extends @stmt_condition, AstNode {
    override string toString() { result = "StmtCondition" }

    ConditionElement getElement(int index) { stmt_condition_elements(this, index, result) }
  }

  class BraceStmt extends @brace_stmt, Stmt {
    override string toString() { result = "BraceStmt" }

    AstNode getElement(int index) { brace_stmt_elements(this, index, result) }
  }

  class BreakStmt extends @break_stmt, Stmt {
    override string toString() { result = "BreakStmt" }

    string getTargetName() { break_stmt_target_names(this, result) }

    Stmt getTarget() { break_stmt_targets(this, result) }
  }

  class CaseStmt extends @case_stmt, Stmt {
    override string toString() { result = "CaseStmt" }

    Stmt getBody() { case_stmts(this, result) }

    CaseLabelItem getLabel(int index) { case_stmt_labels(this, index, result) }

    VarDecl getVariable(int index) { case_stmt_variables(this, index, result) }
  }

  class ContinueStmt extends @continue_stmt, Stmt {
    override string toString() { result = "ContinueStmt" }

    string getTargetName() { continue_stmt_target_names(this, result) }

    Stmt getTarget() { continue_stmt_targets(this, result) }
  }

  class DeferStmt extends @defer_stmt, Stmt {
    override string toString() { result = "DeferStmt" }

    BraceStmt getBody() { defer_stmts(this, result) }
  }

  class FailStmt extends @fail_stmt, Stmt {
    override string toString() { result = "FailStmt" }
  }

  class FallthroughStmt extends @fallthrough_stmt, Stmt {
    override string toString() { result = "FallthroughStmt" }

    CaseStmt getFallthroughSource() { fallthrough_stmts(this, result, _) }

    CaseStmt getFallthroughDest() { fallthrough_stmts(this, _, result) }
  }

  class LabeledStmt extends @labeled_stmt, Stmt {
    string getLabel() { labeled_stmt_labels(this, result) }
  }

  class PoundAssertStmt extends @pound_assert_stmt, Stmt {
    override string toString() { result = "PoundAssertStmt" }

    Expr getCondition() { pound_assert_stmts(this, result, _) }

    string getMessage() { pound_assert_stmts(this, _, result) }
  }

  class ReturnStmt extends @return_stmt, Stmt {
    override string toString() { result = "ReturnStmt" }

    Expr getResult() { return_stmt_results(this, result) }
  }

  class ThrowStmt extends @throw_stmt, Stmt {
    override string toString() { result = "ThrowStmt" }

    Expr getSubExpr() { throw_stmts(this, result) }
  }

  class YieldStmt extends @yield_stmt, Stmt {
    override string toString() { result = "YieldStmt" }

    Expr getResult(int index) { yield_stmt_results(this, index, result) }
  }

  class DoCatchStmt extends @do_catch_stmt, LabeledStmt {
    override string toString() { result = "DoCatchStmt" }

    Stmt getBody() { do_catch_stmts(this, result) }

    CaseStmt getCatch(int index) { do_catch_stmt_catches(this, index, result) }
  }

  class DoStmt extends @do_stmt, LabeledStmt {
    override string toString() { result = "DoStmt" }

    BraceStmt getBody() { do_stmts(this, result) }
  }

  class ForEachStmt extends @for_each_stmt, LabeledStmt {
    override string toString() { result = "ForEachStmt" }

    Pattern getPattern() { for_each_stmts(this, result, _, _) }

    Expr getSequence() { for_each_stmts(this, _, result, _) }

    Expr getWhere() { for_each_stmt_wheres(this, result) }

    BraceStmt getBody() { for_each_stmts(this, _, _, result) }
  }

  class LabeledConditionalStmt extends @labeled_conditional_stmt, LabeledStmt {
    StmtCondition getCondition() { labeled_conditional_stmts(this, result) }
  }

  class RepeatWhileStmt extends @repeat_while_stmt, LabeledStmt {
    override string toString() { result = "RepeatWhileStmt" }

    Expr getCondition() { repeat_while_stmts(this, result, _) }

    Stmt getBody() { repeat_while_stmts(this, _, result) }
  }

  class SwitchStmt extends @switch_stmt, LabeledStmt {
    override string toString() { result = "SwitchStmt" }

    Expr getExpr() { switch_stmts(this, result) }

    CaseStmt getCase(int index) { switch_stmt_cases(this, index, result) }
  }

  class GuardStmt extends @guard_stmt, LabeledConditionalStmt {
    override string toString() { result = "GuardStmt" }

    BraceStmt getBody() { guard_stmts(this, result) }
  }

  class IfStmt extends @if_stmt, LabeledConditionalStmt {
    override string toString() { result = "IfStmt" }

    Stmt getThen() { if_stmts(this, result) }

    Stmt getElse() { if_stmt_elses(this, result) }
  }

  class WhileStmt extends @while_stmt, LabeledConditionalStmt {
    override string toString() { result = "WhileStmt" }

    Stmt getBody() { while_stmts(this, result) }
  }

  class Type extends @type, Element {
    string getName() { types(this, result, _) }

    Type getCanonicalType() { types(this, _, result) }
  }

  class TypeRepr extends @type_repr, AstNode {
    override string toString() { result = "TypeRepr" }

    Type getType() { type_reprs(this, result) }
  }

  class AnyFunctionType extends @any_function_type, Type {
    Type getResult() { any_function_types(this, result) }

    Type getParamType(int index) { any_function_type_param_types(this, index, result) }

    string getParamLabel(int index) { any_function_type_param_labels(this, index, result) }

    predicate isThrowing() { any_function_type_is_throwing(this) }

    predicate isAsync() { any_function_type_is_async(this) }
  }

  class AnyGenericType extends @any_generic_type, Type {
    Type getParent() { any_generic_type_parents(this, result) }

    Decl getDeclaration() { any_generic_types(this, result) }
  }

  class AnyMetatypeType extends @any_metatype_type, Type { }

  class BuiltinType extends @builtin_type, Type { }

  class DependentMemberType extends @dependent_member_type, Type {
    override string toString() { result = "DependentMemberType" }

    Type getBaseType() { dependent_member_types(this, result, _) }

    AssociatedTypeDecl getAssociatedTypeDecl() { dependent_member_types(this, _, result) }
  }

  class DynamicSelfType extends @dynamic_self_type, Type {
    override string toString() { result = "DynamicSelfType" }

    Type getStaticSelfType() { dynamic_self_types(this, result) }
  }

  class ErrorType extends @error_type, Type, ErrorElement {
    override string toString() { result = "ErrorType" }
  }

  class ExistentialType extends @existential_type, Type {
    override string toString() { result = "ExistentialType" }

    Type getConstraint() { existential_types(this, result) }
  }

  class InOutType extends @in_out_type, Type {
    override string toString() { result = "InOutType" }

    Type getObjectType() { in_out_types(this, result) }
  }

  class LValueType extends @l_value_type, Type {
    override string toString() { result = "LValueType" }

    Type getObjectType() { l_value_types(this, result) }
  }

  class ModuleType extends @module_type, Type {
    override string toString() { result = "ModuleType" }

    ModuleDecl getModule() { module_types(this, result) }
  }

  class ParameterizedProtocolType extends @parameterized_protocol_type, Type {
    override string toString() { result = "ParameterizedProtocolType" }

    ProtocolType getBase() { parameterized_protocol_types(this, result) }

    Type getArg(int index) { parameterized_protocol_type_args(this, index, result) }
  }

  class ProtocolCompositionType extends @protocol_composition_type, Type {
    override string toString() { result = "ProtocolCompositionType" }

    Type getMember(int index) { protocol_composition_type_members(this, index, result) }
  }

  class ReferenceStorageType extends @reference_storage_type, Type {
    Type getReferentType() { reference_storage_types(this, result) }
  }

  class SubstitutableType extends @substitutable_type, Type { }

  class SugarType extends @sugar_type, Type { }

  class TupleType extends @tuple_type, Type {
    override string toString() { result = "TupleType" }

    Type getType(int index) { tuple_type_types(this, index, result) }

    string getName(int index) { tuple_type_names(this, index, result) }
  }

  class UnresolvedType extends @unresolved_type, Type, ErrorElement {
    override string toString() { result = "UnresolvedType" }
  }

  class AnyBuiltinIntegerType extends @any_builtin_integer_type, BuiltinType { }

  class ArchetypeType extends @archetype_type, SubstitutableType {
    Type getInterfaceType() { archetype_types(this, result) }

    Type getSuperclass() { archetype_type_superclasses(this, result) }

    ProtocolDecl getProtocol(int index) { archetype_type_protocols(this, index, result) }
  }

  class BuiltinBridgeObjectType extends @builtin_bridge_object_type, BuiltinType {
    override string toString() { result = "BuiltinBridgeObjectType" }
  }

  class BuiltinDefaultActorStorageType extends @builtin_default_actor_storage_type, BuiltinType {
    override string toString() { result = "BuiltinDefaultActorStorageType" }
  }

  class BuiltinExecutorType extends @builtin_executor_type, BuiltinType {
    override string toString() { result = "BuiltinExecutorType" }
  }

  class BuiltinFloatType extends @builtin_float_type, BuiltinType {
    override string toString() { result = "BuiltinFloatType" }
  }

  class BuiltinJobType extends @builtin_job_type, BuiltinType {
    override string toString() { result = "BuiltinJobType" }
  }

  class BuiltinNativeObjectType extends @builtin_native_object_type, BuiltinType {
    override string toString() { result = "BuiltinNativeObjectType" }
  }

  class BuiltinRawPointerType extends @builtin_raw_pointer_type, BuiltinType {
    override string toString() { result = "BuiltinRawPointerType" }
  }

  class BuiltinRawUnsafeContinuationType extends @builtin_raw_unsafe_continuation_type, BuiltinType {
    override string toString() { result = "BuiltinRawUnsafeContinuationType" }
  }

  class BuiltinUnsafeValueBufferType extends @builtin_unsafe_value_buffer_type, BuiltinType {
    override string toString() { result = "BuiltinUnsafeValueBufferType" }
  }

  class BuiltinVectorType extends @builtin_vector_type, BuiltinType {
    override string toString() { result = "BuiltinVectorType" }
  }

  class ExistentialMetatypeType extends @existential_metatype_type, AnyMetatypeType {
    override string toString() { result = "ExistentialMetatypeType" }
  }

  class FunctionType extends @function_type, AnyFunctionType {
    override string toString() { result = "FunctionType" }
  }

  class GenericFunctionType extends @generic_function_type, AnyFunctionType {
    override string toString() { result = "GenericFunctionType" }

    GenericTypeParamType getGenericParam(int index) {
      generic_function_type_generic_params(this, index, result)
    }
  }

  class GenericTypeParamType extends @generic_type_param_type, SubstitutableType {
    override string toString() { result = "GenericTypeParamType" }
  }

  class MetatypeType extends @metatype_type, AnyMetatypeType {
    override string toString() { result = "MetatypeType" }
  }

  class NominalOrBoundGenericNominalType extends @nominal_or_bound_generic_nominal_type,
    AnyGenericType { }

  class ParenType extends @paren_type, SugarType {
    override string toString() { result = "ParenType" }

    Type getType() { paren_types(this, result) }
  }

  class SyntaxSugarType extends @syntax_sugar_type, SugarType { }

  class TypeAliasType extends @type_alias_type, SugarType {
    override string toString() { result = "TypeAliasType" }

    TypeAliasDecl getDecl() { type_alias_types(this, result) }
  }

  class UnboundGenericType extends @unbound_generic_type, AnyGenericType {
    override string toString() { result = "UnboundGenericType" }
  }

  class UnmanagedStorageType extends @unmanaged_storage_type, ReferenceStorageType {
    override string toString() { result = "UnmanagedStorageType" }
  }

  class UnownedStorageType extends @unowned_storage_type, ReferenceStorageType {
    override string toString() { result = "UnownedStorageType" }
  }

  class WeakStorageType extends @weak_storage_type, ReferenceStorageType {
    override string toString() { result = "WeakStorageType" }
  }

  class BoundGenericType extends @bound_generic_type, NominalOrBoundGenericNominalType {
    Type getArgType(int index) { bound_generic_type_arg_types(this, index, result) }
  }

  class BuiltinIntegerLiteralType extends @builtin_integer_literal_type, AnyBuiltinIntegerType {
    override string toString() { result = "BuiltinIntegerLiteralType" }
  }

  class BuiltinIntegerType extends @builtin_integer_type, AnyBuiltinIntegerType {
    override string toString() { result = "BuiltinIntegerType" }

    int getWidth() { builtin_integer_type_widths(this, result) }
  }

  class DictionaryType extends @dictionary_type, SyntaxSugarType {
    override string toString() { result = "DictionaryType" }

    Type getKeyType() { dictionary_types(this, result, _) }

    Type getValueType() { dictionary_types(this, _, result) }
  }

  class NominalType extends @nominal_type, NominalOrBoundGenericNominalType { }

  class OpaqueTypeArchetypeType extends @opaque_type_archetype_type, ArchetypeType {
    override string toString() { result = "OpaqueTypeArchetypeType" }

    OpaqueTypeDecl getDeclaration() { opaque_type_archetype_types(this, result) }
  }

  class OpenedArchetypeType extends @opened_archetype_type, ArchetypeType {
    override string toString() { result = "OpenedArchetypeType" }
  }

  class PrimaryArchetypeType extends @primary_archetype_type, ArchetypeType {
    override string toString() { result = "PrimaryArchetypeType" }
  }

  class UnarySyntaxSugarType extends @unary_syntax_sugar_type, SyntaxSugarType {
    Type getBaseType() { unary_syntax_sugar_types(this, result) }
  }

  class ArraySliceType extends @array_slice_type, UnarySyntaxSugarType {
    override string toString() { result = "ArraySliceType" }
  }

  class BoundGenericClassType extends @bound_generic_class_type, BoundGenericType {
    override string toString() { result = "BoundGenericClassType" }
  }

  class BoundGenericEnumType extends @bound_generic_enum_type, BoundGenericType {
    override string toString() { result = "BoundGenericEnumType" }
  }

  class BoundGenericStructType extends @bound_generic_struct_type, BoundGenericType {
    override string toString() { result = "BoundGenericStructType" }
  }

  class ClassType extends @class_type, NominalType {
    override string toString() { result = "ClassType" }
  }

  class EnumType extends @enum_type, NominalType {
    override string toString() { result = "EnumType" }
  }

  class OptionalType extends @optional_type, UnarySyntaxSugarType {
    override string toString() { result = "OptionalType" }
  }

  class ProtocolType extends @protocol_type, NominalType {
    override string toString() { result = "ProtocolType" }
  }

  class StructType extends @struct_type, NominalType {
    override string toString() { result = "StructType" }
  }

  class VariadicSequenceType extends @variadic_sequence_type, UnarySyntaxSugarType {
    override string toString() { result = "VariadicSequenceType" }
  }
}
