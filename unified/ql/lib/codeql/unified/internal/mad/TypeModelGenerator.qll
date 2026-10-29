/**
 * Provides a graph for generating `typeModel` rows from `.swiftinterface` files.
 *
 * The graph is exported using `codeql.mad.dynamic.GraphExport`. Its nodes are mostly name-binding
 * nodes, such as module scopes and the static/instance namespaces of classes declared in
 * `.swiftinterface` files, with additional nodes for callables, function types, and types that
 * are referenced but not declared in the database (such as types imported from Objective-C).
 */

private import unified
private import codeql.mad.dynamic.GraphExport
private import codeql.unified.internal.StaticNameBinding
private import codeql.unified.internal.NameBindingPlugin
private import codeql.unified.internal.NameBindingPluginSwift as NameBindingPluginSwift
private import codeql.unified.internal.mad.DynamicMaDExtensions as Extensions
private import codeql.unified.internal.mad.DynamicMaD as DynamicMaD

/** Gets the name of the module described by the `.swiftinterface` file containing `n`. */
private string getModuleName(AstNode n) {
  exists(NameBindingPluginSwift::SwiftInterfaceModule mod |
    mod.getFile() = n.getFile() and
    result = mod.getModuleName()
  )
}

/** Holds if `n` is in a `.swiftinterface` file. */
private predicate isInInterface(AstNode n) { exists(getModuleName(n)) }

/**
 * Gets the name of a module declaring a top-level type named `name`, excluding the module containing `ref`.
 */
private string getAnotherModuleDeclaringType(Expr ref, string name) {
  exists(ClassLikeDeclaration cls |
    cls.getName() = name and
    cls.getParent().getParent() instanceof TopLevel and
    result = getModuleName(cls) and
    result != getModuleName(ref)
  )
}

/** Gets the names of the types defined in the `Swift` module, which are visible everywhere. */
private predicate isBuiltinTypeName(string name) {
  name = any(ClassLikeDeclaration cls | cls.getFile().getBaseName() = "types.swift").getName()
}

/** Gets the class declaration referenced by the type expression `te`, if it is declared in an interface file. */
private ClassLikeDeclaration getReferencedClass(Expr te) {
  result.getNameNode() = getStaticBindingTargetFromRef(te) and
  isInInterface(result)
}

/** Holds if `te` refers to something that is not a type we can name, such as a type parameter. */
private predicate isUnnameableTypeRef(Expr te) {
  exists(NameBinding target | target = getStaticBindingTargetFromRef(te) |
    not target = any(ClassLikeDeclaration cls).getNameNode()
  )
  or
  te.(Identifier).getValue() = ["Self", "Any", "AnyObject", "Void", "Never"]
}

/**
 * Gets the qualified type string of the class `cls`, such as `Foundation.FileManager`.
 */
string getClassTypeString(ClassLikeDeclaration cls) {
  isInInterface(cls) and
  not exists(cls.getExtensionTarget()) and
  (
    exists(ClassLikeDeclaration parent |
      cls = parent.getAMember() and
      result = getContainerTypeString(parent) + "." + cls.getName()
    )
    or
    cls.getParent().getParent() instanceof TopLevel and
    result = getModuleName(cls) + "." + cls.getName()
  )
}

/** Gets the type string of the class or extension `container`. */
private string getContainerTypeString(ClassLikeDeclaration container) {
  result = getClassTypeString(container)
  or
  result = getTypeStringFromTypeExpr(container.getExtensionTarget())
}

/**
 * Gets the type string denoted by the type expression `te` appearing in an interface file.
 *
 * References to types that are not declared in the database are assumed to come from the
 * module containing the reference, unless they are names of builtin types.
 */
string getTypeStringFromTypeExpr(Expr te) {
  isInInterface(te) and
  (
    result = getClassTypeString(getReferencedClass(te))
    or
    not exists(getReferencedClass(te)) and
    not isUnnameableTypeRef(te) and
    (
      exists(string name | name = te.(Identifier).getValue() |
        // Prefer a unique declaration in another module, then builtins, then the current module
        if exists(unique(string m | m = getAnotherModuleDeclaringType(te, name)))
        then result = unique(string m | m = getAnotherModuleDeclaringType(te, name)) + "." + name
        else
          if isBuiltinTypeName(name)
          then result = "Swift." + name
          else result = getModuleName(te) + "." + name
      )
      or
      exists(MemberAccessExpr access | access = te |
        result = getTypeStringFromTypeExpr(access.getBase()) + "." + access.getMemberName()
      )
    )
    or
    result = getTypeStringFromTypeExpr(getUnwrappedTypeExpr(te))
  )
}

