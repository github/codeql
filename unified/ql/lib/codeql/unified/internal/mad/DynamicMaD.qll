/**
 * Provides an interpreter for dynamic-style models-as-data rows.
 *
 * Models are given as `(type, path)` pairs, where `type` names either a module (e.g. `Foundation`),
 * an instance type (e.g. `Foundation.FileManager`), or a metatype (e.g. `Foundation.FileManager.Type`),
 * and `path` is an access path leading from a value of that type to the value being modeled.
 *
 * Type information is not required to interpret the models. Instead, values belonging to a
 * given type are found syntactically (references to module members, type annotations, and
 * calls to initializers) and via `typeModel` rows that describe how instances of one type
 * can be obtained from another.
 *
 * The following access path tokens are supported:
 * - `Member[name]`: a property, method, or nested type named `name`. Methods are referred to by
 *   their base name, so overloads are not distinguished by this token. Initializers are referred
 *   to as `Member[init]` on the metatype, and match both `T(...)` and `T.init(...)`.
 * - `WithNamedArgument[label]` and `WithoutNamedArgument[label]`: restricts the preceding function
 *   to calls that do or do not pass an argument with the given label. On the definition side,
 *   restricts to functions that do or do not declare a parameter with the given external name.
 *   These are used to distinguish overloads that differ by argument labels.
 * - `Argument[n]`, `Argument[label:]`, `Argument[self]`: an argument passed to a call.
 * - `Parameter[n]`, `Parameter[label:]`, `Parameter[self]`: a parameter of a function, either a
 *   callback passed to a library function, or a user-defined function overriding a library member.
 * - `ReturnValue`: the result of a call, or the value returned from a user-defined override.
 *
 * Optional types, optional chaining, and force-unwrapping are transparent.
 */

private import unified
private import codeql.dataflow.internal.AccessPathSyntax as AccessPathSyntax
private import codeql.unified.internal.Builtins
private import codeql.unified.internal.NameBindingPluginSwift as NameBindingPluginSwift
private import codeql.unified.internal.StaticNameBinding as StaticNameBinding
private import codeql.unified.internal.dataflow.AllDataFlow as DF
private import DynamicMaDExtensions

/** Holds if `type, path` is the start of a model row. */
private predicate isRelevantRow(string type, string path) {
  sourceModel(type, path, _, _)
  or
  sinkModel(type, path, _, _)
  or
  summaryModel(type, path, _, _, _, _)
  or
  typeModel(_, type, path)
}

/** Holds if `type, path` is the start of a type summary, i.e. a summary of kind `type`. */
private predicate isTypeSummaryRow(string type, string path, string input, string output) {
  summaryModel(type, path, input, output, "type", _)
}

private predicate isRelevantAccessPath(string path) {
  isRelevantRow(_, path)
  or
  summaryModel(_, _, path, _, _, _)
  or
  summaryModel(_, _, _, path, _, _)
}

private module AccessPathInstance = AccessPathSyntax::AccessPath<isRelevantAccessPath/1>;

/** An access path appearing in a model. */
class AccessPath = AccessPathInstance::AccessPath;

/** An access path token appearing in a model. */
class AccessPathToken = AccessPathInstance::AccessPathToken;

private predicate parseIntUnbounded = AccessPathInstance::parseIntUnbounded/1;

/**
 * Holds if `type` is a type string referring to a module.
 *
 * Module names do not contain dots, so any type without a dot is considered a module.
 */
bindingset[type]
predicate isModuleTypeString(string type) { not type.matches("%.%") }

/**
 * Holds if `type` is a type string referring to a metatype `parent.name.Type`.
 *
 * `parent` is the type string to which `name` should be applied as a member to obtain the metatype,
 * that is, either a module, or another metatype.
 */
bindingset[type]
predicate parseMetatypeString(string type, string parent, string name) {
  exists(string prefix |
    type.regexpCapture("(.+)\\.([^.]+)\\.Type", 1) = prefix and
    name = type.regexpCapture("(.+)\\.([^.]+)\\.Type", 2) and
    if isModuleTypeString(prefix) then parent = prefix else parent = prefix + ".Type"
  )
}

