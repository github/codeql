class Function extends @function {
  string toString() { none() }
}

class Type extends @type {
  string toString() { none() }
}

class Variable extends @variable {
  string toString() { none() }
}

query predicate new_coroutine(Function func, Type traits) { coroutine(func, traits, _, _) }

query predicate new_coroutine_placeholder_variable(Variable var, int kind, Function func) {
  coroutine(func, _, var, _) and kind = 1
  or
  coroutine(func, _, _, var) and kind = 2
}
