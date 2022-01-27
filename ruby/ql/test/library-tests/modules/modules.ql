import ruby
private import codeql.ruby.ast.internal.Module as Internal

query Module getModule() { any() }

query ModuleBase getADeclaration(Module m) { result = m.getADeclaration() }

query Module getSuperClass(Module m) { result = m.getSuperClass() }

query Module getAPrependedModule(Module m) { result = m.getAPrependedModule() }

query Module getAnIncludedModule(Module m) { result = m.getAnIncludedModule() }

query predicate resolveConstantReadAccess(ConstantReadAccess a, string s) {
  Internal::TResolved(s) = Internal::resolveConstantReadAccess(a)
}

query predicate resolveConstantWriteAccess(ConstantWriteAccess c, string s) {
  s = Internal::resolveConstantWriteAccess(c)
}