/**
 * Holds if `type` is a type string referring to the instances of a type, i.e. a type string
 * that is neither a module nor a metatype.
 */
bindingset[type]
predicate isInstanceTypeString(string type) {
  not isModuleTypeString(type) and
  not type.matches("%.Type")
}

/** Holds if `type` is a type string that may be relevant for evaluating the models. */
private predicate isRelevantType(string type) {
  isRelevantRow(type, _)
  or
  typeModel(type, _, _)
  or
  exists(string instance |
    isRelevantType(instance) and
    isInstanceTypeString(instance) and
    type = instance + ".Type"
  )
  or
  parseMetatypeString(any(string meta | isRelevantType(meta)), type, _)
}

/**
 * Holds if `prefix` is a dot-separated prefix of a relevant type string, not including
 * a `.Type` suffix.
 */
private predicate isRelevantTypePrefix(string prefix) {
  isRelevantType(prefix) and
  not prefix.matches("%.Type")
  or
  prefix = any(string meta | isRelevantType(meta)).regexpCapture("(.+)\\.Type", 1)
  or
  prefix = any(string s | isRelevantTypePrefix(s)).regexpCapture("(.+)\\.[^.]+", 1)
}

/** Holds if `name` appears as a member name in a model, either in an access path or a type string. */
private predicate isRelevantMemberName(string name) {
  name = any(AccessPathToken tok | tok.getName() = "Member").getAnArgument()
  or
  parseMetatypeString(any(string meta | isRelevantType(meta)), _, name)
  or
  name = any(string prefix | isRelevantTypePrefix(prefix)).regexpCapture(".*\\.([^.]+)", 1)
}

/** Holds if `name` is a relevant module name. */
private predicate isRelevantModule(string name) {
  isModuleTypeString(name) and
  isRelevantTypePrefix(name)
}

/** Gets the leading identifier of a qualified name such as `A.B.C`. */
private Identifier getLeadingIdentifier(Expr e) {
  result = e
  or
  result = getLeadingIdentifier(e.(MemberAccessExpr).getBase())
}

/**
 * Holds if the module `name` should be considered available in the database.
 *
 * To support re-exports and umbrella headers, we consider a module available in every file
 * if it is imported anywhere in the database. The `Swift` module is always available.
 * A module is also available if it is re-exported by an available module, as indicated by
 * a type model of form `(name, otherModule, "")`.
 */
private predicate isModuleAvailable(string name) {
  isRelevantModule(name) and
  (
    name = "Swift"
    or
    name = getLeadingIdentifier(any(ImportDeclaration imprt).getImportedExpr()).getValue()
    or
    name = any(NameBindingPluginSwift::SwiftInterfaceModule m).getModuleName()
    or
    isModuleRef(_, name)
    or
    exists(string other |
      typeModel(name, other, "") and
      isModuleAvailable(other)
    )
  )
}

/**
 * Holds if `binding` is the name of a top-level declaration in a library module named `moduleName`.
 *
 * Builtin types belong to the `Swift` module, and declarations from a `.swiftinterface` file
 * belong to the module that file describes.
 */
private predicate isLibraryTopLevelBinding(NameBinding binding, string moduleName) {
  exists(TopLevel top | binding.getDeclaration() = top.getBody().getAStmt() |
    top.getFile().getParentContainer() instanceof BuiltinsFolder and
    moduleName = "Swift"
    or
    top.(NameBindingPluginSwift::SwiftInterfaceModule).getModuleName() = moduleName
  )
}

/** Holds if `e` is a reference to the module `moduleName`, such as `Foundation` in `Foundation.URL`. */
private predicate isModuleRef(Identifier e, string moduleName) {
  e.getValue() = moduleName and
  isRelevantModule(moduleName) and
  not e instanceof IdentifierLabel and
  not e instanceof NameBinding and
  forall(NameBinding target | target = StaticNameBinding::getStaticBindingTargetFromIdentifier(e) |
    target.getDeclaration() instanceof ImportDeclaration
  )
}

