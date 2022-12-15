class AbstractFunctionDecl extends @abstract_function_decl {
  string toString() { result = "" }
}

query predicate callable_names(AbstractFunctionDecl id, string name) {
  abstract_function_decls(id, name)
}
