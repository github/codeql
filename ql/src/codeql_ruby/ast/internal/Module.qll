private import codeql.Locations
private import codeql_ruby.AST
private import codeql_ruby.ast.Call
private import codeql_ruby.ast.Constant
private import codeql_ruby.ast.Expr
private import codeql_ruby.ast.Module
private import codeql_ruby.ast.Operation
private import codeql_ruby.ast.Scope

// Names of built-in modules and classes
private string builtin() { result = ["Object", "Kernel", "BasicObject", "Class", "Module"] }

cached
private module Cached {
  cached
  newtype TModule =
    TResolved(string qName) {
      qName = builtin()
      or
      qName = namespaceDeclaration(_)
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
      TResolved(container) = resolveScopeExpr(n.getScopeExpr()) and
      result = scopeAppend(container, n.getName())
    )
  }

  cached
  Module getSuperClass(Module cls) {
    cls = TResolved("Object") and result = TResolved("BasicObject")
    or
    cls = TResolved("Module") and result = TResolved("Object")
    or
    cls = TResolved("Class") and result = TResolved("Module")
    or
    not cls = TResolved(builtin()) and
    (
      exists(ClassDeclaration d |
        d = cls.getADeclaration() and
        result = resolveScopeExpr(d.getSuperclassExpr())
      )
      or
      result = TResolved("Object") and
      forex(ClassDeclaration d | d = cls.getADeclaration() |
        not exists(resolveScopeExpr(d.getSuperclassExpr()))
      )
    )
  }

  cached
  Module getAnIncludedModule(Module m) {
    m = TResolved("Object") and result = TResolved("Kernel")
    or
    exists(IncludeOrPrependCall c |
      c.getMethodName() = "include" and
      (
        m = resolveScopeExpr(c.getReceiver())
        or
        m = enclosingModule(c).getModule() and
        c.receiverIsSelf()
      ) and
      result = resolveScopeExpr(c.getAnArgument())
    )
  }

  cached
  Module getAPrependedModule(Module m) {
    exists(IncludeOrPrependCall c |
      c.getMethodName() = "prepend" and
      (
        m = resolveScopeExpr(c.getReceiver())
        or
        m = enclosingModule(c).getModule() and
        c.receiverIsSelf()
      ) and
      result = resolveScopeExpr(c.getAnArgument())
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

private predicate isDefinedConstant(string qualifiedModuleName) {
  qualifiedModuleName = [builtin(), constantDefinition0(_)]
}

/**
 * Resolve constant read access (typically a scope expression) to a qualified module name.
 * `resolveScopeExpr/1` picks the best (lowest priority number) result of
 * `resolveScopeExpr/2` that resolves to a constant definition. If the constant
 * definition is a Namespace then it is returned, if it's a constant assignment then
 * the right-hand side of the assignment is resolved.
 */
private TResolved resolveScopeExpr(ConstantReadAccess r) {
  exists(string qname |
    qname =
      min(string qn, int p |
        isDefinedConstant(qn) and
        qn = resolveScopeExpr(r, p) and
        // prevent classes/modules that contain/extend themselves
        not exists(ConstantWriteAccess w | qn = constantDefinition0(w) |
          r = w.getScopeExpr()
          or
          r = w.(ClassDeclaration).getSuperclassExpr()
        )
      |
        qn order by p
      )
  |
    result = TResolved(qname)
    or
    exists(ConstantAssignment a |
      qname = constantDefinition0(a) and
      result = resolveScopeExpr(a.getParent().(Assignment).getRightOperand())
    )
  )
}

private int maxDepth() { result = 1 + max(int level | exists(enclosing(_, level))) }

private ModuleBase enclosing(ModuleBase m, int level) {
  result = m and level = 0
  or
  result = enclosing(m.getEnclosingModule(), level - 1)
}

/**
 * Resolve constant read access (typically a scope expression) to a qualified name. The
 * `priority` value indicates the precedence of the solution with respect to the lookup order.
 * A constant name without scope specifier is resolved against its enclosing modules (inner-most first);
 * if the constant is not found in any of the enclosing modules, then the constant will be resolved
 * with respect to the ancestors (prepends, includes, super classes, and their ancestors) of the
 * directly enclosing module.
 */
private string resolveScopeExpr(ConstantReadAccess c, int priority) {
  c.hasGlobalScope() and result = c.getName() and priority = 0
  or
  result = qualifiedModuleName(resolveScopeExpr(c.getScopeExpr(), priority), c.getName())
  or
  not exists(c.getScopeExpr()) and
  not c.hasGlobalScope() and
  (
    exists(Namespace n |
      result = qualifiedModuleName(constantDefinition0(n), c.getName()) and
      n = enclosing(c.getEnclosingModule(), priority)
    )
    or
    result =
      qualifiedModuleName(ancestors(qualifiedModuleName(c.getEnclosingModule()),
          priority - maxDepth()), c.getName())
    or
    result = c.getName() and
    priority = maxDepth() + 4 and
    qualifiedModuleName(c.getEnclosingModule()) != "BasicObject"
  )
}

bindingset[qualifier, name]
private string scopeAppend(string qualifier, string name) {
  if qualifier = "Object" then result = name else result = qualifier + "::" + name
}

private string qualifiedModuleName(ModuleBase m) {
  result = "Object" and m instanceof Toplevel
  or
  result = constantDefinition0(m)
}

/**
 * Get a qualified name for a constant definition. May return multiple qualified
 * names because we over-approximate when resolving scope resolutions and ignore
 * lookup order precedence. Taking lookup order into account here would lead to
 * non-monotonic recursion.
 */
private string constantDefinition0(ConstantWriteAccess c) {
  c.hasGlobalScope() and result = c.getName()
  or
  result = scopeAppend(resolveScopeExpr(c.getScopeExpr(), _), c.getName())
  or
  not exists(c.getScopeExpr()) and
  not c.hasGlobalScope() and
  exists(ModuleBase enclosing | enclosing = c.getEnclosingModule() |
    result = scopeAppend(qualifiedModuleName(enclosing), c.getName())
  )
}

/**
 * The qualified names of the ancestors of a class/module. The ancestors should be an ordered list
 * of the ancestores of `prepend`ed modules, the module itself , the ancestors or `include`d modules
 * and the ancestors of the super class. The priority value only distinguishes the kind of ancestor,
 * it does not order the ancestors within a group of the same kind. This is an over-approximation, however,
 * computing the precise order is tricky because it depends on the evaluation/file loading order.
 */
// TODO: the order of super classes can be determined more precisely even without knowing the evaluation
// order, so we should be able to make this more precise.
private string ancestors(string qname, int priority) {
  result = ancestors(prepends(qname), _) and priority = 0
  or
  result = qname and priority = 1 and isDefinedConstant(qname)
  or
  result = ancestors(includes(qname), _) and priority = 2
  or
  result = ancestors(superclass(qname), _) and priority = 3
}

private class IncludeOrPrependCall extends MethodCall {
  IncludeOrPrependCall() { this.getMethodName() = ["include", "prepend"] }

  string getAModule() { result = resolveScopeExpr(this.getAnArgument(), _) }

  string getTarget() {
    result = resolveScopeExpr(this.getReceiver(), _)
    or
    result = qualifiedModuleName(enclosingModule(this)) and
    (
      this.getReceiver() instanceof Self
      or
      not exists(this.getReceiver())
    )
  }
}

/**
 * A variant of AstNode::getEnclosingModule that excludes
 * results that are enclosed in a block. This is a bit wrong because
 * it could lead to false negatives. However, `include` statements in
 * blocks are very rare in normal code. The majority of cases are in calls
 * to methods like `module_eval` and `Rspec.describe` / `Rspec.context`. These
 * methods evaluate the block in the context of some other module/class instead of
 * the enclosing one.
 */
private ModuleBase enclosingModule(AstNode node) { result = parent*(node).getParent() }

private AstNode parent(AstNode n) {
  result = n.getParent() and
  not result instanceof ModuleBase and
  not result instanceof Block
}

private string prepends(string qname) {
  exists(IncludeOrPrependCall m |
    m.getMethodName() = "prepend" and
    qname = m.getTarget() and
    result = m.getAModule()
  )
}

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
  exists(ClassDeclaration c | qname = constantDefinition0(c) and result = c.getSuperclassExpr())
}

private string superclass(string qname) {
  qname = "Object" and result = "BasicObject"
  or
  result = resolveScopeExpr(superexpr(qname), _)
}

private string qualifiedModuleName(string container, string name) {
  isDefinedConstant(result) and
  (
    container = result.regexpCapture("(.+)::([^:]+)", 1) and
    name = result.regexpCapture("(.+)::([^:]+)", 2)
    or
    container = "Object" and name = result
  )
}

private Module getAncestors(Module m) {
  result = m or
  result = getAncestors(m.getAnIncludedModule()) or
  result = getAncestors(m.getAPrependedModule())
}

private Method lookupMethod0(Module m, string name) {
  result = lookupMethod0(m.getAPrependedModule(), name)
  or
  not exists(getAncestors(m.getAPrependedModule()).getMethod(name)) and
  (
    result = m.getMethod(name)
    or
    not exists(m.getMethod(name)) and result = lookupMethod0(m.getAnIncludedModule(), name)
  )
}

Method lookupMethod(Module m, string name) {
  result = lookupMethod0(m, name)
  or
  not exists(lookupMethod0(m, name)) and
  result = lookupMethod(m.getSuperClass(), name)
}
