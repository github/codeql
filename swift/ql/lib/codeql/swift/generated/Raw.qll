/**
 * INTERNAL: Do not use.
 * This module holds thin fully generated class definitions around DB entities.
 */
module Raw {
  /**
   * INTERNAL: Do not use.
   */
  class Element extends @element {
    string toString() { none() }

    /**
     * Holds if this element is unknown.
     */
    predicate isUnknown() { element_is_unknown(this) }
  }

  /**
   * INTERNAL: Do not use.
   */
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

  /**
   * INTERNAL: Do not use.
   */
  class Locatable extends @locatable, Element {
    /**
     * Gets the location associated with this element in the code, if it exists.
     */
    Location getLocation() { locatable_locations(this, result) }
  }

  /**
   * INTERNAL: Do not use.
   */
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

  /**
   * INTERNAL: Do not use.
   */
  class AstNode extends @ast_node, Locatable { }

  /**
   * INTERNAL: Do not use.
   */
  class Comment extends @comment, Locatable {
    override string toString() { result = "Comment" }

    /**
     * Gets the text of this comment.
     */
    string getText() { comments(this, result) }
  }

  /**
   * INTERNAL: Do not use.
   */
  class DbFile extends @db_file, File {
    override string toString() { result = "DbFile" }
  }

  /**
   * INTERNAL: Do not use.
   */
  class DbLocation extends @db_location, Location {
    override string toString() { result = "DbLocation" }
  }

  /**
   * INTERNAL: Do not use.
   */
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

  /**
   * INTERNAL: Do not use.
   * The superclass of all elements indicating some kind of error.
   */
  class ErrorElement extends @error_element, Locatable { }

  /**
   * INTERNAL: Do not use.
   * An availability condition of an `if`, `while`, or `guard` statements.
   *
   * Examples:
   * ```
   * if #available(iOS 12, *) {
   *   // Runs on iOS 12 and above
   * } else {
   *   // Runs only anything below iOS 12
   * }
   * if #unavailable(macOS 10.14, *) {
   *   // Runs only on macOS 10 and below
   * }
   * ```
   */
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

  /**
   * INTERNAL: Do not use.
   * An availability spec, that is, part of an `AvailabilityInfo` condition. For example `iOS 12` and `*` in:
   * ```
   * if #available(iOS 12, *)
   * ```
   */
  class AvailabilitySpec extends @availability_spec, AstNode { }

  /**
   * INTERNAL: Do not use.
   */
  class Callable extends @callable, AstNode {
    /**
     * Gets the name of this callable, if it exists.
     *
     * The name includes argument labels of the callable, for example `myFunction(arg:)`.
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

  /**
   * INTERNAL: Do not use.
   * A component of a `KeyPathExpr`.
   */
  class KeyPathComponent extends @key_path_component, AstNode {
    override string toString() { result = "KeyPathComponent" }

    /**
     * Gets the kind of key path component.
     *
     * INTERNAL: Do not use.
     *
     * This is 3 for properties, 4 for array and dictionary subscripts, 5 for optional forcing
     * (`!`), 6 for optional chaining (`?`), 7 for implicit optional wrapping, 8 for `self`,
     * and 9 for tuple element indexing.
     *
     * The following values should not appear: 0 for invalid components, 1 for unresolved
     * properties, 2 for unresolved subscripts, 10 for #keyPath dictionary keys, and 11 for
     * implicit IDE code completion data.
     */
    int getKind() { key_path_components(this, result, _) }

    /**
     * Gets the `index`th argument to an array or dictionary subscript expression (0-based).
     */
    Argument getSubscriptArgument(int index) {
      key_path_component_subscript_arguments(this, index, result)
    }

    /**
     * Gets the tuple index of this key path component, if it exists.
     */
    int getTupleIndex() { key_path_component_tuple_indices(this, result) }

    /**
     * Gets the property or subscript operator, if it exists.
     */
    ValueDecl getDeclRef() { key_path_component_decl_refs(this, result) }

    /**
     * Gets the return type of this component application.
     *
     * An optional-chaining component has a non-optional type to feed into the rest of the key
     * path; an optional-wrapping component is inserted if required to produce an optional type
     * as the final output.
     */
    Type getComponentType() { key_path_components(this, _, result) }
  }

  /**
   * INTERNAL: Do not use.
   * The role of a macro, for example #freestanding(declaration) or @attached(member).
   */
  class MacroRole extends @macro_role, AstNode {
    override string toString() { result = "MacroRole" }

    /**
     * Gets the kind of this macro role (declaration, expression, member, etc.).
     */
    int getKind() { macro_roles(this, result, _) }

    /**
     * Gets the #freestanding or @attached.
     */
    int getMacroSyntax() { macro_roles(this, _, result) }

    /**
     * Gets the `index`th conformance of this macro role (0-based).
     */
    TypeExpr getConformance(int index) { macro_role_conformances(this, index, result) }

    /**
     * Gets the `index`th name of this macro role (0-based).
     */
    string getName(int index) { macro_role_names(this, index, result) }
  }

  /**
   * INTERNAL: Do not use.
   */
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

    /**
     * Gets the `index`th child of this unspecified element (0-based).
     *
     * These will be present only in certain downgraded databases.
     */
    AstNode getChild(int index) { unspecified_element_children(this, index, result) }
  }

  /**
   * INTERNAL: Do not use.
   * A wildcard availability spec `*`
   */
  class OtherAvailabilitySpec extends @other_availability_spec, AvailabilitySpec {
    override string toString() { result = "OtherAvailabilitySpec" }
  }

  /**
   * INTERNAL: Do not use.
   * An availability spec based on platform and version, for example `macOS 12` or `watchOS 14`
   */
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

  /**
   * INTERNAL: Do not use.
   */
  class Decl extends @decl, AstNode {
    /**
     * Gets the module of this declaration.
     */
    ModuleDecl getModule() { decls(this, result) }

    /**
     * Gets the `index`th member of this declaration (0-based).
     *
     * Prefer to use more specific methods (such as `EnumDecl.getEnumElement`) rather than relying
     * on the order of members given by `getMember`. In some cases the order of members may not
     * align with expectations, and could change in future releases.
     */
    Decl getMember(int index) { decl_members(this, index, result) }
  }

  /**
   * INTERNAL: Do not use.
   */
  class GenericContext extends @generic_context, Element {
    /**
     * Gets the `index`th generic type parameter of this generic context (0-based).
     */
    GenericTypeParamDecl getGenericTypeParam(int index) {
      generic_context_generic_type_params(this, index, result)
    }
  }

  /**
   * INTERNAL: Do not use.
   */
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

  /**
   * INTERNAL: Do not use.
   */
  class EnumCaseDecl extends @enum_case_decl, Decl {
    override string toString() { result = "EnumCaseDecl" }

    /**
     * Gets the `index`th element of this enum case declaration (0-based).
     */
    EnumElementDecl getElement(int index) { enum_case_decl_elements(this, index, result) }
  }

  /**
   * INTERNAL: Do not use.
   */
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

  /**
   * INTERNAL: Do not use.
   */
  class IfConfigDecl extends @if_config_decl, Decl {
    override string toString() { result = "IfConfigDecl" }

    /**
     * Gets the `index`th active element of this if config declaration (0-based).
     */
    AstNode getActiveElement(int index) { if_config_decl_active_elements(this, index, result) }
  }

  /**
   * INTERNAL: Do not use.
   */
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

  /**
   * INTERNAL: Do not use.
   * A placeholder for missing declarations that can arise on object deserialization.
   */
  class MissingMemberDecl extends @missing_member_decl, Decl {
    override string toString() { result = "MissingMemberDecl" }

    /**
     * Gets the name of this missing member declaration.
     */
    string getName() { missing_member_decls(this, result) }
  }

  /**
   * INTERNAL: Do not use.
   */
  class OperatorDecl extends @operator_decl, Decl {
    /**
     * Gets the name of this operator declaration.
     */
    string getName() { operator_decls(this, result) }
  }

  /**
   * INTERNAL: Do not use.
   */
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

  /**
   * INTERNAL: Do not use.
   * A diagnostic directive, which is either `#error` or `#warning`.
   */
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

  /**
   * INTERNAL: Do not use.
   */
  class PrecedenceGroupDecl extends @precedence_group_decl, Decl {
    override string toString() { result = "PrecedenceGroupDecl" }
  }

  /**
   * INTERNAL: Do not use.
   */
  class TopLevelCodeDecl extends @top_level_code_decl, Decl {
    override string toString() { result = "TopLevelCodeDecl" }

    /**
     * Gets the body of this top level code declaration.
     */
    BraceStmt getBody() { top_level_code_decls(this, result) }
  }

  /**
   * INTERNAL: Do not use.
   */
  class ValueDecl extends @value_decl, Decl {
    /**
     * Gets the interface type of this value declaration.
     */
    Type getInterfaceType() { value_decls(this, result) }
  }

  /**
   * INTERNAL: Do not use.
   */
  class AbstractStorageDecl extends @abstract_storage_decl, ValueDecl {
    /**
     * Gets the `index`th accessor of this abstract storage declaration (0-based).
     */
    Accessor getAccessor(int index) { abstract_storage_decl_accessors(this, index, result) }
  }

  /**
   * INTERNAL: Do not use.
   */
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

