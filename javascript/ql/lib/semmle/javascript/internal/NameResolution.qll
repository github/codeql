/**
 * Provides name resolution and propagates type information.
 */

private import javascript

/**
 * Provides name resolution and propagates type information.
 */
module NameResolution {
  private class NodeBase =
    @expr or @typeexpr or @lexical_name or @toplevel or @function_decl_stmt or @class_decl_stmt or
        @namespace_declaration or @enum_declaration or @interface_declaration or
        @type_alias_declaration or @jsdoc_type_expr;

  /**
   * A node in a graph which we use to perform name and type resolution.
   */
  class Node extends NodeBase {
    /** Gets a string representation of this node. */
    string toString() {
      result = this.(AstNode).toString()
      or
      result = this.(LexicalName).toString()
      or
      result = this.(JSDocTypeExpr).toString()
    }

    /** Gets the location of this node. */
    Location getLocation() {
      result = this.(AstNode).getLocation()
      or
      result = this.(LocalVariableLike).getLocation()
      or
      result = this.(JSDocTypeExpr).getLocation()
    }
  }

  private signature predicate nodeSig(Node node);

  /**
   * A module top-level, or a `module {}` or `enum {}` statement.
   */
  private class ModuleLike extends AstNode {
    ModuleLike() {
      this instanceof Module
      or
      this instanceof NamespaceDefinition // `module {}` or `enum {}` statement
      or
      // A module wrapped in a promise. We model this as a module exporting the actual module in a property called `$$promise-content`.
      this instanceof DynamicImportExpr
    }
  }

  /**
   * A local variable, or a top-level variable that acts as a global variable due to an ambient declaration.
   */
  class LocalVariableLike extends Variable {
    LocalVariableLike() { this.isLocal() or this.isTopLevelWithAmbientDeclaration() }

    Location getLocation() {
      result =
        min(Location loc |
          loc = this.getADeclaration().getLocation()
        |
          loc order by loc.getStartLine(), loc.getStartColumn()
        )
    }
  }

  /**
   * Holds if values/namespaces/types in `node1` can flow to values/namespaces/types in `node2`.
   *
   * May also include some type-specific steps in cases where this is harmless when tracking values.
   */
  private predicate commonStep(Node node1, Node node2) {
    // Import paths are part of the graph and has an incoming edge from the imported module, if found.
    // This ensures we can also use the PathExpr as a source when working with external (unresolved) modules.
    exists(Import imprt |
      node1 = imprt.getImportedModule() and
      node2 = imprt.getImportedPathExpr()
    )
    or
    exists(ImportNamespaceSpecifier spec |
      node1 = spec.getImportDeclaration().getImportedPathExpr() and
      node2 = spec.getLocal()
    )
    or
    exists(ExportNamespaceSpecifier spec |
      node1 = spec.getExportDeclaration().(ReExportDeclaration).getImportedPath() and
      node2 = spec
    )
    or
    exists(ExportAssignDeclaration assign |
      node1 = assign.getExpression() and
      node2 = assign.getContainer()
    )
    or
    exists(ImportEqualsDeclaration imprt |
      node1 = imprt.getImportedEntity() and
      node2 = imprt.getIdentifier()
    )
    or
    exists(ExternalModuleReference ref |
      node1 = ref.getImportedPathExpr() and
      node2 = ref
    )
    or
    exists(ImportTypeExpr imprt |
      node1 = imprt.getPathExpr() and // TODO: ImportTypeExpr does not seem to be resolved to a Module
      node2 = imprt
    )
    or
    exists(ClassOrInterface cls |
      node1 = cls and
      node2 = cls.getIdentifier()
    )
    or
    exists(NamespaceDefinition def |
      node1 = def and
      node2 = def.getIdentifier()
    )
    or
    exists(Function fun |
      node1 = fun and
      node2 = fun.getIdentifier()
    )
    or
    exists(EnumMember def |
      node1 = def.getInitializer() and
      node2 = def.getIdentifier()
    )
    or
    exists(TypeAliasDeclaration alias |
      node1 = alias.getDefinition() and
      node2 = alias.getIdentifier()
    )
    or
    exists(VariableDeclarator decl |
      node1 = decl.getInit() and
      node2 = decl.getBindingPattern()
    )
    or
    exists(ParenthesizedTypeExpr type |
      node1 = type.getElementType() and
      node2 = type
    )
    or
    exists(ParenthesisExpr expr |
      node1 = expr.getExpression() and
      node2 = expr
    )
    or
    exists(NonNullAssertion assertion |
      // For the time being we don't use this for nullness analysis, so just
      // propagate through these assertions.
      node1 = assertion.getExpression() and
      node2 = assertion
    )
    or
    exists(FunctionTypeExpr fun |
      node1 = fun.getFunction() and
      node2 = fun
    )
    or
    exists(TypeofTypeExpr type |
      node1 = type.getExpressionName() and
      node2 = type
    )
    or
    exists(Closure::RequireCallExpr req |
      node1.(Closure::ClosureModule).getClosureNamespace() = req.getClosureNamespace() and
      node2 = req
    )
    or
    exists(Closure::ClosureModule mod |
      node1 = mod.getExportsVariable() and
      node2 = mod
    )
    or
    exists(ImmediatelyInvokedFunctionExpr fun, int i |
      node1 = fun.getArgument(i) and
      node2 = fun.getParameter(i)
    )
  }