/** Gets the type expression wrapped by `te`, such as `T` in `T?`, `Array<T>` or `inout T`. */
private Expr getUnwrappedTypeExpr(Expr te) {
  exists(GenericTypeExpr gte | gte = te |
    if gte.getBase().(Identifier).getValue() = "Optional"
    then result = gte.getTypeArgument(0)
    else result = gte.getBase()
  )
  or
  result = te.(ModifiedTypeExpr).getType()
}

/** Holds if `te` is a type expression appearing in a relevant position of an interface file. */
private predicate isTypeExprInInterface(Expr te) {
  isInInterface(te) and
  (
    te = any(VariableDeclaration decl).getType()
    or
    te = any(Callable c).getReturnType()
    or
    te = any(Parameter p).getType()
    or
    te = any(BaseType b).getType()
    or
    te = any(ClassLikeDeclaration cls).getExtensionTarget()
    or
    te = getUnwrappedTypeExpr(any(Expr e | isTypeExprInInterface(e)))
  )
}

/** Holds if `decl` should not be exported. */
private predicate isHidden(AstNode decl) {
  decl.(Member).getNameNode().getValue().matches("\\_%")
  or
  decl.hasModifier(["internal", "private", "fileprivate", "@usableFromInline"])
  or
  exists(Modifier mod | mod.getParent() = decl |
    mod.getValue().matches("@\\_spi%")
    or
    mod.getValue().regexpMatch("@available\\(\\s*\\*\\s*,\\s*unavailable\\b.*")
  )
}

/** Holds if `member` is a static member, or a nested type. */
private predicate isStaticDecl(Member member) {
  member.hasModifier(["static", "class", "enum_case"])
  or
  member instanceof ConstructorDeclaration
  or
  member instanceof ClassLikeDeclaration
  or
  member instanceof TypeAliasDeclaration
}

/** Gets the name of `member`, using `init` for initializers. */
private string getMemberName(Member member) {
  if member instanceof ConstructorDeclaration
  then result = "init"
  else result = member.getNameNode().getValue().regexpReplaceAll("^`(.*)`$", "$1")
}

/**
 * Holds if `type` is relevant for the exported type models, because it is used by a source, sink,
 * or summary model.
 *
 * Note that this does not take existing type models into account, as that would make the output
 * depend on previously generated type models.
 */
private predicate isRelevantType(string type) {
  Extensions::sourceModel(type, _, _, _)
  or
  Extensions::sinkModel(type, _, _, _)
  or
  Extensions::summaryModel(type, _, _, _, any(string kind | kind != "type"), _)
}

private newtype TNode =
  /** A module scope or class namespace from an interface file. */
  MkNamespace(NamespaceNode ns) {
    exists(NameBindingPluginSwift::SwiftInterfaceModule mod | ns.isModuleScopeNode(mod))
    or
    exists(ClassLikeDeclaration cls |
      ns.isInstanceOrStaticMemberNamespace(cls) and
      exists(getClassTypeString(cls))
    )
  } or
  /** A type that is not declared in the database (`type` can also be a module or metatype). */
  MkExternal(string type) {
    type = getTypeStringFromTypeExpr(any(Expr te | isTypeExprInInterface(te))) + ["", ".Type"]
    or
    exists(ImportDeclaration imprt |
      isInInterface(imprt) and
      imprt.hasModifier("@_exported") and
      type = imprt.getImportedExpr().(Identifier).getValue()
    )
  } or
  /** A function or initializer declared in an interface file. */
  MkCallable(Callable c) {
    isInInterface(c) and
    not isHidden(c) and
    (c instanceof FunctionDeclaration or c instanceof ConstructorDeclaration)
  } or
  /** A function type appearing as the type of a parameter. */
  MkFunctionType(FunctionExpr te) { isTypeExprInInterface(te) }

