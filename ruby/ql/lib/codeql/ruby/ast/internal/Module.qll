private import codeql.ruby.AST
private import Scope as Scope

// Names of built-in modules and classes
private string builtin() {
  result =
    [
      "Object", "Kernel", "BasicObject", "Class", "Module", "NilClass", "FalseClass", "TrueClass",
      "Numeric", "Integer", "Float", "Rational", "Complex", "Array", "Hash", "String", "Symbol",
      "Proc",
    ]
}

cached
private module Cached {
  cached
  newtype TModule =
    TResolved(string qName) {
      qName = builtin()
      or
      qName = getAnAssumedGlobalConst()
      or
      qName = namespaceDeclaration(_)
      or
      qName = getAnAssumedGlobalNamespacePrefix(_)
    } or
    TUnresolved(Namespace n) { not exists(namespaceDeclaration(n)) }

  cached
  string namespaceDeclaration(Namespace n) {
    isToplevel(n) and result = n.getName()
    or
    not isToplevel(n) and
    not exists(n.getScopeExpr()) and
    result = scopeAppend(namespaceDeclaration(n.getEnclosingModule()), n.getName())
    or
    exists(string container |
      TResolved(container) = resolveConstantReadAccess(n.getScopeExpr()) and
      result = scopeAppend(container, n.getName())
    )
    or
    result = getAnAssumedGlobalNamespacePrefix(n)
  }

  cached
  predicate isBuiltinModule(Module m) { m = TResolved(builtin()) }

  cached
  Module getSuperClass(Module cls) {
    cls = TResolved("Object") and result = TResolved("BasicObject")
    or
    cls =
      TResolved([
          "Module", "Numeric", "Array", "Hash", "FalseClass", "TrueClass", "NilClass", "String"
        ]) and
    result = TResolved("Object")
    or
    cls = TResolved(["Integer", "Float", "Rational", "Complex"]) and
    result = TResolved("Numeric")
    or
    cls = TResolved("Class") and
    result = TResolved("Module")
    or
    not cls = TResolved(builtin()) and
    (
      exists(ClassDeclaration d |
        d = cls.getADeclaration() and
        result = resolveConstantReadAccess(d.getSuperclassExpr())
      )
      or
      result = TResolved("Object") and
      forex(ClassDeclaration d | d = cls.getADeclaration() |
        not exists(resolveConstantReadAccess(d.getSuperclassExpr()))
      )
      or
      // If a module is used as a base class of another class, but we don't see its class declaration
      // treat it as a class extending Object, so its subclasses transitively extend Object.
      result = TResolved("Object") and
      not cls.getADeclaration() instanceof ClassDeclaration and
      cls = resolveConstantReadAccess(any(ClassDeclaration d).getSuperclassExpr())
    )
  }

  private Module getACludedModule(IncludeOrPrependCall c, Module m) {
    (
      m = resolveConstantReadAccess(c.getReceiver())
      or
      m = enclosingModuleNoBlock(c).getModule() and
      c.getReceiver() instanceof SelfVariableAccess
    ) and
    result = resolveConstantReadAccess(c.getAnArgument())
  }

  cached
  Module getAnIncludedModule(Module m) {
    m = TResolved("Object") and result = TResolved("Kernel")
    or
    exists(IncludeOrPrependCall c |
      c.getMethodName() = "include" and
      result = getACludedModule(c, m)
    )
  }

  cached
  Module getAPrependedModule(Module m) {
    exists(IncludeOrPrependCall c |
      c.getMethodName() = "prepend" and
      result = getACludedModule(c, m)
    )
  }

  /**
   * Resolve class or module read access to a qualified module name.
   */
  cached
  TResolved resolveConstantReadAccess(ConstantReadAccess r) {
    exists(string qname | qname = resolveConstant(r) and result = TResolved(qname))
  }

  pragma[nomagic]
  private string constantWriteAccess1(ConstantReadAccess r) {
    exists(ConstantWriteAccess w | result = resolveConstantWriteAccess(w) |
      r = w.getScopeExpr()
      or
      r = w.(ClassDeclaration).getSuperclassExpr()
    )
  }