/**
 * Holds if `e` refers to the member `name` of the module `moduleName`.
 *
 * This holds for unresolved identifiers (assuming they come from an available module), identifiers
 * that resolve to a top-level library declaration, and qualified references such as `Foundation.URL`.
 */
pragma[nomagic]
private predicate isModuleMemberRef(Expr e, string moduleName, string name) {
  isRelevantMemberName(name) and
  (
    exists(Identifier id |
      id = e and
      id.getValue() = name and
      not id instanceof IdentifierLabel and
      not id instanceof NameBinding
    |
      not exists(StaticNameBinding::getStaticBindingTargetFromIdentifier(id)) and
      isModuleAvailable(moduleName)
      or
      isLibraryTopLevelBinding(StaticNameBinding::getStaticBindingTargetFromIdentifier(id),
        moduleName)
    )
    or
    exists(MemberAccessExpr access |
      access = e and
      access.getMemberName() = name and
      isModuleRef(access.getBase(), moduleName)
    )
  )
}

/**
 * Gets the type string denoted by the type expression `te`, such as `Foundation.URL`.
 *
 * Optional types and type modifiers are unwrapped.
 */
string getTypeStringFromTypeExpr(Expr te) {
  exists(string moduleName, string name |
    isModuleMemberRef(te, moduleName, name) and
    result = moduleName + "." + name and
    isRelevantTypePrefix(result)
  )
  or
  exists(MemberAccessExpr access |
    access = te and
    result = getTypeStringFromTypeExpr(access.getBase()) + "." + access.getMemberName() and
    isRelevantTypePrefix(result)
  )
  or
  exists(GenericTypeExpr gte | gte = te |
    if gte.getBase().(Identifier).getValue() = "Optional"
    then result = getTypeStringFromTypeExpr(gte.getTypeArgument(0))
    else result = getTypeStringFromTypeExpr(gte.getBase())
  )
  or
  result = getTypeStringFromTypeExpr(te.(ModifiedTypeExpr).getType())
}

/** Holds if `cls` is a user-defined class whose base types include the given type. */
private predicate isUserSubtypeOf(ClassLikeDeclaration cls, string type) {
  isInstanceTypeString(type) and
  isRelevantType(type) and
  exists(ClassLikeDeclaration decl |
    decl.resolve() = cls and
    not cls.getFile().getExtension() = "swiftinterface"
  |
    getTypeStringFromTypeExpr(decl.getABaseType().getType()) = type
    or
    isUserSubtypeOf(decl.getABaseClass(), type)
  )
}

/** Gets a method of `cls` (or its extensions) with the given name. */
private Callable getAMethod(ClassLikeDeclaration cls, string name) {
  result = cls.getAMemberIncludingExtensions() and
  (
    result.(FunctionDeclaration).getName() = name
    or
    result instanceof ConstructorDeclaration and name = "init"
  )
}

/**
 * Holds if `id` is an unresolved identifier inside a method of `cls`, and may thus refer to
 * a member inherited from a library type.
 */
private predicate isImplicitSelfMemberAccess(ClassLikeDeclaration cls, Identifier id, string name) {
  isUserSubtypeOf(cls, _) and
  isRelevantMemberName(name) and
  id.getValue() = name and
  not id instanceof IdentifierLabel and
  not id instanceof NameBinding and
  not exists(StaticNameBinding::getStaticBindingTargetFromIdentifier(id)) and
  id.getEnclosingCallable() = getAMethod(cls, _)
}

/** Holds if there is a local value-preserving step from `node1` to `node2`. */
private predicate localValueStep(DataFlow::Node node1, DataFlow::Node node2) {
  exists(DF::Step s |
    DF::step(node1, s, node2) and
    (
      s.value()
      or
      s.valueMustFlow()
      or
      exists(DF::ContentSet c | DF::bypassContentSet(c) | s.read(c) or s.store(c))
    )
  )
  or
  DF::localSsaStep(node1, node2, _)
}

/** Holds if `callable` is a function that may flow into a callback position. */
private predicate isCallbackCandidate(Callable callable) {
  callable instanceof FunctionExpr
  or
  callable instanceof LocalFunctionDeclaration
}

