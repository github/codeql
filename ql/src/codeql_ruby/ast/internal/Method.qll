private import codeql_ruby.ast.Method
private import codeql_ruby.ast.Module
private import codeql_ruby.ast.internal.Module

newtype TMethod =
  TInstanceMethod(TModule owner, string name) { exists(methodDeclaration(owner, name)) }

MethodDeclaration methodDeclaration(TModule owner, string name) {
  exists(ModuleBase m | m.getModule() = owner and result = m.getMethod(name))
}