  /**
   * Resolve constant access (class, module or otherwise) to a qualified module name.
   * `resolveConstantReadAccess/1` picks the best (lowest priority number) result of
   * `resolveConstantReadAccess/2` that resolves to a constant definition. If the constant
   * definition is a Namespace then it is returned, if it's a constant assignment then
   * the right-hand side of the assignment is resolved.
   */
  cached
  string resolveConstant(ConstantReadAccess r) {
    exists(string qname |
      qname =
        min(string qn, int p |
          qn = isDefinedConstant(_, _) and
          qn = resolveConstantReadAccess(r, p) and
          // prevent classes/modules that contain/extend themselves
          not qn = constantWriteAccess1(r)
        |
          qn order by p
        )
    |
      result = qname
      or
      exists(ConstantAssignment a |
        qname = resolveConstantWriteAccess(a) and
        result = resolveConstant(a.getParent().(Assignment).getRightOperand())
      )
    )
  }

  cached
  string resolveConstantWrite(ConstantWriteAccess c) { result = resolveConstantWriteAccess(c) }

  /**
   * Gets a method named `name` that is available in module `m`. This includes methods
   * that are included/prepended into `m` and methods available on base classes of `m`.
   */
  cached
  Method lookupMethod(Module m, string name) { TMethod(result) = lookupMethodOrConst(m, name) }

  /**
   * Gets a method named `name` that is available in a sub class of module `m`. This
   * includes methods that are included/prepended into any of the sub classes of `m`,
   * but not methods inherited from base classes.
   */
  cached
  Method lookupMethodInSubClasses(Module m, string name) {
    exists(Module sub | sub.getAnImmediateAncestor() = m |
      TMethod(result) = lookupMethodOrConst0(sub, name) or
      result = lookupMethodInSubClasses(sub, name)
    )
  }

  cached
  Expr lookupConst(Module m, string name) {
    TExpr(result) = lookupMethodOrConst(m, name)
    or
    exists(AssignExpr ae, ConstantWriteAccess w |
      w = ae.getLeftOperand() and
      w.getName() = name and
      m = resolveConstantReadAccess(w.getScopeExpr()) and
      result = ae.getRightOperand()
    )
  }
}

import Cached

private predicate isToplevel(ConstantAccess n) {
  not exists(n.getScopeExpr()) and
  (
    n.hasGlobalScope()
    or
    n.getEnclosingModule() instanceof Toplevel
  )
}

bindingset[qualifier, name]
private string scopeAppend(string qualifier, string name) {
  if qualifier = "Object" then result = name else result = qualifier + "::" + name
}

/**
 * Provides predicates for resolving constant reads and writes to qualified names.
 *
 * Predicates suffixed with `NonRec` means that they do not depend recursively on
 * `resolveConstantReadAccess`, while predicates suffixed with `Rec` do. This serves
 * both as a performance optimization (minimize non-linear recursion), and as a way
 * to prevent infinite recursion.
 */
private module ResolveImpl {
  private ModuleBase enclosing(ModuleBase m, int level) {
    result = m and level = 0
    or
    result = enclosing(m.getEnclosingModule(), level - 1)
  }

  private int maxDepth() { result = 1 + max(int level | exists(enclosing(_, level))) }

  pragma[noinline]
  private Namespace constantReadAccessEnclosingNameSpace(
    ConstantReadAccess c, int priority, string name
  ) {
    not exists(c.getScopeExpr()) and
    not c.hasGlobalScope() and
    result = enclosing(c.getEnclosingModule(), priority) and
    name = c.getName()
  }

  pragma[nomagic]
  private string enclosingQualifiedModuleNameNonRec(ConstantReadAccess c, string name) {
    result = qualifiedModuleNameNonRec(c.getEnclosingModule(), _, _) and
    name = c.getName() and
    not exists(c.getScopeExpr()) and
    not c.hasGlobalScope()
  }

  pragma[nomagic]
  private string enclosingQualifiedModuleNameRec(ConstantReadAccess c, string name) {
    result = qualifiedModuleNameRec(c.getEnclosingModule(), _, _) and
    name = c.getName() and
    not exists(c.getScopeExpr()) and
    not c.hasGlobalScope()
  }

  pragma[nomagic]
  private string resolveConstantReadAccessScopeNonRec(
    ConstantReadAccess c, int priority, string name
  ) {
    result = resolveConstantReadAccessNonRec(c.getScopeExpr(), priority) and
    name = c.getName()
  }

  pragma[nomagic]
  private string resolveConstantReadAccessScopeRec(ConstantReadAccess c, int priority, string name) {
    result = resolveConstantReadAccessRec(c.getScopeExpr(), priority) and
    name = c.getName()
  }