/** A node in the graph to export. */
class Node extends TNode {
  /** Gets the name-binding node wrapped by this node, if any. */
  NamespaceNode asNamespace() { this = MkNamespace(result) }

  /** Gets the callable wrapped by this node, if any. */
  Callable asCallable() { this = MkCallable(result) }

  /** Gets the type string of the external type represented by this node, if any. */
  string asExternal() { this = MkExternal(result) }

  /** Gets a string representation of this node. */
  string toString() {
    result = this.asNamespace().toString()
    or
    result = "external " + this.asExternal()
    or
    result = "callable " + this.asCallable().toString()
    or
    exists(FunctionExpr te | this = MkFunctionType(te) | result = "function type " + te.toString())
  }

  /** Gets the location of this node. */
  Location getLocation() {
    result = this.asNamespace().getLocation()
    or
    result = this.asCallable().getLocation()
    or
    exists(FunctionExpr te | this = MkFunctionType(te) | result = te.getLocation())
  }
}

/** Gets the type string naming `node`, if it represents a module or a type. */
string getNodeTypeString(Node node) {
  exists(NameBindingPluginSwift::SwiftInterfaceModule mod |
    node.asNamespace().isModuleScopeNode(mod) and
    result = mod.getModuleName()
  )
  or
  exists(ClassLikeDeclaration cls |
    node.asNamespace().isInstanceMemberNamespace(cls) and
    result = getClassTypeString(cls)
    or
    node.asNamespace().isStaticMemberNamespace(cls) and
    result = getClassTypeString(cls) + ".Type"
  )
  or
  result = node.asExternal()
}

/** Gets the node for the given type string, which may be a module, instance type, or metatype. */
Node getNodeFromTypeString(string type) { getNodeTypeString(result) = type }

/** Gets the node representing instances of the type denoted by `te`. */
private Node getInstanceNodeFromTypeExpr(Expr te) {
  isTypeExprInInterface(te) and
  (
    result = MkFunctionType(te)
    or
    not te instanceof FunctionExpr and
    result = getNodeFromTypeString(getTypeStringFromTypeExpr(te))
  )
}

/** Gets a namespace that holds the members of the type represented by `node`, including extensions. */
private ClassLikeDeclaration getAMemberContainer(Node node, boolean isStatic) {
  exists(ClassLikeDeclaration cls |
    node.asNamespace().isInstanceMemberNamespace(cls) and isStatic = false
    or
    node.asNamespace().isStaticMemberNamespace(cls) and isStatic = true
  |
    result = cls
    or
    result.getExtensionTarget() = any(Expr te | getReferencedClass(te) = cls)
  )
  or
  exists(string type |
    isStatic = false and
    type = node.asExternal()
    or
    isStatic = true and
    type + ".Type" = node.asExternal()
  |
    getTypeStringFromTypeExpr(result.getExtensionTarget()) = type and
    not exists(getReferencedClass(result.getExtensionTarget()))
  )
}

/** Holds if `member` is a member of the type represented by `node`. */
private predicate hasMember(Node node, Member member, string name) {
  exists(ClassLikeDeclaration container, boolean isStatic |
    container = getAMemberContainer(node, isStatic) and
    member = container.getAMember() and
    not isHidden(member) and
    name = getMemberName(member) and
    (if isStaticDecl(member) then isStatic = true else isStatic = false)
  )
  or
  // Top-level members of a module
  exists(NameBindingPluginSwift::SwiftInterfaceModule mod |
    node.asNamespace().isModuleScopeNode(mod) and
    member = mod.getBody().getAStmt() and
    not isHidden(member) and
    name = getMemberName(member)
  )
}

/** Gets the external name of a parameter of `c`, which must be passed explicitly in every call. */
private string getARequiredLabel(Callable c) {
  exists(Parameter p |
    p = c.getAParameter() and
    result = p.getExternalName() and
    not exists(p.getDefault())
  )
}

/** Gets the external name of a parameter of `c`. */
private string getALabel(Callable c) { result = c.getAParameter().getExternalName() }

