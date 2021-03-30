private import codeql.Locations
private import codeql_ruby.ast.Constant
private import codeql_ruby.ast.Module
private import codeql_ruby.ast.Operation
private import codeql_ruby.ast.Scope

// Names of built-in modules and classes
private string builtin() { result = ["Object", "Kernel", "BasicObject", "Class", "Module"] }

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

private string resolveRelativeToEnclosing(ConstantAccess n, int i) {
  not isToplevel(n) and
  not exists(n.getScopeExpr()) and
  exists(Scope s, ModuleBase enclosing |
    n = s.getADescendant() and
    enclosing = enclosing(s.getEnclosingModule(), i) and
    (
      result = constantDefinition0(enclosing) + "::" + n.getName()
      or
      enclosing instanceof Toplevel and result = n.getName()
    )
  )
}

private string qualifiedNameForConstant0(ConstantAccess n) {
  isToplevel(n) and
  result = n.getName()
  or
  result = resolveRelativeToEnclosing(n, 0)
  or
  result = resolveScopeExpr0(n.getScopeExpr()) + "::" + n.getName()
}

string constantDefinition(ConstantWriteAccess n) {
  result = constantDefinition0(n)
  or
  result = resolveScopeExpr(n.getScopeExpr()) + "::" + n.getName()
}

private string resolveScopeExpr(ConstantReadAccess n) {
  exists(string qname |
    qname =
      min(int i, string x |
        (
          x = qualifiedNameForConstant0(n) and i = 0
          or
          x = resolveRelativeToEnclosing(n, i)
        ) and
        (x = builtin() or x = constantDefinition0(_))
      |
        x order by i
      )
  |
    qname = builtin() and result = qname
    or
    not qname = builtin() and
    exists(ConstantWriteAccess def | qname = constantDefinition0(def) |
      result = qname and def instanceof Namespace
      or
      result = resolveScopeExpr(def.getParent().(Assignment).getRightOperand())
    )
  )
}