  /**
   * INTERNAL: Do not use.
   */
  class Function extends @function, GenericContext, ValueDecl, Callable { }

  /**
   * INTERNAL: Do not use.
   */
  class InfixOperatorDecl extends @infix_operator_decl, OperatorDecl {
    override string toString() { result = "InfixOperatorDecl" }

    /**
     * Gets the precedence group of this infix operator declaration, if it exists.
     */
    PrecedenceGroupDecl getPrecedenceGroup() { infix_operator_decl_precedence_groups(this, result) }
  }

  /**
   * INTERNAL: Do not use.
   * A declaration of a macro. Some examples:
   *
   * ```
   * @freestanding(declaration)
   * macro A() = #externalMacro(module: "A", type: "A")
   * @freestanding(expression)
   * macro B() = Builtin.B
   * @attached(member)
   * macro C() = C.C
   * ```
   */
  class MacroDecl extends @macro_decl, GenericContext, ValueDecl {
    override string toString() { result = "MacroDecl" }

    /**
     * Gets the name of this macro.
     */
    string getName() { macro_decls(this, result) }

    /**
     * Gets the `index`th parameter of this macro (0-based).
     */
    ParamDecl getParameter(int index) { macro_decl_parameters(this, index, result) }

    /**
     * Gets the `index`th role of this macro (0-based).
     */
    MacroRole getRole(int index) { macro_decl_roles(this, index, result) }
  }

  /**
   * INTERNAL: Do not use.
   */
  class PostfixOperatorDecl extends @postfix_operator_decl, OperatorDecl {
    override string toString() { result = "PostfixOperatorDecl" }
  }

  /**
   * INTERNAL: Do not use.
   */
  class PrefixOperatorDecl extends @prefix_operator_decl, OperatorDecl {
    override string toString() { result = "PrefixOperatorDecl" }
  }

  /**
   * INTERNAL: Do not use.
   */
  class TypeDecl extends @type_decl, ValueDecl {
    /**
     * Gets the name of this type declaration.
     */
    string getName() { type_decls(this, result) }

    /**
     * Gets the `index`th inherited type of this type declaration (0-based).
     *
     * This only returns the types effectively appearing in the declaration. In particular it
     * will not resolve `TypeAliasDecl`s or consider base types added by extensions.
     */
    Type getInheritedType(int index) { type_decl_inherited_types(this, index, result) }
  }

  /**
   * INTERNAL: Do not use.
   */
  class AbstractTypeParamDecl extends @abstract_type_param_decl, TypeDecl { }

  /**
   * INTERNAL: Do not use.
   */
  class AccessorOrNamedFunction extends @accessor_or_named_function, Function { }

  /**
   * INTERNAL: Do not use.
   */
  class Deinitializer extends @deinitializer, Function {
    override string toString() { result = "Deinitializer" }
  }

  /**
   * INTERNAL: Do not use.
   */
  class GenericTypeDecl extends @generic_type_decl, GenericContext, TypeDecl { }

  /**
   * INTERNAL: Do not use.
   */
  class Initializer extends @initializer, Function {
    override string toString() { result = "Initializer" }
  }

  /**
   * INTERNAL: Do not use.
   */
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

  /**
   * INTERNAL: Do not use.
   */
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

  /**
   * INTERNAL: Do not use.
   * A declaration of a variable such as
   * * a local variable in a function:
   * ```
   * func foo() {
   *   var x = 42  // <-
   *   let y = "hello"  // <-
   *   ...
   * }
   * ```
   * * a member of a `struct` or `class`:
   * ```
   * struct S {
   *   var size : Int  // <-
   * }
   * ```
   * * ...
   */
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

  /**
   * INTERNAL: Do not use.
   */
  class Accessor extends @accessor, AccessorOrNamedFunction {
    override string toString() { result = "Accessor" }

    /**
     * Holds if this accessor is a getter.
     */
    predicate isGetter() { accessor_is_getter(this) }

    /**
     * Holds if this accessor is a setter.
     */
    predicate isSetter() { accessor_is_setter(this) }

    /**
     * Holds if this accessor is a `willSet`, called before the property is set.
     */
    predicate isWillSet() { accessor_is_will_set(this) }

    /**
     * Holds if this accessor is a `didSet`, called after the property is set.
     */
    predicate isDidSet() { accessor_is_did_set(this) }

    /**
     * Holds if this accessor is a `_read` coroutine, yielding a borrowed value of the property.
     */
    predicate isRead() { accessor_is_read(this) }

    /**
     * Holds if this accessor is a `_modify` coroutine, yielding an inout value of the property.
     */
    predicate isModify() { accessor_is_modify(this) }

    /**
     * Holds if this accessor is an `unsafeAddress` immutable addressor.
     */
    predicate isUnsafeAddress() { accessor_is_unsafe_address(this) }

    /**
     * Holds if this accessor is an `unsafeMutableAddress` mutable addressor.
     */
    predicate isUnsafeMutableAddress() { accessor_is_unsafe_mutable_address(this) }
  }

  /**
   * INTERNAL: Do not use.
   */
  class AssociatedTypeDecl extends @associated_type_decl, AbstractTypeParamDecl {
    override string toString() { result = "AssociatedTypeDecl" }
  }

  /**
   * INTERNAL: Do not use.
   */
  class ConcreteVarDecl extends @concrete_var_decl, VarDecl {
    override string toString() { result = "ConcreteVarDecl" }

    /**
     * Gets the introducer enumeration value.
     *
     * This is 0 if the variable was introduced with `let` and 1 if it was introduced with `var`.
     */
    int getIntroducerInt() { concrete_var_decls(this, result) }
  }

  /**
   * INTERNAL: Do not use.
   */
  class GenericTypeParamDecl extends @generic_type_param_decl, AbstractTypeParamDecl {
    override string toString() { result = "GenericTypeParamDecl" }
  }

  /**
   * INTERNAL: Do not use.
   */
  class NamedFunction extends @named_function, AccessorOrNamedFunction {
    override string toString() { result = "NamedFunction" }
  }

  /**
   * INTERNAL: Do not use.
   */
  class NominalTypeDecl extends @nominal_type_decl, GenericTypeDecl {
    /**
     * Gets the type of this nominal type declaration.
     */
    Type getType() { nominal_type_decls(this, result) }
  }

  /**
   * INTERNAL: Do not use.
   * A declaration of an opaque type, that is formally equivalent to a given type but abstracts it
   * away.
   *
   * Such a declaration is implicitly given when a declaration is written with an opaque result type,
   * for example
   * ```
   * func opaque() -> some SignedInteger { return 1 }
   * ```
   * See https://docs.swift.org/swift-book/LanguageGuide/OpaqueTypes.html.
   */
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

  /**
   * INTERNAL: Do not use.
   */
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

  /**
   * INTERNAL: Do not use.
   * A declaration of a type alias to another type. For example:
   * ```
   * typealias MyInt = Int
   * ```
   */
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

  /**
   * INTERNAL: Do not use.
   */
  class ClassDecl extends @class_decl, NominalTypeDecl {
    override string toString() { result = "ClassDecl" }
  }

  /**
   * INTERNAL: Do not use.
   */
  class EnumDecl extends @enum_decl, NominalTypeDecl {
    override string toString() { result = "EnumDecl" }
  }

  /**
   * INTERNAL: Do not use.
   */
  class ProtocolDecl extends @protocol_decl, NominalTypeDecl {
    override string toString() { result = "ProtocolDecl" }
  }

  /**
   * INTERNAL: Do not use.
   */
  class StructDecl extends @struct_decl, NominalTypeDecl {
    override string toString() { result = "StructDecl" }
  }

  /**
   * INTERNAL: Do not use.
   */
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

  /**
   * INTERNAL: Do not use.
   * The base class for all expressions in Swift.
   */
  class Expr extends @expr, AstNode {
    /**
     * Gets the type of this expression, if it exists.
     */
    Type getType() { expr_types(this, result) }
  }

  /**
   * INTERNAL: Do not use.
   */
  class AnyTryExpr extends @any_try_expr, Expr {
    /**
     * Gets the sub expression of this any try expression.
     */
    Expr getSubExpr() { any_try_exprs(this, result) }
  }

  /**
   * INTERNAL: Do not use.
   * An implicit application of a property wrapper on the argument of a call.
   */
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

  /**
   * INTERNAL: Do not use.
   */
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

  /**
   * INTERNAL: Do not use.
   */
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

  /**
   * INTERNAL: Do not use.
   */
  class BindOptionalExpr extends @bind_optional_expr, Expr {
    override string toString() { result = "BindOptionalExpr" }

    /**
     * Gets the sub expression of this bind optional expression.
     */
    Expr getSubExpr() { bind_optional_exprs(this, result) }
  }

  /**
   * INTERNAL: Do not use.
   */
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

  /**
   * INTERNAL: Do not use.
   */
  class ClosureExpr extends @closure_expr, Expr, Callable { }

  /**
   * INTERNAL: Do not use.
   */
  class CollectionExpr extends @collection_expr, Expr { }

  /**
   * INTERNAL: Do not use.
   * An expression that forces value to be moved. In the example below, `consume` marks the move expression:
   *
   * ```
   * let y = ...
   * let x = consume y
   * ```
   */
  class ConsumeExpr extends @consume_expr, Expr {
    override string toString() { result = "ConsumeExpr" }