/** Holds if `c1` and `c2` have the same set of argument labels. */
private predicate sameLabels(Callable c1, Callable c2) {
  forall(string l | l = getALabel(c1) | l = getALabel(c2)) and
  forall(string l | l = getALabel(c2) | l = getALabel(c1))
}

/** Holds if `c` and `other` are overloads in the type represented by `node`. */
private predicate overloads(Node node, Callable c, Callable other) {
  exists(string name |
    hasMember(node, c, name) and
    hasMember(node, other, name) and
    not sameLabels(c, other)
  )
}

/**
 * Gets a token that distinguishes calls to `c` from calls to `other`.
 *
 * We prefer a `WithNamedArgument` token for a required label of `c` that `other` does not have,
 * and otherwise a `WithoutNamedArgument` token for a required label of `other` that `c` does not have.
 */
private string getDistinguishingToken(Node node, Callable c, Callable other) {
  overloads(node, c, other) and
  exists(getALabel(c)) and
  (
    result =
      "WithNamedArgument[" +
        min(string l | l = getARequiredLabel(c) and not l = getALabel(other) | l) + "]"
    or
    not exists(string l | l = getARequiredLabel(c) and not l = getALabel(other)) and
    result =
      "WithoutNamedArgument[" +
        min(string l | l = getARequiredLabel(other) and not l = getALabel(c) | l) + "]"
  )
}

/**
 * Gets the access path for the member `c` in `node`, including filters needed to distinguish
 * it from its overloads.
 *
 * Callables that take no named arguments are not filtered.
 */
private string getMemberPath(Node node, Member member, string name) {
  hasMember(node, member, name) and
  result =
    "Member[" + name + "]" +
      concat(string token |
        token = getDistinguishingToken(node, member, _)
      |
        "." + token order by token
      )
}

/** Gets the instance node for the type of the variable or function `member`. */
private Node getTypeOfMember(Member member) {
  result = getInstanceNodeFromTypeExpr(member.(VariableDeclaration).getType())
  or
  result = getInstanceNodeFromTypeExpr(member.(AccessorDeclaration).getReturnType())
  or
  exists(ClassLikeDeclaration cls |
    member = cls and
    result.asNamespace().isStaticMemberNamespace(cls)
  )
  or
  result = MkCallable(member)
}

/** Holds if `c` returns `Self`. */
private predicate returnsSelf(Callable c) {
  exists(Expr te | te = c.getReturnType() |
    te.(Identifier).getValue() = "Self"
    or
    getUnwrappedTypeExpr(te).(Identifier).getValue() = "Self"
  )
}

/** Holds if there is an edge `pred -> succ` labeled with `path`. */
predicate graphEdge(Node pred, string path, Node succ) {
  exists(Member member, string name |
    path = getMemberPath(pred, member, name) and
    succ = getTypeOfMember(member)
  )
  or
  exists(Callable c | pred = MkCallable(c) |
    path = "ReturnValue" and
    not returnsSelf(c) and
    (
      succ = getInstanceNodeFromTypeExpr(c.getReturnType())
      or
      exists(ClassLikeDeclaration cls |
        c = cls.getAMember() and
        c instanceof ConstructorDeclaration and
        succ.asNamespace().isInstanceMemberNamespace(cls)
      )
      or
      c instanceof ConstructorDeclaration and
      exists(ClassLikeDeclaration ext, string type |
        c = ext.getAMember() and
        type = getTypeStringFromTypeExpr(ext.getExtensionTarget()) and
        succ = getNodeFromTypeString(type)
      )
    )
    or
    exists(Parameter p |
      p = c.getAParameter() and
      succ = MkFunctionType(getFunctionTypeExpr(p.getType()))
    |
      path = "Argument[" + p.getExternalName() + ":]"
      or
      not exists(p.getExternalName()) and
      path = "Argument[" + p.getPositionalIndex() + "]"
    )
  )
  or
  exists(FunctionExpr te, int i |
    pred = MkFunctionType(te) and
    path = "Parameter[" + i + "]" and
    succ = getInstanceNodeFromTypeExpr(te.getParameter(i).getType())
  )
  or
  // Subtyping
  exists(ClassLikeDeclaration container, Expr base |
    container = getAMemberContainer(pred, false) and
    base = container.getABaseType().getType() and
    path = "" and
    succ = getInstanceNodeFromTypeExpr(base) and
    succ != pred
  )
  or
  // Re-exported modules
  exists(ImportDeclaration imprt, NameBindingPluginSwift::SwiftInterfaceModule mod |
    imprt.hasModifier("@_exported") and
    imprt = mod.getBody().getAStmt() and
    pred.asNamespace().isModuleScopeNode(mod) and
    path = "" and
    succ = getNodeFromTypeString(imprt.getImportedExpr().(Identifier).getValue()) and
    succ != pred
  )
}

