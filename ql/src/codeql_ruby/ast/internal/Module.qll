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
newtype TConstant =
  TResolved(string qName, boolean isModule) {
    exists(ConstantWriteAccess n |
      qName = builtin() and isModule = true
      or
      qName = constantDefinition(n) and
      if n instanceof Namespace then isModule = true else isModule = false
    )
  } or
  TUnresolved(ConstantWriteAccess n) { not exists(constantDefinition(n)) }

private predicate isToplevel(ConstantAccess n) {
  not exists(n.getScopeExpr()) and
  (
    n.hasGlobalScope()
    or
    exists(Scope x | x.getADescendant() = n and x.getEnclosingModule() instanceof Toplevel)
  )
}

private string constantDefinition0(ConstantWriteAccess n) { result = qualifiedNameForConstant0(n) }

/**
 * Resolve a scope expression
 */
private string resolveScopeExpr0(ConstantReadAccess n) {
  exists(string qname | qname = qualifiedNameForConstant0(n) |
    qname = builtin() and result = qname
    or
    not qname = builtin() and
    exists(ConstantWriteAccess def | qname = constantDefinition0(def) |
      result = qname and def instanceof Namespace
      or
      result = resolveScopeExpr0(def.getParent().(Assignment).getRightOperand())
    )
  )
}

ModuleBase enclosing(ModuleBase m, int level) {
  result = m and level = 0
  or
  result = enclosing(m.getOuterScope().getEnclosingModule(), level - 1)
}

bindingset[qualifier, name]
private string scopeAppend(string qualifier, string name) {
  if qualifier = "Object" then result = name else result = qualifier + "::" + name
}

private string resolveRelativeToEnclosing(ConstantAccess n, int i) {
  not isToplevel(n) and
  not exists(n.getScopeExpr()) and
  exists(Scope s, ModuleBase enclosing |
    n = s.getADescendant() and
    enclosing = enclosing(s.getEnclosingModule(), i) and
    result = scopeAppend(constantDefinition0(enclosing), n.getName()) and
    (result = builtin() or result = constantDefinition0(_) or n instanceof ConstantWriteAccess)
  )
}

private class IncludeOrPrependCall extends MethodCall {
  IncludeOrPrependCall() { this.getMethodName() = ["include", "prepend"] }

  string getAModule() { result = resolveScopeExpr0(this.getAnArgument()) }

  string getTarget() {
    result = resolveScopeExpr0(this.getReceiver())
    or
    exists(Scope s |
      s.getADescendant() = this and
      (
        result = constantDefinition0(s.getEnclosingModule())
        or
        result = "Object" and s.getEnclosingModule() instanceof Toplevel
      )
    |
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
  exists(ClassDefinition c | qname = constantDefinition0(c) and result = c.getSuperclassExpr())
}

private string superclass(string qname) {
  qname = "Object" and result = "BasicObject"
  or
  result = resolveScopeExpr(superexpr(qname))
  or
  qname = constantDefinition0(_) and
  not exists(superexpr(qname)) and
  result = "Object" and
  qname != "BasicObject"
}

private string ancestors(string qname) {
  qname = [builtin(), constantDefinition0(any(Namespace x))] and
  (
    result = prepends(qname)
    or
    result = qname
    or
    result = includes(qname)
  )
}

private string contains(string qname, string name) {
  result = containsIgnoringSuper(qname, name)
  or
  not exists(containsIgnoringSuper(qname, name)) and
  result = contains(superclass(qname), name)
}

private string qualifiedName(string container, string name) {
  result = [builtin(), constantDefinition0(_)] and
  (
    container = result.regexpCapture("(.+)::([^:]+)", 1) and
    name = result.regexpCapture("(.+)::([^:]+)", 2)
    or
    container = "Object" and name = result
  )
}

private string containsIgnoringSuper(string qname, string name) {
  result =
    min(string n, string container, int i |
      n = qualifiedName(container, name) and
      (
        container = ancestors*(prepends(qname)) and i = 0
        or
        container = qname and i = 1
        or
        container = ancestors*(includes(qname)) and i = 2
      )
    |
      n order by i
    )
}

private string resolveRelativeToAncestors(ConstantReadAccess n) {
  not isToplevel(n) and
  not exists(n.getScopeExpr()) and
  exists(Scope s, ModuleBase enclosing |
    n = s.getADescendant() and
    enclosing = s.getEnclosingModule()
  |
    result = contains(constantDefinition(enclosing), n.getName())
    or
    enclosing instanceof Toplevel and result = contains("Object", n.getName())
  )
}

private string qualifiedNameForConstant0(ConstantAccess n) {
  isToplevel(n) and
  result = n.getName()
  or
  result = resolveRelativeToEnclosing(n, 0)
  or
  result = scopeAppend(resolveScopeExpr0(n.getScopeExpr()), n.getName())
}

string constantDefinition(ConstantWriteAccess n) {
  result = constantDefinition0(n)
  or
  result = scopeAppend(resolveScopeExpr(n.getScopeExpr()), n.getName())
}

private string resolveScopeExpr(ConstantReadAccess n) {
  result = resolveScopeExpr0(n)
  or
  exists(string qname |
    qname = min(int i, string x | x = resolveRelativeToEnclosing(n, i) | x order by i)
    or
    not exists(resolveRelativeToEnclosing(n, _)) and
    qname = resolveRelativeToAncestors(n)
  |
    qname = builtin() and result = qname
    or
    not qname = builtin() and
    exists(ConstantWriteAccess def | qname = constantDefinition(def) |
      result = qname and def instanceof Namespace
      or
      result = resolveScopeExpr(def.getParent().(Assignment).getRightOperand())
    )
  )
}