  /**
   * Holds if there is a read from `node1` to `node2` that accesses the member `name`.
   */
  predicate readStep(Node node1, string name, Node node2) {
    exists(QualifiedTypeAccess access |
      node1 = access.getQualifier() and
      name = access.getIdentifier().getName() and
      node2 = access
    )
    or
    exists(QualifiedNamespaceAccess access |
      node1 = access.getQualifier() and
      name = access.getIdentifier().getName() and
      node2 = access
    )
    or
    exists(QualifiedVarTypeAccess access |
      node1 = access.getQualifier() and
      name = access.getIdentifier().getName() and
      node2 = access
    )
    or
    exists(PropAccess access |
      node1 = access.getBase() and
      name = access.getPropertyName() and
      node2 = access
    )
    or
    exists(ObjectPattern pattern |
      node1 = pattern and
      node2 = pattern.getPropertyPatternByName(name).getValuePattern()
    )
    or
    exists(ImportSpecifier spec |
      node1 = spec.getImportDeclaration().getImportedPathExpr() and
      name = spec.getImportedName() and
      node2 = spec.getLocal()
    )
    or
    exists(SelectiveReExportDeclaration exprt, ExportSpecifier spec |
      spec = exprt.getASpecifier() and
      node1 = exprt.getImportedPath() and
      name = spec.getLocalName() and
      node2 = spec.getLocal()
    )
    or
    exists(JSDocQualifiedTypeAccess expr |
      node1 = expr.getBase() and
      name = expr.getName() and
      node2 = expr
    )
    or
    exists(AwaitExpr await |
      node1 = await.getOperand() and
      name = "$$promise-content" and
      node2 = await
    )
    or
    exists(MethodCallExpr call |
      call.getMethodName() = "then" and
      node1 = call.getReceiver() and
      name = "$$promise-content" and
      node2 = call.getArgument(0).(Function).getParameter(0)
    )
  }

  private signature module TypeResolutionInputSig {
    /**
     * Holds if flow is permitted through the given variable.
     */
    predicate isRelevantVariable(LexicalName var);
  }

  /**
   * A local variable with exactly one definition, not counting implicit initialization.
   */
  private class EffectivelyConstantVariable extends LocalVariableLike {
    EffectivelyConstantVariable() {
      count(SsaExplicitDefinition ssa | ssa.getSourceVariable() = this) <= 1 // count may be zero if ambient
    }
  }

  /** Configuration for propagating values and namespaces */
  private module ValueConfig implements TypeResolutionInputSig {
    predicate isRelevantVariable(LexicalName var) {
      var instanceof EffectivelyConstantVariable
      or
      // We merge the namespace and value declaration spaces as it seems there is
      // no need to distinguish them in practice.
      var instanceof LocalNamespaceName
    }
  }

  /**
   * Associates information about values, such as references to a class, module, or namespace.
   */
  module ValueFlow = FlowImpl<ValueConfig>;

  private module TypeConfig implements TypeResolutionInputSig {
    predicate isRelevantVariable(LexicalName var) { var instanceof LocalTypeName }
  }

