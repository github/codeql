/**
 * @name Builtin shadowed by local variable
 * @description Defining a local variable with the same name as a built-in object
 *              makes the built-in object unusable within the current scope and makes the code
 *              more difficult to read.
 * @kind problem
 * @tags maintainability
 *       readability
 * @problem.severity recommendation
 * @sub-severity low
 * @precision medium
 * @id py/local-shadows-builtin
 */

import python
import Shadowing
import semmle.python.types.Builtins

predicate allow_list(string name) {
  name in [
      /* These are rarely used and thus unlikely to be confusing */
      "iter", "next", "input", "file", "apply", "slice", "buffer", "coerce", "intern", "exit",
      "quit", "license",
      /* These are short and/or hard to avoid */
      "dir", "id", "max", "min", "sum", "cmp", "chr", "ord", "bytes", "_",
    ]
}

predicate shadows(Name d, string name, Function scope, int line) {
  exists(LocalVariable l |
    d.defines(l) and
    l.getId() = name and
    exists(Builtin::builtin(l.getId()))
  ) and
  d.getScope() = scope and
  d.getLocation().getStartLine() = line and
  not allow_list(name) and
  not optimizing_parameter(d)
}

predicate first_shadowing_definition(Name d, string name) {
  exists(int first, Scope scope |
    shadows(d, name, scope, first) and
    first = min(int line | shadows(_, name, scope, line))
  )
}

from Name d, string name
where first_shadowing_definition(d, name)
select d, "Local variable " + name + " shadows a builtin variable."