    /**
     * Gets the sub expression of this consume expression.
     */
    Expr getSubExpr() { consume_exprs(this, result) }
  }

  /**
   * INTERNAL: Do not use.
   * An expression that forces value to be copied. In the example below, `copy` marks the copy expression:
   *
   * ```
   * let y = ...
   * let x = copy y
   * ```
   */
  class CopyExpr extends @copy_expr, Expr {
    override string toString() { result = "CopyExpr" }

    /**
     * Gets the sub expression of this copy expression.
     */
    Expr getSubExpr() { copy_exprs(this, result) }
  }

  /**
   * INTERNAL: Do not use.
   */
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

  /**
   * INTERNAL: Do not use.
   */
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

  /**
   * INTERNAL: Do not use.
   */
  class DiscardAssignmentExpr extends @discard_assignment_expr, Expr {
    override string toString() { result = "DiscardAssignmentExpr" }
  }

  /**
   * INTERNAL: Do not use.
   */
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

  /**
   * INTERNAL: Do not use.
   */
  class DynamicTypeExpr extends @dynamic_type_expr, Expr {
    override string toString() { result = "DynamicTypeExpr" }

    /**
     * Gets the base of this dynamic type expression.
     */
    Expr getBase() { dynamic_type_exprs(this, result) }
  }

  /**
   * INTERNAL: Do not use.
   */
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

  /**
   * INTERNAL: Do not use.
   */
  class ErrorExpr extends @error_expr, Expr, ErrorElement {
    override string toString() { result = "ErrorExpr" }
  }

  /**
   * INTERNAL: Do not use.
   */
  class ExplicitCastExpr extends @explicit_cast_expr, Expr {
    /**
     * Gets the sub expression of this explicit cast expression.
     */
    Expr getSubExpr() { explicit_cast_exprs(this, result) }
  }

  /**
   * INTERNAL: Do not use.
   */
  class ForceValueExpr extends @force_value_expr, Expr {
    override string toString() { result = "ForceValueExpr" }

    /**
     * Gets the sub expression of this force value expression.
     */
    Expr getSubExpr() { force_value_exprs(this, result) }
  }

  /**
   * INTERNAL: Do not use.
   */
  class IdentityExpr extends @identity_expr, Expr {
    /**
     * Gets the sub expression of this identity expression.
     */
    Expr getSubExpr() { identity_exprs(this, result) }
  }

  /**
   * INTERNAL: Do not use.
   */
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

  /**
   * INTERNAL: Do not use.
   */
  class ImplicitConversionExpr extends @implicit_conversion_expr, Expr {
    /**
     * Gets the sub expression of this implicit conversion expression.
     */
    Expr getSubExpr() { implicit_conversion_exprs(this, result) }
  }

  /**
   * INTERNAL: Do not use.
   */
  class InOutExpr extends @in_out_expr, Expr {
    override string toString() { result = "InOutExpr" }

    /**
     * Gets the sub expression of this in out expression.
     */
    Expr getSubExpr() { in_out_exprs(this, result) }
  }

  /**
   * INTERNAL: Do not use.
   */
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

  /**
   * INTERNAL: Do not use.
   */
  class KeyPathDotExpr extends @key_path_dot_expr, Expr {
    override string toString() { result = "KeyPathDotExpr" }
  }

  /**
   * INTERNAL: Do not use.
   * A key-path expression.
   */
  class KeyPathExpr extends @key_path_expr, Expr {
    override string toString() { result = "KeyPathExpr" }

    /**
     * Gets the root of this key path expression, if it exists.
     */
    TypeRepr getRoot() { key_path_expr_roots(this, result) }

    /**
     * Gets the `index`th component of this key path expression (0-based).
     */
    KeyPathComponent getComponent(int index) { key_path_expr_components(this, index, result) }
  }

  /**
   * INTERNAL: Do not use.
   */
  class LazyInitializationExpr extends @lazy_initialization_expr, Expr {
    override string toString() { result = "LazyInitializationExpr" }

    /**
     * Gets the sub expression of this lazy initialization expression.
     */
    Expr getSubExpr() { lazy_initialization_exprs(this, result) }
  }

  /**
   * INTERNAL: Do not use.
   */
  class LiteralExpr extends @literal_expr, Expr { }

  /**
   * INTERNAL: Do not use.
   */
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

  /**
   * INTERNAL: Do not use.
   */
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

  /**
   * INTERNAL: Do not use.
   * An expression that materializes a pack during expansion. Appears around PackExpansionExpr.
   *
   * More details:
   * https://github.com/apple/swift-evolution/blob/main/proposals/0393-parameter-packs.md
   */
  class MaterializePackExpr extends @materialize_pack_expr, Expr {
    override string toString() { result = "MaterializePackExpr" }

    /**
     * Gets the sub expression of this materialize pack expression.
     */
    Expr getSubExpr() { materialize_pack_exprs(this, result) }
  }

  /**
   * INTERNAL: Do not use.
   */
  class ObjCSelectorExpr extends @obj_c_selector_expr, Expr {
    override string toString() { result = "ObjCSelectorExpr" }

    /**
     * Gets the sub expression of this obj c selector expression.
     */
    Expr getSubExpr() { obj_c_selector_exprs(this, result, _) }

    /**
     * Gets the method of this obj c selector expression.
     */
    Function getMethod() { obj_c_selector_exprs(this, _, result) }
  }

  /**
   * INTERNAL: Do not use.
   */
  class OneWayExpr extends @one_way_expr, Expr {
    override string toString() { result = "OneWayExpr" }

    /**
     * Gets the sub expression of this one way expression.
     */
    Expr getSubExpr() { one_way_exprs(this, result) }
  }

  /**
   * INTERNAL: Do not use.
   */
  class OpaqueValueExpr extends @opaque_value_expr, Expr {
    override string toString() { result = "OpaqueValueExpr" }
  }

  /**
   * INTERNAL: Do not use.
   * An implicit expression created by the compiler when a method is called on a protocol. For example in
   * ```
   * protocol P {
   *   func foo() -> Int
   * }
   * func bar(x: P) -> Int {
   *   return x.foo()
   * }
   * `x.foo()` is actually wrapped in an `OpenExistentialExpr` that "opens" `x` replacing it in its subexpression with
   * an `OpaqueValueExpr`.
   * ```
   */
  class OpenExistentialExpr extends @open_existential_expr, Expr {
    override string toString() { result = "OpenExistentialExpr" }

    /**
     * Gets the sub expression of this open existential expression.
     *
     * This wrapped subexpression is where the opaque value and the dynamic type under the protocol type may be used.
     */
    Expr getSubExpr() { open_existential_exprs(this, result, _, _) }

    /**
     * Gets the protocol-typed expression opened by this expression.
     */
    Expr getExistential() { open_existential_exprs(this, _, result, _) }

    /**
     * Gets the opaque value expression embedded within `getSubExpr()`.
     */
    OpaqueValueExpr getOpaqueExpr() { open_existential_exprs(this, _, _, result) }
  }

  /**
   * INTERNAL: Do not use.
   */
  class OptionalEvaluationExpr extends @optional_evaluation_expr, Expr {
    override string toString() { result = "OptionalEvaluationExpr" }

    /**
     * Gets the sub expression of this optional evaluation expression.
     */
    Expr getSubExpr() { optional_evaluation_exprs(this, result) }
  }

  /**
   * INTERNAL: Do not use.
   */
  class OtherInitializerRefExpr extends @other_initializer_ref_expr, Expr {
    override string toString() { result = "OtherInitializerRefExpr" }

    /**
     * Gets the initializer of this other initializer reference expression.
     */
    Initializer getInitializer() { other_initializer_ref_exprs(this, result) }
  }

  /**
   * INTERNAL: Do not use.
   * An ambiguous expression that might refer to multiple declarations. This will be present only
   * for failing compilations.
   */
  class OverloadedDeclRefExpr extends @overloaded_decl_ref_expr, Expr, ErrorElement {
    override string toString() { result = "OverloadedDeclRefExpr" }

    /**
     * Gets the `index`th possible declaration of this overloaded declaration reference expression (0-based).
     */
    ValueDecl getPossibleDeclaration(int index) {
      overloaded_decl_ref_expr_possible_declarations(this, index, result)
    }
  }

  /**
   * INTERNAL: Do not use.
   * A pack element expression is a child of PackExpansionExpr.
   *
   * In the following example, `each t` on the second line is the pack element expression:
   * ```
   * func makeTuple<each T>(_ t: repeat each T) -> (repeat each T) {
   *   return (repeat each t)
   * }
   * ```
   *
   * More details:
   * https://github.com/apple/swift-evolution/blob/main/proposals/0393-parameter-packs.md
   */
  class PackElementExpr extends @pack_element_expr, Expr {
    override string toString() { result = "PackElementExpr" }

    /**
     * Gets the sub expression of this pack element expression.
     */
    Expr getSubExpr() { pack_element_exprs(this, result) }
  }

  /**
   * INTERNAL: Do not use.
   * A pack expansion expression.
   *
   * In the following example, `repeat each t` on the second line is the pack expansion expression:
   * ```
   * func makeTuple<each T>(_ t: repeat each T) -> (repeat each T) {
   *   return (repeat each t)
   * }
   * ```
   *
   * More details:
   * https://github.com/apple/swift-evolution/blob/main/proposals/0393-parameter-packs.md
   */
  class PackExpansionExpr extends @pack_expansion_expr, Expr {
    override string toString() { result = "PackExpansionExpr" }