/** Holds if the function `callable` locally flows to `node`. */
private predicate callableFlowsTo(Callable callable, DataFlow::Node node) {
  isCallbackCandidate(callable) and
  node.isCallable(callable)
  or
  exists(DataFlow::Node mid |
    callableFlowsTo(callable, mid) and
    localValueStep(mid, node)
  )
}

private newtype TApiNode =
  /** The module named `name`. */
  MkModule(string name) { isModuleAvailable(name) } or
  /** A value flowing out of a library. */
  MkUse(DataFlow::Node node) or
  /** A value flowing into a library. */
  MkDef(DataFlow::Node node) or
  /** A static reference to a type, which does not have a corresponding data-flow node. */
  MkStaticRef(Expr e) { isStaticRefCandidate(e) and not hasValueNode(e) } or
  /** The `init` member being implicitly invoked by a call `callee(...)`. */
  MkImplicitInit(Expr callee) { callee = any(CallExpr call).getCallee() } or
  /** A user-defined class extending or conforming to a library type. */
  MkClassDef(ClassLikeDeclaration cls) { isUserSubtypeOf(cls, _) } or
  /** A user-defined method in a class extending or conforming to a library type. */
  MkFunctionDef(Callable callable) {
    exists(ClassLikeDeclaration cls | isUserSubtypeOf(cls, _) and callable = getAMethod(cls, _))
  }

/**
 * A node used for evaluating access paths.
 *
 * This is either a data-flow node (flowing in or out of a library), or a node representing a
 * module, user-defined subclass, or user-defined method.
 */
class ApiNode extends TApiNode {
  /** Gets the data-flow node for a value flowing out of a library, if this is such a node. */
  DataFlow::Node asUse() { this = MkUse(result) }

  /** Gets the data-flow node for a value flowing into a library, if this is such a node. */
  DataFlow::Node asDef() { this = MkDef(result) }

  /** Gets a string representation of this node. */
  string toString() {
    exists(string name | this = MkModule(name) and result = "module " + name)
    or
    result = "use " + this.asUse().toString()
    or
    result = "def " + this.asDef().toString()
    or
    exists(Expr callee | this = MkImplicitInit(callee) and result = "init " + callee.toString())
    or
    exists(Expr e | this = MkStaticRef(e) and result = "static " + e.toString())
    or
    exists(ClassLikeDeclaration cls | this = MkClassDef(cls) and result = "class " + cls.toString())
    or
    exists(Callable c | this = MkFunctionDef(c) and result = "function " + c.toString())
  }

  /** Gets the location of this node. */
  Location getLocation() {
    result = this.asUse().getLocation()
    or
    result = this.asDef().getLocation()
    or
    exists(Expr callee | this = MkImplicitInit(callee) and result = callee.getLocation())
    or
    exists(Expr e | this = MkStaticRef(e) and result = e.getLocation())
    or
    exists(ClassLikeDeclaration cls | this = MkClassDef(cls) and result = cls.getLocation())
    or
    exists(Callable c | this = MkFunctionDef(c) and result = c.getLocation())
  }
}

/** Holds if `e` has a data-flow node representing its value. */
private predicate hasValueNode(Expr e) { any(DataFlow::Node n).isResultValue(e) }

/** Holds if `e` may be a static reference to a type. */
private predicate isStaticRefCandidate(Expr e) {
  isModuleMemberRef(e, _, _)
  or
  exists(MemberAccessExpr access |
    access = e and
    isStaticRefCandidate(access.getBase()) and
    isRelevantMemberName(access.getMemberName())
  )
}

/**
 * Gets the API node representing the use of `e`.
 *
 * For expressions without a value, such as type references, a static reference node is used instead.
 */
private ApiNode useOfExpr(Expr e) {
  result.asUse().isResultValue(e)
  or
  result = MkStaticRef(e)
}

/** Holds if `node` represents the function being invoked at `call`. */
pragma[nomagic]
private predicate isFunctionNodeForCall(ApiNode node, CallExpr call) {
  node.asUse().isResultValue(call.getCallee())
  or
  node = MkImplicitInit(call.getCallee())
}