/** Gets the function type wrapped by `te`, possibly inside optionals and modifiers. */
private FunctionExpr getFunctionTypeExpr(Expr te) {
  result = te
  or
  result = getFunctionTypeExpr(getUnwrappedTypeExpr(te))
}

/** The configuration for exporting the type graph. */
module TypeGraphConfig implements GraphExportSig<Location, Node> {
  bindingset[pred]
  predicate edge(Node pred, string path, Node succ) { graphEdge(pred, path, succ) }

  predicate exposedName(Node node, string type, string path) {
    path = "" and
    (
      node.asNamespace().isModuleScopeNode(_) and
      type = getNodeTypeString(node)
      or
      type = node.asExternal()
    )
  }

  predicate suggestedName(Node node, string name) {
    node.asNamespace().isInstanceOrStaticMemberNamespace(_) and
    name = getNodeTypeString(node)
  }

  predicate mustBeNamed(Node node) { exists(getNodeTypeString(node)) }

  predicate shouldContain(Node node) { isRelevantType(getNodeTypeString(node)) }

  bindingset[host]
  predicate hasTypeSummary(Node host, string path) {
    exists(Member member, string name |
      returnsSelf(member) and
      path = getMemberPath(host, member, name) + ".ReturnValue"
    )
  }

  predicate shouldNotContain(Node node) { isHidden(node.asCallable()) }
}

private module Exported = GraphExport<Location, Node, TypeGraphConfig>;

/**
 * Holds if `(type1, type2, path)` is implied by conventions of the interpreter, and need
 * not be emitted.
 */
bindingset[type1, type2, path]
private predicate isImpliedTypeModel(string type1, string type2, string path) {
  // Metatypes of nested types: `A.B.Type` is implied by `(A.Type, Member[B])` or `(A, Member[B])` for modules
  exists(string parent, string name |
    DynamicMaD::parseMetatypeString(type1, parent, name) and
    type2 = parent and
    path = "Member[" + name + "]"
  )
  or
  // Instances obtained by calling an initializer
  type2 = type1 + ".Type" and
  path.regexpMatch("Member\\[init\\](\\.With(out)?NamedArgument\\[[^\\]]*\\])*\\.ReturnValue")
}

/**
 * Holds if rows describing how to obtain values of `type` should be emitted.
 *
 * To keep the output small, we only emit rows leading directly to a relevant type, its metatype,
 * or a module containing a relevant type. Intermediate types are not named, as they can usually be
 * recognized from type annotations in the code being analyzed.
 */
private predicate isRelevantOutputType(string type) {
  isRelevantType(type)
  or
  type = any(string t | isRelevantType(t)) + ".Type"
  or
  type = any(string t | isRelevantType(t)).regexpCapture("([^.]+)\\..*", 1)
}

/** Holds if `sub` is a direct subtype of `sup` in the exported graph. */
private predicate directSubtype(string sub, string sup) { Exported::typeModel(sup, sub, "") }

/** Holds if `(type1, type2, path)` should be emitted as a type model. */
predicate typeModel(string type1, string type2, string path) {
  Exported::typeModel(type1, type2, path) and
  isRelevantOutputType(type1) and
  not isImpliedTypeModel(type1, type2, path)
  or
  // Subtyping relations are flattened, since intermediate types may not be emitted
  isRelevantOutputType(type1) and
  directSubtype+(type2, type1) and
  not directSubtype(type2, type1) and
  type1 != type2 and
  path = ""
}

/** Holds if `(type, path, input, output, kind)` should be emitted as a summary model. */
predicate summaryModel(string type, string path, string input, string output, string kind) {
  Exported::summaryModel(type, path, input, output, kind) and
  isRelevantOutputType(type)
}