    /**
     * Gets the pattern expression of this pack expansion expression.
     */
    Expr getPatternExpr() { pack_expansion_exprs(this, result) }
  }

  /**
   * INTERNAL: Do not use.
   * A placeholder substituting property initializations with `=` when the property has a property
   * wrapper with an initializer.
   */
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

  /**
   * INTERNAL: Do not use.
   */
  class RebindSelfInInitializerExpr extends @rebind_self_in_initializer_expr, Expr {
    override string toString() { result = "RebindSelfInInitializerExpr" }

    /**
     * Gets the sub expression of this rebind self in initializer expression.
     */
    Expr getSubExpr() { rebind_self_in_initializer_exprs(this, result, _) }

    /**
     * Gets the self of this rebind self in initializer expression.
     */
    VarDecl getSelf() { rebind_self_in_initializer_exprs(this, _, result) }
  }

  /**
   * INTERNAL: Do not use.
   */
  class SequenceExpr extends @sequence_expr, Expr {
    override string toString() { result = "SequenceExpr" }

    /**
     * Gets the `index`th element of this sequence expression (0-based).
     */
    Expr getElement(int index) { sequence_expr_elements(this, index, result) }
  }

  /**
   * INTERNAL: Do not use.
   * An expression that wraps a statement which produces a single value.
   */
  class SingleValueStmtExpr extends @single_value_stmt_expr, Expr {
    override string toString() { result = "SingleValueStmtExpr" }

    /**
     * Gets the statement of this single value statement expression.
     */
    Stmt getStmt() { single_value_stmt_exprs(this, result) }
  }

  /**
   * INTERNAL: Do not use.
   */
  class SuperRefExpr extends @super_ref_expr, Expr {
    override string toString() { result = "SuperRefExpr" }

    /**
     * Gets the self of this super reference expression.
     */
    VarDecl getSelf() { super_ref_exprs(this, result) }
  }

  /**
   * INTERNAL: Do not use.
   */
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

  /**
   * INTERNAL: Do not use.
   */
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

  /**
   * INTERNAL: Do not use.
   */
  class TupleExpr extends @tuple_expr, Expr {
    override string toString() { result = "TupleExpr" }

    /**
     * Gets the `index`th element of this tuple expression (0-based).
     */
    Expr getElement(int index) { tuple_expr_elements(this, index, result) }
  }

  /**
   * INTERNAL: Do not use.
   */
  class TypeExpr extends @type_expr, Expr {
    override string toString() { result = "TypeExpr" }

    /**
     * Gets the type representation of this type expression, if it exists.
     */
    TypeRepr getTypeRepr() { type_expr_type_reprs(this, result) }
  }

  /**
   * INTERNAL: Do not use.
   */
  class UnresolvedDeclRefExpr extends @unresolved_decl_ref_expr, Expr, ErrorElement {
    override string toString() { result = "UnresolvedDeclRefExpr" }

    /**
     * Gets the name of this unresolved declaration reference expression, if it exists.
     */
    string getName() { unresolved_decl_ref_expr_names(this, result) }
  }

  /**
   * INTERNAL: Do not use.
   */
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

  /**
   * INTERNAL: Do not use.
   */
  class UnresolvedMemberExpr extends @unresolved_member_expr, Expr, ErrorElement {
    override string toString() { result = "UnresolvedMemberExpr" }

    /**
     * Gets the name of this unresolved member expression.
     */
    string getName() { unresolved_member_exprs(this, result) }
  }

  /**
   * INTERNAL: Do not use.
   */
  class UnresolvedPatternExpr extends @unresolved_pattern_expr, Expr, ErrorElement {
    override string toString() { result = "UnresolvedPatternExpr" }

    /**
     * Gets the sub pattern of this unresolved pattern expression.
     */
    Pattern getSubPattern() { unresolved_pattern_exprs(this, result) }
  }

  /**
   * INTERNAL: Do not use.
   */
  class UnresolvedSpecializeExpr extends @unresolved_specialize_expr, Expr, ErrorElement {
    override string toString() { result = "UnresolvedSpecializeExpr" }

    /**
     * Gets the sub expression of this unresolved specialize expression.
     */
    Expr getSubExpr() { unresolved_specialize_exprs(this, result) }
  }

  /**
   * INTERNAL: Do not use.
   */
  class VarargExpansionExpr extends @vararg_expansion_expr, Expr {
    override string toString() { result = "VarargExpansionExpr" }

    /**
     * Gets the sub expression of this vararg expansion expression.
     */
    Expr getSubExpr() { vararg_expansion_exprs(this, result) }
  }

  /**
   * INTERNAL: Do not use.
   */
  class AbiSafeConversionExpr extends @abi_safe_conversion_expr, ImplicitConversionExpr {
    override string toString() { result = "AbiSafeConversionExpr" }
  }

  /**
   * INTERNAL: Do not use.
   */
  class AnyHashableErasureExpr extends @any_hashable_erasure_expr, ImplicitConversionExpr {
    override string toString() { result = "AnyHashableErasureExpr" }
  }

  /**
   * INTERNAL: Do not use.
   */
  class ArchetypeToSuperExpr extends @archetype_to_super_expr, ImplicitConversionExpr {
    override string toString() { result = "ArchetypeToSuperExpr" }
  }

  /**
   * INTERNAL: Do not use.
   */
  class ArrayExpr extends @array_expr, CollectionExpr {
    override string toString() { result = "ArrayExpr" }

    /**
     * Gets the `index`th element of this array expression (0-based).
     */
    Expr getElement(int index) { array_expr_elements(this, index, result) }
  }

  /**
   * INTERNAL: Do not use.
   */
  class ArrayToPointerExpr extends @array_to_pointer_expr, ImplicitConversionExpr {
    override string toString() { result = "ArrayToPointerExpr" }
  }

  /**
   * INTERNAL: Do not use.
   */
  class AutoClosureExpr extends @auto_closure_expr, ClosureExpr {
    override string toString() { result = "AutoClosureExpr" }
  }

  /**
   * INTERNAL: Do not use.
   */
  class AwaitExpr extends @await_expr, IdentityExpr {
    override string toString() { result = "AwaitExpr" }
  }

  /**
   * INTERNAL: Do not use.
   */
  class BinaryExpr extends @binary_expr, ApplyExpr {
    override string toString() { result = "BinaryExpr" }
  }

  /**
   * INTERNAL: Do not use.
   * An expression that marks value as borrowed. In the example below, `_borrow` marks the borrow expression:
   *
   * ```
   * let y = ...
   * let x = _borrow y
   * ```
   */
  class BorrowExpr extends @borrow_expr, IdentityExpr {
    override string toString() { result = "BorrowExpr" }
  }

  /**
   * INTERNAL: Do not use.
   */
  class BridgeFromObjCExpr extends @bridge_from_obj_c_expr, ImplicitConversionExpr {
    override string toString() { result = "BridgeFromObjCExpr" }
  }

  /**
   * INTERNAL: Do not use.
   */
  class BridgeToObjCExpr extends @bridge_to_obj_c_expr, ImplicitConversionExpr {
    override string toString() { result = "BridgeToObjCExpr" }
  }

  /**
   * INTERNAL: Do not use.
   */
  class BuiltinLiteralExpr extends @builtin_literal_expr, LiteralExpr { }

  /**
   * INTERNAL: Do not use.
   */
  class CallExpr extends @call_expr, ApplyExpr {
    override string toString() { result = "CallExpr" }
  }

  /**
   * INTERNAL: Do not use.
   */
  class CheckedCastExpr extends @checked_cast_expr, ExplicitCastExpr { }

  /**
   * INTERNAL: Do not use.
   */
  class ClassMetatypeToObjectExpr extends @class_metatype_to_object_expr, ImplicitConversionExpr {
    override string toString() { result = "ClassMetatypeToObjectExpr" }
  }

  /**
   * INTERNAL: Do not use.
   */
  class CoerceExpr extends @coerce_expr, ExplicitCastExpr {
    override string toString() { result = "CoerceExpr" }
  }

  /**
   * INTERNAL: Do not use.
   */
  class CollectionUpcastConversionExpr extends @collection_upcast_conversion_expr,
    ImplicitConversionExpr
  {
    override string toString() { result = "CollectionUpcastConversionExpr" }
  }

  /**
   * INTERNAL: Do not use.
   */
  class ConditionalBridgeFromObjCExpr extends @conditional_bridge_from_obj_c_expr,
    ImplicitConversionExpr
  {
    override string toString() { result = "ConditionalBridgeFromObjCExpr" }
  }

  /**
   * INTERNAL: Do not use.
   */
  class CovariantFunctionConversionExpr extends @covariant_function_conversion_expr,
    ImplicitConversionExpr
  {
    override string toString() { result = "CovariantFunctionConversionExpr" }
  }

  /**
   * INTERNAL: Do not use.
   */
  class CovariantReturnConversionExpr extends @covariant_return_conversion_expr,
    ImplicitConversionExpr
  {
    override string toString() { result = "CovariantReturnConversionExpr" }
  }

