class Function extends @function {
  string toString() { none() }
}

class Type extends @type {
  string toString() { none() }
}

class Variable extends @variable {
  string toString() { none() }
}

from Function func, Type traits, Variable handle, Variable promise
where
  coroutine(func, traits) and
  coroutine_placeholder_variable(handle, 1, func) and
  coroutine_placeholder_variable(promise, 2, func)
select func, traits, handle, promise
