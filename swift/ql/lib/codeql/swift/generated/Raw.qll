module Raw {
  class Element extends @element {
    string toString() { none() }

    /**
     * Holds if this element is unknown.
     */
    predicate isUnknown() { element_is_unknown(this) }
  }

  class Callable extends @callable, Element {
    /**
     * Gets the name of this callable, if it exists.
     */
    string getName() { callable_names(this, result) }

    /**
     * Gets the self parameter of this callable, if it exists.
     */
    ParamDecl getSelfParam() { callable_self_params(this, result) }

    /**
     * Gets the `index`th parameter of this callable (0-based).
     */
    ParamDecl getParam(int index) { callable_params(this, index, result) }

    /**
     * Gets the body of this callable, if it exists.
     *
     * The body is absent within protocol declarations.
     */
    BraceStmt getBody() { callable_bodies(this, result) }

    /**
     * Gets the `index`th capture of this callable (0-based).
     */
    CapturedDecl getCapture(int index) { callable_captures(this, index, result) }
  }

  class File extends @file, Element {
    /**
     * Gets the name of this file.
     */
    string getName() { files(this, result) }

    /**
     * Holds if this file is successfully extracted.
     */
    predicate isSuccessfullyExtracted() { file_is_successfully_extracted(this) }
  }

  class Locatable extends @locatable, Element {
    /**
     * Gets the location associated with this element in the code, if it exists.
     */
    Location getLocation() { locatable_locations(this, result) }
  }

  class Location extends @location, Element {
    /**
     * Gets the file of this location.
     */
    File getFile() { locations(this, result, _, _, _, _) }

    /**
     * Gets the start line of this location.
     */
    int getStartLine() { locations(this, _, result, _, _, _) }

    /**
     * Gets the start column of this location.
     */
    int getStartColumn() { locations(this, _, _, result, _, _) }

    /**
     * Gets the end line of this location.
     */
    int getEndLine() { locations(this, _, _, _, result, _) }

    /**
     * Gets the end column of this location.
     */
    int getEndColumn() { locations(this, _, _, _, _, result) }
  }

  class AstNode extends @ast_node, Locatable { }

  class Comment extends @comment, Locatable {
    override string toString() { result = "Comment" }

    /**
     * Gets the text of this comment.
     */
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

    /**
     * Gets the text of this diagnostics.
     */
    string getText() { diagnostics(this, result, _) }

    /**
     * Gets the kind of this diagnostics.
     */
    int getKind() { diagnostics(this, _, result) }
  }

  class ErrorElement extends @error_element, Locatable { }

  class AvailabilityInfo extends @availability_info, AstNode {
    override string toString() { result = "AvailabilityInfo" }

    /**
     * Holds if it is #unavailable as opposed to #available.
     */
    predicate isUnavailable() { availability_info_is_unavailable(this) }

    /**
     * Gets the `index`th spec of this availability info (0-based).
     */
    AvailabilitySpec getSpec(int index) { availability_info_specs(this, index, result) }
  }

  class AvailabilitySpec extends @availability_spec, AstNode { }

  class UnspecifiedElement extends @unspecified_element, ErrorElement {
    override string toString() { result = "UnspecifiedElement" }

    /**
     * Gets the parent of this unspecified element, if it exists.
     */
    Element getParent() { unspecified_element_parents(this, result) }

    /**
     * Gets the property of this unspecified element.
     */
    string getProperty() { unspecified_elements(this, result, _) }

    /**
     * Gets the index of this unspecified element, if it exists.
     */
    int getIndex() { unspecified_element_indices(this, result) }

    /**
     * Gets the error of this unspecified element.
     */
    string getError() { unspecified_elements(this, _, result) }
  }

  class OtherAvailabilitySpec extends @other_availability_spec, AvailabilitySpec {
    override string toString() { result = "OtherAvailabilitySpec" }
  }

  class PlatformVersionAvailabilitySpec extends @platform_version_availability_spec,
    AvailabilitySpec
  {
    override string toString() { result = "PlatformVersionAvailabilitySpec" }

    /**
     * Gets the platform of this platform version availability spec.
     */
    string getPlatform() { platform_version_availability_specs(this, result, _) }

    /**
     * Gets the version of this platform version availability spec.
     */
    string getVersion() { platform_version_availability_specs(this, _, result) }
  }

  class Decl extends @decl, AstNode {
    /**
     * Gets the module of this declaration.
     */
    ModuleDecl getModule() { decls(this, result) }

    /**
     * Gets the `index`th member of this declaration (0-based).
     */
    Decl getMember(int index) { decl_members(this, index, result) }
  }

  class GenericContext extends @generic_context, Element {
    /**
     * Gets the `index`th generic type parameter of this generic context (0-based).
     */
    GenericTypeParamDecl getGenericTypeParam(int index) {
      generic_context_generic_type_params(this, index, result)
    }
  }

  class CapturedDecl extends @captured_decl, Decl {
    override string toString() { result = "CapturedDecl" }

    /**
     * Gets the the declaration captured by the parent closure.
     */
    ValueDecl getDecl() { captured_decls(this, result) }

    /**
     * Holds if this captured declaration is direct.
     */
    predicate isDirect() { captured_decl_is_direct(this) }

    /**
     * Holds if this captured declaration is escaping.
     */
    predicate isEscaping() { captured_decl_is_escaping(this) }
  }

  class EnumCaseDecl extends @enum_case_decl, Decl {
    override string toString() { result = "EnumCaseDecl" }

    /**
     * Gets the `index`th element of this enum case declaration (0-based).
     */
    EnumElementDecl getElement(int index) { enum_case_decl_elements(this, index, result) }
  }

  class ExtensionDecl extends @extension_decl, GenericContext, Decl {
    override string toString() { result = "ExtensionDecl" }

    /**
     * Gets the extended type declaration of this extension declaration.
     */
    NominalTypeDecl getExtendedTypeDecl() { extension_decls(this, result) }

    /**
     * Gets the `index`th protocol of this extension declaration (0-based).
     */
    ProtocolDecl getProtocol(int index) { extension_decl_protocols(this, index, result) }
  }

  class IfConfigDecl extends @if_config_decl, Decl {
    override string toString() { result = "IfConfigDecl" }

    /**
     * Gets the `index`th active element of this if config declaration (0-based).
     */
    AstNode getActiveElement(int index) { if_config_decl_active_elements(this, index, result) }
  }

  class ImportDecl extends @import_decl, Decl {
    override string toString() { result = "ImportDecl" }

    /**
     * Holds if this import declaration is exported.
     */
    predicate isExported() { import_decl_is_exported(this) }

    /**
     * Gets the imported module of this import declaration, if it exists.
     */
    ModuleDecl getImportedModule() { import_decl_imported_modules(this, result) }

    /**
     * Gets the `index`th declaration of this import declaration (0-based).
     */
    ValueDecl getDeclaration(int index) { import_decl_declarations(this, index, result) }
  }

  class MissingMemberDecl extends @missing_member_decl, Decl {
    override string toString() { result = "MissingMemberDecl" }

    /**
     * Gets the name of this missing member declaration.
     */
    string getName() { missing_member_decls(this, result) }
  }

  class OperatorDecl extends @operator_decl, Decl {
    /**
     * Gets the name of this operator declaration.
     */
    string getName() { operator_decls(this, result) }
  }

  class PatternBindingDecl extends @pattern_binding_decl, Decl {
    override string toString() { result = "PatternBindingDecl" }

    /**
     * Gets the `index`th init of this pattern binding declaration (0-based), if it exists.
     */
    Expr getInit(int index) { pattern_binding_decl_inits(this, index, result) }

    /**
     * Gets the `index`th pattern of this pattern binding declaration (0-based).
     */
    Pattern getPattern(int index) { pattern_binding_decl_patterns(this, index, result) }
  }

  class PoundDiagnosticDecl extends @pound_diagnostic_decl, Decl {
    override string toString() { result = "PoundDiagnosticDecl" }

    /**
     * Gets the kind of this pound diagnostic declaration.
     *
     * This is 1 for `#error` and 2 for `#warning`.
     */
    int getKind() { pound_diagnostic_decls(this, result, _) }

    /**
     * Gets the message of this pound diagnostic declaration.
     */
    StringLiteralExpr getMessage() { pound_diagnostic_decls(this, _, result) }
  }

  class PrecedenceGroupDecl extends @precedence_group_decl, Decl {
    override string toString() { result = "PrecedenceGroupDecl" }
  }

  class TopLevelCodeDecl extends @top_level_code_decl, Decl {
    override string toString() { result = "TopLevelCodeDecl" }

    /**
     * Gets the body of this top level code declaration.
     */
    BraceStmt getBody() { top_level_code_decls(this, result) }
  }

  class ValueDecl extends @value_decl, Decl {
    /**
     * Gets the interface type of this value declaration.
     */
    Type getInterfaceType() { value_decls(this, result) }
  }

  class AbstractFunctionDecl extends @abstract_function_decl, GenericContext, ValueDecl, Callable {
  }

  class AbstractStorageDecl extends @abstract_storage_decl, ValueDecl {
    /**
     * Gets the `index`th accessor declaration of this abstract storage declaration (0-based).
     */
    AccessorDecl getAccessorDecl(int index) {
      abstract_storage_decl_accessor_decls(this, index, result)
    }
  }

  class EnumElementDecl extends @enum_element_decl, ValueDecl {
    override string toString() { result = "EnumElementDecl" }

    /**
     * Gets the name of this enum element declaration.
     */
    string getName() { enum_element_decls(this, result) }

    /**
     * Gets the `index`th parameter of this enum element declaration (0-based).
     */
    ParamDecl getParam(int index) { enum_element_decl_params(this, index, result) }
  }

  class InfixOperatorDecl extends @infix_operator_decl, OperatorDecl {
    override string toString() { result = "InfixOperatorDecl" }

    /**
     * Gets the precedence group of this infix operator declaration, if it exists.
     */
    PrecedenceGroupDecl getPrecedenceGroup() { infix_operator_decl_precedence_groups(this, result) }
  }

  class PostfixOperatorDecl extends @postfix_operator_decl, OperatorDecl {
    override string toString() { result = "PostfixOperatorDecl" }
  }

  class PrefixOperatorDecl extends @prefix_operator_decl, OperatorDecl {
    override string toString() { result = "PrefixOperatorDecl" }
  }

  class TypeDecl extends @type_decl, ValueDecl {
    /**
     * Gets the name of this type declaration.
     */
    string getName() { type_decls(this, result) }

    /**
     * Gets the `index`th base type of this type declaration (0-based).
     */
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

    /**
     * Holds if this module is the built-in one.
     */
    predicate isBuiltinModule() { module_decl_is_builtin_module(this) }

    /**
     * Holds if this module is a system one.
     */
    predicate isSystemModule() { module_decl_is_system_module(this) }

    /**
     * Gets the `index`th imported module of this module declaration (0-based).
     *Gets any of the imported modules of this module declaration.
     */
    ModuleDecl getAnImportedModule() { module_decl_imported_modules(this, result) }

    /**
     * Gets the `index`th exported module of this module declaration (0-based).
     *Gets any of the exported modules of this module declaration.
     */
    ModuleDecl getAnExportedModule() { module_decl_exported_modules(this, result) }
  }

  class SubscriptDecl extends @subscript_decl, AbstractStorageDecl, GenericContext {
    override string toString() { result = "SubscriptDecl" }

    /**
     * Gets the `index`th parameter of this subscript declaration (0-based).
     */
    ParamDecl getParam(int index) { subscript_decl_params(this, index, result) }

    /**
     * Gets the element type of this subscript declaration.
     */
    Type getElementType() { subscript_decls(this, result) }
  }

  class VarDecl extends @var_decl, AbstractStorageDecl {
    /**
     * Gets the name of this variable declaration.
     */
    string getName() { var_decls(this, result, _) }

    /**
     * Gets the type of this variable declaration.
     */
    Type getType() { var_decls(this, _, result) }

    /**
     * Gets the attached property wrapper type of this variable declaration, if it exists.
     */
    Type getAttachedPropertyWrapperType() { var_decl_attached_property_wrapper_types(this, result) }

    /**
     * Gets the parent pattern of this variable declaration, if it exists.
     */
    Pattern getParentPattern() { var_decl_parent_patterns(this, result) }

    /**
     * Gets the parent initializer of this variable declaration, if it exists.
     */
    Expr getParentInitializer() { var_decl_parent_initializers(this, result) }

    /**
     * Gets the property wrapper backing variable binding of this variable declaration, if it exists.
     *
     * This is the synthesized binding introducing the property wrapper backing variable for this
     * variable, if any. See `getPropertyWrapperBackingVar`.
     */
    PatternBindingDecl getPropertyWrapperBackingVarBinding() {
      var_decl_property_wrapper_backing_var_bindings(this, result)
    }

    /**
     * Gets the property wrapper backing variable of this variable declaration, if it exists.
     *
     * This is the compiler synthesized variable holding the property wrapper for this variable, if any.
     *
     * For a property wrapper like
     * ```
     * @propertyWrapper struct MyWrapper { ... }
     *
     * struct S {
     *   @MyWrapper var x : Int = 42
     * }
     * ```
     * the compiler synthesizes a variable in `S` along the lines of
     * ```
     *   var _x = MyWrapper(wrappedValue: 42)
     * ```
     * This predicate returns such variable declaration.
     */
    VarDecl getPropertyWrapperBackingVar() { var_decl_property_wrapper_backing_vars(this, result) }

    /**
     * Gets the property wrapper projection variable binding of this variable declaration, if it exists.
     *
     * This is the synthesized binding introducing the property wrapper projection variable for this
     * variable, if any. See `getPropertyWrapperProjectionVar`.
     */
    PatternBindingDecl getPropertyWrapperProjectionVarBinding() {
      var_decl_property_wrapper_projection_var_bindings(this, result)
    }

    /**
     * Gets the property wrapper projection variable of this variable declaration, if it exists.
     *
     * If this variable has a property wrapper with a projected value, this is the corresponding
     * synthesized variable holding that projected value, accessible with this variable's name
     * prefixed with `$`.
     *
     * For a property wrapper like
     * ```
     * @propertyWrapper struct MyWrapper {
     *   var projectedValue : Bool
     *   ...
     * }
     *
     * struct S {
     *   @MyWrapper var x : Int = 42
     * }
     * ```
     * ```
     * the compiler synthesizes a variable in `S` along the lines of
     * ```
     *   var $x : Bool { ... }
     * ```
     * This predicate returns such variable declaration.
     */
    VarDecl getPropertyWrapperProjectionVar() {
      var_decl_property_wrapper_projection_vars(this, result)
    }
  }

  class AccessorDecl extends @accessor_decl, FuncDecl {
    override string toString() { result = "AccessorDecl" }

    /**
     * Holds if this accessor is a getter.
     */
    predicate isGetter() { accessor_decl_is_getter(this) }

    /**
     * Holds if this accessor is a setter.
     */
    predicate isSetter() { accessor_decl_is_setter(this) }

    /**
     * Holds if this accessor is a `willSet`, called before the property is set.
     */
    predicate isWillSet() { accessor_decl_is_will_set(this) }

    /**
     * Holds if this accessor is a `didSet`, called after the property is set.
     */
    predicate isDidSet() { accessor_decl_is_did_set(this) }

    /**
     * Holds if this accessor is a `_read` coroutine, yielding a borrowed value of the property.
     */
    predicate isRead() { accessor_decl_is_read(this) }

    /**
     * Holds if this accessor is a `_modify` coroutine, yielding an inout value of the property.
     */
    predicate isModify() { accessor_decl_is_modify(this) }

    /**
     * Holds if this accessor is an `unsafeAddress` immutable addressor.
     */
    predicate isUnsafeAddress() { accessor_decl_is_unsafe_address(this) }

    /**
     * Holds if this accessor is an `unsafeMutableAddress` mutable addressor.
     */
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

    /**
     * Gets the introducer enumeration value.
     *
     * This is 0 if the variable was introduced with `let` and 1 if it was introduced with `var`.
     */
    int getIntroducerInt() { concrete_var_decls(this, result) }
  }

  class GenericTypeParamDecl extends @generic_type_param_decl, AbstractTypeParamDecl {
    override string toString() { result = "GenericTypeParamDecl" }
  }

  class NominalTypeDecl extends @nominal_type_decl, GenericTypeDecl {
    /**
     * Gets the type of this nominal type declaration.
     */
    Type getType() { nominal_type_decls(this, result) }
  }

  class OpaqueTypeDecl extends @opaque_type_decl, GenericTypeDecl {
    override string toString() { result = "OpaqueTypeDecl" }

    /**
     * Gets the naming declaration of this opaque type declaration.
     */
    ValueDecl getNamingDeclaration() { opaque_type_decls(this, result) }

    /**
     * Gets the `index`th opaque generic parameter of this opaque type declaration (0-based).
     */
    GenericTypeParamType getOpaqueGenericParam(int index) {
      opaque_type_decl_opaque_generic_params(this, index, result)
    }
  }

  class ParamDecl extends @param_decl, VarDecl {
    override string toString() { result = "ParamDecl" }

    /**
     * Holds if this is an `inout` parameter.
     */
    predicate isInout() { param_decl_is_inout(this) }

    /**
     * Gets the property wrapper local wrapped variable binding of this parameter declaration, if it exists.
     *
     * This is the synthesized binding introducing the property wrapper local wrapped projection
     * variable for this variable, if any.
     */
    PatternBindingDecl getPropertyWrapperLocalWrappedVarBinding() {
      param_decl_property_wrapper_local_wrapped_var_bindings(this, result)
    }

    /**
     * Gets the property wrapper local wrapped variable of this parameter declaration, if it exists.
     *
     * This is the synthesized local wrapped value, shadowing this parameter declaration in case it
     * has a property wrapper.
     */
    VarDecl getPropertyWrapperLocalWrappedVar() {
      param_decl_property_wrapper_local_wrapped_vars(this, result)
    }
  }

  class TypeAliasDecl extends @type_alias_decl, GenericTypeDecl {
    override string toString() { result = "TypeAliasDecl" }

    /**
     * Gets the aliased type on the right-hand side of this type alias declaration.
     *
     * For example the aliased type of `MyInt` in the following code is `Int`:
     * ```
     * typealias MyInt = Int
     * ```
     */
    Type getAliasedType() { type_alias_decls(this, result) }
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

    /**
     * Gets the label of this argument.
     */
    string getLabel() { arguments(this, result, _) }

    /**
     * Gets the expression of this argument.
     */
    Expr getExpr() { arguments(this, _, result) }
  }

  class Expr extends @expr, AstNode {
    /**
     * Gets the type of this expression, if it exists.
     */
    Type getType() { expr_types(this, result) }
  }

  class AbstractClosureExpr extends @abstract_closure_expr, Expr, Callable { }

  class AnyTryExpr extends @any_try_expr, Expr {
    /**
     * Gets the sub expression of this any try expression.
     */
    Expr getSubExpr() { any_try_exprs(this, result) }
  }

  class AppliedPropertyWrapperExpr extends @applied_property_wrapper_expr, Expr {
    override string toString() { result = "AppliedPropertyWrapperExpr" }

    /**
     * Gets the kind of this applied property wrapper expression.
     *
     * This is 1 for a wrapped value and 2 for a projected one.
     */
    int getKind() { applied_property_wrapper_exprs(this, result, _, _) }

    /**
     * Gets the value of this applied property wrapper expression.
     *
     * The value on which the wrapper is applied.
     */
    Expr getValue() { applied_property_wrapper_exprs(this, _, result, _) }

    /**
     * Gets the parameter declaration owning this wrapper application.
     */
    ParamDecl getParam() { applied_property_wrapper_exprs(this, _, _, result) }
  }

  class ApplyExpr extends @apply_expr, Expr {
    /**
     * Gets the function being applied.
     */
    Expr getFunction() { apply_exprs(this, result) }

    /**
     * Gets the `index`th argument passed to the applied function (0-based).
     */
    Argument getArgument(int index) { apply_expr_arguments(this, index, result) }
  }

  class AssignExpr extends @assign_expr, Expr {
    override string toString() { result = "AssignExpr" }

    /**
     * Gets the dest of this assign expression.
     */
    Expr getDest() { assign_exprs(this, result, _) }

    /**
     * Gets the source of this assign expression.
     */
    Expr getSource() { assign_exprs(this, _, result) }
  }

  class BindOptionalExpr extends @bind_optional_expr, Expr {
    override string toString() { result = "BindOptionalExpr" }

    /**
     * Gets the sub expression of this bind optional expression.
     */
    Expr getSubExpr() { bind_optional_exprs(this, result) }
  }

  class CaptureListExpr extends @capture_list_expr, Expr {
    override string toString() { result = "CaptureListExpr" }

    /**
     * Gets the `index`th binding declaration of this capture list expression (0-based).
     */
    PatternBindingDecl getBindingDecl(int index) {
      capture_list_expr_binding_decls(this, index, result)
    }

    /**
     * Gets the closure body of this capture list expression.
     */
    ClosureExpr getClosureBody() { capture_list_exprs(this, result) }
  }

  class CollectionExpr extends @collection_expr, Expr { }

  class DeclRefExpr extends @decl_ref_expr, Expr {
    override string toString() { result = "DeclRefExpr" }

    /**
     * Gets the declaration of this declaration reference expression.
     */
    Decl getDecl() { decl_ref_exprs(this, result) }

    /**
     * Gets the `index`th replacement type of this declaration reference expression (0-based).
     */
    Type getReplacementType(int index) { decl_ref_expr_replacement_types(this, index, result) }

    /**
     * Holds if this declaration reference expression has direct to storage semantics.
     */
    predicate hasDirectToStorageSemantics() { decl_ref_expr_has_direct_to_storage_semantics(this) }

    /**
     * Holds if this declaration reference expression has direct to implementation semantics.
     */
    predicate hasDirectToImplementationSemantics() {
      decl_ref_expr_has_direct_to_implementation_semantics(this)
    }

    /**
     * Holds if this declaration reference expression has ordinary semantics.
     */
    predicate hasOrdinarySemantics() { decl_ref_expr_has_ordinary_semantics(this) }

    /**
     * Holds if this declaration reference expression has distributed thunk semantics.
     */
    predicate hasDistributedThunkSemantics() { decl_ref_expr_has_distributed_thunk_semantics(this) }
  }

  class DefaultArgumentExpr extends @default_argument_expr, Expr {
    override string toString() { result = "DefaultArgumentExpr" }

    /**
     * Gets the parameter declaration of this default argument expression.
     */
    ParamDecl getParamDecl() { default_argument_exprs(this, result, _) }

    /**
     * Gets the parameter index of this default argument expression.
     */
    int getParamIndex() { default_argument_exprs(this, _, result) }

    /**
     * Gets the caller side default of this default argument expression, if it exists.
     */
    Expr getCallerSideDefault() { default_argument_expr_caller_side_defaults(this, result) }
  }

  class DiscardAssignmentExpr extends @discard_assignment_expr, Expr {
    override string toString() { result = "DiscardAssignmentExpr" }
  }

  class DotSyntaxBaseIgnoredExpr extends @dot_syntax_base_ignored_expr, Expr {
    override string toString() { result = "DotSyntaxBaseIgnoredExpr" }

    /**
     * Gets the qualifier of this dot syntax base ignored expression.
     */
    Expr getQualifier() { dot_syntax_base_ignored_exprs(this, result, _) }

    /**
     * Gets the sub expression of this dot syntax base ignored expression.
     */
    Expr getSubExpr() { dot_syntax_base_ignored_exprs(this, _, result) }
  }

  class DynamicTypeExpr extends @dynamic_type_expr, Expr {
    override string toString() { result = "DynamicTypeExpr" }

    /**
     * Gets the base of this dynamic type expression.
     */
    Expr getBase() { dynamic_type_exprs(this, result) }
  }

  class EnumIsCaseExpr extends @enum_is_case_expr, Expr {
    override string toString() { result = "EnumIsCaseExpr" }

    /**
     * Gets the sub expression of this enum is case expression.
     */
    Expr getSubExpr() { enum_is_case_exprs(this, result, _) }

    /**
     * Gets the element of this enum is case expression.
     */
    EnumElementDecl getElement() { enum_is_case_exprs(this, _, result) }
  }

  class ErrorExpr extends @error_expr, Expr, ErrorElement {
    override string toString() { result = "ErrorExpr" }
  }

  class ExplicitCastExpr extends @explicit_cast_expr, Expr {
    /**
     * Gets the sub expression of this explicit cast expression.
     */
    Expr getSubExpr() { explicit_cast_exprs(this, result) }
  }

  class ForceValueExpr extends @force_value_expr, Expr {
    override string toString() { result = "ForceValueExpr" }

    /**
     * Gets the sub expression of this force value expression.
     */
    Expr getSubExpr() { force_value_exprs(this, result) }
  }

  class IdentityExpr extends @identity_expr, Expr {
    /**
     * Gets the sub expression of this identity expression.
     */
    Expr getSubExpr() { identity_exprs(this, result) }
  }

  class IfExpr extends @if_expr, Expr {
    override string toString() { result = "IfExpr" }

    /**
     * Gets the condition of this if expression.
     */
    Expr getCondition() { if_exprs(this, result, _, _) }

    /**
     * Gets the then expression of this if expression.
     */
    Expr getThenExpr() { if_exprs(this, _, result, _) }

    /**
     * Gets the else expression of this if expression.
     */
    Expr getElseExpr() { if_exprs(this, _, _, result) }
  }

  class ImplicitConversionExpr extends @implicit_conversion_expr, Expr {
    /**
     * Gets the sub expression of this implicit conversion expression.
     */
    Expr getSubExpr() { implicit_conversion_exprs(this, result) }
  }

  class InOutExpr extends @in_out_expr, Expr {
    override string toString() { result = "InOutExpr" }

    /**
     * Gets the sub expression of this in out expression.
     */
    Expr getSubExpr() { in_out_exprs(this, result) }
  }

  class KeyPathApplicationExpr extends @key_path_application_expr, Expr {
    override string toString() { result = "KeyPathApplicationExpr" }

    /**
     * Gets the base of this key path application expression.
     */
    Expr getBase() { key_path_application_exprs(this, result, _) }

    /**
     * Gets the key path of this key path application expression.
     */
    Expr getKeyPath() { key_path_application_exprs(this, _, result) }
  }

  class KeyPathDotExpr extends @key_path_dot_expr, Expr {
    override string toString() { result = "KeyPathDotExpr" }
  }

  class KeyPathExpr extends @key_path_expr, Expr {
    override string toString() { result = "KeyPathExpr" }

    /**
     * Gets the root of this key path expression, if it exists.
     */
    TypeRepr getRoot() { key_path_expr_roots(this, result) }

    /**
     * Gets the parsed path of this key path expression, if it exists.
     */
    Expr getParsedPath() { key_path_expr_parsed_paths(this, result) }
  }

  class LazyInitializerExpr extends @lazy_initializer_expr, Expr {
    override string toString() { result = "LazyInitializerExpr" }

    /**
     * Gets the sub expression of this lazy initializer expression.
     */
    Expr getSubExpr() { lazy_initializer_exprs(this, result) }
  }

  class LiteralExpr extends @literal_expr, Expr { }

  class LookupExpr extends @lookup_expr, Expr {
    /**
     * Gets the base of this lookup expression.
     */
    Expr getBase() { lookup_exprs(this, result) }

    /**
     * Gets the member of this lookup expression, if it exists.
     */
    Decl getMember() { lookup_expr_members(this, result) }
  }

  class MakeTemporarilyEscapableExpr extends @make_temporarily_escapable_expr, Expr {
    override string toString() { result = "MakeTemporarilyEscapableExpr" }

    /**
     * Gets the escaping closure of this make temporarily escapable expression.
     */
    OpaqueValueExpr getEscapingClosure() { make_temporarily_escapable_exprs(this, result, _, _) }

    /**
     * Gets the nonescaping closure of this make temporarily escapable expression.
     */
    Expr getNonescapingClosure() { make_temporarily_escapable_exprs(this, _, result, _) }

    /**
     * Gets the sub expression of this make temporarily escapable expression.
     */
    Expr getSubExpr() { make_temporarily_escapable_exprs(this, _, _, result) }
  }

  class ObjCSelectorExpr extends @obj_c_selector_expr, Expr {
    override string toString() { result = "ObjCSelectorExpr" }

    /**
     * Gets the sub expression of this obj c selector expression.
     */
    Expr getSubExpr() { obj_c_selector_exprs(this, result, _) }

    /**
     * Gets the method of this obj c selector expression.
     */
    AbstractFunctionDecl getMethod() { obj_c_selector_exprs(this, _, result) }
  }

  class OneWayExpr extends @one_way_expr, Expr {
    override string toString() { result = "OneWayExpr" }

    /**
     * Gets the sub expression of this one way expression.
     */
    Expr getSubExpr() { one_way_exprs(this, result) }
  }

  class OpaqueValueExpr extends @opaque_value_expr, Expr {
    override string toString() { result = "OpaqueValueExpr" }
  }

  class OpenExistentialExpr extends @open_existential_expr, Expr {
    override string toString() { result = "OpenExistentialExpr" }

    /**
     * Gets the sub expression of this open existential expression.
     */
    Expr getSubExpr() { open_existential_exprs(this, result, _, _) }

    /**
     * Gets the existential of this open existential expression.
     */
    Expr getExistential() { open_existential_exprs(this, _, result, _) }

    /**
     * Gets the opaque expression of this open existential expression.
     */
    OpaqueValueExpr getOpaqueExpr() { open_existential_exprs(this, _, _, result) }
  }

  class OptionalEvaluationExpr extends @optional_evaluation_expr, Expr {
    override string toString() { result = "OptionalEvaluationExpr" }

    /**
     * Gets the sub expression of this optional evaluation expression.
     */
    Expr getSubExpr() { optional_evaluation_exprs(this, result) }
  }

  class OtherConstructorDeclRefExpr extends @other_constructor_decl_ref_expr, Expr {
    override string toString() { result = "OtherConstructorDeclRefExpr" }

    /**
     * Gets the constructor declaration of this other constructor declaration reference expression.
     */
    ConstructorDecl getConstructorDecl() { other_constructor_decl_ref_exprs(this, result) }
  }

  class OverloadedDeclRefExpr extends @overloaded_decl_ref_expr, Expr, ErrorElement {
    override string toString() { result = "OverloadedDeclRefExpr" }

    /**
     * Gets the `index`th possible declaration of this overloaded declaration reference expression (0-based).
     */
    ValueDecl getPossibleDeclaration(int index) {
      overloaded_decl_ref_expr_possible_declarations(this, index, result)
    }
  }

  class PropertyWrapperValuePlaceholderExpr extends @property_wrapper_value_placeholder_expr, Expr {
    override string toString() { result = "PropertyWrapperValuePlaceholderExpr" }

    /**
     * Gets the wrapped value of this property wrapper value placeholder expression, if it exists.
     */
    Expr getWrappedValue() { property_wrapper_value_placeholder_expr_wrapped_values(this, result) }

    /**
     * Gets the placeholder of this property wrapper value placeholder expression.
     */
    OpaqueValueExpr getPlaceholder() { property_wrapper_value_placeholder_exprs(this, result) }
  }

  class RebindSelfInConstructorExpr extends @rebind_self_in_constructor_expr, Expr {
    override string toString() { result = "RebindSelfInConstructorExpr" }

    /**
     * Gets the sub expression of this rebind self in constructor expression.
     */
    Expr getSubExpr() { rebind_self_in_constructor_exprs(this, result, _) }

    /**
     * Gets the self of this rebind self in constructor expression.
     */
    VarDecl getSelf() { rebind_self_in_constructor_exprs(this, _, result) }
  }

  class SequenceExpr extends @sequence_expr, Expr {
    override string toString() { result = "SequenceExpr" }

    /**
     * Gets the `index`th element of this sequence expression (0-based).
     */
    Expr getElement(int index) { sequence_expr_elements(this, index, result) }
  }

  class SuperRefExpr extends @super_ref_expr, Expr {
    override string toString() { result = "SuperRefExpr" }

    /**
     * Gets the self of this super reference expression.
     */
    VarDecl getSelf() { super_ref_exprs(this, result) }
  }

  class TapExpr extends @tap_expr, Expr {
    override string toString() { result = "TapExpr" }

    /**
     * Gets the sub expression of this tap expression, if it exists.
     */
    Expr getSubExpr() { tap_expr_sub_exprs(this, result) }

    /**
     * Gets the body of this tap expression.
     */
    BraceStmt getBody() { tap_exprs(this, result, _) }

    /**
     * Gets the variable of this tap expression.
     */
    VarDecl getVar() { tap_exprs(this, _, result) }
  }

  class TupleElementExpr extends @tuple_element_expr, Expr {
    override string toString() { result = "TupleElementExpr" }

    /**
     * Gets the sub expression of this tuple element expression.
     */
    Expr getSubExpr() { tuple_element_exprs(this, result, _) }

    /**
     * Gets the index of this tuple element expression.
     */
    int getIndex() { tuple_element_exprs(this, _, result) }
  }

  class TupleExpr extends @tuple_expr, Expr {
    override string toString() { result = "TupleExpr" }

    /**
     * Gets the `index`th element of this tuple expression (0-based).
     */
    Expr getElement(int index) { tuple_expr_elements(this, index, result) }
  }

  class TypeExpr extends @type_expr, Expr {
    override string toString() { result = "TypeExpr" }

    /**
     * Gets the type representation of this type expression, if it exists.
     */
    TypeRepr getTypeRepr() { type_expr_type_reprs(this, result) }
  }

  class UnresolvedDeclRefExpr extends @unresolved_decl_ref_expr, Expr, ErrorElement {
    override string toString() { result = "UnresolvedDeclRefExpr" }

    /**
     * Gets the name of this unresolved declaration reference expression, if it exists.
     */
    string getName() { unresolved_decl_ref_expr_names(this, result) }
  }

  class UnresolvedDotExpr extends @unresolved_dot_expr, Expr, ErrorElement {
    override string toString() { result = "UnresolvedDotExpr" }

    /**
     * Gets the base of this unresolved dot expression.
     */
    Expr getBase() { unresolved_dot_exprs(this, result, _) }

    /**
     * Gets the name of this unresolved dot expression.
     */
    string getName() { unresolved_dot_exprs(this, _, result) }
  }

  class UnresolvedMemberExpr extends @unresolved_member_expr, Expr, ErrorElement {
    override string toString() { result = "UnresolvedMemberExpr" }

    /**
     * Gets the name of this unresolved member expression.
     */
    string getName() { unresolved_member_exprs(this, result) }
  }

  class UnresolvedPatternExpr extends @unresolved_pattern_expr, Expr, ErrorElement {
    override string toString() { result = "UnresolvedPatternExpr" }

    /**
     * Gets the sub pattern of this unresolved pattern expression.
     */
    Pattern getSubPattern() { unresolved_pattern_exprs(this, result) }
  }

  class UnresolvedSpecializeExpr extends @unresolved_specialize_expr, Expr, ErrorElement {
    override string toString() { result = "UnresolvedSpecializeExpr" }

    /**
     * Gets the sub expression of this unresolved specialize expression.
     */
    Expr getSubExpr() { unresolved_specialize_exprs(this, result) }
  }

  class VarargExpansionExpr extends @vararg_expansion_expr, Expr {
    override string toString() { result = "VarargExpansionExpr" }

    /**
     * Gets the sub expression of this vararg expansion expression.
     */
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

    /**
     * Gets the `index`th element of this array expression (0-based).
     */
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
    ImplicitConversionExpr
  {
    override string toString() { result = "CollectionUpcastConversionExpr" }
  }

  class ConditionalBridgeFromObjCExpr extends @conditional_bridge_from_obj_c_expr,
    ImplicitConversionExpr
  {
    override string toString() { result = "ConditionalBridgeFromObjCExpr" }
  }

  class CovariantFunctionConversionExpr extends @covariant_function_conversion_expr,
    ImplicitConversionExpr
  {
    override string toString() { result = "CovariantFunctionConversionExpr" }
  }

  class CovariantReturnConversionExpr extends @covariant_return_conversion_expr,
    ImplicitConversionExpr
  {
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

    /**
     * Gets the `index`th element of this dictionary expression (0-based).
     */
    Expr getElement(int index) { dictionary_expr_elements(this, index, result) }
  }

  class DifferentiableFunctionExpr extends @differentiable_function_expr, ImplicitConversionExpr {
    override string toString() { result = "DifferentiableFunctionExpr" }
  }

  class DifferentiableFunctionExtractOriginalExpr extends @differentiable_function_extract_original_expr,
    ImplicitConversionExpr
  {
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
    ImplicitConversionExpr
  {
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

    /**
     * Gets the interpolation expression of this interpolated string literal expression, if it exists.
     */
    OpaqueValueExpr getInterpolationExpr() {
      interpolated_string_literal_expr_interpolation_exprs(this, result)
    }

    /**
     * Gets the interpolation count expression of this interpolated string literal expression, if it exists.
     */
    Expr getInterpolationCountExpr() {
      interpolated_string_literal_expr_interpolation_count_exprs(this, result)
    }

    /**
     * Gets the literal capacity expression of this interpolated string literal expression, if it exists.
     */
    Expr getLiteralCapacityExpr() {
      interpolated_string_literal_expr_literal_capacity_exprs(this, result)
    }

    /**
     * Gets the appending expression of this interpolated string literal expression, if it exists.
     */
    TapExpr getAppendingExpr() { interpolated_string_literal_expr_appending_exprs(this, result) }
  }

  class LinearFunctionExpr extends @linear_function_expr, ImplicitConversionExpr {
    override string toString() { result = "LinearFunctionExpr" }
  }

  class LinearFunctionExtractOriginalExpr extends @linear_function_extract_original_expr,
    ImplicitConversionExpr
  {
    override string toString() { result = "LinearFunctionExtractOriginalExpr" }
  }

  class LinearToDifferentiableFunctionExpr extends @linear_to_differentiable_function_expr,
    ImplicitConversionExpr
  {
    override string toString() { result = "LinearToDifferentiableFunctionExpr" }
  }

  class LoadExpr extends @load_expr, ImplicitConversionExpr {
    override string toString() { result = "LoadExpr" }
  }

  class MemberRefExpr extends @member_ref_expr, LookupExpr {
    override string toString() { result = "MemberRefExpr" }

    /**
     * Holds if this member reference expression has direct to storage semantics.
     */
    predicate hasDirectToStorageSemantics() {
      member_ref_expr_has_direct_to_storage_semantics(this)
    }

    /**
     * Holds if this member reference expression has direct to implementation semantics.
     */
    predicate hasDirectToImplementationSemantics() {
      member_ref_expr_has_direct_to_implementation_semantics(this)
    }

    /**
     * Holds if this member reference expression has ordinary semantics.
     */
    predicate hasOrdinarySemantics() { member_ref_expr_has_ordinary_semantics(this) }

    /**
     * Holds if this member reference expression has distributed thunk semantics.
     */
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

    /**
     * Gets the kind of this object literal expression.
     *
     * This is 0 for `#fileLiteral`, 1 for `#imageLiteral` and 2 for `#colorLiteral`.
     */
    int getKind() { object_literal_exprs(this, result) }

    /**
     * Gets the `index`th argument of this object literal expression (0-based).
     */
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
    ImplicitConversionExpr
  {
    override string toString() { result = "ProtocolMetatypeToObjectExpr" }
  }

  class RegexLiteralExpr extends @regex_literal_expr, LiteralExpr {
    override string toString() { result = "RegexLiteralExpr" }

    /**
     * Gets the pattern of this regular expression.
     */
    string getPattern() { regex_literal_exprs(this, result, _) }

    /**
     * Gets the version of the internal regular expression language being used by Swift.
     */
    int getVersion() { regex_literal_exprs(this, _, result) }
  }

  class SelfApplyExpr extends @self_apply_expr, ApplyExpr {
    /**
     * Gets the base of this self apply expression.
     */
    Expr getBase() { self_apply_exprs(this, result) }
  }

  class StringToPointerExpr extends @string_to_pointer_expr, ImplicitConversionExpr {
    override string toString() { result = "StringToPointerExpr" }
  }

  class SubscriptExpr extends @subscript_expr, LookupExpr {
    override string toString() { result = "SubscriptExpr" }

    /**
     * Gets the `index`th argument of this subscript expression (0-based).
     */
    Argument getArgument(int index) { subscript_expr_arguments(this, index, result) }

    /**
     * Holds if this subscript expression has direct to storage semantics.
     */
    predicate hasDirectToStorageSemantics() { subscript_expr_has_direct_to_storage_semantics(this) }

    /**
     * Holds if this subscript expression has direct to implementation semantics.
     */
    predicate hasDirectToImplementationSemantics() {
      subscript_expr_has_direct_to_implementation_semantics(this)
    }

    /**
     * Holds if this subscript expression has ordinary semantics.
     */
    predicate hasOrdinarySemantics() { subscript_expr_has_ordinary_semantics(this) }

    /**
     * Holds if this subscript expression has distributed thunk semantics.
     */
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
    ErrorElement
  {
    override string toString() { result = "UnresolvedMemberChainResultExpr" }
  }

  class UnresolvedTypeConversionExpr extends @unresolved_type_conversion_expr,
    ImplicitConversionExpr, ErrorElement
  {
    override string toString() { result = "UnresolvedTypeConversionExpr" }
  }

  class BooleanLiteralExpr extends @boolean_literal_expr, BuiltinLiteralExpr {
    override string toString() { result = "BooleanLiteralExpr" }

    /**
     * Gets the value of this boolean literal expression.
     */
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

    /**
     * Gets the kind of this magic identifier literal expression.
     */
    string getKind() { magic_identifier_literal_exprs(this, result) }
  }

  class NumberLiteralExpr extends @number_literal_expr, BuiltinLiteralExpr { }

  class StringLiteralExpr extends @string_literal_expr, BuiltinLiteralExpr {
    override string toString() { result = "StringLiteralExpr" }

    /**
     * Gets the value of this string literal expression.
     */
    string getValue() { string_literal_exprs(this, result) }
  }

  class FloatLiteralExpr extends @float_literal_expr, NumberLiteralExpr {
    override string toString() { result = "FloatLiteralExpr" }

    /**
     * Gets the string value of this float literal expression.
     */
    string getStringValue() { float_literal_exprs(this, result) }
  }

  class IntegerLiteralExpr extends @integer_literal_expr, NumberLiteralExpr {
    override string toString() { result = "IntegerLiteralExpr" }

    /**
     * Gets the string value of this integer literal expression.
     */
    string getStringValue() { integer_literal_exprs(this, result) }
  }

  class Pattern extends @pattern, AstNode { }

  class AnyPattern extends @any_pattern, Pattern {
    override string toString() { result = "AnyPattern" }
  }

  class BindingPattern extends @binding_pattern, Pattern {
    override string toString() { result = "BindingPattern" }

    /**
     * Gets the sub pattern of this binding pattern.
     */
    Pattern getSubPattern() { binding_patterns(this, result) }
  }

  class BoolPattern extends @bool_pattern, Pattern {
    override string toString() { result = "BoolPattern" }

    /**
     * Gets the value of this bool pattern.
     */
    boolean getValue() { bool_patterns(this, result) }
  }

  class EnumElementPattern extends @enum_element_pattern, Pattern {
    override string toString() { result = "EnumElementPattern" }

    /**
     * Gets the element of this enum element pattern.
     */
    EnumElementDecl getElement() { enum_element_patterns(this, result) }

    /**
     * Gets the sub pattern of this enum element pattern, if it exists.
     */
    Pattern getSubPattern() { enum_element_pattern_sub_patterns(this, result) }
  }

  class ExprPattern extends @expr_pattern, Pattern {
    override string toString() { result = "ExprPattern" }

    /**
     * Gets the sub expression of this expression pattern.
     */
    Expr getSubExpr() { expr_patterns(this, result) }
  }

  class IsPattern extends @is_pattern, Pattern {
    override string toString() { result = "IsPattern" }

    /**
     * Gets the cast type representation of this is pattern, if it exists.
     */
    TypeRepr getCastTypeRepr() { is_pattern_cast_type_reprs(this, result) }

    /**
     * Gets the sub pattern of this is pattern, if it exists.
     */
    Pattern getSubPattern() { is_pattern_sub_patterns(this, result) }
  }

  class NamedPattern extends @named_pattern, Pattern {
    override string toString() { result = "NamedPattern" }

    /**
     * Gets the name of this named pattern.
     */
    string getName() { named_patterns(this, result) }
  }

  class OptionalSomePattern extends @optional_some_pattern, Pattern {
    override string toString() { result = "OptionalSomePattern" }

    /**
     * Gets the sub pattern of this optional some pattern.
     */
    Pattern getSubPattern() { optional_some_patterns(this, result) }
  }

  class ParenPattern extends @paren_pattern, Pattern {
    override string toString() { result = "ParenPattern" }

    /**
     * Gets the sub pattern of this paren pattern.
     */
    Pattern getSubPattern() { paren_patterns(this, result) }
  }

  class TuplePattern extends @tuple_pattern, Pattern {
    override string toString() { result = "TuplePattern" }

    /**
     * Gets the `index`th element of this tuple pattern (0-based).
     */
    Pattern getElement(int index) { tuple_pattern_elements(this, index, result) }
  }

  class TypedPattern extends @typed_pattern, Pattern {
    override string toString() { result = "TypedPattern" }

    /**
     * Gets the sub pattern of this typed pattern.
     */
    Pattern getSubPattern() { typed_patterns(this, result) }

    /**
     * Gets the type representation of this typed pattern, if it exists.
     */
    TypeRepr getTypeRepr() { typed_pattern_type_reprs(this, result) }
  }

  class CaseLabelItem extends @case_label_item, AstNode {
    override string toString() { result = "CaseLabelItem" }

    /**
     * Gets the pattern of this case label item.
     */
    Pattern getPattern() { case_label_items(this, result) }

    /**
     * Gets the guard of this case label item, if it exists.
     */
    Expr getGuard() { case_label_item_guards(this, result) }
  }

  class ConditionElement extends @condition_element, AstNode {
    override string toString() { result = "ConditionElement" }

    /**
     * Gets the boolean of this condition element, if it exists.
     */
    Expr getBoolean() { condition_element_booleans(this, result) }

    /**
     * Gets the pattern of this condition element, if it exists.
     */
    Pattern getPattern() { condition_element_patterns(this, result) }

    /**
     * Gets the initializer of this condition element, if it exists.
     */
    Expr getInitializer() { condition_element_initializers(this, result) }

    /**
     * Gets the availability of this condition element, if it exists.
     */
    AvailabilityInfo getAvailability() { condition_element_availabilities(this, result) }
  }

  class Stmt extends @stmt, AstNode { }

  class StmtCondition extends @stmt_condition, AstNode {
    override string toString() { result = "StmtCondition" }

    /**
     * Gets the `index`th element of this statement condition (0-based).
     */
    ConditionElement getElement(int index) { stmt_condition_elements(this, index, result) }
  }

  class BraceStmt extends @brace_stmt, Stmt {
    override string toString() { result = "BraceStmt" }

    /**
     * Gets the `index`th element of this brace statement (0-based).
     */
    AstNode getElement(int index) { brace_stmt_elements(this, index, result) }
  }

  class BreakStmt extends @break_stmt, Stmt {
    override string toString() { result = "BreakStmt" }

    /**
     * Gets the target name of this break statement, if it exists.
     */
    string getTargetName() { break_stmt_target_names(this, result) }

    /**
     * Gets the target of this break statement, if it exists.
     */
    Stmt getTarget() { break_stmt_targets(this, result) }
  }

  class CaseStmt extends @case_stmt, Stmt {
    override string toString() { result = "CaseStmt" }

    /**
     * Gets the body of this case statement.
     */
    Stmt getBody() { case_stmts(this, result) }

    /**
     * Gets the `index`th label of this case statement (0-based).
     */
    CaseLabelItem getLabel(int index) { case_stmt_labels(this, index, result) }

    /**
     * Gets the `index`th variable of this case statement (0-based).
     */
    VarDecl getVariable(int index) { case_stmt_variables(this, index, result) }
  }

  class ContinueStmt extends @continue_stmt, Stmt {
    override string toString() { result = "ContinueStmt" }

    /**
     * Gets the target name of this continue statement, if it exists.
     */
    string getTargetName() { continue_stmt_target_names(this, result) }

    /**
     * Gets the target of this continue statement, if it exists.
     */
    Stmt getTarget() { continue_stmt_targets(this, result) }
  }

  class DeferStmt extends @defer_stmt, Stmt {
    override string toString() { result = "DeferStmt" }

    /**
     * Gets the body of this defer statement.
     */
    BraceStmt getBody() { defer_stmts(this, result) }
  }

  class FailStmt extends @fail_stmt, Stmt {
    override string toString() { result = "FailStmt" }
  }

  class FallthroughStmt extends @fallthrough_stmt, Stmt {
    override string toString() { result = "FallthroughStmt" }

    /**
     * Gets the fallthrough source of this fallthrough statement.
     */
    CaseStmt getFallthroughSource() { fallthrough_stmts(this, result, _) }

    /**
     * Gets the fallthrough dest of this fallthrough statement.
     */
    CaseStmt getFallthroughDest() { fallthrough_stmts(this, _, result) }
  }

  class LabeledStmt extends @labeled_stmt, Stmt {
    /**
     * Gets the label of this labeled statement, if it exists.
     */
    string getLabel() { labeled_stmt_labels(this, result) }
  }

  class PoundAssertStmt extends @pound_assert_stmt, Stmt {
    override string toString() { result = "PoundAssertStmt" }

    /**
     * Gets the condition of this pound assert statement.
     */
    Expr getCondition() { pound_assert_stmts(this, result, _) }

    /**
     * Gets the message of this pound assert statement.
     */
    string getMessage() { pound_assert_stmts(this, _, result) }
  }

  class ReturnStmt extends @return_stmt, Stmt {
    override string toString() { result = "ReturnStmt" }

    /**
     * Gets the result of this return statement, if it exists.
     */
    Expr getResult() { return_stmt_results(this, result) }
  }

  class ThrowStmt extends @throw_stmt, Stmt {
    override string toString() { result = "ThrowStmt" }

    /**
     * Gets the sub expression of this throw statement.
     */
    Expr getSubExpr() { throw_stmts(this, result) }
  }

  class YieldStmt extends @yield_stmt, Stmt {
    override string toString() { result = "YieldStmt" }

    /**
     * Gets the `index`th result of this yield statement (0-based).
     */
    Expr getResult(int index) { yield_stmt_results(this, index, result) }
  }

  class DoCatchStmt extends @do_catch_stmt, LabeledStmt {
    override string toString() { result = "DoCatchStmt" }

    /**
     * Gets the body of this do catch statement.
     */
    Stmt getBody() { do_catch_stmts(this, result) }

    /**
     * Gets the `index`th catch of this do catch statement (0-based).
     */
    CaseStmt getCatch(int index) { do_catch_stmt_catches(this, index, result) }
  }

  class DoStmt extends @do_stmt, LabeledStmt {
    override string toString() { result = "DoStmt" }

    /**
     * Gets the body of this do statement.
     */
    BraceStmt getBody() { do_stmts(this, result) }
  }

  class ForEachStmt extends @for_each_stmt, LabeledStmt {
    override string toString() { result = "ForEachStmt" }

    /**
     * Gets the pattern of this for each statement.
     */
    Pattern getPattern() { for_each_stmts(this, result, _, _) }

    /**
     * Gets the sequence of this for each statement.
     */
    Expr getSequence() { for_each_stmts(this, _, result, _) }

    /**
     * Gets the where of this for each statement, if it exists.
     */
    Expr getWhere() { for_each_stmt_wheres(this, result) }

    /**
     * Gets the body of this for each statement.
     */
    BraceStmt getBody() { for_each_stmts(this, _, _, result) }
  }

  class LabeledConditionalStmt extends @labeled_conditional_stmt, LabeledStmt {
    /**
     * Gets the condition of this labeled conditional statement.
     */
    StmtCondition getCondition() { labeled_conditional_stmts(this, result) }
  }

  class RepeatWhileStmt extends @repeat_while_stmt, LabeledStmt {
    override string toString() { result = "RepeatWhileStmt" }

    /**
     * Gets the condition of this repeat while statement.
     */
    Expr getCondition() { repeat_while_stmts(this, result, _) }

    /**
     * Gets the body of this repeat while statement.
     */
    Stmt getBody() { repeat_while_stmts(this, _, result) }
  }

  class SwitchStmt extends @switch_stmt, LabeledStmt {
    override string toString() { result = "SwitchStmt" }

    /**
     * Gets the expression of this switch statement.
     */
    Expr getExpr() { switch_stmts(this, result) }

    /**
     * Gets the `index`th case of this switch statement (0-based).
     */
    CaseStmt getCase(int index) { switch_stmt_cases(this, index, result) }
  }

  class GuardStmt extends @guard_stmt, LabeledConditionalStmt {
    override string toString() { result = "GuardStmt" }

    /**
     * Gets the body of this guard statement.
     */
    BraceStmt getBody() { guard_stmts(this, result) }
  }

  class IfStmt extends @if_stmt, LabeledConditionalStmt {
    override string toString() { result = "IfStmt" }

    /**
     * Gets the then of this if statement.
     */
    Stmt getThen() { if_stmts(this, result) }

    /**
     * Gets the else of this if statement, if it exists.
     */
    Stmt getElse() { if_stmt_elses(this, result) }
  }

  class WhileStmt extends @while_stmt, LabeledConditionalStmt {
    override string toString() { result = "WhileStmt" }

    /**
     * Gets the body of this while statement.
     */
    Stmt getBody() { while_stmts(this, result) }
  }

  class Type extends @type, Element {
    /**
     * Gets the name of this type.
     */
    string getName() { types(this, result, _) }

    /**
     * Gets the canonical type of this type.
     */
    Type getCanonicalType() { types(this, _, result) }
  }

  class TypeRepr extends @type_repr, AstNode {
    override string toString() { result = "TypeRepr" }

    /**
     * Gets the type of this type representation.
     */
    Type getType() { type_reprs(this, result) }
  }

  class AnyFunctionType extends @any_function_type, Type {
    /**
     * Gets the result of this function type.
     */
    Type getResult() { any_function_types(this, result) }

    /**
     * Gets the `index`th parameter type of this function type (0-based).
     */
    Type getParamType(int index) { any_function_type_param_types(this, index, result) }

    /**
     * Holds if this type refers to a throwing function.
     */
    predicate isThrowing() { any_function_type_is_throwing(this) }

    /**
     * Holds if this type refers to an `async` function.
     */
    predicate isAsync() { any_function_type_is_async(this) }
  }

  class AnyGenericType extends @any_generic_type, Type {
    /**
     * Gets the parent of this any generic type, if it exists.
     */
    Type getParent() { any_generic_type_parents(this, result) }

    /**
     * Gets the declaration of this any generic type.
     */
    GenericTypeDecl getDeclaration() { any_generic_types(this, result) }
  }

  class AnyMetatypeType extends @any_metatype_type, Type { }

  class BuiltinType extends @builtin_type, Type { }

  class DependentMemberType extends @dependent_member_type, Type {
    override string toString() { result = "DependentMemberType" }

    /**
     * Gets the base type of this dependent member type.
     */
    Type getBaseType() { dependent_member_types(this, result, _) }

    /**
     * Gets the associated type declaration of this dependent member type.
     */
    AssociatedTypeDecl getAssociatedTypeDecl() { dependent_member_types(this, _, result) }
  }

  class DynamicSelfType extends @dynamic_self_type, Type {
    override string toString() { result = "DynamicSelfType" }

    /**
     * Gets the static self type of this dynamic self type.
     */
    Type getStaticSelfType() { dynamic_self_types(this, result) }
  }

  class ErrorType extends @error_type, Type, ErrorElement {
    override string toString() { result = "ErrorType" }
  }

  class ExistentialType extends @existential_type, Type {
    override string toString() { result = "ExistentialType" }

    /**
     * Gets the constraint of this existential type.
     */
    Type getConstraint() { existential_types(this, result) }
  }

  class InOutType extends @in_out_type, Type {
    override string toString() { result = "InOutType" }

    /**
     * Gets the object type of this in out type.
     */
    Type getObjectType() { in_out_types(this, result) }
  }

  class LValueType extends @l_value_type, Type {
    override string toString() { result = "LValueType" }

    /**
     * Gets the object type of this l value type.
     */
    Type getObjectType() { l_value_types(this, result) }
  }

  class ModuleType extends @module_type, Type {
    override string toString() { result = "ModuleType" }

    /**
     * Gets the module of this module type.
     */
    ModuleDecl getModule() { module_types(this, result) }
  }

  class ParameterizedProtocolType extends @parameterized_protocol_type, Type {
    override string toString() { result = "ParameterizedProtocolType" }

    /**
     * Gets the base of this parameterized protocol type.
     */
    ProtocolType getBase() { parameterized_protocol_types(this, result) }

    /**
     * Gets the `index`th argument of this parameterized protocol type (0-based).
     */
    Type getArg(int index) { parameterized_protocol_type_args(this, index, result) }
  }

  class ProtocolCompositionType extends @protocol_composition_type, Type {
    override string toString() { result = "ProtocolCompositionType" }

    /**
     * Gets the `index`th member of this protocol composition type (0-based).
     */
    Type getMember(int index) { protocol_composition_type_members(this, index, result) }
  }

  class ReferenceStorageType extends @reference_storage_type, Type {
    /**
     * Gets the referent type of this reference storage type.
     */
    Type getReferentType() { reference_storage_types(this, result) }
  }

  class SubstitutableType extends @substitutable_type, Type { }

  class SugarType extends @sugar_type, Type { }

  class TupleType extends @tuple_type, Type {
    override string toString() { result = "TupleType" }

    /**
     * Gets the `index`th type of this tuple type (0-based).
     */
    Type getType(int index) { tuple_type_types(this, index, result) }

    /**
     * Gets the `index`th name of this tuple type (0-based), if it exists.
     */
    string getName(int index) { tuple_type_names(this, index, result) }
  }

  class UnresolvedType extends @unresolved_type, Type, ErrorElement {
    override string toString() { result = "UnresolvedType" }
  }

  class AnyBuiltinIntegerType extends @any_builtin_integer_type, BuiltinType { }

  class ArchetypeType extends @archetype_type, SubstitutableType {
    /**
     * Gets the interface type of this archetype type.
     */
    Type getInterfaceType() { archetype_types(this, result) }

    /**
     * Gets the superclass of this archetype type, if it exists.
     */
    Type getSuperclass() { archetype_type_superclasses(this, result) }

    /**
     * Gets the `index`th protocol of this archetype type (0-based).
     */
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

    /**
     * Gets the `index`th type parameter of this generic type (0-based).
     */
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
    AnyGenericType
  { }

  class ParenType extends @paren_type, SugarType {
    override string toString() { result = "ParenType" }

    /**
     * Gets the type of this paren type.
     */
    Type getType() { paren_types(this, result) }
  }

  class SyntaxSugarType extends @syntax_sugar_type, SugarType { }

  class TypeAliasType extends @type_alias_type, SugarType {
    override string toString() { result = "TypeAliasType" }

    /**
     * Gets the declaration of this type alias type.
     */
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
    /**
     * Gets the `index`th argument type of this bound generic type (0-based).
     */
    Type getArgType(int index) { bound_generic_type_arg_types(this, index, result) }
  }

  class BuiltinIntegerLiteralType extends @builtin_integer_literal_type, AnyBuiltinIntegerType {
    override string toString() { result = "BuiltinIntegerLiteralType" }
  }

  class BuiltinIntegerType extends @builtin_integer_type, AnyBuiltinIntegerType {
    override string toString() { result = "BuiltinIntegerType" }

    /**
     * Gets the width of this builtin integer type, if it exists.
     */
    int getWidth() { builtin_integer_type_widths(this, result) }
  }

  class DictionaryType extends @dictionary_type, SyntaxSugarType {
    override string toString() { result = "DictionaryType" }

    /**
     * Gets the key type of this dictionary type.
     */
    Type getKeyType() { dictionary_types(this, result, _) }

    /**
     * Gets the value type of this dictionary type.
     */
    Type getValueType() { dictionary_types(this, _, result) }
  }

  class NominalType extends @nominal_type, NominalOrBoundGenericNominalType { }

  class OpaqueTypeArchetypeType extends @opaque_type_archetype_type, ArchetypeType {
    override string toString() { result = "OpaqueTypeArchetypeType" }

    /**
     * Gets the declaration of this opaque type archetype type.
     */
    OpaqueTypeDecl getDeclaration() { opaque_type_archetype_types(this, result) }
  }

  class OpenedArchetypeType extends @opened_archetype_type, ArchetypeType {
    override string toString() { result = "OpenedArchetypeType" }
  }

  class PrimaryArchetypeType extends @primary_archetype_type, ArchetypeType {
    override string toString() { result = "PrimaryArchetypeType" }
  }

  class UnarySyntaxSugarType extends @unary_syntax_sugar_type, SyntaxSugarType {
    /**
     * Gets the base type of this unary syntax sugar type.
     */
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