/** Holds if `call` has an argument with the given `label`. */
private predicate callHasLabel(CallExpr call, string label) {
  call.getAnArgument().getName() = label
}

/** Holds if `callable` has a parameter with the given external name. */
private predicate callableHasLabel(Callable callable, string label) {
  callable.getAParameter().getExternalName() = label
}

/** Gets the member `name` of `node`. */
pragma[nomagic]
private ApiNode getMember(ApiNode node, string name) {
  isRelevantMemberName(name) and
  (
    exists(string moduleName, Expr e |
      node = MkModule(moduleName) and
      isModuleMemberRef(e, moduleName, name) and
      result = useOfExpr(e)
    )
    or
    exists(Expr base | node = MkStaticRef(base) |
      exists(MemberAccessExpr access |
        access.getBase() = base and
        access.getMemberName() = name and
        result = useOfExpr(access)
      )
      or
      name = "init" and
      result = MkImplicitInit(base)
    )
    or
    exists(DataFlow::Node base | base = node.asUse() |
      DF::step(base, any(DF::Step s | s.readName(name)), result.asUse())
      or
      exists(MemberAccessExpr access |
        base.isResultValue(access.getBase()) and
        access.getMemberName() = name and
        result.asDef().isIncomingValue(access)
      )
      or
      name = "init" and
      exists(Expr callee |
        base.isResultValue(callee) and
        result = MkImplicitInit(callee)
      )
    )
    or
    exists(ClassLikeDeclaration cls | node = MkClassDef(cls) |
      result = MkFunctionDef(getAMethod(cls, name))
      or
      exists(Identifier id | isImplicitSelfMemberAccess(cls, id, name) |
        result.asUse().isResultValue(id)
        or
        result.asDef().isIncomingValue(id)
      )
    )
  )
}

bindingset[token]
pragma[inline_late]
private predicate argumentMatchesToken(Argument arg, AccessPathToken token) {
  arg.getPositionalIndex() = parseIntUnbounded(token.getAnArgument())
  or
  arg.getName() + ":" = token.getAnArgument()
}

bindingset[token]
pragma[inline_late]
private predicate parameterMatchesToken(Parameter param, AccessPathToken token) {
  param.getPositionalIndex() = parseIntUnbounded(token.getAnArgument())
  or
  param.getExternalName() + ":" = token.getAnArgument()
}

/** Gets the node reached by applying `token` to `node`. */
bindingset[node, token]
private ApiNode getSuccessorFromToken(ApiNode node, AccessPathToken token) {
  token.getName() = "Member" and
  result = getMember(node, token.getAnArgument())
  or
  token.getName() = "WithNamedArgument" and
  result = node and
  (
    exists(CallExpr call | isFunctionNodeForCall(node, call) |
      callHasLabel(call, token.getAnArgument())
    )
    or
    exists(Callable c | node = MkFunctionDef(c) | callableHasLabel(c, token.getAnArgument()))
  )
  or
  token.getName() = "WithoutNamedArgument" and
  result = node and
  (
    exists(CallExpr call | isFunctionNodeForCall(node, call) |
      not callHasLabel(call, token.getAnArgument())
    )
    or
    exists(Callable c | node = MkFunctionDef(c) | not callableHasLabel(c, token.getAnArgument()))
  )
  or
  token.getName() = "Argument" and
  exists(CallExpr call | isFunctionNodeForCall(node, call) |
    exists(Argument arg |
      arg = call.getAnArgument() and
      argumentMatchesToken(arg, token) and
      result.asDef().isResultValue(arg.getValue())
    )
    or
    token.getAnArgument() = "self" and
    result.asDef().isReceiverArgument(call)
  )
  or
  token.getName() = "Parameter" and
  exists(Callable callable |
    node = MkFunctionDef(callable)
    or
    callableFlowsTo(callable, node.asDef())
  |
    exists(Parameter param |
      param.getDeclaringCallable() = callable and
      parameterMatchesToken(param, token) and
      result.asUse().asExpr() = param.getPattern()
    )
    or
    token.getAnArgument() = "self" and
    result.asUse().isReceiverParameter(callable)
  )
  or
  token = "ReturnValue" and
  (
    exists(CallExpr call |
      isFunctionNodeForCall(node, call) and
      result.asUse().isResultValue(call)
    )
    or
    exists(Callable callable |
      node = MkFunctionDef(callable) and
      result.asDef().isReturnNode(callable)
    )
  )
}