  /**
   * INTERNAL: Do not use.
   */
  class DerivedToBaseExpr extends @derived_to_base_expr, ImplicitConversionExpr {
    override string toString() { result = "DerivedToBaseExpr" }
  }

  /**
   * INTERNAL: Do not use.
   */
  class DestructureTupleExpr extends @destructure_tuple_expr, ImplicitConversionExpr {
    override string toString() { result = "DestructureTupleExpr" }
  }

  /**
   * INTERNAL: Do not use.
   */
  class DictionaryExpr extends @dictionary_expr, CollectionExpr {
    override string toString() { result = "DictionaryExpr" }

    /**
     * Gets the `index`th element of this dictionary expression (0-based).
     */
    Expr getElement(int index) { dictionary_expr_elements(this, index, result) }
  }

  /**
   * INTERNAL: Do not use.
   */
  class DifferentiableFunctionExpr extends @differentiable_function_expr, ImplicitConversionExpr {
    override string toString() { result = "DifferentiableFunctionExpr" }
  }

  /**
   * INTERNAL: Do not use.
   */
  class DifferentiableFunctionExtractOriginalExpr extends @differentiable_function_extract_original_expr,
    ImplicitConversionExpr
  {
    override string toString() { result = "DifferentiableFunctionExtractOriginalExpr" }
  }

  /**
   * INTERNAL: Do not use.
   */
  class DotSelfExpr extends @dot_self_expr, IdentityExpr {
    override string toString() { result = "DotSelfExpr" }
  }

  /**
   * INTERNAL: Do not use.
   */
  class DynamicLookupExpr extends @dynamic_lookup_expr, LookupExpr { }

  /**
   * INTERNAL: Do not use.
   */
  class ErasureExpr extends @erasure_expr, ImplicitConversionExpr {
    override string toString() { result = "ErasureExpr" }
  }

  /**
   * INTERNAL: Do not use.
   */
  class ExistentialMetatypeToObjectExpr extends @existential_metatype_to_object_expr,
    ImplicitConversionExpr
  {
    override string toString() { result = "ExistentialMetatypeToObjectExpr" }
  }

  /**
   * INTERNAL: Do not use.
   */
  class ExplicitClosureExpr extends @explicit_closure_expr, ClosureExpr {
    override string toString() { result = "ExplicitClosureExpr" }
  }

  /**
   * INTERNAL: Do not use.
   */
  class ForceTryExpr extends @force_try_expr, AnyTryExpr {
    override string toString() { result = "ForceTryExpr" }
  }

  /**
   * INTERNAL: Do not use.
   */
  class ForeignObjectConversionExpr extends @foreign_object_conversion_expr, ImplicitConversionExpr {
    override string toString() { result = "ForeignObjectConversionExpr" }
  }

  /**
   * INTERNAL: Do not use.
   */
  class FunctionConversionExpr extends @function_conversion_expr, ImplicitConversionExpr {
    override string toString() { result = "FunctionConversionExpr" }
  }

  /**
   * INTERNAL: Do not use.
   */
  class InOutToPointerExpr extends @in_out_to_pointer_expr, ImplicitConversionExpr {
    override string toString() { result = "InOutToPointerExpr" }
  }

  /**
   * INTERNAL: Do not use.
   */
  class InjectIntoOptionalExpr extends @inject_into_optional_expr, ImplicitConversionExpr {
    override string toString() { result = "InjectIntoOptionalExpr" }
  }

  /**
   * INTERNAL: Do not use.
   */
  class InterpolatedStringLiteralExpr extends @interpolated_string_literal_expr, LiteralExpr {
    override string toString() { result = "InterpolatedStringLiteralExpr" }

    /**
     * Gets the interpolation expression of this interpolated string literal expression, if it exists.
     */
    OpaqueValueExpr getInterpolationExpr() {
      interpolated_string_literal_expr_interpolation_exprs(this, result)
    }

    /**
     * Gets the appending expression of this interpolated string literal expression, if it exists.
     */
    TapExpr getAppendingExpr() { interpolated_string_literal_expr_appending_exprs(this, result) }
  }

  /**
   * INTERNAL: Do not use.
   */
  class LinearFunctionExpr extends @linear_function_expr, ImplicitConversionExpr {
    override string toString() { result = "LinearFunctionExpr" }
  }

  /**
   * INTERNAL: Do not use.
   */
  class LinearFunctionExtractOriginalExpr extends @linear_function_extract_original_expr,
    ImplicitConversionExpr
  {
    override string toString() { result = "LinearFunctionExtractOriginalExpr" }
  }

  /**
   * INTERNAL: Do not use.
   */
  class LinearToDifferentiableFunctionExpr extends @linear_to_differentiable_function_expr,
    ImplicitConversionExpr
  {
    override string toString() { result = "LinearToDifferentiableFunctionExpr" }
  }

  /**
   * INTERNAL: Do not use.
   */
  class LoadExpr extends @load_expr, ImplicitConversionExpr {
    override string toString() { result = "LoadExpr" }
  }

  /**
   * INTERNAL: Do not use.
   */
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

  /**
   * INTERNAL: Do not use.
   */
  class MetatypeConversionExpr extends @metatype_conversion_expr, ImplicitConversionExpr {
    override string toString() { result = "MetatypeConversionExpr" }
  }

  /**
   * INTERNAL: Do not use.
   */
  class NilLiteralExpr extends @nil_literal_expr, LiteralExpr {
    override string toString() { result = "NilLiteralExpr" }
  }

  /**
   * INTERNAL: Do not use.
   * An instance of `#fileLiteral`, `#imageLiteral` or `#colorLiteral` expressions, which are used in playgrounds.
   */
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

  /**
   * INTERNAL: Do not use.
   */
  class OptionalTryExpr extends @optional_try_expr, AnyTryExpr {
    override string toString() { result = "OptionalTryExpr" }
  }

  /**
   * INTERNAL: Do not use.
   */
  class ParenExpr extends @paren_expr, IdentityExpr {
    override string toString() { result = "ParenExpr" }
  }

  /**
   * INTERNAL: Do not use.
   */
  class PointerToPointerExpr extends @pointer_to_pointer_expr, ImplicitConversionExpr {
    override string toString() { result = "PointerToPointerExpr" }
  }

  /**
   * INTERNAL: Do not use.
   */
  class PostfixUnaryExpr extends @postfix_unary_expr, ApplyExpr {
    override string toString() { result = "PostfixUnaryExpr" }
  }

  /**
   * INTERNAL: Do not use.
   */
  class PrefixUnaryExpr extends @prefix_unary_expr, ApplyExpr {
    override string toString() { result = "PrefixUnaryExpr" }
  }

  /**
   * INTERNAL: Do not use.
   */
  class ProtocolMetatypeToObjectExpr extends @protocol_metatype_to_object_expr,
    ImplicitConversionExpr
  {
    override string toString() { result = "ProtocolMetatypeToObjectExpr" }
  }

  /**
   * INTERNAL: Do not use.
   * A regular expression literal which is checked at compile time, for example `/a(a|b)*b/`.
   */
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

  /**
   * INTERNAL: Do not use.
   * An internal raw instance of method lookups like `x.foo` in `x.foo()`.
   * This is completely replaced by the synthesized type `MethodLookupExpr`.
   */
  class SelfApplyExpr extends @self_apply_expr, ApplyExpr {
    /**
     * Gets the base of this self apply expression.
     */
    Expr getBase() { self_apply_exprs(this, result) }
  }

  /**
   * INTERNAL: Do not use.
   */
  class StringToPointerExpr extends @string_to_pointer_expr, ImplicitConversionExpr {
    override string toString() { result = "StringToPointerExpr" }
  }

  /**
   * INTERNAL: Do not use.
   */
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

  /**
   * INTERNAL: Do not use.
   */
  class TryExpr extends @try_expr, AnyTryExpr {
    override string toString() { result = "TryExpr" }
  }

  /**
   * INTERNAL: Do not use.
   */
  class UnderlyingToOpaqueExpr extends @underlying_to_opaque_expr, ImplicitConversionExpr {
    override string toString() { result = "UnderlyingToOpaqueExpr" }
  }

  /**
   * INTERNAL: Do not use.
   */
  class UnevaluatedInstanceExpr extends @unevaluated_instance_expr, ImplicitConversionExpr {
    override string toString() { result = "UnevaluatedInstanceExpr" }
  }

  /**
   * INTERNAL: Do not use.
   */
  class UnresolvedMemberChainResultExpr extends @unresolved_member_chain_result_expr, IdentityExpr,
    ErrorElement
  {
    override string toString() { result = "UnresolvedMemberChainResultExpr" }
  }

  /**
   * INTERNAL: Do not use.
   */
  class UnresolvedTypeConversionExpr extends @unresolved_type_conversion_expr,
    ImplicitConversionExpr, ErrorElement
  {
    override string toString() { result = "UnresolvedTypeConversionExpr" }
  }

  /**
   * INTERNAL: Do not use.
   */
  class BooleanLiteralExpr extends @boolean_literal_expr, BuiltinLiteralExpr {
    override string toString() { result = "BooleanLiteralExpr" }

    /**
     * Gets the value of this boolean literal expression.
     */
    boolean getValue() { boolean_literal_exprs(this, result) }
  }

  /**
   * INTERNAL: Do not use.
   */
  class ConditionalCheckedCastExpr extends @conditional_checked_cast_expr, CheckedCastExpr {
    override string toString() { result = "ConditionalCheckedCastExpr" }
  }

