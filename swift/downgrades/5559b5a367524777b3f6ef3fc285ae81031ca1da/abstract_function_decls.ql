class Callable extends @callable {
  string toString() { result = "" }
}

query predicate abstract_function_decls(Callable id, string name) { callable_names(id, name) }