/** Gets the result of applying `ReturnValue` to `node`. */
private ApiNode getReturnValue(ApiNode node) {
  exists(CallExpr call |
    isFunctionNodeForCall(node, call) and
    result.asUse().isResultValue(call)
  )
}

/**
 * Holds if `type` is a user-defined type alias for the given type, or a class extending it.
 */
private predicate isUserTypeForType(Identifier decl, string type) {
  exists(ClassLikeDeclaration cls |
    isUserSubtypeOf(cls, type) and
    decl = cls.getNameNode()
  )
}

/** Gets a node that is an instance of the type `type` due to a type annotation or similar. */
pragma[nomagic]
private ApiNode getAnAnnotatedInstance(string type) {
  isInstanceTypeString(type) and
  isRelevantType(type) and
  (
    exists(Parameter param |
      getTypeStringFromTypeExpr(param.getType()) = type and
      result.asUse().asExpr() = param.getPattern()
    )
    or
    exists(TypeCastExpr cast |
      getTypeStringFromTypeExpr(cast.getType()) = type and
      result = useOfExpr(cast)
    )
    or
    // Accesses to a user-defined property or function with a declared type
    exists(Expr access, NameBinding target |
      target = StaticNameBinding::getStaticBindingTargetFromRef(access)
    |
      exists(VariableDeclaration decl |
        target = decl.getNameNode() and
        getTypeStringFromTypeExpr(decl.getType()) = type and
        result = useOfExpr(access)
      )
      or
      exists(FunctionDeclaration decl, CallExpr call |
        target = decl.getNameNode() and
        getTypeStringFromTypeExpr(decl.getReturnType()) = type and
        access = call.getCallee() and
        result = useOfExpr(call)
      )
    )
    or
    // Instantiation of a user-defined subclass
    exists(CallExpr call, Expr callee |
      callee = call.getCallee() and
      isUserTypeForType(StaticNameBinding::getStaticBindingTargetFromRef([
            callee, callee.(MemberAccessExpr).getBase()
          ]), type) and
      result = useOfExpr(call)
    )
    or
    // Receivers of user-defined methods in a subclass
    exists(ClassLikeDeclaration cls |
      isUserSubtypeOf(cls, type) and
      result.asUse().isReceiverParameter(getAMethod(cls, _))
    )
    or
    exists(ClassLikeDeclaration cls |
      isUserSubtypeOf(cls, type) and
      result = MkClassDef(cls)
    )
  )
}

/** Gets a node that is an instance of the given type, without following local flow. */
private ApiNode getATypeNodeRaw(string type) {
  isRelevantType(type) and
  (
    result = MkModule(type)
    or
    exists(string type2, AccessPath path |
      typeModel(type, type2, path) and
      result = getNodeFromPath(type2, path)
    )
    or
    exists(string parent, string name |
      parseMetatypeString(type, parent, name) and
      result = getMember(getATypeNode(parent), name)
    )
    or
    isInstanceTypeString(type) and
    result = getReturnValue(getMember(getATypeNode(type + ".Type"), "init"))
    or
    result = getAnAnnotatedInstance(type)
  )
}

/** Gets a node that is an instance of the given type. */
cached
ApiNode getATypeNode(string type) {
  result = getATypeNodeRaw(type)
  or
  localValueStepPlus(getATypeNodeRaw(type).asUse(), result.asUse())
}

/** Holds if `node` is the use of a value appearing in the evaluation of an access path. */
private predicate isRelevantUse(DataFlow::Node node) {
  node = getATypeNodeRaw(_).asUse()
  or
  node = getNodeFromPathRaw(_, _, _).asUse()
  or
  node = getNodeFromSubPathRaw(_, _, _).asUse()
}