  /**
   * Associates nodes with information about types.
   */
  module TypeFlow = FlowImpl<TypeConfig>;

  /**
   * Generates a directed graph for tracking type names or value names back toward their definition.
   * The ultimate definition might not be in the database, but the graph lets us track as far as we can.
   *
   * The module parameter determines whether types or values should be tracked.
   *
   * The example below illustrates the need for two separate instantiations of this module.
   * When tracking through the nodes corresponding to `X`, we need to remember whether a type or value was tracked.
   *
   * ```ts
   * // lib.ts
   * class C1 {}
   * class C2 {}
   *
   * const X = C1;
   * type X = C2;
   *
   * export { X }
   *
   * // use.ts
   * import { X } from "./lib"
   *
   * var x1 = X // should refer to C1
   * var x2: X; // should refer to C2
   * ```
   */
  private module FlowImpl<TypeResolutionInputSig S> {
    /**
     * Gets the exported member of `mod` named `name`.
     */
    Node getModuleExport(ModuleLike mod, string name) {
      exists(ExportDeclaration exprt |
        mod = exprt.getContainer() and
        exprt.exportsAs(result, name) and
        S::isRelevantVariable(result)
      )
      or
      exists(ExportNamespaceSpecifier spec |
        result = spec and
        mod = spec.getContainer() and
        name = spec.getExportedName()
      )
      or
      exists(SelectiveReExportDeclaration exprt, ExportSpecifier spec |
        // `export { A as B } from 'blah'`
        // This is not covered by `exportsAs` above because neither A or B is a LexicalName
        // (both are property names) so it doesn't fit the interface of `exportsAs`.
        spec = exprt.getASpecifier() and
        mod = exprt.getContainer() and
        name = spec.getExportedName() and
        result = spec.getLocal()
      )
      or
      exists(EnumDeclaration enum |
        mod = enum and
        result = enum.getMemberByName(name).getIdentifier()
      )
      or
      storeToVariable(result, name, mod.(Closure::ClosureModule).getExportsVariable())
      or
      exists(DynamicImportExpr imprt |
        mod = imprt and
        name = "$$promise-content" and
        result = imprt.getImportedPathExpr()
      )
    }

    /**
     * Holds if `value` is stored in `target.prop`. Only needs to recognise assignments
     * that are also recognised by JSDoc tooling such as the Closure compiler.
     */
    private predicate storeToVariable(Expr value, string prop, LocalVariableLike target) {
      exists(AssignExpr assign |
        // target.name = value
        assign.getLhs().(PropAccess).accesses(target.getAnAccess(), prop) and
        value = assign.getRhs()
      )
      or
      // target = { name: value }
      value = target.getAnAssignedExpr().(ObjectExpr).getPropertyByName(prop).getInit()
    }

    /** Steps that only apply for this configuration. */
    private predicate specificStep(Node node1, Node node2) {
      exists(LexicalName var | S::isRelevantVariable(var) |
        node1.(LexicalDecl).getALexicalName() = var and
        node2 = var
        or
        node1 = var and
        node2.(LexicalAccess).getALexicalName() = var
        or
        node1 = var and
        node2.(JSDocLocalTypeAccess).getALexicalName() = var
      )
      or
      exists(Node base, string name, ModuleLike mod |
        readStep(base, name, node2) and
        base = trackModule(mod) and
        node1 = getModuleExport(mod, name)
      )
    }

    /**
     * Holds if data should propagate from `node1` to `node2`.
     */
    pragma[inline]
    predicate step(Node node1, Node node2) {
      commonStep(node1, node2)
      or
      specificStep(node1, node2)
    }

    /** Helps track flow from a particular set of source nodes. */
    module Track<nodeSig/1 isSource> {
      /** Gets the set of nodes reachable from `source`. */
      Node track(Node source) {
        isSource(source) and
        result = source
        or
        step(track(source), result)
      }
    }

    signature class AstNodeSig extends AstNode;

    /** Helps track flow from a particular set of source nodes. */
    module TrackNode<AstNodeSig Source> {
      /** Gets the set of nodes reachable from `source`. */
      Node track(Source source) {
        result = source
        or
        step(track(source), result)
      }
    }
  }

  /**
   * Gets a node to which the given module flows.
   */
  predicate trackModule = ValueFlow::TrackNode<ModuleLike>::track/1;

