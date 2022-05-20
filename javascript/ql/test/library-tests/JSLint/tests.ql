import javascript

query predicate jsLintDirective(JSLintDirective dir, StmtContainer scope) { dir.getScope() = scope }

query predicate jsLintGlobal(JSLintGlobal decl, string name, boolean b) {
  decl.declaresGlobal(name, b)
}

query predicate jsLintOptions(JSLintOptions options, string name, string value) {
  options.definesFlag(name, value)
}

query predicate jsLintProperties(JSLintProperties props, string prop) {
  props.getAProperty() = prop
}