/** Holds if `node2` can be reached from the relevant node `node1` via one or more local flow steps. */
private predicate localValueStepPlus(DataFlow::Node node1, DataFlow::Node node2) {
  isRelevantUse(node1) and
  localValueStep(node1, node2)
  or
  exists(DataFlow::Node mid |
    localValueStepPlus(node1, mid) and
    localValueStep(mid, node2)
  )
}

/**
 * Gets the node reached by evaluating the first `n` tokens of `(type, path)`, but without following
 * local flow after the last token.
 */
private ApiNode getNodeFromPathRaw(string type, AccessPath path, int n) {
  isRelevantRow(type, path) and
  (
    n = 0 and
    result = getATypeNode(type)
    or
    result = getSuccessorFromToken(getNodeFromPath(type, path, n - 1), path.getToken(n - 1))
  )
}

/** Gets the node reached by evaluating the first `n` tokens of `(type, path)`. */
private ApiNode getNodeFromPath(string type, AccessPath path, int n) {
  result = getNodeFromPathRaw(type, path, n)
  or
  localValueStepPlus(getNodeFromPathRaw(type, path, n).asUse(), result.asUse())
  or
  // Apply type summaries
  typeStep(getNodeFromPath(type, path, n), result)
}

/**
 * Gets the node reached by evaluating `(type, path)`.
 *
 * This does not include nodes reached by local flow after the last token. This is to avoid
 * reporting every alias of a source as a source.
 */
cached
ApiNode getNodeFromPath(string type, AccessPath path) {
  result = getNodeFromPathRaw(type, path, path.getNumToken())
}

/** Like `getNodeFromPath` but also includes nodes reached via local flow. */
private ApiNode getNodeFromPathEx(string type, AccessPath path) {
  result = getNodeFromPath(type, path, path.getNumToken())
}

/** Holds if `base` should be used as the base for evaluating a type summary input or output. */
private predicate isTypeSummaryBase(ApiNode base, AccessPath subPath) {
  exists(string type, string path |
    isTypeSummaryRow(type, path, subPath, _) or isTypeSummaryRow(type, path, _, subPath)
  |
    base = getNodeFromPathEx(type, path)
  )
}

/** Gets the node reached by evaluating the first `n` tokens of `subPath`, starting at `base`. */
private ApiNode getNodeFromSubPathRaw(ApiNode base, AccessPath subPath, int n) {
  isTypeSummaryBase(base, subPath) and
  (
    n = 0 and result = base
    or
    result =
      getSuccessorFromToken(getNodeFromSubPathEx(base, subPath, n - 1), subPath.getToken(n - 1))
  )
}

/** Like `getNodeFromSubPathRaw` but also includes nodes reachable via local flow. */
private ApiNode getNodeFromSubPathEx(ApiNode base, AccessPath subPath, int n) {
  result = getNodeFromSubPathRaw(base, subPath, n)
  or
  localValueStepPlus(getNodeFromSubPathRaw(base, subPath, n).asUse(), result.asUse())
}

/** Gets the node reached by evaluating `subPath` starting at `base`. */
private ApiNode getNodeFromSubPath(ApiNode base, AccessPath subPath) {
  result = getNodeFromSubPathRaw(base, subPath, subPath.getNumToken())
}

/**
 * Holds if a type summary implies that `succ` has the same type as `pred`.
 */
private predicate typeStep(ApiNode pred, ApiNode succ) {
  exists(string type, string path, ApiNode base, AccessPath input, AccessPath output |
    isTypeSummaryRow(type, path, input, output) and
    base = getNodeFromPathEx(type, path) and
    pred = getNodeFromSubPath(base, input) and
    succ = getNodeFromSubPath(base, output)
  )
}

/**
 * Holds if `node` is inside a library file, that is, a file with builtins or a `.swiftinterface` file.
 *
 * Sources and sinks are not reported inside library files.
 */
private predicate isInLibraryFile(DataFlow::Node node) {
  exists(File file | file = node.getLocation().getFile() |
    file.getParentContainer() instanceof BuiltinsFolder
    or
    file.getExtension() = "swiftinterface"
  )
}