  predicate trackClassValue = ValueFlow::TrackNode<ClassDefinition>::track/1;

  predicate trackFunctionValue = ValueFlow::TrackNode<Function>::track/1;

  /**
   * Holds if `moduleName` appears to start with a package name, as opposed to a relative file import.
   */
  bindingset[moduleName]
  private predicate isExternalModuleName(string moduleName) {
    not moduleName.regexpMatch("^(\\.|/).*")
  }

  bindingset[name]
  private string normalizeModuleName(string name) {
    result =
      name.regexpReplaceAll("^node:", "")
          .regexpReplaceAll("\\.[cm]?[jt]sx?$", "")
          .regexpReplaceAll("/(index)?$", "")
  }

  /** Appends a name onto a qualified name */
  bindingset[a, b]
  string append(string a, string b) {
    if b = "default"
    then result = a
    else (
      (if a = "" or b = "" then result = a + b else result = a + "." + b) and
      result.length() < 100
    )
  }

  private predicate needsQualifiedName(Node node) {
    node = any(JSDocLocalTypeAccess t).getALexicalName().(Variable)
    or
    exists(Node prev | needsQualifiedName(prev) |
      ValueFlow::step(node, prev)
      or
      readStep(node, _, prev)
    )
  }

  /**
   * Holds if `node` is a reference to the given module, or a qualified name rooted in that module.
   *
   * If `qualifiedName` is empty, `node` refers to the module itself.
   *
   * If `mod` is the string `"global"`, `node` refers to a global access path.
   *
   * Unlike `trackModule`, this is intended to track uses of external packages.
   */
  predicate nodeRefersToModule(Node node, string mod, string qualifiedName) {
    exists(Expr path |
      path = any(Import imprt).getImportedPathExpr() or
      path = any(ReExportDeclaration e).getImportedPath()
    |
      node = path and
      mod = normalizeModuleName(path.getStringValue()) and
      isExternalModuleName(mod) and
      qualifiedName = ""
    )
    or
    mod = "global" and
    exists(LocalNamespaceAccess access |
      node = access and
      not exists(access.getLocalNamespaceName()) and
      access.getName() = qualifiedName
    )
    or
    mod = "global" and
    exists(JSDocLocalTypeAccess access |
      node = access and
      not exists(access.getALexicalName()) and
      access.getName() = qualifiedName
    )
    or
    mod = "global" and
    exists(GlobalVarAccess access |
      node = access and
      needsQualifiedName(access) and // restrict number of qualified names we generate
      access.getName() = qualifiedName
    )
    or
    mod = "global" and
    qualifiedName = node.(Closure::RequireCallExpr).getClosureNamespace()
    or
    // Additionally track through bulk re-exports (`export * from 'mod`).
    // These are normally handled by 'exportAs' which supports various shadowing rules,
    // but has no effect when the ultimate re-exported module is not resolved to a Module.
    // We propagate external module refs through bulk re-exports and ignore shadowing rules.
    exists(BulkReExportDeclaration reExport |
      nodeRefersToModule(reExport.getImportedPath(), mod, qualifiedName) and
      node = reExport.getContainer()
    )
    or
    exists(Node mid |
      nodeRefersToModule(mid, mod, qualifiedName) and
      ValueFlow::step(mid, node)
    )
    or
    exists(Node mid, string prefix, string step |
      nodeRefersToModule(mid, mod, prefix) and
      readStep(mid, step, node) and
      qualifiedName = append(prefix, step)
    )
  }

  pragma[nomagic]
  predicate classHasGlobalName(DataFlow::ClassNode cls, string name) {
    cls.flowsTo(AccessPath::getAnAssignmentTo(name)) and
    not cls.getTopLevel().isExterns() // don't propagate externs classes
  }

  /**
   * Holds if `node` refers to the given class.
   */
  pragma[nomagic]
  predicate nodeRefersToClass(Node node, DataFlow::ClassNode cls) {
    exists(string name |
      classHasGlobalName(cls, name) and
      nodeRefersToModule(node, "global", name)
    )
    or
    trackClassValue(cls.getAstNode()) = node
    or
    trackFunctionValue(cls.getAstNode()) = node
  }
}
