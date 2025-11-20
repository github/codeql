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

  private Element getImmediateChildOfComment(Comment e, int index) { none() }

  /**
   * INTERNAL: Do not use.
   */
  class DbFile extends @db_file, File {
    override string toString() { result = "DbFile" }
  }

  private Element getImmediateChildOfDbFile(DbFile e, int index) { none() }

  /**
   * INTERNAL: Do not use.
   */
  class DbLocation extends @db_location, Location {
    override string toString() { result = "DbLocation" }
  }

  private Element getImmediateChildOfDbLocation(DbLocation e, int index) { none() }

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

  private Element getImmediateChildOfDiagnostics(Diagnostics e, int index) { none() }

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

    /**
     * Gets the number of specs of this availability info.
     */
    int getNumberOfSpecs() { result = count(int i | availability_info_specs(this, i, _)) }
  }

  private Element getImmediateChildOfAvailabilityInfo(AvailabilityInfo e, int index) {
    exists(int n, int nSpec |
      n = 0 and
      nSpec = n + e.getNumberOfSpecs() and
      (
        none()
        or
        result = e.getSpec(index - n)
      )
    )
  }

  /**
   * INTERNAL: Do not use.
   * An availability spec, that is, part of an `AvailabilityInfo` condition. For example `iOS 12` and `*` in:
   * ```
   * if #available(iOS 12, *)
   * ```
   */
  class AvailabilitySpec extends @availability_spec, AstNode {
    override string toString() { result = "AvailabilitySpec" }

    /**
     * Gets the platform of this availability spec, if it exists.
     */
    string getPlatform() { availability_spec_platforms(this, result) }

    /**
     * Gets the version of this availability spec, if it exists.
     */
    string getVersion() { availability_spec_versions(this, result) }

    /**
     * Holds if this availability spec is wildcard.
     */
    predicate isWildcard() { availability_spec_is_wildcard(this) }
  }

  private Element getImmediateChildOfAvailabilitySpec(AvailabilitySpec e, int index) { none() }

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
     * Gets the number of parameters of this callable.
     */
    int getNumberOfParams() { result = count(int i | callable_params(this, i, _)) }

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

    /**
     * Gets the number of captures of this callable.
     */
    int getNumberOfCaptures() { result = count(int i | callable_captures(this, i, _)) }
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
     * This is 4 for method or initializer application, 5 for members, 6 for array and dictionary
     * subscripts, 7 for optional forcing (`!`), 8 for optional chaining (`?`), 9 for implicit
     * optional wrapping, 10 for `self`, and 11 for tuple element indexing.
     *
     * The following values should not appear: 0 for invalid components, 1 for unresolved
     * method or initializer applications, 2 for unresolved members, 3 for unresolved subscripts,
     * 12 for #keyPath dictionary keys, and 13 for implicit IDE code completion data.
     */
    int getKind() { key_path_components(this, result, _) }

    /**
     * Gets the `index`th argument to an array or dictionary subscript expression (0-based).
     */
    Argument getSubscriptArgument(int index) {
      key_path_component_subscript_arguments(this, index, result)
    }

    /**
     * Gets the number of arguments to an array or dictionary subscript expression.
     */
    int getNumberOfSubscriptArguments() {
      result = count(int i | key_path_component_subscript_arguments(this, i, _))
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

  private Element getImmediateChildOfKeyPathComponent(KeyPathComponent e, int index) {
    exists(int n, int nSubscriptArgument |
      n = 0 and
      nSubscriptArgument = n + e.getNumberOfSubscriptArguments() and
      (
        none()
        or
        result = e.getSubscriptArgument(index - n)
      )
    )
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
    Expr getConformance(int index) { macro_role_conformances(this, index, result) }

    /**
     * Gets the number of conformances of this macro role.
     */
    int getNumberOfConformances() { result = count(int i | macro_role_conformances(this, i, _)) }

    /**
     * Gets the `index`th name of this macro role (0-based).
     */
    string getName(int index) { macro_role_names(this, index, result) }

    /**
     * Gets the number of names of this macro role.
     */
    int getNumberOfNames() { result = count(int i | macro_role_names(this, i, _)) }
  }

  private Element getImmediateChildOfMacroRole(MacroRole e, int index) { none() }

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

    /**
     * Gets the number of children of this unspecified element.
     */
    int getNumberOfChildren() { result = count(int i | unspecified_element_children(this, i, _)) }
  }

  private Element getImmediateChildOfUnspecifiedElement(UnspecifiedElement e, int index) {
    exists(int n, int nChild |
      n = 0 and
      nChild = n + e.getNumberOfChildren() and
      (
        none()
        or
        result = e.getChild(index - n)
      )
    )
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

    /**
     * Gets the number of members of this declaration.
     */
    int getNumberOfMembers() { result = count(int i | decl_members(this, i, _)) }
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

    /**
     * Gets the number of generic type parameters of this generic context.
     */
    int getNumberOfGenericTypeParams() {
      result = count(int i | generic_context_generic_type_params(this, i, _))
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

  private Element getImmediateChildOfCapturedDecl(CapturedDecl e, int index) {
    exists(int n, int nMember |
      n = 0 and
      nMember = n + e.getNumberOfMembers() and
      (
        none()
        or
        result = e.getMember(index - n)
      )
    )
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

    /**
     * Gets the number of elements of this enum case declaration.
     */
    int getNumberOfElements() { result = count(int i | enum_case_decl_elements(this, i, _)) }
  }

  private Element getImmediateChildOfEnumCaseDecl(EnumCaseDecl e, int index) {
    exists(int n, int nMember |
      n = 0 and
      nMember = n + e.getNumberOfMembers() and
      (
        none()
        or
        result = e.getMember(index - n)
      )
    )
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

    /**
     * Gets the number of protocols of this extension declaration.
     */
    int getNumberOfProtocols() { result = count(int i | extension_decl_protocols(this, i, _)) }
  }

  private Element getImmediateChildOfExtensionDecl(ExtensionDecl e, int index) {
    exists(int n, int nGenericTypeParam, int nMember |
      n = 0 and
      nGenericTypeParam = n + e.getNumberOfGenericTypeParams() and
      nMember = nGenericTypeParam + e.getNumberOfMembers() and
      (
        none()
        or
        result = e.getGenericTypeParam(index - n)
        or
        result = e.getMember(index - nGenericTypeParam)
      )
    )
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

    /**
     * Gets the number of active elements of this if config declaration.
     */
    int getNumberOfActiveElements() {
      result = count(int i | if_config_decl_active_elements(this, i, _))
    }
  }

  private Element getImmediateChildOfIfConfigDecl(IfConfigDecl e, int index) {
    exists(int n, int nMember |
      n = 0 and
      nMember = n + e.getNumberOfMembers() and
      (
        none()
        or
        result = e.getMember(index - n)
      )
    )
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

    /**
     * Gets the number of declarations of this import declaration.
     */
    int getNumberOfDeclarations() { result = count(int i | import_decl_declarations(this, i, _)) }
  }

  private Element getImmediateChildOfImportDecl(ImportDecl e, int index) {
    exists(int n, int nMember |
      n = 0 and
      nMember = n + e.getNumberOfMembers() and
      (
        none()
        or
        result = e.getMember(index - n)
      )
    )
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

  private Element getImmediateChildOfMissingMemberDecl(MissingMemberDecl e, int index) {
    exists(int n, int nMember |
      n = 0 and
      nMember = n + e.getNumberOfMembers() and
      (
        none()
        or
        result = e.getMember(index - n)
      )
    )
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
     * Gets the number of inits of this pattern binding declaration.
     */
    int getNumberOfInits() { result = count(int i | pattern_binding_decl_inits(this, i, _)) }

    /**
     * Gets the `index`th pattern of this pattern binding declaration (0-based).
     */
    Pattern getPattern(int index) { pattern_binding_decl_patterns(this, index, result) }

    /**
     * Gets the number of patterns of this pattern binding declaration.
     */
    int getNumberOfPatterns() { result = count(int i | pattern_binding_decl_patterns(this, i, _)) }
  }

  private Element getImmediateChildOfPatternBindingDecl(PatternBindingDecl e, int index) {
    exists(int n, int nMember, int nInit, int nPattern |
      n = 0 and
      nMember = n + e.getNumberOfMembers() and
      nInit = nMember + e.getNumberOfInits() and
      nPattern = nInit + e.getNumberOfPatterns() and
      (
        none()
        or
        result = e.getMember(index - n)
        or
        result = e.getInit(index - nMember)
        or
        result = e.getPattern(index - nInit)
      )
    )
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

  private Element getImmediateChildOfPoundDiagnosticDecl(PoundDiagnosticDecl e, int index) {
    exists(int n, int nMember, int nMessage |
      n = 0 and
      nMember = n + e.getNumberOfMembers() and
      nMessage = nMember + 1 and
      (
        none()
        or
        result = e.getMember(index - n)
        or
        index = nMember and result = e.getMessage()
      )
    )
  }

  /**
   * INTERNAL: Do not use.
   */
  class PrecedenceGroupDecl extends @precedence_group_decl, Decl {
    override string toString() { result = "PrecedenceGroupDecl" }
  }

  private Element getImmediateChildOfPrecedenceGroupDecl(PrecedenceGroupDecl e, int index) {
    exists(int n, int nMember |
      n = 0 and
      nMember = n + e.getNumberOfMembers() and
      (
        none()
        or
        result = e.getMember(index - n)
      )
    )
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

  private Element getImmediateChildOfTopLevelCodeDecl(TopLevelCodeDecl e, int index) {
    exists(int n, int nMember, int nBody |
      n = 0 and
      nMember = n + e.getNumberOfMembers() and
      nBody = nMember + 1 and
      (
        none()
        or
        result = e.getMember(index - n)
        or
        index = nMember and result = e.getBody()
      )
    )
  }

  /**
   * INTERNAL: Do not use.
   */
  class UsingDecl extends @using_decl, Decl {
    override string toString() { result = "UsingDecl" }

    /**
     * Holds if this using declaration is main actor.
     */
    predicate isMainActor() { using_decl_is_main_actor(this) }

    /**
     * Holds if this using declaration is nonisolated.
     */
    predicate isNonisolated() { using_decl_is_nonisolated(this) }
  }

  private Element getImmediateChildOfUsingDecl(UsingDecl e, int index) {
    exists(int n, int nMember |
      n = 0 and
      nMember = n + e.getNumberOfMembers() and
      (
        none()
        or
        result = e.getMember(index - n)
      )
    )
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

    /**
     * Gets the number of accessors of this abstract storage declaration.
     */
    int getNumberOfAccessors() {
      result = count(int i | abstract_storage_decl_accessors(this, i, _))
    }
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

    /**
     * Gets the number of parameters of this enum element declaration.
     */
    int getNumberOfParams() { result = count(int i | enum_element_decl_params(this, i, _)) }
  }

  private Element getImmediateChildOfEnumElementDecl(EnumElementDecl e, int index) {
    exists(int n, int nMember, int nParam |
      n = 0 and
      nMember = n + e.getNumberOfMembers() and
      nParam = nMember + e.getNumberOfParams() and
      (
        none()
        or
        result = e.getMember(index - n)
        or
        result = e.getParam(index - nMember)
      )
    )
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

  private Element getImmediateChildOfInfixOperatorDecl(InfixOperatorDecl e, int index) {
    exists(int n, int nMember |
      n = 0 and
      nMember = n + e.getNumberOfMembers() and
      (
        none()
        or
        result = e.getMember(index - n)
      )
    )
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
     * Gets the number of parameters of this macro.
     */
    int getNumberOfParameters() { result = count(int i | macro_decl_parameters(this, i, _)) }

    /**
     * Gets the `index`th role of this macro (0-based).
     */
    MacroRole getRole(int index) { macro_decl_roles(this, index, result) }

    /**
     * Gets the number of roles of this macro.
     */
    int getNumberOfRoles() { result = count(int i | macro_decl_roles(this, i, _)) }
  }

  private Element getImmediateChildOfMacroDecl(MacroDecl e, int index) {
    exists(int n, int nGenericTypeParam, int nMember |
      n = 0 and
      nGenericTypeParam = n + e.getNumberOfGenericTypeParams() and
      nMember = nGenericTypeParam + e.getNumberOfMembers() and
      (
        none()
        or
        result = e.getGenericTypeParam(index - n)
        or
        result = e.getMember(index - nGenericTypeParam)
      )
    )
  }

  /**
   * INTERNAL: Do not use.
   */
  class PostfixOperatorDecl extends @postfix_operator_decl, OperatorDecl {
    override string toString() { result = "PostfixOperatorDecl" }
  }

  private Element getImmediateChildOfPostfixOperatorDecl(PostfixOperatorDecl e, int index) {
    exists(int n, int nMember |
      n = 0 and
      nMember = n + e.getNumberOfMembers() and
      (
        none()
        or
        result = e.getMember(index - n)
      )
    )
  }

  /**
   * INTERNAL: Do not use.
   */
  class PrefixOperatorDecl extends @prefix_operator_decl, OperatorDecl {
    override string toString() { result = "PrefixOperatorDecl" }
  }

  private Element getImmediateChildOfPrefixOperatorDecl(PrefixOperatorDecl e, int index) {
    exists(int n, int nMember |
      n = 0 and
      nMember = n + e.getNumberOfMembers() and
      (
        none()
        or
        result = e.getMember(index - n)
      )
    )
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

    /**
     * Gets the number of inherited types of this type declaration.
     */
    int getNumberOfInheritedTypes() {
      result = count(int i | type_decl_inherited_types(this, i, _))
    }
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

  private Element getImmediateChildOfDeinitializer(Deinitializer e, int index) {
    exists(
      int n, int nGenericTypeParam, int nMember, int nSelfParam, int nParam, int nBody, int nCapture
    |
      n = 0 and
      nGenericTypeParam = n + e.getNumberOfGenericTypeParams() and
      nMember = nGenericTypeParam + e.getNumberOfMembers() and
      nSelfParam = nMember + 1 and
      nParam = nSelfParam + e.getNumberOfParams() and
      nBody = nParam + 1 and
      nCapture = nBody + e.getNumberOfCaptures() and
      (
        none()
        or
        result = e.getGenericTypeParam(index - n)
        or
        result = e.getMember(index - nGenericTypeParam)
        or
        index = nMember and result = e.getSelfParam()
        or
        result = e.getParam(index - nSelfParam)
        or
        index = nParam and result = e.getBody()
        or
        result = e.getCapture(index - nBody)
      )
    )
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

  private Element getImmediateChildOfInitializer(Initializer e, int index) {
    exists(
      int n, int nGenericTypeParam, int nMember, int nSelfParam, int nParam, int nBody, int nCapture
    |
      n = 0 and
      nGenericTypeParam = n + e.getNumberOfGenericTypeParams() and
      nMember = nGenericTypeParam + e.getNumberOfMembers() and
      nSelfParam = nMember + 1 and
      nParam = nSelfParam + e.getNumberOfParams() and
      nBody = nParam + 1 and
      nCapture = nBody + e.getNumberOfCaptures() and
      (
        none()
        or
        result = e.getGenericTypeParam(index - n)
        or
        result = e.getMember(index - nGenericTypeParam)
        or
        index = nMember and result = e.getSelfParam()
        or
        result = e.getParam(index - nSelfParam)
        or
        index = nParam and result = e.getBody()
        or
        result = e.getCapture(index - nBody)
      )
    )
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

  private Element getImmediateChildOfModuleDecl(ModuleDecl e, int index) {
    exists(int n, int nMember |
      n = 0 and
      nMember = n + e.getNumberOfMembers() and
      (
        none()
        or
        result = e.getMember(index - n)
      )
    )
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
     * Gets the number of parameters of this subscript declaration.
     */
    int getNumberOfParams() { result = count(int i | subscript_decl_params(this, i, _)) }

    /**
     * Gets the element type of this subscript declaration.
     */
    Type getElementType() { subscript_decls(this, result) }
  }

  private Element getImmediateChildOfSubscriptDecl(SubscriptDecl e, int index) {
    exists(int n, int nMember, int nAccessor, int nGenericTypeParam, int nParam |
      n = 0 and
      nMember = n + e.getNumberOfMembers() and
      nAccessor = nMember + e.getNumberOfAccessors() and
      nGenericTypeParam = nAccessor + e.getNumberOfGenericTypeParams() and
      nParam = nGenericTypeParam + e.getNumberOfParams() and
      (
        none()
        or
        result = e.getMember(index - n)
        or
        result = e.getAccessor(index - nMember)
        or
        result = e.getGenericTypeParam(index - nAccessor)
        or
        result = e.getParam(index - nGenericTypeParam)
      )
    )
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

    /**
     * Holds if this accessor is a distributed getter.
     */
    predicate isDistributedGet() { accessor_is_distributed_get(this) }

    /**
     * Holds if this accessor is a `read` coroutine, yielding a borrowed value of the property.
     */
    predicate isRead2() { accessor_is_read2(this) }

    /**
     * Holds if this accessor is a `modify` coroutine, yielding an inout value of the property.
     */
    predicate isModify2() { accessor_is_modify2(this) }

    /**
     * Holds if this accessor is an `init` accessor.
     */
    predicate isInit() { accessor_is_init(this) }
  }

  private Element getImmediateChildOfAccessor(Accessor e, int index) {
    exists(
      int n, int nGenericTypeParam, int nMember, int nSelfParam, int nParam, int nBody, int nCapture
    |
      n = 0 and
      nGenericTypeParam = n + e.getNumberOfGenericTypeParams() and
      nMember = nGenericTypeParam + e.getNumberOfMembers() and
      nSelfParam = nMember + 1 and
      nParam = nSelfParam + e.getNumberOfParams() and
      nBody = nParam + 1 and
      nCapture = nBody + e.getNumberOfCaptures() and
      (
        none()
        or
        result = e.getGenericTypeParam(index - n)
        or
        result = e.getMember(index - nGenericTypeParam)
        or
        index = nMember and result = e.getSelfParam()
        or
        result = e.getParam(index - nSelfParam)
        or
        index = nParam and result = e.getBody()
        or
        result = e.getCapture(index - nBody)
      )
    )
  }

  /**
   * INTERNAL: Do not use.
   */
  class AssociatedTypeDecl extends @associated_type_decl, AbstractTypeParamDecl {
    override string toString() { result = "AssociatedTypeDecl" }
  }

  private Element getImmediateChildOfAssociatedTypeDecl(AssociatedTypeDecl e, int index) {
    exists(int n, int nMember |
      n = 0 and
      nMember = n + e.getNumberOfMembers() and
      (
        none()
        or
        result = e.getMember(index - n)
      )
    )
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

  private Element getImmediateChildOfConcreteVarDecl(ConcreteVarDecl e, int index) {
    exists(
      int n, int nMember, int nAccessor, int nPropertyWrapperBackingVarBinding,
      int nPropertyWrapperBackingVar, int nPropertyWrapperProjectionVarBinding,
      int nPropertyWrapperProjectionVar
    |
      n = 0 and
      nMember = n + e.getNumberOfMembers() and
      nAccessor = nMember + e.getNumberOfAccessors() and
      nPropertyWrapperBackingVarBinding = nAccessor + 1 and
      nPropertyWrapperBackingVar = nPropertyWrapperBackingVarBinding + 1 and
      nPropertyWrapperProjectionVarBinding = nPropertyWrapperBackingVar + 1 and
      nPropertyWrapperProjectionVar = nPropertyWrapperProjectionVarBinding + 1 and
      (
        none()
        or
        result = e.getMember(index - n)
        or
        result = e.getAccessor(index - nMember)
        or
        index = nAccessor and result = e.getPropertyWrapperBackingVarBinding()
        or
        index = nPropertyWrapperBackingVarBinding and result = e.getPropertyWrapperBackingVar()
        or
        index = nPropertyWrapperBackingVar and result = e.getPropertyWrapperProjectionVarBinding()
        or
        index = nPropertyWrapperProjectionVarBinding and
        result = e.getPropertyWrapperProjectionVar()
      )
    )
  }

  /**
   * INTERNAL: Do not use.
   */
  class GenericTypeParamDecl extends @generic_type_param_decl, AbstractTypeParamDecl {
    override string toString() { result = "GenericTypeParamDecl" }
  }

  private Element getImmediateChildOfGenericTypeParamDecl(GenericTypeParamDecl e, int index) {
    exists(int n, int nMember |
      n = 0 and
      nMember = n + e.getNumberOfMembers() and
      (
        none()
        or
        result = e.getMember(index - n)
      )
    )
  }

  /**
   * INTERNAL: Do not use.
   */
  class NamedFunction extends @named_function, AccessorOrNamedFunction {
    override string toString() { result = "NamedFunction" }
  }

  private Element getImmediateChildOfNamedFunction(NamedFunction e, int index) {
    exists(
      int n, int nGenericTypeParam, int nMember, int nSelfParam, int nParam, int nBody, int nCapture
    |
      n = 0 and
      nGenericTypeParam = n + e.getNumberOfGenericTypeParams() and
      nMember = nGenericTypeParam + e.getNumberOfMembers() and
      nSelfParam = nMember + 1 and
      nParam = nSelfParam + e.getNumberOfParams() and
      nBody = nParam + 1 and
      nCapture = nBody + e.getNumberOfCaptures() and
      (
        none()
        or
        result = e.getGenericTypeParam(index - n)
        or
        result = e.getMember(index - nGenericTypeParam)
        or
        index = nMember and result = e.getSelfParam()
        or
        result = e.getParam(index - nSelfParam)
        or
        index = nParam and result = e.getBody()
        or
        result = e.getCapture(index - nBody)
      )
    )
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

    /**
     * Gets the number of opaque generic parameters of this opaque type declaration.
     */
    int getNumberOfOpaqueGenericParams() {
      result = count(int i | opaque_type_decl_opaque_generic_params(this, i, _))
    }
  }

  private Element getImmediateChildOfOpaqueTypeDecl(OpaqueTypeDecl e, int index) {
    exists(int n, int nGenericTypeParam, int nMember |
      n = 0 and
      nGenericTypeParam = n + e.getNumberOfGenericTypeParams() and
      nMember = nGenericTypeParam + e.getNumberOfMembers() and
      (
        none()
        or
        result = e.getGenericTypeParam(index - n)
        or
        result = e.getMember(index - nGenericTypeParam)
      )
    )
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

  private Element getImmediateChildOfParamDecl(ParamDecl e, int index) {
    exists(
      int n, int nMember, int nAccessor, int nPropertyWrapperBackingVarBinding,
      int nPropertyWrapperBackingVar, int nPropertyWrapperProjectionVarBinding,
      int nPropertyWrapperProjectionVar, int nPropertyWrapperLocalWrappedVarBinding,
      int nPropertyWrapperLocalWrappedVar
    |
      n = 0 and
      nMember = n + e.getNumberOfMembers() and
      nAccessor = nMember + e.getNumberOfAccessors() and
      nPropertyWrapperBackingVarBinding = nAccessor + 1 and
      nPropertyWrapperBackingVar = nPropertyWrapperBackingVarBinding + 1 and
      nPropertyWrapperProjectionVarBinding = nPropertyWrapperBackingVar + 1 and
      nPropertyWrapperProjectionVar = nPropertyWrapperProjectionVarBinding + 1 and
      nPropertyWrapperLocalWrappedVarBinding = nPropertyWrapperProjectionVar + 1 and
      nPropertyWrapperLocalWrappedVar = nPropertyWrapperLocalWrappedVarBinding + 1 and
      (
        none()
        or
        result = e.getMember(index - n)
        or
        result = e.getAccessor(index - nMember)
        or
        index = nAccessor and result = e.getPropertyWrapperBackingVarBinding()
        or
        index = nPropertyWrapperBackingVarBinding and result = e.getPropertyWrapperBackingVar()
        or
        index = nPropertyWrapperBackingVar and result = e.getPropertyWrapperProjectionVarBinding()
        or
        index = nPropertyWrapperProjectionVarBinding and
        result = e.getPropertyWrapperProjectionVar()
        or
        index = nPropertyWrapperProjectionVar and
        result = e.getPropertyWrapperLocalWrappedVarBinding()
        or
        index = nPropertyWrapperLocalWrappedVarBinding and
        result = e.getPropertyWrapperLocalWrappedVar()
      )
    )
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

  private Element getImmediateChildOfTypeAliasDecl(TypeAliasDecl e, int index) {
    exists(int n, int nGenericTypeParam, int nMember |
      n = 0 and
      nGenericTypeParam = n + e.getNumberOfGenericTypeParams() and
      nMember = nGenericTypeParam + e.getNumberOfMembers() and
      (
        none()
        or
        result = e.getGenericTypeParam(index - n)
        or
        result = e.getMember(index - nGenericTypeParam)
      )
    )
  }

  /**
   * INTERNAL: Do not use.
   */
  class ClassDecl extends @class_decl, NominalTypeDecl {
    override string toString() { result = "ClassDecl" }
  }

  private Element getImmediateChildOfClassDecl(ClassDecl e, int index) {
    exists(int n, int nGenericTypeParam, int nMember |
      n = 0 and
      nGenericTypeParam = n + e.getNumberOfGenericTypeParams() and
      nMember = nGenericTypeParam + e.getNumberOfMembers() and
      (
        none()
        or
        result = e.getGenericTypeParam(index - n)
        or
        result = e.getMember(index - nGenericTypeParam)
      )
    )
  }

  /**
   * INTERNAL: Do not use.
   */
  class EnumDecl extends @enum_decl, NominalTypeDecl {
    override string toString() { result = "EnumDecl" }
  }

  private Element getImmediateChildOfEnumDecl(EnumDecl e, int index) {
    exists(int n, int nGenericTypeParam, int nMember |
      n = 0 and
      nGenericTypeParam = n + e.getNumberOfGenericTypeParams() and
      nMember = nGenericTypeParam + e.getNumberOfMembers() and
      (
        none()
        or
        result = e.getGenericTypeParam(index - n)
        or
        result = e.getMember(index - nGenericTypeParam)
      )
    )
  }

  /**
   * INTERNAL: Do not use.
   */
  class ProtocolDecl extends @protocol_decl, NominalTypeDecl {
    override string toString() { result = "ProtocolDecl" }
  }

  private Element getImmediateChildOfProtocolDecl(ProtocolDecl e, int index) {
    exists(int n, int nGenericTypeParam, int nMember |
      n = 0 and
      nGenericTypeParam = n + e.getNumberOfGenericTypeParams() and
      nMember = nGenericTypeParam + e.getNumberOfMembers() and
      (
        none()
        or
        result = e.getGenericTypeParam(index - n)
        or
        result = e.getMember(index - nGenericTypeParam)
      )
    )
  }

  /**
   * INTERNAL: Do not use.
   */
  class StructDecl extends @struct_decl, NominalTypeDecl {
    override string toString() { result = "StructDecl" }
  }

  private Element getImmediateChildOfStructDecl(StructDecl e, int index) {
    exists(int n, int nGenericTypeParam, int nMember |
      n = 0 and
      nGenericTypeParam = n + e.getNumberOfGenericTypeParams() and
      nMember = nGenericTypeParam + e.getNumberOfMembers() and
      (
        none()
        or
        result = e.getGenericTypeParam(index - n)
        or
        result = e.getMember(index - nGenericTypeParam)
      )
    )
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

  private Element getImmediateChildOfArgument(Argument e, int index) {
    exists(int n, int nExpr |
      n = 0 and
      nExpr = n + 1 and
      (
        none()
        or
        index = n and result = e.getExpr()
      )
    )
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

  private Element getImmediateChildOfAppliedPropertyWrapperExpr(
    AppliedPropertyWrapperExpr e, int index
  ) {
    exists(int n, int nValue |
      n = 0 and
      nValue = n + 1 and
      (
        none()
        or
        index = n and result = e.getValue()
      )
    )
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

    /**
     * Gets the number of arguments passed to the applied function.
     */
    int getNumberOfArguments() { result = count(int i | apply_expr_arguments(this, i, _)) }
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

  private Element getImmediateChildOfAssignExpr(AssignExpr e, int index) {
    exists(int n, int nDest, int nSource |
      n = 0 and
      nDest = n + 1 and
      nSource = nDest + 1 and
      (
        none()
        or
        index = n and result = e.getDest()
        or
        index = nDest and result = e.getSource()
      )
    )
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

  private Element getImmediateChildOfBindOptionalExpr(BindOptionalExpr e, int index) {
    exists(int n, int nSubExpr |
      n = 0 and
      nSubExpr = n + 1 and
      (
        none()
        or
        index = n and result = e.getSubExpr()
      )
    )
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
     * Gets the number of binding declarations of this capture list expression.
     */
    int getNumberOfBindingDecls() {
      result = count(int i | capture_list_expr_binding_decls(this, i, _))
    }

    /**
     * Gets the closure body of this capture list expression.
     */
    ClosureExpr getClosureBody() { capture_list_exprs(this, result) }
  }

  private Element getImmediateChildOfCaptureListExpr(CaptureListExpr e, int index) {
    exists(int n, int nBindingDecl, int nVariable, int nClosureBody |
      n = 0 and
      nBindingDecl = n + e.getNumberOfBindingDecls() and
      nVariable = nBindingDecl and
      nClosureBody = nVariable + 1 and
      (
        none()
        or
        result = e.getBindingDecl(index - n)
        or
        index = nVariable and result = e.getClosureBody()
      )
    )
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

  private Element getImmediateChildOfConsumeExpr(ConsumeExpr e, int index) {
    exists(int n, int nSubExpr |
      n = 0 and
      nSubExpr = n + 1 and
      (
        none()
        or
        index = n and result = e.getSubExpr()
      )
    )
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

  private Element getImmediateChildOfCopyExpr(CopyExpr e, int index) {
    exists(int n, int nSubExpr |
      n = 0 and
      nSubExpr = n + 1 and
      (
        none()
        or
        index = n and result = e.getSubExpr()
      )
    )
  }

  /**
   * INTERNAL: Do not use.
   * An expression that extracts the actor isolation of the current context, of type `(any Actor)?`.
   * This is synthesized by the type checker and does not have any way to be expressed explicitly in
   * the source.
   */
  class CurrentContextIsolationExpr extends @current_context_isolation_expr, Expr {
    override string toString() { result = "CurrentContextIsolationExpr" }

    /**
     * Gets the actor of this current context isolation expression.
     */
    Expr getActor() { current_context_isolation_exprs(this, result) }
  }

  private Element getImmediateChildOfCurrentContextIsolationExpr(
    CurrentContextIsolationExpr e, int index
  ) {
    none()
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
     * Gets the number of replacement types of this declaration reference expression.
     */
    int getNumberOfReplacementTypes() {
      result = count(int i | decl_ref_expr_replacement_types(this, i, _))
    }

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

  private Element getImmediateChildOfDeclRefExpr(DeclRefExpr e, int index) { none() }

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

  private Element getImmediateChildOfDefaultArgumentExpr(DefaultArgumentExpr e, int index) {
    none()
  }

  /**
   * INTERNAL: Do not use.
   */
  class DiscardAssignmentExpr extends @discard_assignment_expr, Expr {
    override string toString() { result = "DiscardAssignmentExpr" }
  }

  private Element getImmediateChildOfDiscardAssignmentExpr(DiscardAssignmentExpr e, int index) {
    none()
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

  private Element getImmediateChildOfDotSyntaxBaseIgnoredExpr(DotSyntaxBaseIgnoredExpr e, int index) {
    exists(int n, int nQualifier, int nSubExpr |
      n = 0 and
      nQualifier = n + 1 and
      nSubExpr = nQualifier + 1 and
      (
        none()
        or
        index = n and result = e.getQualifier()
        or
        index = nQualifier and result = e.getSubExpr()
      )
    )
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

  private Element getImmediateChildOfDynamicTypeExpr(DynamicTypeExpr e, int index) {
    exists(int n, int nBase |
      n = 0 and
      nBase = n + 1 and
      (
        none()
        or
        index = n and result = e.getBase()
      )
    )
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

  private Element getImmediateChildOfEnumIsCaseExpr(EnumIsCaseExpr e, int index) {
    exists(int n, int nSubExpr |
      n = 0 and
      nSubExpr = n + 1 and
      (
        none()
        or
        index = n and result = e.getSubExpr()
      )
    )
  }

  /**
   * INTERNAL: Do not use.
   */
  class ErrorExpr extends @error_expr, Expr, ErrorElement {
    override string toString() { result = "ErrorExpr" }
  }

  private Element getImmediateChildOfErrorExpr(ErrorExpr e, int index) { none() }

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
   * An expression that extracts the function isolation of an expression with `@isolated(any)`
   * function type.
   *
   * For example:
   * ```
   * func foo(x: @isolated(any) () -> ()) {
   *     let isolation = x.isolation
   * }
   * ```
   */
  class ExtractFunctionIsolationExpr extends @extract_function_isolation_expr, Expr {
    override string toString() { result = "ExtractFunctionIsolationExpr" }

    /**
     * Gets the function expression of this extract function isolation expression.
     */
    Expr getFunctionExpr() { extract_function_isolation_exprs(this, result) }
  }

  private Element getImmediateChildOfExtractFunctionIsolationExpr(
    ExtractFunctionIsolationExpr e, int index
  ) {
    exists(int n, int nFunctionExpr |
      n = 0 and
      nFunctionExpr = n + 1 and
      (
        none()
        or
        index = n and result = e.getFunctionExpr()
      )
    )
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

  private Element getImmediateChildOfForceValueExpr(ForceValueExpr e, int index) {
    exists(int n, int nSubExpr |
      n = 0 and
      nSubExpr = n + 1 and
      (
        none()
        or
        index = n and result = e.getSubExpr()
      )
    )
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

  private Element getImmediateChildOfIfExpr(IfExpr e, int index) {
    exists(int n, int nCondition, int nThenExpr, int nElseExpr |
      n = 0 and
      nCondition = n + 1 and
      nThenExpr = nCondition + 1 and
      nElseExpr = nThenExpr + 1 and
      (
        none()
        or
        index = n and result = e.getCondition()
        or
        index = nCondition and result = e.getThenExpr()
        or
        index = nThenExpr and result = e.getElseExpr()
      )
    )
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

  private Element getImmediateChildOfInOutExpr(InOutExpr e, int index) {
    exists(int n, int nSubExpr |
      n = 0 and
      nSubExpr = n + 1 and
      (
        none()
        or
        index = n and result = e.getSubExpr()
      )
    )
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

  private Element getImmediateChildOfKeyPathApplicationExpr(KeyPathApplicationExpr e, int index) {
    exists(int n, int nBase, int nKeyPath |
      n = 0 and
      nBase = n + 1 and
      nKeyPath = nBase + 1 and
      (
        none()
        or
        index = n and result = e.getBase()
        or
        index = nBase and result = e.getKeyPath()
      )
    )
  }

  /**
   * INTERNAL: Do not use.
   */
  class KeyPathDotExpr extends @key_path_dot_expr, Expr {
    override string toString() { result = "KeyPathDotExpr" }
  }

  private Element getImmediateChildOfKeyPathDotExpr(KeyPathDotExpr e, int index) { none() }

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

    /**
     * Gets the number of components of this key path expression.
     */
    int getNumberOfComponents() { result = count(int i | key_path_expr_components(this, i, _)) }
  }

  private Element getImmediateChildOfKeyPathExpr(KeyPathExpr e, int index) {
    exists(int n, int nRoot, int nComponent |
      n = 0 and
      nRoot = n + 1 and
      nComponent = nRoot + e.getNumberOfComponents() and
      (
        none()
        or
        index = n and result = e.getRoot()
        or
        result = e.getComponent(index - nRoot)
      )
    )
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

  private Element getImmediateChildOfLazyInitializationExpr(LazyInitializationExpr e, int index) {
    exists(int n, int nSubExpr |
      n = 0 and
      nSubExpr = n + 1 and
      (
        none()
        or
        index = n and result = e.getSubExpr()
      )
    )
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

  private Element getImmediateChildOfMakeTemporarilyEscapableExpr(
    MakeTemporarilyEscapableExpr e, int index
  ) {
    exists(int n, int nEscapingClosure, int nNonescapingClosure, int nSubExpr |
      n = 0 and
      nEscapingClosure = n + 1 and
      nNonescapingClosure = nEscapingClosure + 1 and
      nSubExpr = nNonescapingClosure + 1 and
      (
        none()
        or
        index = n and result = e.getEscapingClosure()
        or
        index = nEscapingClosure and result = e.getNonescapingClosure()
        or
        index = nNonescapingClosure and result = e.getSubExpr()
      )
    )
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

  private Element getImmediateChildOfMaterializePackExpr(MaterializePackExpr e, int index) {
    exists(int n, int nSubExpr |
      n = 0 and
      nSubExpr = n + 1 and
      (
        none()
        or
        index = n and result = e.getSubExpr()
      )
    )
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

  private Element getImmediateChildOfObjCSelectorExpr(ObjCSelectorExpr e, int index) {
    exists(int n, int nSubExpr |
      n = 0 and
      nSubExpr = n + 1 and
      (
        none()
        or
        index = n and result = e.getSubExpr()
      )
    )
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

  private Element getImmediateChildOfOneWayExpr(OneWayExpr e, int index) {
    exists(int n, int nSubExpr |
      n = 0 and
      nSubExpr = n + 1 and
      (
        none()
        or
        index = n and result = e.getSubExpr()
      )
    )
  }

  /**
   * INTERNAL: Do not use.
   */
  class OpaqueValueExpr extends @opaque_value_expr, Expr {
    override string toString() { result = "OpaqueValueExpr" }
  }

  private Element getImmediateChildOfOpaqueValueExpr(OpaqueValueExpr e, int index) { none() }

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

  private Element getImmediateChildOfOpenExistentialExpr(OpenExistentialExpr e, int index) {
    exists(int n, int nSubExpr, int nExistential |
      n = 0 and
      nSubExpr = n + 1 and
      nExistential = nSubExpr + 1 and
      (
        none()
        or
        index = n and result = e.getSubExpr()
        or
        index = nSubExpr and result = e.getExistential()
      )
    )
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

  private Element getImmediateChildOfOptionalEvaluationExpr(OptionalEvaluationExpr e, int index) {
    exists(int n, int nSubExpr |
      n = 0 and
      nSubExpr = n + 1 and
      (
        none()
        or
        index = n and result = e.getSubExpr()
      )
    )
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

  private Element getImmediateChildOfOtherInitializerRefExpr(OtherInitializerRefExpr e, int index) {
    none()
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

    /**
     * Gets the number of possible declarations of this overloaded declaration reference expression.
     */
    int getNumberOfPossibleDeclarations() {
      result = count(int i | overloaded_decl_ref_expr_possible_declarations(this, i, _))
    }
  }

  private Element getImmediateChildOfOverloadedDeclRefExpr(OverloadedDeclRefExpr e, int index) {
    none()
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

  private Element getImmediateChildOfPackElementExpr(PackElementExpr e, int index) {
    exists(int n, int nSubExpr |
      n = 0 and
      nSubExpr = n + 1 and
      (
        none()
        or
        index = n and result = e.getSubExpr()
      )
    )
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

  private Element getImmediateChildOfPackExpansionExpr(PackExpansionExpr e, int index) {
    exists(int n, int nPatternExpr |
      n = 0 and
      nPatternExpr = n + 1 and
      (
        none()
        or
        index = n and result = e.getPatternExpr()
      )
    )
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

  private Element getImmediateChildOfPropertyWrapperValuePlaceholderExpr(
    PropertyWrapperValuePlaceholderExpr e, int index
  ) {
    none()
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

  private Element getImmediateChildOfRebindSelfInInitializerExpr(
    RebindSelfInInitializerExpr e, int index
  ) {
    exists(int n, int nSubExpr |
      n = 0 and
      nSubExpr = n + 1 and
      (
        none()
        or
        index = n and result = e.getSubExpr()
      )
    )
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

    /**
     * Gets the number of elements of this sequence expression.
     */
    int getNumberOfElements() { result = count(int i | sequence_expr_elements(this, i, _)) }
  }

  private Element getImmediateChildOfSequenceExpr(SequenceExpr e, int index) {
    exists(int n, int nElement |
      n = 0 and
      nElement = n + e.getNumberOfElements() and
      (
        none()
        or
        result = e.getElement(index - n)
      )
    )
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

  private Element getImmediateChildOfSingleValueStmtExpr(SingleValueStmtExpr e, int index) {
    exists(int n, int nStmt |
      n = 0 and
      nStmt = n + 1 and
      (
        none()
        or
        index = n and result = e.getStmt()
      )
    )
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

  private Element getImmediateChildOfSuperRefExpr(SuperRefExpr e, int index) { none() }

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

  private Element getImmediateChildOfTapExpr(TapExpr e, int index) {
    exists(int n, int nSubExpr, int nBody |
      n = 0 and
      nSubExpr = n + 1 and
      nBody = nSubExpr + 1 and
      (
        none()
        or
        index = n and result = e.getSubExpr()
        or
        index = nSubExpr and result = e.getBody()
      )
    )
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

  private Element getImmediateChildOfTupleElementExpr(TupleElementExpr e, int index) {
    exists(int n, int nSubExpr |
      n = 0 and
      nSubExpr = n + 1 and
      (
        none()
        or
        index = n and result = e.getSubExpr()
      )
    )
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

    /**
     * Gets the number of elements of this tuple expression.
     */
    int getNumberOfElements() { result = count(int i | tuple_expr_elements(this, i, _)) }
  }

  private Element getImmediateChildOfTupleExpr(TupleExpr e, int index) {
    exists(int n, int nElement |
      n = 0 and
      nElement = n + e.getNumberOfElements() and
      (
        none()
        or
        result = e.getElement(index - n)
      )
    )
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

  private Element getImmediateChildOfTypeExpr(TypeExpr e, int index) {
    exists(int n, int nTypeRepr |
      n = 0 and
      nTypeRepr = n + 1 and
      (
        none()
        or
        index = n and result = e.getTypeRepr()
      )
    )
  }

  /**
   * INTERNAL: Do not use.
   */
  class TypeValueExpr extends @type_value_expr, Expr {
    override string toString() { result = "TypeValueExpr" }

    /**
     * Gets the type representation of this type value expression.
     */
    TypeRepr getTypeRepr() { type_value_exprs(this, result) }
  }

  private Element getImmediateChildOfTypeValueExpr(TypeValueExpr e, int index) {
    exists(int n, int nTypeRepr |
      n = 0 and
      nTypeRepr = n + 1 and
      (
        none()
        or
        index = n and result = e.getTypeRepr()
      )
    )
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

  private Element getImmediateChildOfUnresolvedDeclRefExpr(UnresolvedDeclRefExpr e, int index) {
    none()
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

  private Element getImmediateChildOfUnresolvedDotExpr(UnresolvedDotExpr e, int index) {
    exists(int n, int nBase |
      n = 0 and
      nBase = n + 1 and
      (
        none()
        or
        index = n and result = e.getBase()
      )
    )
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

  private Element getImmediateChildOfUnresolvedMemberExpr(UnresolvedMemberExpr e, int index) {
    none()
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

  private Element getImmediateChildOfUnresolvedPatternExpr(UnresolvedPatternExpr e, int index) {
    exists(int n, int nSubPattern |
      n = 0 and
      nSubPattern = n + 1 and
      (
        none()
        or
        index = n and result = e.getSubPattern()
      )
    )
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

  private Element getImmediateChildOfUnresolvedSpecializeExpr(UnresolvedSpecializeExpr e, int index) {
    exists(int n, int nSubExpr |
      n = 0 and
      nSubExpr = n + 1 and
      (
        none()
        or
        index = n and result = e.getSubExpr()
      )
    )
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

  private Element getImmediateChildOfVarargExpansionExpr(VarargExpansionExpr e, int index) {
    exists(int n, int nSubExpr |
      n = 0 and
      nSubExpr = n + 1 and
      (
        none()
        or
        index = n and result = e.getSubExpr()
      )
    )
  }

  /**
   * INTERNAL: Do not use.
   */
  class AbiSafeConversionExpr extends @abi_safe_conversion_expr, ImplicitConversionExpr {
    override string toString() { result = "AbiSafeConversionExpr" }
  }

  private Element getImmediateChildOfAbiSafeConversionExpr(AbiSafeConversionExpr e, int index) {
    exists(int n, int nSubExpr |
      n = 0 and
      nSubExpr = n + 1 and
      (
        none()
        or
        index = n and result = e.getSubExpr()
      )
    )
  }

  /**
   * INTERNAL: Do not use.
   * A conversion that erases the actor isolation of an expression with `@isolated(any)` function
   * type.
   */
  class ActorIsolationErasureExpr extends @actor_isolation_erasure_expr, ImplicitConversionExpr {
    override string toString() { result = "ActorIsolationErasureExpr" }
  }

  private Element getImmediateChildOfActorIsolationErasureExpr(
    ActorIsolationErasureExpr e, int index
  ) {
    exists(int n, int nSubExpr |
      n = 0 and
      nSubExpr = n + 1 and
      (
        none()
        or
        index = n and result = e.getSubExpr()
      )
    )
  }

  /**
   * INTERNAL: Do not use.
   */
  class AnyHashableErasureExpr extends @any_hashable_erasure_expr, ImplicitConversionExpr {
    override string toString() { result = "AnyHashableErasureExpr" }
  }

  private Element getImmediateChildOfAnyHashableErasureExpr(AnyHashableErasureExpr e, int index) {
    exists(int n, int nSubExpr |
      n = 0 and
      nSubExpr = n + 1 and
      (
        none()
        or
        index = n and result = e.getSubExpr()
      )
    )
  }

  /**
   * INTERNAL: Do not use.
   */
  class ArchetypeToSuperExpr extends @archetype_to_super_expr, ImplicitConversionExpr {
    override string toString() { result = "ArchetypeToSuperExpr" }
  }

  private Element getImmediateChildOfArchetypeToSuperExpr(ArchetypeToSuperExpr e, int index) {
    exists(int n, int nSubExpr |
      n = 0 and
      nSubExpr = n + 1 and
      (
        none()
        or
        index = n and result = e.getSubExpr()
      )
    )
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

    /**
     * Gets the number of elements of this array expression.
     */
    int getNumberOfElements() { result = count(int i | array_expr_elements(this, i, _)) }
  }

  private Element getImmediateChildOfArrayExpr(ArrayExpr e, int index) {
    exists(int n, int nElement |
      n = 0 and
      nElement = n + e.getNumberOfElements() and
      (
        none()
        or
        result = e.getElement(index - n)
      )
    )
  }

  /**
   * INTERNAL: Do not use.
   */
  class ArrayToPointerExpr extends @array_to_pointer_expr, ImplicitConversionExpr {
    override string toString() { result = "ArrayToPointerExpr" }
  }

  private Element getImmediateChildOfArrayToPointerExpr(ArrayToPointerExpr e, int index) {
    exists(int n, int nSubExpr |
      n = 0 and
      nSubExpr = n + 1 and
      (
        none()
        or
        index = n and result = e.getSubExpr()
      )
    )
  }

  /**
   * INTERNAL: Do not use.
   */
  class AutoClosureExpr extends @auto_closure_expr, ClosureExpr {
    override string toString() { result = "AutoClosureExpr" }
  }

  private Element getImmediateChildOfAutoClosureExpr(AutoClosureExpr e, int index) {
    exists(int n, int nSelfParam, int nParam, int nBody, int nCapture |
      n = 0 and
      nSelfParam = n + 1 and
      nParam = nSelfParam + e.getNumberOfParams() and
      nBody = nParam + 1 and
      nCapture = nBody + e.getNumberOfCaptures() and
      (
        none()
        or
        index = n and result = e.getSelfParam()
        or
        result = e.getParam(index - nSelfParam)
        or
        index = nParam and result = e.getBody()
        or
        result = e.getCapture(index - nBody)
      )
    )
  }

  /**
   * INTERNAL: Do not use.
   */
  class AwaitExpr extends @await_expr, IdentityExpr {
    override string toString() { result = "AwaitExpr" }
  }

  private Element getImmediateChildOfAwaitExpr(AwaitExpr e, int index) {
    exists(int n, int nSubExpr |
      n = 0 and
      nSubExpr = n + 1 and
      (
        none()
        or
        index = n and result = e.getSubExpr()
      )
    )
  }

  /**
   * INTERNAL: Do not use.
   */
  class BinaryExpr extends @binary_expr, ApplyExpr {
    override string toString() { result = "BinaryExpr" }
  }

  private Element getImmediateChildOfBinaryExpr(BinaryExpr e, int index) {
    exists(int n, int nFunction, int nArgument |
      n = 0 and
      nFunction = n + 1 and
      nArgument = nFunction + e.getNumberOfArguments() and
      (
        none()
        or
        index = n and result = e.getFunction()
        or
        result = e.getArgument(index - nFunction)
      )
    )
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

  private Element getImmediateChildOfBorrowExpr(BorrowExpr e, int index) {
    exists(int n, int nSubExpr |
      n = 0 and
      nSubExpr = n + 1 and
      (
        none()
        or
        index = n and result = e.getSubExpr()
      )
    )
  }

  /**
   * INTERNAL: Do not use.
   */
  class BridgeFromObjCExpr extends @bridge_from_obj_c_expr, ImplicitConversionExpr {
    override string toString() { result = "BridgeFromObjCExpr" }
  }

  private Element getImmediateChildOfBridgeFromObjCExpr(BridgeFromObjCExpr e, int index) {
    exists(int n, int nSubExpr |
      n = 0 and
      nSubExpr = n + 1 and
      (
        none()
        or
        index = n and result = e.getSubExpr()
      )
    )
  }

  /**
   * INTERNAL: Do not use.
   */
  class BridgeToObjCExpr extends @bridge_to_obj_c_expr, ImplicitConversionExpr {
    override string toString() { result = "BridgeToObjCExpr" }
  }

  private Element getImmediateChildOfBridgeToObjCExpr(BridgeToObjCExpr e, int index) {
    exists(int n, int nSubExpr |
      n = 0 and
      nSubExpr = n + 1 and
      (
        none()
        or
        index = n and result = e.getSubExpr()
      )
    )
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

  private Element getImmediateChildOfCallExpr(CallExpr e, int index) {
    exists(int n, int nFunction, int nArgument |
      n = 0 and
      nFunction = n + 1 and
      nArgument = nFunction + e.getNumberOfArguments() and
      (
        none()
        or
        index = n and result = e.getFunction()
        or
        result = e.getArgument(index - nFunction)
      )
    )
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

  private Element getImmediateChildOfClassMetatypeToObjectExpr(
    ClassMetatypeToObjectExpr e, int index
  ) {
    exists(int n, int nSubExpr |
      n = 0 and
      nSubExpr = n + 1 and
      (
        none()
        or
        index = n and result = e.getSubExpr()
      )
    )
  }

  /**
   * INTERNAL: Do not use.
   */
  class CoerceExpr extends @coerce_expr, ExplicitCastExpr {
    override string toString() { result = "CoerceExpr" }
  }

  private Element getImmediateChildOfCoerceExpr(CoerceExpr e, int index) {
    exists(int n, int nSubExpr |
      n = 0 and
      nSubExpr = n + 1 and
      (
        none()
        or
        index = n and result = e.getSubExpr()
      )
    )
  }

  /**
   * INTERNAL: Do not use.
   */
  class CollectionUpcastConversionExpr extends @collection_upcast_conversion_expr,
    ImplicitConversionExpr
  {
    override string toString() { result = "CollectionUpcastConversionExpr" }
  }

  private Element getImmediateChildOfCollectionUpcastConversionExpr(
    CollectionUpcastConversionExpr e, int index
  ) {
    exists(int n, int nSubExpr |
      n = 0 and
      nSubExpr = n + 1 and
      (
        none()
        or
        index = n and result = e.getSubExpr()
      )
    )
  }

  /**
   * INTERNAL: Do not use.
   */
  class ConditionalBridgeFromObjCExpr extends @conditional_bridge_from_obj_c_expr,
    ImplicitConversionExpr
  {
    override string toString() { result = "ConditionalBridgeFromObjCExpr" }
  }

  private Element getImmediateChildOfConditionalBridgeFromObjCExpr(
    ConditionalBridgeFromObjCExpr e, int index
  ) {
    exists(int n, int nSubExpr |
      n = 0 and
      nSubExpr = n + 1 and
      (
        none()
        or
        index = n and result = e.getSubExpr()
      )
    )
  }

  /**
   * INTERNAL: Do not use.
   */
  class CovariantFunctionConversionExpr extends @covariant_function_conversion_expr,
    ImplicitConversionExpr
  {
    override string toString() { result = "CovariantFunctionConversionExpr" }
  }

  private Element getImmediateChildOfCovariantFunctionConversionExpr(
    CovariantFunctionConversionExpr e, int index
  ) {
    exists(int n, int nSubExpr |
      n = 0 and
      nSubExpr = n + 1 and
      (
        none()
        or
        index = n and result = e.getSubExpr()
      )
    )
  }

  /**
   * INTERNAL: Do not use.
   */
  class CovariantReturnConversionExpr extends @covariant_return_conversion_expr,
    ImplicitConversionExpr
  {
    override string toString() { result = "CovariantReturnConversionExpr" }
  }

  private Element getImmediateChildOfCovariantReturnConversionExpr(
    CovariantReturnConversionExpr e, int index
  ) {
    exists(int n, int nSubExpr |
      n = 0 and
      nSubExpr = n + 1 and
      (
        none()
        or
        index = n and result = e.getSubExpr()
      )
    )
  }

  /**
   * INTERNAL: Do not use.
   */
  class DerivedToBaseExpr extends @derived_to_base_expr, ImplicitConversionExpr {
    override string toString() { result = "DerivedToBaseExpr" }
  }

  private Element getImmediateChildOfDerivedToBaseExpr(DerivedToBaseExpr e, int index) {
    exists(int n, int nSubExpr |
      n = 0 and
      nSubExpr = n + 1 and
      (
        none()
        or
        index = n and result = e.getSubExpr()
      )
    )
  }

  /**
   * INTERNAL: Do not use.
   */
  class DestructureTupleExpr extends @destructure_tuple_expr, ImplicitConversionExpr {
    override string toString() { result = "DestructureTupleExpr" }
  }

  private Element getImmediateChildOfDestructureTupleExpr(DestructureTupleExpr e, int index) {
    exists(int n, int nSubExpr |
      n = 0 and
      nSubExpr = n + 1 and
      (
        none()
        or
        index = n and result = e.getSubExpr()
      )
    )
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

    /**
     * Gets the number of elements of this dictionary expression.
     */
    int getNumberOfElements() { result = count(int i | dictionary_expr_elements(this, i, _)) }
  }

  private Element getImmediateChildOfDictionaryExpr(DictionaryExpr e, int index) {
    exists(int n, int nElement |
      n = 0 and
      nElement = n + e.getNumberOfElements() and
      (
        none()
        or
        result = e.getElement(index - n)
      )
    )
  }

  /**
   * INTERNAL: Do not use.
   */
  class DifferentiableFunctionExpr extends @differentiable_function_expr, ImplicitConversionExpr {
    override string toString() { result = "DifferentiableFunctionExpr" }
  }

  private Element getImmediateChildOfDifferentiableFunctionExpr(
    DifferentiableFunctionExpr e, int index
  ) {
    exists(int n, int nSubExpr |
      n = 0 and
      nSubExpr = n + 1 and
      (
        none()
        or
        index = n and result = e.getSubExpr()
      )
    )
  }

  /**
   * INTERNAL: Do not use.
   */
  class DifferentiableFunctionExtractOriginalExpr extends @differentiable_function_extract_original_expr,
    ImplicitConversionExpr
  {
    override string toString() { result = "DifferentiableFunctionExtractOriginalExpr" }
  }

  private Element getImmediateChildOfDifferentiableFunctionExtractOriginalExpr(
    DifferentiableFunctionExtractOriginalExpr e, int index
  ) {
    exists(int n, int nSubExpr |
      n = 0 and
      nSubExpr = n + 1 and
      (
        none()
        or
        index = n and result = e.getSubExpr()
      )
    )
  }

  /**
   * INTERNAL: Do not use.
   */
  class DotSelfExpr extends @dot_self_expr, IdentityExpr {
    override string toString() { result = "DotSelfExpr" }
  }

  private Element getImmediateChildOfDotSelfExpr(DotSelfExpr e, int index) {
    exists(int n, int nSubExpr |
      n = 0 and
      nSubExpr = n + 1 and
      (
        none()
        or
        index = n and result = e.getSubExpr()
      )
    )
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

  private Element getImmediateChildOfErasureExpr(ErasureExpr e, int index) {
    exists(int n, int nSubExpr |
      n = 0 and
      nSubExpr = n + 1 and
      (
        none()
        or
        index = n and result = e.getSubExpr()
      )
    )
  }

  /**
   * INTERNAL: Do not use.
   */
  class ExistentialMetatypeToObjectExpr extends @existential_metatype_to_object_expr,
    ImplicitConversionExpr
  {
    override string toString() { result = "ExistentialMetatypeToObjectExpr" }
  }

  private Element getImmediateChildOfExistentialMetatypeToObjectExpr(
    ExistentialMetatypeToObjectExpr e, int index
  ) {
    exists(int n, int nSubExpr |
      n = 0 and
      nSubExpr = n + 1 and
      (
        none()
        or
        index = n and result = e.getSubExpr()
      )
    )
  }

  /**
   * INTERNAL: Do not use.
   */
  class ExplicitClosureExpr extends @explicit_closure_expr, ClosureExpr {
    override string toString() { result = "ExplicitClosureExpr" }
  }

  private Element getImmediateChildOfExplicitClosureExpr(ExplicitClosureExpr e, int index) {
    exists(int n, int nSelfParam, int nParam, int nBody, int nCapture |
      n = 0 and
      nSelfParam = n + 1 and
      nParam = nSelfParam + e.getNumberOfParams() and
      nBody = nParam + 1 and
      nCapture = nBody + e.getNumberOfCaptures() and
      (
        none()
        or
        index = n and result = e.getSelfParam()
        or
        result = e.getParam(index - nSelfParam)
        or
        index = nParam and result = e.getBody()
        or
        result = e.getCapture(index - nBody)
      )
    )
  }

  /**
   * INTERNAL: Do not use.
   */
  class ForceTryExpr extends @force_try_expr, AnyTryExpr {
    override string toString() { result = "ForceTryExpr" }
  }

  private Element getImmediateChildOfForceTryExpr(ForceTryExpr e, int index) {
    exists(int n, int nSubExpr |
      n = 0 and
      nSubExpr = n + 1 and
      (
        none()
        or
        index = n and result = e.getSubExpr()
      )
    )
  }

  /**
   * INTERNAL: Do not use.
   */
  class ForeignObjectConversionExpr extends @foreign_object_conversion_expr, ImplicitConversionExpr {
    override string toString() { result = "ForeignObjectConversionExpr" }
  }

  private Element getImmediateChildOfForeignObjectConversionExpr(
    ForeignObjectConversionExpr e, int index
  ) {
    exists(int n, int nSubExpr |
      n = 0 and
      nSubExpr = n + 1 and
      (
        none()
        or
        index = n and result = e.getSubExpr()
      )
    )
  }

  /**
   * INTERNAL: Do not use.
   */
  class FunctionConversionExpr extends @function_conversion_expr, ImplicitConversionExpr {
    override string toString() { result = "FunctionConversionExpr" }
  }

  private Element getImmediateChildOfFunctionConversionExpr(FunctionConversionExpr e, int index) {
    exists(int n, int nSubExpr |
      n = 0 and
      nSubExpr = n + 1 and
      (
        none()
        or
        index = n and result = e.getSubExpr()
      )
    )
  }

  /**
   * INTERNAL: Do not use.
   */
  class InOutToPointerExpr extends @in_out_to_pointer_expr, ImplicitConversionExpr {
    override string toString() { result = "InOutToPointerExpr" }
  }

  private Element getImmediateChildOfInOutToPointerExpr(InOutToPointerExpr e, int index) {
    exists(int n, int nSubExpr |
      n = 0 and
      nSubExpr = n + 1 and
      (
        none()
        or
        index = n and result = e.getSubExpr()
      )
    )
  }

  /**
   * INTERNAL: Do not use.
   */
  class InjectIntoOptionalExpr extends @inject_into_optional_expr, ImplicitConversionExpr {
    override string toString() { result = "InjectIntoOptionalExpr" }
  }

  private Element getImmediateChildOfInjectIntoOptionalExpr(InjectIntoOptionalExpr e, int index) {
    exists(int n, int nSubExpr |
      n = 0 and
      nSubExpr = n + 1 and
      (
        none()
        or
        index = n and result = e.getSubExpr()
      )
    )
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

  private Element getImmediateChildOfInterpolatedStringLiteralExpr(
    InterpolatedStringLiteralExpr e, int index
  ) {
    exists(int n, int nAppendingExpr |
      n = 0 and
      nAppendingExpr = n + 1 and
      (
        none()
        or
        index = n and result = e.getAppendingExpr()
      )
    )
  }

  /**
   * INTERNAL: Do not use.
   */
  class LinearFunctionExpr extends @linear_function_expr, ImplicitConversionExpr {
    override string toString() { result = "LinearFunctionExpr" }
  }

  private Element getImmediateChildOfLinearFunctionExpr(LinearFunctionExpr e, int index) {
    exists(int n, int nSubExpr |
      n = 0 and
      nSubExpr = n + 1 and
      (
        none()
        or
        index = n and result = e.getSubExpr()
      )
    )
  }

  /**
   * INTERNAL: Do not use.
   */
  class LinearFunctionExtractOriginalExpr extends @linear_function_extract_original_expr,
    ImplicitConversionExpr
  {
    override string toString() { result = "LinearFunctionExtractOriginalExpr" }
  }

  private Element getImmediateChildOfLinearFunctionExtractOriginalExpr(
    LinearFunctionExtractOriginalExpr e, int index
  ) {
    exists(int n, int nSubExpr |
      n = 0 and
      nSubExpr = n + 1 and
      (
        none()
        or
        index = n and result = e.getSubExpr()
      )
    )
  }

  /**
   * INTERNAL: Do not use.
   */
  class LinearToDifferentiableFunctionExpr extends @linear_to_differentiable_function_expr,
    ImplicitConversionExpr
  {
    override string toString() { result = "LinearToDifferentiableFunctionExpr" }
  }

  private Element getImmediateChildOfLinearToDifferentiableFunctionExpr(
    LinearToDifferentiableFunctionExpr e, int index
  ) {
    exists(int n, int nSubExpr |
      n = 0 and
      nSubExpr = n + 1 and
      (
        none()
        or
        index = n and result = e.getSubExpr()
      )
    )
  }

  /**
   * INTERNAL: Do not use.
   */
  class LoadExpr extends @load_expr, ImplicitConversionExpr {
    override string toString() { result = "LoadExpr" }
  }

  private Element getImmediateChildOfLoadExpr(LoadExpr e, int index) {
    exists(int n, int nSubExpr |
      n = 0 and
      nSubExpr = n + 1 and
      (
        none()
        or
        index = n and result = e.getSubExpr()
      )
    )
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

  private Element getImmediateChildOfMemberRefExpr(MemberRefExpr e, int index) {
    exists(int n, int nBase |
      n = 0 and
      nBase = n + 1 and
      (
        none()
        or
        index = n and result = e.getBase()
      )
    )
  }

  /**
   * INTERNAL: Do not use.
   */
  class MetatypeConversionExpr extends @metatype_conversion_expr, ImplicitConversionExpr {
    override string toString() { result = "MetatypeConversionExpr" }
  }

  private Element getImmediateChildOfMetatypeConversionExpr(MetatypeConversionExpr e, int index) {
    exists(int n, int nSubExpr |
      n = 0 and
      nSubExpr = n + 1 and
      (
        none()
        or
        index = n and result = e.getSubExpr()
      )
    )
  }

  /**
   * INTERNAL: Do not use.
   */
  class NilLiteralExpr extends @nil_literal_expr, LiteralExpr {
    override string toString() { result = "NilLiteralExpr" }
  }

  private Element getImmediateChildOfNilLiteralExpr(NilLiteralExpr e, int index) { none() }

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

    /**
     * Gets the number of arguments of this object literal expression.
     */
    int getNumberOfArguments() { result = count(int i | object_literal_expr_arguments(this, i, _)) }
  }

  private Element getImmediateChildOfObjectLiteralExpr(ObjectLiteralExpr e, int index) {
    exists(int n, int nArgument |
      n = 0 and
      nArgument = n + e.getNumberOfArguments() and
      (
        none()
        or
        result = e.getArgument(index - n)
      )
    )
  }

  /**
   * INTERNAL: Do not use.
   */
  class OptionalTryExpr extends @optional_try_expr, AnyTryExpr {
    override string toString() { result = "OptionalTryExpr" }
  }

  private Element getImmediateChildOfOptionalTryExpr(OptionalTryExpr e, int index) {
    exists(int n, int nSubExpr |
      n = 0 and
      nSubExpr = n + 1 and
      (
        none()
        or
        index = n and result = e.getSubExpr()
      )
    )
  }

  /**
   * INTERNAL: Do not use.
   */
  class ParenExpr extends @paren_expr, IdentityExpr {
    override string toString() { result = "ParenExpr" }
  }

  private Element getImmediateChildOfParenExpr(ParenExpr e, int index) {
    exists(int n, int nSubExpr |
      n = 0 and
      nSubExpr = n + 1 and
      (
        none()
        or
        index = n and result = e.getSubExpr()
      )
    )
  }

  /**
   * INTERNAL: Do not use.
   */
  class PointerToPointerExpr extends @pointer_to_pointer_expr, ImplicitConversionExpr {
    override string toString() { result = "PointerToPointerExpr" }
  }

  private Element getImmediateChildOfPointerToPointerExpr(PointerToPointerExpr e, int index) {
    exists(int n, int nSubExpr |
      n = 0 and
      nSubExpr = n + 1 and
      (
        none()
        or
        index = n and result = e.getSubExpr()
      )
    )
  }

  /**
   * INTERNAL: Do not use.
   */
  class PostfixUnaryExpr extends @postfix_unary_expr, ApplyExpr {
    override string toString() { result = "PostfixUnaryExpr" }
  }

  private Element getImmediateChildOfPostfixUnaryExpr(PostfixUnaryExpr e, int index) {
    exists(int n, int nFunction, int nArgument |
      n = 0 and
      nFunction = n + 1 and
      nArgument = nFunction + e.getNumberOfArguments() and
      (
        none()
        or
        index = n and result = e.getFunction()
        or
        result = e.getArgument(index - nFunction)
      )
    )
  }

  /**
   * INTERNAL: Do not use.
   */
  class PrefixUnaryExpr extends @prefix_unary_expr, ApplyExpr {
    override string toString() { result = "PrefixUnaryExpr" }
  }

  private Element getImmediateChildOfPrefixUnaryExpr(PrefixUnaryExpr e, int index) {
    exists(int n, int nFunction, int nArgument |
      n = 0 and
      nFunction = n + 1 and
      nArgument = nFunction + e.getNumberOfArguments() and
      (
        none()
        or
        index = n and result = e.getFunction()
        or
        result = e.getArgument(index - nFunction)
      )
    )
  }

  /**
   * INTERNAL: Do not use.
   */
  class ProtocolMetatypeToObjectExpr extends @protocol_metatype_to_object_expr,
    ImplicitConversionExpr
  {
    override string toString() { result = "ProtocolMetatypeToObjectExpr" }
  }

  private Element getImmediateChildOfProtocolMetatypeToObjectExpr(
    ProtocolMetatypeToObjectExpr e, int index
  ) {
    exists(int n, int nSubExpr |
      n = 0 and
      nSubExpr = n + 1 and
      (
        none()
        or
        index = n and result = e.getSubExpr()
      )
    )
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

  private Element getImmediateChildOfRegexLiteralExpr(RegexLiteralExpr e, int index) { none() }

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

  private Element getImmediateChildOfStringToPointerExpr(StringToPointerExpr e, int index) {
    exists(int n, int nSubExpr |
      n = 0 and
      nSubExpr = n + 1 and
      (
        none()
        or
        index = n and result = e.getSubExpr()
      )
    )
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
     * Gets the number of arguments of this subscript expression.
     */
    int getNumberOfArguments() { result = count(int i | subscript_expr_arguments(this, i, _)) }

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

  private Element getImmediateChildOfSubscriptExpr(SubscriptExpr e, int index) {
    exists(int n, int nBase, int nArgument |
      n = 0 and
      nBase = n + 1 and
      nArgument = nBase + e.getNumberOfArguments() and
      (
        none()
        or
        index = n and result = e.getBase()
        or
        result = e.getArgument(index - nBase)
      )
    )
  }

  /**
   * INTERNAL: Do not use.
   */
  class TryExpr extends @try_expr, AnyTryExpr {
    override string toString() { result = "TryExpr" }
  }

  private Element getImmediateChildOfTryExpr(TryExpr e, int index) {
    exists(int n, int nSubExpr |
      n = 0 and
      nSubExpr = n + 1 and
      (
        none()
        or
        index = n and result = e.getSubExpr()
      )
    )
  }

  /**
   * INTERNAL: Do not use.
   */
  class UnderlyingToOpaqueExpr extends @underlying_to_opaque_expr, ImplicitConversionExpr {
    override string toString() { result = "UnderlyingToOpaqueExpr" }
  }

  private Element getImmediateChildOfUnderlyingToOpaqueExpr(UnderlyingToOpaqueExpr e, int index) {
    exists(int n, int nSubExpr |
      n = 0 and
      nSubExpr = n + 1 and
      (
        none()
        or
        index = n and result = e.getSubExpr()
      )
    )
  }

  /**
   * INTERNAL: Do not use.
   */
  class UnevaluatedInstanceExpr extends @unevaluated_instance_expr, ImplicitConversionExpr {
    override string toString() { result = "UnevaluatedInstanceExpr" }
  }

  private Element getImmediateChildOfUnevaluatedInstanceExpr(UnevaluatedInstanceExpr e, int index) {
    exists(int n, int nSubExpr |
      n = 0 and
      nSubExpr = n + 1 and
      (
        none()
        or
        index = n and result = e.getSubExpr()
      )
    )
  }

  /**
   * INTERNAL: Do not use.
   * A conversion from the uninhabited type to any other type. It's never evaluated.
   */
  class UnreachableExpr extends @unreachable_expr, ImplicitConversionExpr {
    override string toString() { result = "UnreachableExpr" }
  }

  private Element getImmediateChildOfUnreachableExpr(UnreachableExpr e, int index) {
    exists(int n, int nSubExpr |
      n = 0 and
      nSubExpr = n + 1 and
      (
        none()
        or
        index = n and result = e.getSubExpr()
      )
    )
  }

  /**
   * INTERNAL: Do not use.
   */
  class UnresolvedMemberChainResultExpr extends @unresolved_member_chain_result_expr, IdentityExpr,
    ErrorElement
  {
    override string toString() { result = "UnresolvedMemberChainResultExpr" }
  }

  private Element getImmediateChildOfUnresolvedMemberChainResultExpr(
    UnresolvedMemberChainResultExpr e, int index
  ) {
    exists(int n, int nSubExpr |
      n = 0 and
      nSubExpr = n + 1 and
      (
        none()
        or
        index = n and result = e.getSubExpr()
      )
    )
  }

  /**
   * INTERNAL: Do not use.
   */
  class UnresolvedTypeConversionExpr extends @unresolved_type_conversion_expr,
    ImplicitConversionExpr, ErrorElement
  {
    override string toString() { result = "UnresolvedTypeConversionExpr" }
  }

  private Element getImmediateChildOfUnresolvedTypeConversionExpr(
    UnresolvedTypeConversionExpr e, int index
  ) {
    exists(int n, int nSubExpr |
      n = 0 and
      nSubExpr = n + 1 and
      (
        none()
        or
        index = n and result = e.getSubExpr()
      )
    )
  }

  /**
   * INTERNAL: Do not use.
   * A conversion that performs an unsafe bitcast.
   */
  class UnsafeCastExpr extends @unsafe_cast_expr, ImplicitConversionExpr {
    override string toString() { result = "UnsafeCastExpr" }
  }

  private Element getImmediateChildOfUnsafeCastExpr(UnsafeCastExpr e, int index) {
    exists(int n, int nSubExpr |
      n = 0 and
      nSubExpr = n + 1 and
      (
        none()
        or
        index = n and result = e.getSubExpr()
      )
    )
  }

  /**
   * INTERNAL: Do not use.
   */
  class UnsafeExpr extends @unsafe_expr, IdentityExpr {
    override string toString() { result = "UnsafeExpr" }
  }

  private Element getImmediateChildOfUnsafeExpr(UnsafeExpr e, int index) {
    exists(int n, int nSubExpr |
      n = 0 and
      nSubExpr = n + 1 and
      (
        none()
        or
        index = n and result = e.getSubExpr()
      )
    )
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

  private Element getImmediateChildOfBooleanLiteralExpr(BooleanLiteralExpr e, int index) { none() }

  /**
   * INTERNAL: Do not use.
   */
  class ConditionalCheckedCastExpr extends @conditional_checked_cast_expr, CheckedCastExpr {
    override string toString() { result = "ConditionalCheckedCastExpr" }
  }

  private Element getImmediateChildOfConditionalCheckedCastExpr(
    ConditionalCheckedCastExpr e, int index
  ) {
    exists(int n, int nSubExpr |
      n = 0 and
      nSubExpr = n + 1 and
      (
        none()
        or
        index = n and result = e.getSubExpr()
      )
    )
  }

  /**
   * INTERNAL: Do not use.
   */
  class DotSyntaxCallExpr extends @dot_syntax_call_expr, SelfApplyExpr {
    override string toString() { result = "DotSyntaxCallExpr" }
  }

  private Element getImmediateChildOfDotSyntaxCallExpr(DotSyntaxCallExpr e, int index) {
    exists(int n, int nFunction, int nArgument |
      n = 0 and
      nFunction = n + 1 and
      nArgument = nFunction + e.getNumberOfArguments() and
      (
        none()
        or
        index = n and result = e.getFunction()
        or
        result = e.getArgument(index - nFunction)
      )
    )
  }

  /**
   * INTERNAL: Do not use.
   */
  class DynamicMemberRefExpr extends @dynamic_member_ref_expr, DynamicLookupExpr {
    override string toString() { result = "DynamicMemberRefExpr" }
  }

  private Element getImmediateChildOfDynamicMemberRefExpr(DynamicMemberRefExpr e, int index) {
    exists(int n, int nBase |
      n = 0 and
      nBase = n + 1 and
      (
        none()
        or
        index = n and result = e.getBase()
      )
    )
  }

  /**
   * INTERNAL: Do not use.
   */
  class DynamicSubscriptExpr extends @dynamic_subscript_expr, DynamicLookupExpr {
    override string toString() { result = "DynamicSubscriptExpr" }
  }

  private Element getImmediateChildOfDynamicSubscriptExpr(DynamicSubscriptExpr e, int index) {
    exists(int n, int nBase |
      n = 0 and
      nBase = n + 1 and
      (
        none()
        or
        index = n and result = e.getBase()
      )
    )
  }

  /**
   * INTERNAL: Do not use.
   */
  class ForcedCheckedCastExpr extends @forced_checked_cast_expr, CheckedCastExpr {
    override string toString() { result = "ForcedCheckedCastExpr" }
  }

  private Element getImmediateChildOfForcedCheckedCastExpr(ForcedCheckedCastExpr e, int index) {
    exists(int n, int nSubExpr |
      n = 0 and
      nSubExpr = n + 1 and
      (
        none()
        or
        index = n and result = e.getSubExpr()
      )
    )
  }

  /**
   * INTERNAL: Do not use.
   */
  class InitializerRefCallExpr extends @initializer_ref_call_expr, SelfApplyExpr {
    override string toString() { result = "InitializerRefCallExpr" }
  }

  private Element getImmediateChildOfInitializerRefCallExpr(InitializerRefCallExpr e, int index) {
    exists(int n, int nFunction, int nArgument |
      n = 0 and
      nFunction = n + 1 and
      nArgument = nFunction + e.getNumberOfArguments() and
      (
        none()
        or
        index = n and result = e.getFunction()
        or
        result = e.getArgument(index - nFunction)
      )
    )
  }

  /**
   * INTERNAL: Do not use.
   */
  class IsExpr extends @is_expr, CheckedCastExpr {
    override string toString() { result = "IsExpr" }
  }

  private Element getImmediateChildOfIsExpr(IsExpr e, int index) {
    exists(int n, int nSubExpr |
      n = 0 and
      nSubExpr = n + 1 and
      (
        none()
        or
        index = n and result = e.getSubExpr()
      )
    )
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

  private Element getImmediateChildOfMagicIdentifierLiteralExpr(
    MagicIdentifierLiteralExpr e, int index
  ) {
    none()
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

  private Element getImmediateChildOfStringLiteralExpr(StringLiteralExpr e, int index) { none() }

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

  private Element getImmediateChildOfFloatLiteralExpr(FloatLiteralExpr e, int index) { none() }

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

  private Element getImmediateChildOfIntegerLiteralExpr(IntegerLiteralExpr e, int index) { none() }

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

  private Element getImmediateChildOfAnyPattern(AnyPattern e, int index) { none() }

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

  private Element getImmediateChildOfBindingPattern(BindingPattern e, int index) {
    exists(int n, int nSubPattern |
      n = 0 and
      nSubPattern = n + 1 and
      (
        none()
        or
        index = n and result = e.getSubPattern()
      )
    )
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

  private Element getImmediateChildOfBoolPattern(BoolPattern e, int index) { none() }

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

  private Element getImmediateChildOfEnumElementPattern(EnumElementPattern e, int index) {
    exists(int n, int nSubPattern |
      n = 0 and
      nSubPattern = n + 1 and
      (
        none()
        or
        index = n and result = e.getSubPattern()
      )
    )
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

  private Element getImmediateChildOfExprPattern(ExprPattern e, int index) {
    exists(int n, int nSubExpr |
      n = 0 and
      nSubExpr = n + 1 and
      (
        none()
        or
        index = n and result = e.getSubExpr()
      )
    )
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

  private Element getImmediateChildOfIsPattern(IsPattern e, int index) {
    exists(int n, int nCastTypeRepr, int nSubPattern |
      n = 0 and
      nCastTypeRepr = n + 1 and
      nSubPattern = nCastTypeRepr + 1 and
      (
        none()
        or
        index = n and result = e.getCastTypeRepr()
        or
        index = nCastTypeRepr and result = e.getSubPattern()
      )
    )
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

  private Element getImmediateChildOfNamedPattern(NamedPattern e, int index) { none() }

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

  private Element getImmediateChildOfOptionalSomePattern(OptionalSomePattern e, int index) {
    exists(int n, int nSubPattern |
      n = 0 and
      nSubPattern = n + 1 and
      (
        none()
        or
        index = n and result = e.getSubPattern()
      )
    )
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

  private Element getImmediateChildOfParenPattern(ParenPattern e, int index) {
    exists(int n, int nSubPattern |
      n = 0 and
      nSubPattern = n + 1 and
      (
        none()
        or
        index = n and result = e.getSubPattern()
      )
    )
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

    /**
     * Gets the number of elements of this tuple pattern.
     */
    int getNumberOfElements() { result = count(int i | tuple_pattern_elements(this, i, _)) }
  }

  private Element getImmediateChildOfTuplePattern(TuplePattern e, int index) {
    exists(int n, int nElement |
      n = 0 and
      nElement = n + e.getNumberOfElements() and
      (
        none()
        or
        result = e.getElement(index - n)
      )
    )
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

  private Element getImmediateChildOfTypedPattern(TypedPattern e, int index) {
    exists(int n, int nSubPattern, int nTypeRepr |
      n = 0 and
      nSubPattern = n + 1 and
      nTypeRepr = nSubPattern + 1 and
      (
        none()
        or
        index = n and result = e.getSubPattern()
        or
        index = nSubPattern and result = e.getTypeRepr()
      )
    )
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

  private Element getImmediateChildOfCaseLabelItem(CaseLabelItem e, int index) {
    exists(int n, int nPattern, int nGuard |
      n = 0 and
      nPattern = n + 1 and
      nGuard = nPattern + 1 and
      (
        none()
        or
        index = n and result = e.getPattern()
        or
        index = nPattern and result = e.getGuard()
      )
    )
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

  private Element getImmediateChildOfConditionElement(ConditionElement e, int index) {
    exists(int n, int nBoolean, int nPattern, int nInitializer, int nAvailability |
      n = 0 and
      nBoolean = n + 1 and
      nPattern = nBoolean + 1 and
      nInitializer = nPattern + 1 and
      nAvailability = nInitializer + 1 and
      (
        none()
        or
        index = n and result = e.getBoolean()
        or
        index = nBoolean and result = e.getPattern()
        or
        index = nPattern and result = e.getInitializer()
        or
        index = nInitializer and result = e.getAvailability()
      )
    )
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

    /**
     * Gets the number of elements of this statement condition.
     */
    int getNumberOfElements() { result = count(int i | stmt_condition_elements(this, i, _)) }
  }

  private Element getImmediateChildOfStmtCondition(StmtCondition e, int index) {
    exists(int n, int nElement |
      n = 0 and
      nElement = n + e.getNumberOfElements() and
      (
        none()
        or
        result = e.getElement(index - n)
      )
    )
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

    /**
     * Gets the number of elements of this brace statement.
     */
    int getNumberOfElements() { result = count(int i | brace_stmt_elements(this, i, _)) }
  }

  private Element getImmediateChildOfBraceStmt(BraceStmt e, int index) {
    exists(int n, int nVariable, int nElement |
      n = 0 and
      nVariable = n and
      nElement = nVariable + e.getNumberOfElements() and
      (
        none()
        or
        result = e.getElement(index - nVariable)
      )
    )
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

  private Element getImmediateChildOfBreakStmt(BreakStmt e, int index) { none() }

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
     * Gets the number of labels of this case statement.
     */
    int getNumberOfLabels() { result = count(int i | case_stmt_labels(this, i, _)) }

    /**
     * Gets the `index`th variable of this case statement (0-based).
     */
    VarDecl getVariable(int index) { case_stmt_variables(this, index, result) }

    /**
     * Gets the number of variables of this case statement.
     */
    int getNumberOfVariables() { result = count(int i | case_stmt_variables(this, i, _)) }

    /**
     * Gets the body of this case statement.
     */
    Stmt getBody() { case_stmts(this, result) }
  }

  private Element getImmediateChildOfCaseStmt(CaseStmt e, int index) {
    exists(int n, int nLabel, int nVariable, int nBody |
      n = 0 and
      nLabel = n + e.getNumberOfLabels() and
      nVariable = nLabel + e.getNumberOfVariables() and
      nBody = nVariable + 1 and
      (
        none()
        or
        result = e.getLabel(index - n)
        or
        result = e.getVariable(index - nLabel)
        or
        index = nVariable and result = e.getBody()
      )
    )
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

  private Element getImmediateChildOfContinueStmt(ContinueStmt e, int index) { none() }

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

  private Element getImmediateChildOfDeferStmt(DeferStmt e, int index) {
    exists(int n, int nBody |
      n = 0 and
      nBody = n + 1 and
      (
        none()
        or
        index = n and result = e.getBody()
      )
    )
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

  private Element getImmediateChildOfDiscardStmt(DiscardStmt e, int index) {
    exists(int n, int nSubExpr |
      n = 0 and
      nSubExpr = n + 1 and
      (
        none()
        or
        index = n and result = e.getSubExpr()
      )
    )
  }

  /**
   * INTERNAL: Do not use.
   */
  class FailStmt extends @fail_stmt, Stmt {
    override string toString() { result = "FailStmt" }
  }

  private Element getImmediateChildOfFailStmt(FailStmt e, int index) { none() }

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

  private Element getImmediateChildOfFallthroughStmt(FallthroughStmt e, int index) { none() }

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

  private Element getImmediateChildOfPoundAssertStmt(PoundAssertStmt e, int index) { none() }

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

  private Element getImmediateChildOfReturnStmt(ReturnStmt e, int index) {
    exists(int n, int nResult |
      n = 0 and
      nResult = n + 1 and
      (
        none()
        or
        index = n and result = e.getResult()
      )
    )
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

  private Element getImmediateChildOfThenStmt(ThenStmt e, int index) {
    exists(int n, int nResult |
      n = 0 and
      nResult = n + 1 and
      (
        none()
        or
        index = n and result = e.getResult()
      )
    )
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

  private Element getImmediateChildOfThrowStmt(ThrowStmt e, int index) {
    exists(int n, int nSubExpr |
      n = 0 and
      nSubExpr = n + 1 and
      (
        none()
        or
        index = n and result = e.getSubExpr()
      )
    )
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

    /**
     * Gets the number of results of this yield statement.
     */
    int getNumberOfResults() { result = count(int i | yield_stmt_results(this, i, _)) }
  }

  private Element getImmediateChildOfYieldStmt(YieldStmt e, int index) {
    exists(int n, int nResult |
      n = 0 and
      nResult = n + e.getNumberOfResults() and
      (
        none()
        or
        result = e.getResult(index - n)
      )
    )
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

    /**
     * Gets the number of catches of this do catch statement.
     */
    int getNumberOfCatches() { result = count(int i | do_catch_stmt_catches(this, i, _)) }
  }

  private Element getImmediateChildOfDoCatchStmt(DoCatchStmt e, int index) {
    exists(int n, int nBody, int nCatch |
      n = 0 and
      nBody = n + 1 and
      nCatch = nBody + e.getNumberOfCatches() and
      (
        none()
        or
        index = n and result = e.getBody()
        or
        result = e.getCatch(index - nBody)
      )
    )
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

  private Element getImmediateChildOfDoStmt(DoStmt e, int index) {
    exists(int n, int nBody |
      n = 0 and
      nBody = n + 1 and
      (
        none()
        or
        index = n and result = e.getBody()
      )
    )
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
     * Gets the number of variables of this for each statement.
     */
    int getNumberOfVariables() { result = count(int i | for_each_stmt_variables(this, i, _)) }

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

  private Element getImmediateChildOfForEachStmt(ForEachStmt e, int index) {
    exists(
      int n, int nVariable, int nPattern, int nWhere, int nIteratorVar, int nNextCall, int nBody
    |
      n = 0 and
      nVariable = n + e.getNumberOfVariables() and
      nPattern = nVariable + 1 and
      nWhere = nPattern + 1 and
      nIteratorVar = nWhere + 1 and
      nNextCall = nIteratorVar + 1 and
      nBody = nNextCall + 1 and
      (
        none()
        or
        result = e.getVariable(index - n)
        or
        index = nVariable and result = e.getPattern()
        or
        index = nPattern and result = e.getWhere()
        or
        index = nWhere and result = e.getIteratorVar()
        or
        index = nIteratorVar and result = e.getNextCall()
        or
        index = nNextCall and result = e.getBody()
      )
    )
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

  private Element getImmediateChildOfRepeatWhileStmt(RepeatWhileStmt e, int index) {
    exists(int n, int nCondition, int nBody |
      n = 0 and
      nCondition = n + 1 and
      nBody = nCondition + 1 and
      (
        none()
        or
        index = n and result = e.getCondition()
        or
        index = nCondition and result = e.getBody()
      )
    )
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

    /**
     * Gets the number of cases of this switch statement.
     */
    int getNumberOfCases() { result = count(int i | switch_stmt_cases(this, i, _)) }
  }

  private Element getImmediateChildOfSwitchStmt(SwitchStmt e, int index) {
    exists(int n, int nExpr, int nCase |
      n = 0 and
      nExpr = n + 1 and
      nCase = nExpr + e.getNumberOfCases() and
      (
        none()
        or
        index = n and result = e.getExpr()
        or
        result = e.getCase(index - nExpr)
      )
    )
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

  private Element getImmediateChildOfGuardStmt(GuardStmt e, int index) {
    exists(int n, int nCondition, int nBody |
      n = 0 and
      nCondition = n + 1 and
      nBody = nCondition + 1 and
      (
        none()
        or
        index = n and result = e.getCondition()
        or
        index = nCondition and result = e.getBody()
      )
    )
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

  private Element getImmediateChildOfIfStmt(IfStmt e, int index) {
    exists(int n, int nCondition, int nThen, int nElse |
      n = 0 and
      nCondition = n + 1 and
      nThen = nCondition + 1 and
      nElse = nThen + 1 and
      (
        none()
        or
        index = n and result = e.getCondition()
        or
        index = nCondition and result = e.getThen()
        or
        index = nThen and result = e.getElse()
      )
    )
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

  private Element getImmediateChildOfWhileStmt(WhileStmt e, int index) {
    exists(int n, int nCondition, int nBody |
      n = 0 and
      nCondition = n + 1 and
      nBody = nCondition + 1 and
      (
        none()
        or
        index = n and result = e.getCondition()
        or
        index = nCondition and result = e.getBody()
      )
    )
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

  private Element getImmediateChildOfTypeRepr(TypeRepr e, int index) { none() }

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
     * Gets the number of parameter types of this function type.
     */
    int getNumberOfParamTypes() {
      result = count(int i | any_function_type_param_types(this, i, _))
    }

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

  private Element getImmediateChildOfDependentMemberType(DependentMemberType e, int index) {
    none()
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

  private Element getImmediateChildOfDynamicSelfType(DynamicSelfType e, int index) { none() }

  /**
   * INTERNAL: Do not use.
   */
  class ErrorType extends @error_type, Type, ErrorElement {
    override string toString() { result = "ErrorType" }
  }

  private Element getImmediateChildOfErrorType(ErrorType e, int index) { none() }

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

  private Element getImmediateChildOfExistentialType(ExistentialType e, int index) { none() }

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

  private Element getImmediateChildOfInOutType(InOutType e, int index) { none() }

  /**
   * INTERNAL: Do not use.
   */
  class IntegerType extends @integer_type, Type {
    override string toString() { result = "IntegerType" }

    /**
     * Gets the value of this integer type.
     */
    string getValue() { integer_types(this, result) }
  }

  private Element getImmediateChildOfIntegerType(IntegerType e, int index) { none() }

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

  private Element getImmediateChildOfLValueType(LValueType e, int index) { none() }

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

  private Element getImmediateChildOfModuleType(ModuleType e, int index) { none() }

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

  private Element getImmediateChildOfPackElementType(PackElementType e, int index) { none() }

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

  private Element getImmediateChildOfPackExpansionType(PackExpansionType e, int index) { none() }

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

    /**
     * Gets the number of elements of this pack type.
     */
    int getNumberOfElements() { result = count(int i | pack_type_elements(this, i, _)) }
  }

  private Element getImmediateChildOfPackType(PackType e, int index) { none() }

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

    /**
     * Gets the number of arguments of this parameterized protocol type.
     */
    int getNumberOfArgs() { result = count(int i | parameterized_protocol_type_args(this, i, _)) }
  }

  private Element getImmediateChildOfParameterizedProtocolType(
    ParameterizedProtocolType e, int index
  ) {
    none()
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

    /**
     * Gets the number of members of this protocol composition type.
     */
    int getNumberOfMembers() {
      result = count(int i | protocol_composition_type_members(this, i, _))
    }
  }

  private Element getImmediateChildOfProtocolCompositionType(ProtocolCompositionType e, int index) {
    none()
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
     * Gets the number of types of this tuple type.
     */
    int getNumberOfTypes() { result = count(int i | tuple_type_types(this, i, _)) }

    /**
     * Gets the `index`th name of this tuple type (0-based), if it exists.
     */
    string getName(int index) { tuple_type_names(this, index, result) }

    /**
     * Gets the number of names of this tuple type.
     */
    int getNumberOfNames() { result = count(int i | tuple_type_names(this, i, _)) }
  }

  private Element getImmediateChildOfTupleType(TupleType e, int index) { none() }

  /**
   * INTERNAL: Do not use.
   */
  class UnresolvedType extends @unresolved_type, Type, ErrorElement {
    override string toString() { result = "UnresolvedType" }
  }

  private Element getImmediateChildOfUnresolvedType(UnresolvedType e, int index) { none() }

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

    /**
     * Gets the number of protocols of this archetype type.
     */
    int getNumberOfProtocols() { result = count(int i | archetype_type_protocols(this, i, _)) }
  }

  /**
   * INTERNAL: Do not use.
   */
  class BuiltinBridgeObjectType extends @builtin_bridge_object_type, BuiltinType {
    override string toString() { result = "BuiltinBridgeObjectType" }
  }

  private Element getImmediateChildOfBuiltinBridgeObjectType(BuiltinBridgeObjectType e, int index) {
    none()
  }

  /**
   * INTERNAL: Do not use.
   */
  class BuiltinDefaultActorStorageType extends @builtin_default_actor_storage_type, BuiltinType {
    override string toString() { result = "BuiltinDefaultActorStorageType" }
  }

  private Element getImmediateChildOfBuiltinDefaultActorStorageType(
    BuiltinDefaultActorStorageType e, int index
  ) {
    none()
  }

  /**
   * INTERNAL: Do not use.
   */
  class BuiltinExecutorType extends @builtin_executor_type, BuiltinType {
    override string toString() { result = "BuiltinExecutorType" }
  }

  private Element getImmediateChildOfBuiltinExecutorType(BuiltinExecutorType e, int index) {
    none()
  }

  /**
   * INTERNAL: Do not use.
   * A builtin type representing N values stored contiguously.
   */
  class BuiltinFixedArrayType extends @builtin_fixed_array_type, BuiltinType {
    override string toString() { result = "BuiltinFixedArrayType" }
  }

  private Element getImmediateChildOfBuiltinFixedArrayType(BuiltinFixedArrayType e, int index) {
    none()
  }

  /**
   * INTERNAL: Do not use.
   */
  class BuiltinFloatType extends @builtin_float_type, BuiltinType {
    override string toString() { result = "BuiltinFloatType" }
  }

  private Element getImmediateChildOfBuiltinFloatType(BuiltinFloatType e, int index) { none() }

  /**
   * INTERNAL: Do not use.
   */
  class BuiltinJobType extends @builtin_job_type, BuiltinType {
    override string toString() { result = "BuiltinJobType" }
  }

  private Element getImmediateChildOfBuiltinJobType(BuiltinJobType e, int index) { none() }

  /**
   * INTERNAL: Do not use.
   */
  class BuiltinNativeObjectType extends @builtin_native_object_type, BuiltinType {
    override string toString() { result = "BuiltinNativeObjectType" }
  }

  private Element getImmediateChildOfBuiltinNativeObjectType(BuiltinNativeObjectType e, int index) {
    none()
  }

  /**
   * INTERNAL: Do not use.
   */
  class BuiltinRawPointerType extends @builtin_raw_pointer_type, BuiltinType {
    override string toString() { result = "BuiltinRawPointerType" }
  }

  private Element getImmediateChildOfBuiltinRawPointerType(BuiltinRawPointerType e, int index) {
    none()
  }

  /**
   * INTERNAL: Do not use.
   */
  class BuiltinRawUnsafeContinuationType extends @builtin_raw_unsafe_continuation_type, BuiltinType {
    override string toString() { result = "BuiltinRawUnsafeContinuationType" }
  }

  private Element getImmediateChildOfBuiltinRawUnsafeContinuationType(
    BuiltinRawUnsafeContinuationType e, int index
  ) {
    none()
  }

  /**
   * INTERNAL: Do not use.
   */
  class BuiltinUnsafeValueBufferType extends @builtin_unsafe_value_buffer_type, BuiltinType {
    override string toString() { result = "BuiltinUnsafeValueBufferType" }
  }

  private Element getImmediateChildOfBuiltinUnsafeValueBufferType(
    BuiltinUnsafeValueBufferType e, int index
  ) {
    none()
  }

  /**
   * INTERNAL: Do not use.
   */
  class BuiltinVectorType extends @builtin_vector_type, BuiltinType {
    override string toString() { result = "BuiltinVectorType" }
  }

  private Element getImmediateChildOfBuiltinVectorType(BuiltinVectorType e, int index) { none() }

  /**
   * INTERNAL: Do not use.
   */
  class ExistentialMetatypeType extends @existential_metatype_type, AnyMetatypeType {
    override string toString() { result = "ExistentialMetatypeType" }
  }

  private Element getImmediateChildOfExistentialMetatypeType(ExistentialMetatypeType e, int index) {
    none()
  }

  /**
   * INTERNAL: Do not use.
   */
  class FunctionType extends @function_type, AnyFunctionType {
    override string toString() { result = "FunctionType" }
  }

  private Element getImmediateChildOfFunctionType(FunctionType e, int index) { none() }

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

    /**
     * Gets the number of type parameters of this generic type.
     */
    int getNumberOfGenericParams() {
      result = count(int i | generic_function_type_generic_params(this, i, _))
    }
  }

  private Element getImmediateChildOfGenericFunctionType(GenericFunctionType e, int index) {
    none()
  }

  /**
   * INTERNAL: Do not use.
   */
  class GenericTypeParamType extends @generic_type_param_type, SubstitutableType {
    override string toString() { result = "GenericTypeParamType" }
  }

  private Element getImmediateChildOfGenericTypeParamType(GenericTypeParamType e, int index) {
    none()
  }

  /**
   * INTERNAL: Do not use.
   */
  class MetatypeType extends @metatype_type, AnyMetatypeType {
    override string toString() { result = "MetatypeType" }
  }

  private Element getImmediateChildOfMetatypeType(MetatypeType e, int index) { none() }

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

  private Element getImmediateChildOfParenType(ParenType e, int index) { none() }

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

  private Element getImmediateChildOfTypeAliasType(TypeAliasType e, int index) { none() }

  /**
   * INTERNAL: Do not use.
   */
  class UnboundGenericType extends @unbound_generic_type, AnyGenericType {
    override string toString() { result = "UnboundGenericType" }
  }

  private Element getImmediateChildOfUnboundGenericType(UnboundGenericType e, int index) { none() }

  /**
   * INTERNAL: Do not use.
   */
  class UnmanagedStorageType extends @unmanaged_storage_type, ReferenceStorageType {
    override string toString() { result = "UnmanagedStorageType" }
  }

  private Element getImmediateChildOfUnmanagedStorageType(UnmanagedStorageType e, int index) {
    none()
  }

  /**
   * INTERNAL: Do not use.
   */
  class UnownedStorageType extends @unowned_storage_type, ReferenceStorageType {
    override string toString() { result = "UnownedStorageType" }
  }

  private Element getImmediateChildOfUnownedStorageType(UnownedStorageType e, int index) { none() }

  /**
   * INTERNAL: Do not use.
   */
  class WeakStorageType extends @weak_storage_type, ReferenceStorageType {
    override string toString() { result = "WeakStorageType" }
  }

  private Element getImmediateChildOfWeakStorageType(WeakStorageType e, int index) { none() }

  /**
   * INTERNAL: Do not use.
   */
  class BoundGenericType extends @bound_generic_type, NominalOrBoundGenericNominalType {
    /**
     * Gets the `index`th argument type of this bound generic type (0-based).
     */
    Type getArgType(int index) { bound_generic_type_arg_types(this, index, result) }

    /**
     * Gets the number of argument types of this bound generic type.
     */
    int getNumberOfArgTypes() { result = count(int i | bound_generic_type_arg_types(this, i, _)) }
  }

  /**
   * INTERNAL: Do not use.
   */
  class BuiltinIntegerLiteralType extends @builtin_integer_literal_type, AnyBuiltinIntegerType {
    override string toString() { result = "BuiltinIntegerLiteralType" }
  }

  private Element getImmediateChildOfBuiltinIntegerLiteralType(
    BuiltinIntegerLiteralType e, int index
  ) {
    none()
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

  private Element getImmediateChildOfBuiltinIntegerType(BuiltinIntegerType e, int index) { none() }

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

  private Element getImmediateChildOfDictionaryType(DictionaryType e, int index) { none() }

  /**
   * INTERNAL: Do not use.
   */
  class InlineArrayType extends @inline_array_type, SyntaxSugarType {
    override string toString() { result = "InlineArrayType" }

    /**
     * Gets the count type of this inline array type.
     */
    Type getCountType() { inline_array_types(this, result, _) }

    /**
     * Gets the element type of this inline array type.
     */
    Type getElementType() { inline_array_types(this, _, result) }
  }

  private Element getImmediateChildOfInlineArrayType(InlineArrayType e, int index) { none() }

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

  private Element getImmediateChildOfOpaqueTypeArchetypeType(OpaqueTypeArchetypeType e, int index) {
    none()
  }

  /**
   * INTERNAL: Do not use.
   * An archetype type of PackType.
   */
  class PackArchetypeType extends @pack_archetype_type, ArchetypeType {
    override string toString() { result = "PackArchetypeType" }
  }

  private Element getImmediateChildOfPackArchetypeType(PackArchetypeType e, int index) { none() }

  /**
   * INTERNAL: Do not use.
   */
  class PrimaryArchetypeType extends @primary_archetype_type, ArchetypeType {
    override string toString() { result = "PrimaryArchetypeType" }
  }

  private Element getImmediateChildOfPrimaryArchetypeType(PrimaryArchetypeType e, int index) {
    none()
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

  private Element getImmediateChildOfArraySliceType(ArraySliceType e, int index) { none() }

  /**
   * INTERNAL: Do not use.
   */
  class BoundGenericClassType extends @bound_generic_class_type, BoundGenericType {
    override string toString() { result = "BoundGenericClassType" }
  }

  private Element getImmediateChildOfBoundGenericClassType(BoundGenericClassType e, int index) {
    none()
  }

  /**
   * INTERNAL: Do not use.
   */
  class BoundGenericEnumType extends @bound_generic_enum_type, BoundGenericType {
    override string toString() { result = "BoundGenericEnumType" }
  }

  private Element getImmediateChildOfBoundGenericEnumType(BoundGenericEnumType e, int index) {
    none()
  }

  /**
   * INTERNAL: Do not use.
   */
  class BoundGenericStructType extends @bound_generic_struct_type, BoundGenericType {
    override string toString() { result = "BoundGenericStructType" }
  }

  private Element getImmediateChildOfBoundGenericStructType(BoundGenericStructType e, int index) {
    none()
  }

  /**
   * INTERNAL: Do not use.
   */
  class ClassType extends @class_type, NominalType {
    override string toString() { result = "ClassType" }
  }

  private Element getImmediateChildOfClassType(ClassType e, int index) { none() }

  /**
   * INTERNAL: Do not use.
   * An archetype type of PackElementType.
   */
  class ElementArchetypeType extends @element_archetype_type, LocalArchetypeType {
    override string toString() { result = "ElementArchetypeType" }
  }

  private Element getImmediateChildOfElementArchetypeType(ElementArchetypeType e, int index) {
    none()
  }

  /**
   * INTERNAL: Do not use.
   */
  class EnumType extends @enum_type, NominalType {
    override string toString() { result = "EnumType" }
  }

  private Element getImmediateChildOfEnumType(EnumType e, int index) { none() }

  /**
   * INTERNAL: Do not use.
   */
  class ExistentialArchetypeType extends @existential_archetype_type, LocalArchetypeType {
    override string toString() { result = "ExistentialArchetypeType" }
  }

  private Element getImmediateChildOfExistentialArchetypeType(ExistentialArchetypeType e, int index) {
    none()
  }

  /**
   * INTERNAL: Do not use.
   */
  class OptionalType extends @optional_type, UnarySyntaxSugarType {
    override string toString() { result = "OptionalType" }
  }

  private Element getImmediateChildOfOptionalType(OptionalType e, int index) { none() }

  /**
   * INTERNAL: Do not use.
   */
  class ProtocolType extends @protocol_type, NominalType {
    override string toString() { result = "ProtocolType" }
  }

  private Element getImmediateChildOfProtocolType(ProtocolType e, int index) { none() }

  /**
   * INTERNAL: Do not use.
   */
  class StructType extends @struct_type, NominalType {
    override string toString() { result = "StructType" }
  }

  private Element getImmediateChildOfStructType(StructType e, int index) { none() }

  /**
   * INTERNAL: Do not use.
   */
  class VariadicSequenceType extends @variadic_sequence_type, UnarySyntaxSugarType {
    override string toString() { result = "VariadicSequenceType" }
  }

  private Element getImmediateChildOfVariadicSequenceType(VariadicSequenceType e, int index) {
    none()
  }

  /**
   * Gets the immediate child indexed at `index`. Indexes are not guaranteed to be contiguous, but are guaranteed to be distinct.
   */
  pragma[nomagic]
  Element getImmediateChild(Element e, int index) {
    // why does this look more complicated than it should?
    // * none() simplifies generation, as we can append `or ...` without a special case for the first item
    none()
    or
    result = getImmediateChildOfComment(e, index)
    or
    result = getImmediateChildOfDbFile(e, index)
    or
    result = getImmediateChildOfDbLocation(e, index)
    or
    result = getImmediateChildOfDiagnostics(e, index)
    or
    result = getImmediateChildOfAvailabilityInfo(e, index)
    or
    result = getImmediateChildOfAvailabilitySpec(e, index)
    or
    result = getImmediateChildOfKeyPathComponent(e, index)
    or
    result = getImmediateChildOfMacroRole(e, index)
    or
    result = getImmediateChildOfUnspecifiedElement(e, index)
    or
    result = getImmediateChildOfCapturedDecl(e, index)
    or
    result = getImmediateChildOfEnumCaseDecl(e, index)
    or
    result = getImmediateChildOfExtensionDecl(e, index)
    or
    result = getImmediateChildOfIfConfigDecl(e, index)
    or
    result = getImmediateChildOfImportDecl(e, index)
    or
    result = getImmediateChildOfMissingMemberDecl(e, index)
    or
    result = getImmediateChildOfPatternBindingDecl(e, index)
    or
    result = getImmediateChildOfPoundDiagnosticDecl(e, index)
    or
    result = getImmediateChildOfPrecedenceGroupDecl(e, index)
    or
    result = getImmediateChildOfTopLevelCodeDecl(e, index)
    or
    result = getImmediateChildOfUsingDecl(e, index)
    or
    result = getImmediateChildOfEnumElementDecl(e, index)
    or
    result = getImmediateChildOfInfixOperatorDecl(e, index)
    or
    result = getImmediateChildOfMacroDecl(e, index)
    or
    result = getImmediateChildOfPostfixOperatorDecl(e, index)
    or
    result = getImmediateChildOfPrefixOperatorDecl(e, index)
    or
    result = getImmediateChildOfDeinitializer(e, index)
    or
    result = getImmediateChildOfInitializer(e, index)
    or
    result = getImmediateChildOfModuleDecl(e, index)
    or
    result = getImmediateChildOfSubscriptDecl(e, index)
    or
    result = getImmediateChildOfAccessor(e, index)
    or
    result = getImmediateChildOfAssociatedTypeDecl(e, index)
    or
    result = getImmediateChildOfConcreteVarDecl(e, index)
    or
    result = getImmediateChildOfGenericTypeParamDecl(e, index)
    or
    result = getImmediateChildOfNamedFunction(e, index)
    or
    result = getImmediateChildOfOpaqueTypeDecl(e, index)
    or
    result = getImmediateChildOfParamDecl(e, index)
    or
    result = getImmediateChildOfTypeAliasDecl(e, index)
    or
    result = getImmediateChildOfClassDecl(e, index)
    or
    result = getImmediateChildOfEnumDecl(e, index)
    or
    result = getImmediateChildOfProtocolDecl(e, index)
    or
    result = getImmediateChildOfStructDecl(e, index)
    or
    result = getImmediateChildOfArgument(e, index)
    or
    result = getImmediateChildOfAppliedPropertyWrapperExpr(e, index)
    or
    result = getImmediateChildOfAssignExpr(e, index)
    or
    result = getImmediateChildOfBindOptionalExpr(e, index)
    or
    result = getImmediateChildOfCaptureListExpr(e, index)
    or
    result = getImmediateChildOfConsumeExpr(e, index)
    or
    result = getImmediateChildOfCopyExpr(e, index)
    or
    result = getImmediateChildOfCurrentContextIsolationExpr(e, index)
    or
    result = getImmediateChildOfDeclRefExpr(e, index)
    or
    result = getImmediateChildOfDefaultArgumentExpr(e, index)
    or
    result = getImmediateChildOfDiscardAssignmentExpr(e, index)
    or
    result = getImmediateChildOfDotSyntaxBaseIgnoredExpr(e, index)
    or
    result = getImmediateChildOfDynamicTypeExpr(e, index)
    or
    result = getImmediateChildOfEnumIsCaseExpr(e, index)
    or
    result = getImmediateChildOfErrorExpr(e, index)
    or
    result = getImmediateChildOfExtractFunctionIsolationExpr(e, index)
    or
    result = getImmediateChildOfForceValueExpr(e, index)
    or
    result = getImmediateChildOfIfExpr(e, index)
    or
    result = getImmediateChildOfInOutExpr(e, index)
    or
    result = getImmediateChildOfKeyPathApplicationExpr(e, index)
    or
    result = getImmediateChildOfKeyPathDotExpr(e, index)
    or
    result = getImmediateChildOfKeyPathExpr(e, index)
    or
    result = getImmediateChildOfLazyInitializationExpr(e, index)
    or
    result = getImmediateChildOfMakeTemporarilyEscapableExpr(e, index)
    or
    result = getImmediateChildOfMaterializePackExpr(e, index)
    or
    result = getImmediateChildOfObjCSelectorExpr(e, index)
    or
    result = getImmediateChildOfOneWayExpr(e, index)
    or
    result = getImmediateChildOfOpaqueValueExpr(e, index)
    or
    result = getImmediateChildOfOpenExistentialExpr(e, index)
    or
    result = getImmediateChildOfOptionalEvaluationExpr(e, index)
    or
    result = getImmediateChildOfOtherInitializerRefExpr(e, index)
    or
    result = getImmediateChildOfOverloadedDeclRefExpr(e, index)
    or
    result = getImmediateChildOfPackElementExpr(e, index)
    or
    result = getImmediateChildOfPackExpansionExpr(e, index)
    or
    result = getImmediateChildOfPropertyWrapperValuePlaceholderExpr(e, index)
    or
    result = getImmediateChildOfRebindSelfInInitializerExpr(e, index)
    or
    result = getImmediateChildOfSequenceExpr(e, index)
    or
    result = getImmediateChildOfSingleValueStmtExpr(e, index)
    or
    result = getImmediateChildOfSuperRefExpr(e, index)
    or
    result = getImmediateChildOfTapExpr(e, index)
    or
    result = getImmediateChildOfTupleElementExpr(e, index)
    or
    result = getImmediateChildOfTupleExpr(e, index)
    or
    result = getImmediateChildOfTypeExpr(e, index)
    or
    result = getImmediateChildOfTypeValueExpr(e, index)
    or
    result = getImmediateChildOfUnresolvedDeclRefExpr(e, index)
    or
    result = getImmediateChildOfUnresolvedDotExpr(e, index)
    or
    result = getImmediateChildOfUnresolvedMemberExpr(e, index)
    or
    result = getImmediateChildOfUnresolvedPatternExpr(e, index)
    or
    result = getImmediateChildOfUnresolvedSpecializeExpr(e, index)
    or
    result = getImmediateChildOfVarargExpansionExpr(e, index)
    or
    result = getImmediateChildOfAbiSafeConversionExpr(e, index)
    or
    result = getImmediateChildOfActorIsolationErasureExpr(e, index)
    or
    result = getImmediateChildOfAnyHashableErasureExpr(e, index)
    or
    result = getImmediateChildOfArchetypeToSuperExpr(e, index)
    or
    result = getImmediateChildOfArrayExpr(e, index)
    or
    result = getImmediateChildOfArrayToPointerExpr(e, index)
    or
    result = getImmediateChildOfAutoClosureExpr(e, index)
    or
    result = getImmediateChildOfAwaitExpr(e, index)
    or
    result = getImmediateChildOfBinaryExpr(e, index)
    or
    result = getImmediateChildOfBorrowExpr(e, index)
    or
    result = getImmediateChildOfBridgeFromObjCExpr(e, index)
    or
    result = getImmediateChildOfBridgeToObjCExpr(e, index)
    or
    result = getImmediateChildOfCallExpr(e, index)
    or
    result = getImmediateChildOfClassMetatypeToObjectExpr(e, index)
    or
    result = getImmediateChildOfCoerceExpr(e, index)
    or
    result = getImmediateChildOfCollectionUpcastConversionExpr(e, index)
    or
    result = getImmediateChildOfConditionalBridgeFromObjCExpr(e, index)
    or
    result = getImmediateChildOfCovariantFunctionConversionExpr(e, index)
    or
    result = getImmediateChildOfCovariantReturnConversionExpr(e, index)
    or
    result = getImmediateChildOfDerivedToBaseExpr(e, index)
    or
    result = getImmediateChildOfDestructureTupleExpr(e, index)
    or
    result = getImmediateChildOfDictionaryExpr(e, index)
    or
    result = getImmediateChildOfDifferentiableFunctionExpr(e, index)
    or
    result = getImmediateChildOfDifferentiableFunctionExtractOriginalExpr(e, index)
    or
    result = getImmediateChildOfDotSelfExpr(e, index)
    or
    result = getImmediateChildOfErasureExpr(e, index)
    or
    result = getImmediateChildOfExistentialMetatypeToObjectExpr(e, index)
    or
    result = getImmediateChildOfExplicitClosureExpr(e, index)
    or
    result = getImmediateChildOfForceTryExpr(e, index)
    or
    result = getImmediateChildOfForeignObjectConversionExpr(e, index)
    or
    result = getImmediateChildOfFunctionConversionExpr(e, index)
    or
    result = getImmediateChildOfInOutToPointerExpr(e, index)
    or
    result = getImmediateChildOfInjectIntoOptionalExpr(e, index)
    or
    result = getImmediateChildOfInterpolatedStringLiteralExpr(e, index)
    or
    result = getImmediateChildOfLinearFunctionExpr(e, index)
    or
    result = getImmediateChildOfLinearFunctionExtractOriginalExpr(e, index)
    or
    result = getImmediateChildOfLinearToDifferentiableFunctionExpr(e, index)
    or
    result = getImmediateChildOfLoadExpr(e, index)
    or
    result = getImmediateChildOfMemberRefExpr(e, index)
    or
    result = getImmediateChildOfMetatypeConversionExpr(e, index)
    or
    result = getImmediateChildOfNilLiteralExpr(e, index)
    or
    result = getImmediateChildOfObjectLiteralExpr(e, index)
    or
    result = getImmediateChildOfOptionalTryExpr(e, index)
    or
    result = getImmediateChildOfParenExpr(e, index)
    or
    result = getImmediateChildOfPointerToPointerExpr(e, index)
    or
    result = getImmediateChildOfPostfixUnaryExpr(e, index)
    or
    result = getImmediateChildOfPrefixUnaryExpr(e, index)
    or
    result = getImmediateChildOfProtocolMetatypeToObjectExpr(e, index)
    or
    result = getImmediateChildOfRegexLiteralExpr(e, index)
    or
    result = getImmediateChildOfStringToPointerExpr(e, index)
    or
    result = getImmediateChildOfSubscriptExpr(e, index)
    or
    result = getImmediateChildOfTryExpr(e, index)
    or
    result = getImmediateChildOfUnderlyingToOpaqueExpr(e, index)
    or
    result = getImmediateChildOfUnevaluatedInstanceExpr(e, index)
    or
    result = getImmediateChildOfUnreachableExpr(e, index)
    or
    result = getImmediateChildOfUnresolvedMemberChainResultExpr(e, index)
    or
    result = getImmediateChildOfUnresolvedTypeConversionExpr(e, index)
    or
    result = getImmediateChildOfUnsafeCastExpr(e, index)
    or
    result = getImmediateChildOfUnsafeExpr(e, index)
    or
    result = getImmediateChildOfBooleanLiteralExpr(e, index)
    or
    result = getImmediateChildOfConditionalCheckedCastExpr(e, index)
    or
    result = getImmediateChildOfDotSyntaxCallExpr(e, index)
    or
    result = getImmediateChildOfDynamicMemberRefExpr(e, index)
    or
    result = getImmediateChildOfDynamicSubscriptExpr(e, index)
    or
    result = getImmediateChildOfForcedCheckedCastExpr(e, index)
    or
    result = getImmediateChildOfInitializerRefCallExpr(e, index)
    or
    result = getImmediateChildOfIsExpr(e, index)
    or
    result = getImmediateChildOfMagicIdentifierLiteralExpr(e, index)
    or
    result = getImmediateChildOfStringLiteralExpr(e, index)
    or
    result = getImmediateChildOfFloatLiteralExpr(e, index)
    or
    result = getImmediateChildOfIntegerLiteralExpr(e, index)
    or
    result = getImmediateChildOfAnyPattern(e, index)
    or
    result = getImmediateChildOfBindingPattern(e, index)
    or
    result = getImmediateChildOfBoolPattern(e, index)
    or
    result = getImmediateChildOfEnumElementPattern(e, index)
    or
    result = getImmediateChildOfExprPattern(e, index)
    or
    result = getImmediateChildOfIsPattern(e, index)
    or
    result = getImmediateChildOfNamedPattern(e, index)
    or
    result = getImmediateChildOfOptionalSomePattern(e, index)
    or
    result = getImmediateChildOfParenPattern(e, index)
    or
    result = getImmediateChildOfTuplePattern(e, index)
    or
    result = getImmediateChildOfTypedPattern(e, index)
    or
    result = getImmediateChildOfCaseLabelItem(e, index)
    or
    result = getImmediateChildOfConditionElement(e, index)
    or
    result = getImmediateChildOfStmtCondition(e, index)
    or
    result = getImmediateChildOfBraceStmt(e, index)
    or
    result = getImmediateChildOfBreakStmt(e, index)
    or
    result = getImmediateChildOfCaseStmt(e, index)
    or
    result = getImmediateChildOfContinueStmt(e, index)
    or
    result = getImmediateChildOfDeferStmt(e, index)
    or
    result = getImmediateChildOfDiscardStmt(e, index)
    or
    result = getImmediateChildOfFailStmt(e, index)
    or
    result = getImmediateChildOfFallthroughStmt(e, index)
    or
    result = getImmediateChildOfPoundAssertStmt(e, index)
    or
    result = getImmediateChildOfReturnStmt(e, index)
    or
    result = getImmediateChildOfThenStmt(e, index)
    or
    result = getImmediateChildOfThrowStmt(e, index)
    or
    result = getImmediateChildOfYieldStmt(e, index)
    or
    result = getImmediateChildOfDoCatchStmt(e, index)
    or
    result = getImmediateChildOfDoStmt(e, index)
    or
    result = getImmediateChildOfForEachStmt(e, index)
    or
    result = getImmediateChildOfRepeatWhileStmt(e, index)
    or
    result = getImmediateChildOfSwitchStmt(e, index)
    or
    result = getImmediateChildOfGuardStmt(e, index)
    or
    result = getImmediateChildOfIfStmt(e, index)
    or
    result = getImmediateChildOfWhileStmt(e, index)
    or
    result = getImmediateChildOfTypeRepr(e, index)
    or
    result = getImmediateChildOfDependentMemberType(e, index)
    or
    result = getImmediateChildOfDynamicSelfType(e, index)
    or
    result = getImmediateChildOfErrorType(e, index)
    or
    result = getImmediateChildOfExistentialType(e, index)
    or
    result = getImmediateChildOfInOutType(e, index)
    or
    result = getImmediateChildOfIntegerType(e, index)
    or
    result = getImmediateChildOfLValueType(e, index)
    or
    result = getImmediateChildOfModuleType(e, index)
    or
    result = getImmediateChildOfPackElementType(e, index)
    or
    result = getImmediateChildOfPackExpansionType(e, index)
    or
    result = getImmediateChildOfPackType(e, index)
    or
    result = getImmediateChildOfParameterizedProtocolType(e, index)
    or
    result = getImmediateChildOfProtocolCompositionType(e, index)
    or
    result = getImmediateChildOfTupleType(e, index)
    or
    result = getImmediateChildOfUnresolvedType(e, index)
    or
    result = getImmediateChildOfBuiltinBridgeObjectType(e, index)
    or
    result = getImmediateChildOfBuiltinDefaultActorStorageType(e, index)
    or
    result = getImmediateChildOfBuiltinExecutorType(e, index)
    or
    result = getImmediateChildOfBuiltinFixedArrayType(e, index)
    or
    result = getImmediateChildOfBuiltinFloatType(e, index)
    or
    result = getImmediateChildOfBuiltinJobType(e, index)
    or
    result = getImmediateChildOfBuiltinNativeObjectType(e, index)
    or
    result = getImmediateChildOfBuiltinRawPointerType(e, index)
    or
    result = getImmediateChildOfBuiltinRawUnsafeContinuationType(e, index)
    or
    result = getImmediateChildOfBuiltinUnsafeValueBufferType(e, index)
    or
    result = getImmediateChildOfBuiltinVectorType(e, index)
    or
    result = getImmediateChildOfExistentialMetatypeType(e, index)
    or
    result = getImmediateChildOfFunctionType(e, index)
    or
    result = getImmediateChildOfGenericFunctionType(e, index)
    or
    result = getImmediateChildOfGenericTypeParamType(e, index)
    or
    result = getImmediateChildOfMetatypeType(e, index)
    or
    result = getImmediateChildOfParenType(e, index)
    or
    result = getImmediateChildOfTypeAliasType(e, index)
    or
    result = getImmediateChildOfUnboundGenericType(e, index)
    or
    result = getImmediateChildOfUnmanagedStorageType(e, index)
    or
    result = getImmediateChildOfUnownedStorageType(e, index)
    or
    result = getImmediateChildOfWeakStorageType(e, index)
    or
    result = getImmediateChildOfBuiltinIntegerLiteralType(e, index)
    or
    result = getImmediateChildOfBuiltinIntegerType(e, index)
    or
    result = getImmediateChildOfDictionaryType(e, index)
    or
    result = getImmediateChildOfInlineArrayType(e, index)
    or
    result = getImmediateChildOfOpaqueTypeArchetypeType(e, index)
    or
    result = getImmediateChildOfPackArchetypeType(e, index)
    or
    result = getImmediateChildOfPrimaryArchetypeType(e, index)
    or
    result = getImmediateChildOfArraySliceType(e, index)
    or
    result = getImmediateChildOfBoundGenericClassType(e, index)
    or
    result = getImmediateChildOfBoundGenericEnumType(e, index)
    or
    result = getImmediateChildOfBoundGenericStructType(e, index)
    or
    result = getImmediateChildOfClassType(e, index)
    or
    result = getImmediateChildOfElementArchetypeType(e, index)
    or
    result = getImmediateChildOfEnumType(e, index)
    or
    result = getImmediateChildOfExistentialArchetypeType(e, index)
    or
    result = getImmediateChildOfOptionalType(e, index)
    or
    result = getImmediateChildOfProtocolType(e, index)
    or
    result = getImmediateChildOfStructType(e, index)
    or
    result = getImmediateChildOfVariadicSequenceType(e, index)
  }
}