  /**
   * INTERNAL: Do not use.
   */
  class DotSyntaxCallExpr extends @dot_syntax_call_expr, SelfApplyExpr {
    override string toString() { result = "DotSyntaxCallExpr" }
  }

  /**
   * INTERNAL: Do not use.
   */
  class DynamicMemberRefExpr extends @dynamic_member_ref_expr, DynamicLookupExpr {
    override string toString() { result = "DynamicMemberRefExpr" }
  }

  /**
   * INTERNAL: Do not use.
   */
  class DynamicSubscriptExpr extends @dynamic_subscript_expr, DynamicLookupExpr {
    override string toString() { result = "DynamicSubscriptExpr" }
  }

  /**
   * INTERNAL: Do not use.
   */
  class ForcedCheckedCastExpr extends @forced_checked_cast_expr, CheckedCastExpr {
    override string toString() { result = "ForcedCheckedCastExpr" }
  }

  /**
   * INTERNAL: Do not use.
   */
  class InitializerRefCallExpr extends @initializer_ref_call_expr, SelfApplyExpr {
    override string toString() { result = "InitializerRefCallExpr" }
  }

  /**
   * INTERNAL: Do not use.
   */
  class IsExpr extends @is_expr, CheckedCastExpr {
    override string toString() { result = "IsExpr" }
  }

  /**
   * INTERNAL: Do not use.
   */
  class MagicIdentifierLiteralExpr extends @magic_identifier_literal_expr, BuiltinLiteralExpr {
    override string toString() { result = "MagicIdentifierLiteralExpr" }

    /**
     * Gets the kind of this magic identifier literal expression.
     */
    string getKind() { magic_identifier_literal_exprs(this, result) }
  }

  /**
   * INTERNAL: Do not use.
   */
  class NumberLiteralExpr extends @number_literal_expr, BuiltinLiteralExpr { }

  /**
   * INTERNAL: Do not use.
   */
  class StringLiteralExpr extends @string_literal_expr, BuiltinLiteralExpr {
    override string toString() { result = "StringLiteralExpr" }

    /**
     * Gets the value of this string literal expression.
     */
    string getValue() { string_literal_exprs(this, result) }
  }

  /**
   * INTERNAL: Do not use.
   */
  class FloatLiteralExpr extends @float_literal_expr, NumberLiteralExpr {
    override string toString() { result = "FloatLiteralExpr" }

    /**
     * Gets the string value of this float literal expression.
     */
    string getStringValue() { float_literal_exprs(this, result) }
  }

  /**
   * INTERNAL: Do not use.
   */
  class IntegerLiteralExpr extends @integer_literal_expr, NumberLiteralExpr {
    override string toString() { result = "IntegerLiteralExpr" }

    /**
     * Gets the string value of this integer literal expression.
     */
    string getStringValue() { integer_literal_exprs(this, result) }
  }

  /**
   * INTERNAL: Do not use.
   */
  class Pattern extends @pattern, AstNode {
    /**
     * Gets the type of this pattern, if it exists.
     */
    Type getType() { pattern_types(this, result) }
  }

  /**
   * INTERNAL: Do not use.
   */
  class AnyPattern extends @any_pattern, Pattern {
    override string toString() { result = "AnyPattern" }
  }

  /**
   * INTERNAL: Do not use.
   */
  class BindingPattern extends @binding_pattern, Pattern {
    override string toString() { result = "BindingPattern" }

    /**
     * Gets the sub pattern of this binding pattern.
     */
    Pattern getSubPattern() { binding_patterns(this, result) }
  }

  /**
   * INTERNAL: Do not use.
   */
  class BoolPattern extends @bool_pattern, Pattern {
    override string toString() { result = "BoolPattern" }

    /**
     * Gets the value of this bool pattern.
     */
    boolean getValue() { bool_patterns(this, result) }
  }

  /**
   * INTERNAL: Do not use.
   */
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

  /**
   * INTERNAL: Do not use.
   */
  class ExprPattern extends @expr_pattern, Pattern {
    override string toString() { result = "ExprPattern" }

    /**
     * Gets the sub expression of this expression pattern.
     */
    Expr getSubExpr() { expr_patterns(this, result) }
  }

  /**
   * INTERNAL: Do not use.
   */
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

  /**
   * INTERNAL: Do not use.
   */
  class NamedPattern extends @named_pattern, Pattern {
    override string toString() { result = "NamedPattern" }

    /**
     * Gets the variable declaration of this named pattern.
     */
    VarDecl getVarDecl() { named_patterns(this, result) }
  }

  /**
   * INTERNAL: Do not use.
   */
  class OptionalSomePattern extends @optional_some_pattern, Pattern {
    override string toString() { result = "OptionalSomePattern" }

    /**
     * Gets the sub pattern of this optional some pattern.
     */
    Pattern getSubPattern() { optional_some_patterns(this, result) }
  }

  /**
   * INTERNAL: Do not use.
   */
  class ParenPattern extends @paren_pattern, Pattern {
    override string toString() { result = "ParenPattern" }

    /**
     * Gets the sub pattern of this paren pattern.
     */
    Pattern getSubPattern() { paren_patterns(this, result) }
  }

  /**
   * INTERNAL: Do not use.
   */
  class TuplePattern extends @tuple_pattern, Pattern {
    override string toString() { result = "TuplePattern" }

    /**
     * Gets the `index`th element of this tuple pattern (0-based).
     */
    Pattern getElement(int index) { tuple_pattern_elements(this, index, result) }
  }

  /**
   * INTERNAL: Do not use.
   */
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

  /**
   * INTERNAL: Do not use.
   */
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

  /**
   * INTERNAL: Do not use.
   */
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

  /**
   * INTERNAL: Do not use.
   */
  class Stmt extends @stmt, AstNode { }

  /**
   * INTERNAL: Do not use.
   */
  class StmtCondition extends @stmt_condition, AstNode {
    override string toString() { result = "StmtCondition" }

    /**
     * Gets the `index`th element of this statement condition (0-based).
     */
    ConditionElement getElement(int index) { stmt_condition_elements(this, index, result) }
  }

  /**
   * INTERNAL: Do not use.
   */
  class BraceStmt extends @brace_stmt, Stmt {
    override string toString() { result = "BraceStmt" }

    /**
     * Gets the `index`th element of this brace statement (0-based).
     */
    AstNode getElement(int index) { brace_stmt_elements(this, index, result) }
  }

  /**
   * INTERNAL: Do not use.
   */
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

  /**
   * INTERNAL: Do not use.
   */
  class CaseStmt extends @case_stmt, Stmt {
    override string toString() { result = "CaseStmt" }

    /**
     * Gets the `index`th label of this case statement (0-based).
     */
    CaseLabelItem getLabel(int index) { case_stmt_labels(this, index, result) }

    /**
     * Gets the `index`th variable of this case statement (0-based).
     */
    VarDecl getVariable(int index) { case_stmt_variables(this, index, result) }

    /**
     * Gets the body of this case statement.
     */
    Stmt getBody() { case_stmts(this, result) }
  }

  /**
   * INTERNAL: Do not use.
   */
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

  /**
   * INTERNAL: Do not use.
   */
  class DeferStmt extends @defer_stmt, Stmt {
    override string toString() { result = "DeferStmt" }

    /**
     * Gets the body of this defer statement.
     */
    BraceStmt getBody() { defer_stmts(this, result) }
  }

  /**
   * INTERNAL: Do not use.
   * A statement that takes a non-copyable value and destructs its members/fields.
   *
   * The only valid syntax:
   * ```
   * destruct self
   * ```
   */
  class DiscardStmt extends @discard_stmt, Stmt {
    override string toString() { result = "DiscardStmt" }

    /**
     * Gets the sub expression of this discard statement.
     */
    Expr getSubExpr() { discard_stmts(this, result) }
  }

  /**
   * INTERNAL: Do not use.
   */
  class FailStmt extends @fail_stmt, Stmt {
    override string toString() { result = "FailStmt" }
  }

  /**
   * INTERNAL: Do not use.
   */
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

  /**
   * INTERNAL: Do not use.
   */
  class LabeledStmt extends @labeled_stmt, Stmt {
    /**
     * Gets the label of this labeled statement, if it exists.
     */
    string getLabel() { labeled_stmt_labels(this, result) }
  }

  /**
   * INTERNAL: Do not use.
   */
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

  /**
   * INTERNAL: Do not use.
   */
  class ReturnStmt extends @return_stmt, Stmt {
    override string toString() { result = "ReturnStmt" }

    /**
     * Gets the result of this return statement, if it exists.
     */
    Expr getResult() { return_stmt_results(this, result) }
  }

  /**
   * INTERNAL: Do not use.
   * A statement implicitly wrapping values to be used in branches of if/switch expressions. For example in:
   * ```
   * let rank = switch value {
   *     case 0..<0x80: 1
   *     case 0x80..<0x0800: 2
   *     default: 3
   * }
   * ```
   * the literal expressions `1`, `2` and `3` are wrapped in `ThenStmt`.
   */
  class ThenStmt extends @then_stmt, Stmt {
    override string toString() { result = "ThenStmt" }

    /**
     * Gets the result of this then statement.
     */
    Expr getResult() { then_stmts(this, result) }
  }