  pragma[nomagic]
  private string resolveConstantReadAccessNonRec(ConstantReadAccess c, int priority) {
    // ::B
    c.hasGlobalScope() and result = c.getName() and priority = 0
    or
    // A::B
    exists(string name, string s | result = isDefinedConstantNonRec(s, name) |
      s = resolveConstantReadAccessScopeNonRec(c, priority, name)
    )
    or
    // module A
    //   B
    // end
    exists(string name |
      exists(Namespace n, string qname |
        n = constantReadAccessEnclosingNameSpace(c, priority, name) and
        qname = resolveConstantWriteAccessNonRec(n, _, _) and
        result = isDefinedConstantNonRec(qname, name)
      )
    )
    or
    priority = maxDepth() + 4 and
    enclosingQualifiedModuleNameNonRec(c, result) != "BasicObject"
  }

  pragma[nomagic]
  private string resolveConstantReadAccessRec(ConstantReadAccess c, int priority) {
    exists(string name, string s |
      result = isDefinedConstantRec(s, name) and
      s = resolveConstantReadAccessScopeNonRec(c, priority, name)
      or
      result = isDefinedConstant(s, name) and
      s = resolveConstantReadAccessScopeRec(c, priority, name)
    )
    or
    exists(string name |
      exists(Namespace n, string qname |
        n = constantReadAccessEnclosingNameSpace(c, priority, name)
      |
        qname = resolveConstantWriteAccess(n) and
        result = isDefinedConstantRec(qname, name)
        or
        qname = resolveConstantWriteAccessRec(n, _, _) and
        result = isDefinedConstantNonRec(qname, name)
      )
      or
      exists(string encl | result = qualifiedModuleNameAncestors(encl, name, priority) |
        encl = enclosingQualifiedModuleNameNonRec(c, name)
        or
        encl = enclosingQualifiedModuleNameRec(c, name)
      )
    )
    or
    priority = maxDepth() + 4 and
    enclosingQualifiedModuleNameRec(c, result) != "BasicObject"
  }

  /**
   * Resolve constant read access (typically a scope expression) to a qualified name. The
   * `priority` value indicates the precedence of the solution with respect to the lookup order.
   * A constant name without scope specifier is resolved against its enclosing modules (inner-most first);
   * if the constant is not found in any of the enclosing modules, then the constant will be resolved
   * with respect to the ancestors (prepends, includes, super classes, and their ancestors) of the
   * directly enclosing module.
   */
  string resolveConstantReadAccess(ConstantReadAccess c, int priority) {
    result = resolveConstantReadAccessNonRec(c, priority)
    or
    result = resolveConstantReadAccessRec(c, priority)
  }

  pragma[nomagic]
  private string qualifiedModuleNameNonRec(ModuleBase m, string container, string name) {
    result = "Object" and
    m instanceof Toplevel and
    container = "" and
    name = result
    or
    result = resolveConstantWriteAccessNonRec(m, container, name)
  }

  pragma[nomagic]
  private string qualifiedModuleNameRec(ModuleBase m, string container, string name) {
    result = resolveConstantWriteAccessRec(m, container, name)
  }

  pragma[nomagic]
  private string qualifiedModuleNameResolveConstantWriteAccessNonRec(
    ConstantWriteAccess c, string name
  ) {
    result = qualifiedModuleNameNonRec(c.getEnclosingModule(), _, _) and
    name = c.getName()
  }

  pragma[nomagic]
  private string qualifiedModuleNameResolveConstantWriteAccessRec(ConstantWriteAccess c, string name) {
    result = qualifiedModuleNameRec(c.getEnclosingModule(), _, _) and
    name = c.getName()
  }

  pragma[nomagic]
  private string resolveConstantWriteAccessNonRec(
    ConstantWriteAccess c, string container, string name
  ) {
    c.hasGlobalScope() and
    result = c.getName() and
    container = "" and
    name = result
    or
    result = scopeAppend(container, name) and
    (
      container = resolveConstantReadAccessNonRec(c.getScopeExpr(), _) and name = c.getName()
      or
      not exists(c.getScopeExpr()) and
      not c.hasGlobalScope() and
      container = qualifiedModuleNameResolveConstantWriteAccessNonRec(c, name)
    )
  }

