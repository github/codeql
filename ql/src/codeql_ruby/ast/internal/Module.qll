private import codeql.Locations
private import codeql_ruby.ast.Call
private import codeql_ruby.ast.Constant
private import codeql_ruby.ast.Expr
private import codeql_ruby.ast.Module
private import codeql_ruby.ast.Operation
private import codeql_ruby.ast.Scope

// Names of built-in modules and classes
private string builtin() { result = ["Object", "Kernel", "BasicObject", "Class", "Module"] }

cached
newtype TModule =
  TResolved(string qName) {
    qName = builtin()
    or
    qName = constantDefinition(_)
  } or
  TUnresolved(Namespace n) { not exists(constantDefinition(n)) }

private predicate isToplevel(ConstantAccess n) {
  not exists(n.getScopeExpr()) and
  (
    n.hasGlobalScope()
    or
    n.getEnclosingModule() instanceof Toplevel
  )
}

string constantDefinition(ConstantWriteAccess n) {
  isToplevel(n) and result = n.getName()
  or
  not isToplevel(n) and
  not exists(n.getScopeExpr()) and
  result = scopeAppend(constantDefinition(n.getEnclosingModule()), n.getName())
  or
  result = scopeAppend(resolveScopeExpr(n.getScopeExpr()), n.getName())
}

private predicate isDefinedConstant(string qualifiedModuleName) {
  qualifiedModuleName = [builtin(), constantDefinition0(_)]
}

/**
 * Resolve a scope expression
 */
private string resolveScopeExpr(ConstantReadAccess r) {
  exists(string container |
    container =
      min(string c, int p |
        isDefinedConstant(c) and
        c = resolveScopeExpr(r, p)
      |
        c order by p
      )
  |
    result = container and
    container = [builtin(), constantDefinition(any(Namespace x))]
    or
    exists(ConstantAssignment a |
      container = constantDefinition(a) and
      result = resolveScopeExpr(a.getParent().(Assignment).getRightOperand())
    )
  )
}

cached
private int maxDepth() { result = max(ConstantAccess c | | count(c.getEnclosingModule+())) }

private ModuleBase enclosing(ModuleBase m, int level) {
  result = m and level = 0
  or
  result = enclosing(m.getEnclosingModule(), level - 1)
}

private string resolveScopeExpr(ConstantReadAccess c, int priority) {
  c.hasGlobalScope() and result = c.getName() and priority = 0
  or
  result = qualifiedModuleName(resolveScopeExpr(c.getScopeExpr(), priority), c.getName())
  or
  not exists(c.getScopeExpr()) and
  not c.hasGlobalScope() and
  exists(Namespace n |
    result = qualifiedModuleName(constantDefinition0(n), c.getName()) and
    n = enclosing(c.getEnclosingModule(), priority)
  )
  or
  result =
    qualifiedModuleName(ancestors(qualifiedModuleName(c.getEnclosingModule()), priority - maxDepth()),
      c.getName())
  or
  result = c.getName() and
  priority = maxDepth() + 4 and
  qualifiedModuleName(c.getEnclosingModule()) != "BasicObject"
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
    result = qualifiedModuleName(this.getEnclosingModule()) and
    (
      this.getReceiver() instanceof Self
      or
      not exists(this.getReceiver())
    )
  }
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