  /**
   * INTERNAL: Do not use.
   */
  class ThrowStmt extends @throw_stmt, Stmt {
    override string toString() { result = "ThrowStmt" }

    /**
     * Gets the sub expression of this throw statement.
     */
    Expr getSubExpr() { throw_stmts(this, result) }
  }

  /**
   * INTERNAL: Do not use.
   */
  class YieldStmt extends @yield_stmt, Stmt {
    override string toString() { result = "YieldStmt" }

    /**
     * Gets the `index`th result of this yield statement (0-based).
     */
    Expr getResult(int index) { yield_stmt_results(this, index, result) }
  }

  /**
   * INTERNAL: Do not use.
   */
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

  /**
   * INTERNAL: Do not use.
   */
  class DoStmt extends @do_stmt, LabeledStmt {
    override string toString() { result = "DoStmt" }

    /**
     * Gets the body of this do statement.
     */
    BraceStmt getBody() { do_stmts(this, result) }
  }

  /**
   * INTERNAL: Do not use.
   */
  class ForEachStmt extends @for_each_stmt, LabeledStmt {
    override string toString() { result = "ForEachStmt" }

    /**
     * Gets the `index`th variable of this for each statement (0-based).
     */
    VarDecl getVariable(int index) { for_each_stmt_variables(this, index, result) }

    /**
     * Gets the pattern of this for each statement.
     */
    Pattern getPattern() { for_each_stmts(this, result, _) }

    /**
     * Gets the where of this for each statement, if it exists.
     */
    Expr getWhere() { for_each_stmt_wheres(this, result) }

    /**
     * Gets the iteratorvar of this for each statement, if it exists.
     */
    PatternBindingDecl getIteratorVar() { for_each_stmt_iterator_vars(this, result) }

    /**
     * Gets the nextcall of this for each statement, if it exists.
     */
    Expr getNextCall() { for_each_stmt_next_calls(this, result) }

    /**
     * Gets the body of this for each statement.
     */
    BraceStmt getBody() { for_each_stmts(this, _, result) }
  }

  /**
   * INTERNAL: Do not use.
   */
  class LabeledConditionalStmt extends @labeled_conditional_stmt, LabeledStmt {
    /**
     * Gets the condition of this labeled conditional statement.
     */
    StmtCondition getCondition() { labeled_conditional_stmts(this, result) }
  }

  /**
   * INTERNAL: Do not use.
   */
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

  /**
   * INTERNAL: Do not use.
   */
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

  /**
   * INTERNAL: Do not use.
   */
  class GuardStmt extends @guard_stmt, LabeledConditionalStmt {
    override string toString() { result = "GuardStmt" }

    /**
     * Gets the body of this guard statement.
     */
    BraceStmt getBody() { guard_stmts(this, result) }
  }

  /**
   * INTERNAL: Do not use.
   */
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

  /**
   * INTERNAL: Do not use.
   */
  class WhileStmt extends @while_stmt, LabeledConditionalStmt {
    override string toString() { result = "WhileStmt" }

    /**
     * Gets the body of this while statement.
     */
    Stmt getBody() { while_stmts(this, result) }
  }

  /**
   * INTERNAL: Do not use.
   */
  class Type extends @type, Element {
    /**
     * Gets the name of this type.
     */
    string getName() { types(this, result, _) }

    /**
     * Gets the canonical type of this type.
     *
     * This is the unique type we get after resolving aliases and desugaring. For example, given
     * ```
     * typealias MyInt = Int
     * ```
     * then `[MyInt?]` has the canonical type `Array<Optional<Int>>`.
     */
    Type getCanonicalType() { types(this, _, result) }
  }

  /**
   * INTERNAL: Do not use.
   */
  class TypeRepr extends @type_repr, AstNode {
    override string toString() { result = "TypeRepr" }

    /**
     * Gets the type of this type representation.
     */
    Type getType() { type_reprs(this, result) }
  }

  /**
   * INTERNAL: Do not use.
   */
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

  /**
   * INTERNAL: Do not use.
   */
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

  /**
   * INTERNAL: Do not use.
   */
  class AnyMetatypeType extends @any_metatype_type, Type { }

  /**
   * INTERNAL: Do not use.
   */
  class BuiltinType extends @builtin_type, Type { }

  /**
   * INTERNAL: Do not use.
   */
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

  /**
   * INTERNAL: Do not use.
   */
  class DynamicSelfType extends @dynamic_self_type, Type {
    override string toString() { result = "DynamicSelfType" }

    /**
     * Gets the static self type of this dynamic self type.
     */
    Type getStaticSelfType() { dynamic_self_types(this, result) }
  }

  /**
   * INTERNAL: Do not use.
   */
  class ErrorType extends @error_type, Type, ErrorElement {
    override string toString() { result = "ErrorType" }
  }

  /**
   * INTERNAL: Do not use.
   */
  class ExistentialType extends @existential_type, Type {
    override string toString() { result = "ExistentialType" }

    /**
     * Gets the constraint of this existential type.
     */
    Type getConstraint() { existential_types(this, result) }
  }

  /**
   * INTERNAL: Do not use.
   */
  class InOutType extends @in_out_type, Type {
    override string toString() { result = "InOutType" }

    /**
     * Gets the object type of this in out type.
     */
    Type getObjectType() { in_out_types(this, result) }
  }

  /**
   * INTERNAL: Do not use.
   */
  class LValueType extends @l_value_type, Type {
    override string toString() { result = "LValueType" }

    /**
     * Gets the object type of this l value type.
     */
    Type getObjectType() { l_value_types(this, result) }
  }

  /**
   * INTERNAL: Do not use.
   */
  class ModuleType extends @module_type, Type {
    override string toString() { result = "ModuleType" }

    /**
     * Gets the module of this module type.
     */
    ModuleDecl getModule() { module_types(this, result) }
  }

  /**
   * INTERNAL: Do not use.
   * A type of PackElementExpr, see PackElementExpr for more information.
   */
  class PackElementType extends @pack_element_type, Type {
    override string toString() { result = "PackElementType" }

    /**
     * Gets the pack type of this pack element type.
     */
    Type getPackType() { pack_element_types(this, result) }
  }

  /**
   * INTERNAL: Do not use.
   * A type of PackExpansionExpr, see PackExpansionExpr for more information.
   */
  class PackExpansionType extends @pack_expansion_type, Type {
    override string toString() { result = "PackExpansionType" }

    /**
     * Gets the pattern type of this pack expansion type.
     */
    Type getPatternType() { pack_expansion_types(this, result, _) }

    /**
     * Gets the count type of this pack expansion type.
     */
    Type getCountType() { pack_expansion_types(this, _, result) }
  }

  /**
   * INTERNAL: Do not use.
   * An actual type of a pack expression at the instatiation point.
   *
   * In the following example, PackType will appear around `makeTuple` call site as `Pack{String, Int}`:
   * ```
   * func makeTuple<each T>(_ t: repeat each T) -> (repeat each T) { ... }
   * makeTuple("A", 2)
   * ```
   *
   * More details:
   * https://github.com/apple/swift-evolution/blob/main/proposals/0393-parameter-packs.md
   */
  class PackType extends @pack_type, Type {
    override string toString() { result = "PackType" }

    /**
     * Gets the `index`th element of this pack type (0-based).
     */
    Type getElement(int index) { pack_type_elements(this, index, result) }
  }

  /**
   * INTERNAL: Do not use.
   * A sugar type of the form `P<X>` with `P` a protocol.
   *
   * If `P` has primary associated type `A`, then `T: P<X>` is a shortcut for `T: P where T.A == X`.
   */
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

  /**
   * INTERNAL: Do not use.
   */
  class ProtocolCompositionType extends @protocol_composition_type, Type {
    override string toString() { result = "ProtocolCompositionType" }

    /**
     * Gets the `index`th member of this protocol composition type (0-based).
     */
    Type getMember(int index) { protocol_composition_type_members(this, index, result) }
  }

  /**
   * INTERNAL: Do not use.
   */
  class ReferenceStorageType extends @reference_storage_type, Type {
    /**
     * Gets the referent type of this reference storage type.
     */
    Type getReferentType() { reference_storage_types(this, result) }
  }

  /**
   * INTERNAL: Do not use.
   */
  class SubstitutableType extends @substitutable_type, Type { }

  /**
   * INTERNAL: Do not use.
   */
  class SugarType extends @sugar_type, Type { }

  /**
   * INTERNAL: Do not use.
   */
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

  /**
   * INTERNAL: Do not use.
   */
  class UnresolvedType extends @unresolved_type, Type, ErrorElement {
    override string toString() { result = "UnresolvedType" }
  }

  /**
   * INTERNAL: Do not use.
   */
  class AnyBuiltinIntegerType extends @any_builtin_integer_type, BuiltinType { }

  /**
   * INTERNAL: Do not use.
   */
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

  /**
   * INTERNAL: Do not use.
   */
  class BuiltinBridgeObjectType extends @builtin_bridge_object_type, BuiltinType {
    override string toString() { result = "BuiltinBridgeObjectType" }
  }

  /**
   * INTERNAL: Do not use.
   */
  class BuiltinDefaultActorStorageType extends @builtin_default_actor_storage_type, BuiltinType {
    override string toString() { result = "BuiltinDefaultActorStorageType" }
  }