  pragma[nomagic]
  private string resolveConstantWriteAccessRec(ConstantWriteAccess c, string container, string name) {
    result = scopeAppend(container, name) and
    (
      container = resolveConstantReadAccessRec(c.getScopeExpr(), _) and name = c.getName()
      or
      not exists(c.getScopeExpr()) and
      not c.hasGlobalScope() and
      container = qualifiedModuleNameResolveConstantWriteAccessRec(c, name)
    )
  }

  /**
   * Get a qualified name for a constant definition. May return multiple qualified
   * names because we over-approximate when resolving scope resolutions and ignore
   * lookup order precedence. Taking lookup order into account here would lead to
   * non-monotonic recursion.
   */
  pragma[inline]
  string resolveConstantWriteAccess(ConstantWriteAccess c) {
    result = resolveConstantWriteAccessNonRec(c, _, _)
    or
    result = resolveConstantWriteAccessRec(c, _, _)
  }

  /**
   * Gets the name of a constant `C` that we assume to be defined in the top-level because
   * it is referenced in a way that can only resolve to a top-level constant.
   */
  string getAnAssumedGlobalConst() {
    exists(ConstantAccess access |
      result = access.getName() and
      isToplevel(access)
    )
  }

  private ConstantAccess getANamespaceScopeInTopLevel() {
    result.(Namespace).getEnclosingModule() instanceof Toplevel
    or
    result = getANamespaceScopeInTopLevel().getScopeExpr()
  }

  /**
   * Gets the syntactical qualified name of the given constant access, which must be a top-level
   * namespace or scope prefix thereof.
   *
   * For example, for `module A::B::C` this gets `A`, `A::B`, and `A::B::C` for the two prefixes
   * and the module itself, respectively.
   */
  string getAnAssumedGlobalNamespacePrefix(ConstantAccess access) {
    access = getANamespaceScopeInTopLevel() and
    (
      not exists(access.getScopeExpr()) and
      result = access.getName()
      or
      result =
        scopeAppend(getAnAssumedGlobalNamespacePrefix(access.getScopeExpr()), access.getName())
    )
  }

  pragma[nomagic]
  private string isDefinedConstantNonRec(string container, string name) {
    result = resolveConstantWriteAccessNonRec(_, container, name)
    or
    result = [builtin(), getAnAssumedGlobalConst()] and
    name = result and
    container = "Object"
    or
    exists(ConstantAccess access |
      container = getAnAssumedGlobalNamespacePrefix(access.getScopeExpr()) and
      name = access.getName() and
      result = getAnAssumedGlobalNamespacePrefix(access)
    )
  }

  pragma[nomagic]
  private string isDefinedConstantRec(string container, string name) {
    result = resolveConstantWriteAccessRec(_, container, name)
  }

  pragma[inline]
  string isDefinedConstant(string container, string name) {
    result = isDefinedConstantNonRec(container, name)
    or
    result = isDefinedConstantRec(container, name)
  }

  /**
   * The qualified names of the ancestors of a class/module. The ancestors should be an ordered list
   * of the ancestors of `prepend`ed modules, the module itself , the ancestors or `include`d modules
   * and the ancestors of the super class. The priority value only distinguishes the kind of ancestor,
   * it does not order the ancestors within a group of the same kind. This is an over-approximation, however,
   * computing the precise order is tricky because it depends on the evaluation/file loading order.
   */
  // TODO: the order of super classes can be determined more precisely even without knowing the evaluation
  // order, so we should be able to make this more precise.
  private string ancestors(string qname, int priority) {
    result = ancestors(prepends(qname), _) and priority = 0
    or
    result = qname and priority = 1 and qname = isDefinedConstant(_, _)
    or
    result = ancestors(includes(qname), _) and priority = 2
    or
    result = ancestors(superclass(qname), _) and priority = 3
  }

  pragma[nomagic]
  private string qualifiedModuleNameAncestors(string encl, string name, int priority) {
    result = isDefinedConstantNonRec(encl, name) and
    priority = 1
    or
    // avoid infinite recursion
    not exists(isDefinedConstantNonRec(encl, name)) and
    result = isDefinedConstant(ancestors(encl, priority - maxDepth()), name)
  }

  class IncludeOrPrependCall extends MethodCall {
    IncludeOrPrependCall() { this.getMethodName() = ["include", "prepend"] }

    string getAModule() { result = resolveConstantReadAccess(this.getAnArgument(), _) }