/** Gets a data-flow node to use as a source, given a node reached by a source model. */
private DataFlow::Node getSourceNode(ApiNode node) {
  result = node.asUse()
  or
  result = node.asDef().getPostUpdateNode()
}

/** Gets a data-flow node to use as a sink, given a node reached by a sink model. */
private DataFlow::Node getSinkNode(ApiNode node) { result = node.asDef() }

/** Holds if `node` is a source of the given `kind`, due to `madId`. */
cached
predicate sourceNode(DataFlow::Node node, string kind, QlBuiltins::ExtensionId madId) {
  exists(string type, string path |
    sourceModel(type, path, kind, madId) and
    node = getSourceNode(getNodeFromPath(type, path)) and
    not isInLibraryFile(node)
  )
}

/** Holds if `node` is a sink of the given `kind`, due to `madId`. */
cached
predicate sinkNode(DataFlow::Node node, string kind, QlBuiltins::ExtensionId madId) {
  exists(string type, string path |
    sinkModel(type, path, kind, madId) and
    node = getSinkNode(getNodeFromPath(type, path)) and
    not isInLibraryFile(node)
  )
}

/**
 * Holds if `call` is a call to `(type, path)`.
 */
pragma[nomagic]
predicate isCallToPath(string type, string path, CallExpr call) {
  isFunctionNodeForCall(getNodeFromPathEx(type, path), call)
}

/** Holds if a summary model with `(type, path)` propagates flow from `input` to `output`. */
predicate flowSummaryModel(
  string type, string path, string input, string output, string kind, QlBuiltins::ExtensionId madId
) {
  summaryModel(type, path, input, output, kind, madId) and
  kind = ["value", "taint"]
}

module Public {
  /** Provides access to data from library models. */
  module Models {
    /** Holds if `node` is a source of the given `kind`. */
    predicate isSource(DataFlow::Node node, string kind) { sourceNode(node, kind, _) }

    /** Holds if `node` is a sink of the given `kind`. */
    predicate isSink(DataFlow::Node node, string kind) { sinkNode(node, kind, _) }
  }
}

/** Provides debugging predicates for finding problems in the models. */
module Debug {
  private predicate isValidTokenName(string name) {
    name =
      [
        "Member", "WithNamedArgument", "WithoutNamedArgument", "Argument", "Parameter",
        "ReturnValue"
      ]
  }

  private predicate isValidSummaryTokenName(string name) {
    isValidTokenName(name)
    or
    name =
      [
        "ArrayElement", "OptionalSome", "CollectionElement", "TupleElement", "WithArrayElement",
        "WithoutArrayElement", "WithOptionalSome", "WithoutOptionalSome", "WithCollectionElement",
        "WithoutCollectionElement"
      ]
  }

  /** Holds if `path`, used as the `type, path` pair in a model, contains an invalid token. */
  query predicate invalidAccessPath(string type, AccessPath path, string message) {
    isRelevantRow(type, path) and
    (
      path.hasSyntaxError() and
      message = "Syntax error"
      or
      exists(AccessPathToken token |
        token = path.getToken(_) and
        not isValidTokenName(token.getName()) and
        message = "Invalid token '" + token + "'"
      )
      or
      exists(AccessPathToken token |
        token = path.getToken(_) and
        token.getName() = ["Argument", "Parameter"] and
        exists(string arg | arg = token.getAnArgument() |
          not arg.regexpMatch("-?\\d+(\\.\\.(-?\\d+)?)?") and
          not arg.matches("%:") and
          not arg = "self"
        ) and
        message = "Invalid argument in '" + token + "'"
      )
    )
    or
    exists(string input, string output |
      summaryModel(type, _, input, output, _, _) and
      path = [input, output] and
      exists(AccessPathToken token |
        token = path.getToken(_) and
        not isValidSummaryTokenName(token.getName()) and
        message = "Invalid summary token '" + token + "'"
      )
    )
  }

  /** Holds if `type` is used in a model but has no instances in the database. */
  query predicate typeWithoutInstances(string type) {
    isRelevantRow(type, _) and
    not exists(getATypeNode(type))
  }
}