  /**
   * INTERNAL: Do not use.
   */
  class BuiltinExecutorType extends @builtin_executor_type, BuiltinType {
    override string toString() { result = "BuiltinExecutorType" }
  }

  /**
   * INTERNAL: Do not use.
   */
  class BuiltinFloatType extends @builtin_float_type, BuiltinType {
    override string toString() { result = "BuiltinFloatType" }
  }

  /**
   * INTERNAL: Do not use.
   */
  class BuiltinJobType extends @builtin_job_type, BuiltinType {
    override string toString() { result = "BuiltinJobType" }
  }

  /**
   * INTERNAL: Do not use.
   */
  class BuiltinNativeObjectType extends @builtin_native_object_type, BuiltinType {
    override string toString() { result = "BuiltinNativeObjectType" }
  }

  /**
   * INTERNAL: Do not use.
   */
  class BuiltinRawPointerType extends @builtin_raw_pointer_type, BuiltinType {
    override string toString() { result = "BuiltinRawPointerType" }
  }

  /**
   * INTERNAL: Do not use.
   */
  class BuiltinRawUnsafeContinuationType extends @builtin_raw_unsafe_continuation_type, BuiltinType {
    override string toString() { result = "BuiltinRawUnsafeContinuationType" }
  }

  /**
   * INTERNAL: Do not use.
   */
  class BuiltinUnsafeValueBufferType extends @builtin_unsafe_value_buffer_type, BuiltinType {
    override string toString() { result = "BuiltinUnsafeValueBufferType" }
  }

  /**
   * INTERNAL: Do not use.
   */
  class BuiltinVectorType extends @builtin_vector_type, BuiltinType {
    override string toString() { result = "BuiltinVectorType" }
  }

  /**
   * INTERNAL: Do not use.
   */
  class ExistentialMetatypeType extends @existential_metatype_type, AnyMetatypeType {
    override string toString() { result = "ExistentialMetatypeType" }
  }

  /**
   * INTERNAL: Do not use.
   */
  class FunctionType extends @function_type, AnyFunctionType {
    override string toString() { result = "FunctionType" }
  }

  /**
   * INTERNAL: Do not use.
   * The type of a generic function with type parameters
   */
  class GenericFunctionType extends @generic_function_type, AnyFunctionType {
    override string toString() { result = "GenericFunctionType" }

    /**
     * Gets the `index`th type parameter of this generic type (0-based).
     */
    GenericTypeParamType getGenericParam(int index) {
      generic_function_type_generic_params(this, index, result)
    }
  }

  /**
   * INTERNAL: Do not use.
   */
  class GenericTypeParamType extends @generic_type_param_type, SubstitutableType {
    override string toString() { result = "GenericTypeParamType" }
  }

  /**
   * INTERNAL: Do not use.
   */
  class MetatypeType extends @metatype_type, AnyMetatypeType {
    override string toString() { result = "MetatypeType" }
  }

  /**
   * INTERNAL: Do not use.
   */
  class NominalOrBoundGenericNominalType extends @nominal_or_bound_generic_nominal_type,
    AnyGenericType
  { }

  /**
   * INTERNAL: Do not use.
   */
  class ParenType extends @paren_type, SugarType {
    override string toString() { result = "ParenType" }

    /**
     * Gets the type of this paren type.
     */
    Type getType() { paren_types(this, result) }
  }

  /**
   * INTERNAL: Do not use.
   */
  class SyntaxSugarType extends @syntax_sugar_type, SugarType { }

  /**
   * INTERNAL: Do not use.
   */
  class TypeAliasType extends @type_alias_type, SugarType {
    override string toString() { result = "TypeAliasType" }

    /**
     * Gets the declaration of this type alias type.
     */
    TypeAliasDecl getDecl() { type_alias_types(this, result) }
  }

  /**
   * INTERNAL: Do not use.
   */
  class UnboundGenericType extends @unbound_generic_type, AnyGenericType {
    override string toString() { result = "UnboundGenericType" }
  }

  /**
   * INTERNAL: Do not use.
   */
  class UnmanagedStorageType extends @unmanaged_storage_type, ReferenceStorageType {
    override string toString() { result = "UnmanagedStorageType" }
  }

  /**
   * INTERNAL: Do not use.
   */
  class UnownedStorageType extends @unowned_storage_type, ReferenceStorageType {
    override string toString() { result = "UnownedStorageType" }
  }

  /**
   * INTERNAL: Do not use.
   */
  class WeakStorageType extends @weak_storage_type, ReferenceStorageType {
    override string toString() { result = "WeakStorageType" }
  }

  /**
   * INTERNAL: Do not use.
   */
  class BoundGenericType extends @bound_generic_type, NominalOrBoundGenericNominalType {
    /**
     * Gets the `index`th argument type of this bound generic type (0-based).
     */
    Type getArgType(int index) { bound_generic_type_arg_types(this, index, result) }
  }

  /**
   * INTERNAL: Do not use.
   */
  class BuiltinIntegerLiteralType extends @builtin_integer_literal_type, AnyBuiltinIntegerType {
    override string toString() { result = "BuiltinIntegerLiteralType" }
  }

  /**
   * INTERNAL: Do not use.
   */
  class BuiltinIntegerType extends @builtin_integer_type, AnyBuiltinIntegerType {
    override string toString() { result = "BuiltinIntegerType" }

    /**
     * Gets the width of this builtin integer type, if it exists.
     */
    int getWidth() { builtin_integer_type_widths(this, result) }
  }

  /**
   * INTERNAL: Do not use.
   */
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

  /**
   * INTERNAL: Do not use.
   */
  class LocalArchetypeType extends @local_archetype_type, ArchetypeType { }

  /**
   * INTERNAL: Do not use.
   */
  class NominalType extends @nominal_type, NominalOrBoundGenericNominalType { }

  /**
   * INTERNAL: Do not use.
   * An opaque type, that is a type formally equivalent to an underlying type but abstracting it away.
   *
   * See https://docs.swift.org/swift-book/LanguageGuide/OpaqueTypes.html.
   */
  class OpaqueTypeArchetypeType extends @opaque_type_archetype_type, ArchetypeType {
    override string toString() { result = "OpaqueTypeArchetypeType" }

    /**
     * Gets the declaration of this opaque type archetype type.
     */
    OpaqueTypeDecl getDeclaration() { opaque_type_archetype_types(this, result) }
  }

  /**
   * INTERNAL: Do not use.
   * An archetype type of PackType.
   */
  class PackArchetypeType extends @pack_archetype_type, ArchetypeType {
    override string toString() { result = "PackArchetypeType" }
  }

  /**
   * INTERNAL: Do not use.
   */
  class PrimaryArchetypeType extends @primary_archetype_type, ArchetypeType {
    override string toString() { result = "PrimaryArchetypeType" }
  }

  /**
   * INTERNAL: Do not use.
   */
  class UnarySyntaxSugarType extends @unary_syntax_sugar_type, SyntaxSugarType {
    /**
     * Gets the base type of this unary syntax sugar type.
     */
    Type getBaseType() { unary_syntax_sugar_types(this, result) }
  }

  /**
   * INTERNAL: Do not use.
   */
  class ArraySliceType extends @array_slice_type, UnarySyntaxSugarType {
    override string toString() { result = "ArraySliceType" }
  }

  /**
   * INTERNAL: Do not use.
   */
  class BoundGenericClassType extends @bound_generic_class_type, BoundGenericType {
    override string toString() { result = "BoundGenericClassType" }
  }

  /**
   * INTERNAL: Do not use.
   */
  class BoundGenericEnumType extends @bound_generic_enum_type, BoundGenericType {
    override string toString() { result = "BoundGenericEnumType" }
  }

  /**
   * INTERNAL: Do not use.
   */
  class BoundGenericStructType extends @bound_generic_struct_type, BoundGenericType {
    override string toString() { result = "BoundGenericStructType" }
  }

  /**
   * INTERNAL: Do not use.
   */
  class ClassType extends @class_type, NominalType {
    override string toString() { result = "ClassType" }
  }

  /**
   * INTERNAL: Do not use.
   * An archetype type of PackElementType.
   */
  class ElementArchetypeType extends @element_archetype_type, LocalArchetypeType {
    override string toString() { result = "ElementArchetypeType" }
  }

  /**
   * INTERNAL: Do not use.
   */
  class EnumType extends @enum_type, NominalType {
    override string toString() { result = "EnumType" }
  }

  /**
   * INTERNAL: Do not use.
   */
  class OpenedArchetypeType extends @opened_archetype_type, LocalArchetypeType {
    override string toString() { result = "OpenedArchetypeType" }
  }

  /**
   * INTERNAL: Do not use.
   */
  class OptionalType extends @optional_type, UnarySyntaxSugarType {
    override string toString() { result = "OptionalType" }
  }

  /**
   * INTERNAL: Do not use.
   */
  class ProtocolType extends @protocol_type, NominalType {
    override string toString() { result = "ProtocolType" }
  }

  /**
   * INTERNAL: Do not use.
   */
  class StructType extends @struct_type, NominalType {
    override string toString() { result = "StructType" }
  }

  /**
   * INTERNAL: Do not use.
   */
  class VariadicSequenceType extends @variadic_sequence_type, UnarySyntaxSugarType {
    override string toString() { result = "VariadicSequenceType" }
  }
}