    string getTarget() {
      result = resolveConstantReadAccess(this.getReceiver(), _)
      or
      exists(ModuleBase encl |
        encl = enclosingModuleNoBlock(this) and
        result = [qualifiedModuleNameNonRec(encl, _, _), qualifiedModuleNameRec(encl, _, _)]
      |
        this.getReceiver() instanceof SelfVariableAccess
        or
        not exists(this.getReceiver())
      )
    }
  }

  pragma[nomagic]
  private string prepends(string qname) {
    exists(IncludeOrPrependCall m |
      m.getMethodName() = "prepend" and
      qname = m.getTarget() and
      result = m.getAModule()
    )
  }

  pragma[nomagic]
  private string includes(string qname) {
    qname = "Object" and
    result = "Kernel"
    or
    exists(IncludeOrPrependCall m |
      m.getMethodName() = "include" and
      qname = m.getTarget() and
      result = m.getAModule()
    )
  }

  private Expr superexpr(string qname) {
    exists(ClassDeclaration c |
      qname = resolveConstantWriteAccess(c) and result = c.getSuperclassExpr()
    )
  }

  pragma[nomagic]
  private string superclass(string qname) {
    qname = "Object" and result = "BasicObject"
    or
    result = resolveConstantReadAccess(superexpr(qname), _)
  }
}

private import ResolveImpl

/**
 * Gets an enclosing scope of `scope`, stopping at the first module or block.
 *
 * Includes `scope` itself and the final module/block.
 */
private Scope enclosingScopesNoBlock(Scope scope) {
  result = scope
  or
  not scope instanceof ModuleBase and
  not scope instanceof Block and
  result = enclosingScopesNoBlock(scope.getOuterScope())
}

/**
 * A variant of `AstNode::getEnclosingModule` that excludes
 * results that are enclosed in a block. This is a bit wrong because
 * it could lead to false negatives. However, `include` statements in
 * blocks are very rare in normal code. The majority of cases are in calls
 * to methods like `module_eval` and `Rspec.describe` / `Rspec.context`. These
 * methods evaluate the block in the context of some other module/class instead of
 * the enclosing one.
 */
private ModuleBase enclosingModuleNoBlock(Stmt node) {
  // Note: don't rely on AstNode.getParent() here.
  // Instead use Scope.getOuterScope() to correctly handle the scoping of things like Namespace.getScopeExpr().
  result = enclosingScopesNoBlock(Scope::scopeOfInclSynth(node))
}

private Module getAncestors(Module m) {
  result = m or
  result = getAncestors(m.getAnIncludedModule()) or
  result = getAncestors(m.getAPrependedModule())
}

private newtype TMethodOrExpr =
  TMethod(Method m) or
  TExpr(Expr e)

private TMethodOrExpr getMethodOrConst(TModule owner, string name) {
  exists(ModuleBase m | m.getModule() = owner |
    result = TMethod(m.getMethod(name))
    or
    result = TExpr(m.getConstant(name))
  )
}

module ExposedForTestingOnly {
  Method getMethod(TModule owner, string name) { TMethod(result) = getMethodOrConst(owner, name) }

  Expr getConst(TModule owner, string name) { TExpr(result) = getMethodOrConst(owner, name) }
}

private TMethodOrExpr lookupMethodOrConst0(Module m, string name) {
  result = lookupMethodOrConst0(m.getAPrependedModule(), name)
  or
  not exists(getMethodOrConst(getAncestors(m.getAPrependedModule()), pragma[only_bind_into](name))) and
  (
    result = getMethodOrConst(m, pragma[only_bind_into](name))
    or
    not exists(getMethodOrConst(m, name)) and
    result = lookupMethodOrConst0(m.getAnIncludedModule(), name)
  )
}

private AstNode getNode(TMethodOrExpr e) { e = TMethod(result) or e = TExpr(result) }

private TMethodOrExpr lookupMethodOrConst(Module m, string name) {
  result = lookupMethodOrConst0(m, name)
  or
  not exists(lookupMethodOrConst0(m, name)) and
  result = lookupMethodOrConst(m.getSuperClass(), name) and
  // For now, we restrict the scope of top-level declarations to their file.
  // This may remove some plausible targets, but also removes a lot of
  // implausible targets
  if getNode(result).getEnclosingModule() instanceof Toplevel
  then getNode(result).getFile() = m.getADeclaration().getFile()
  else any()
}
