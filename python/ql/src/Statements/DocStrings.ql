/**
 * @name Missing docstring
 * @description Omitting documentation strings from public classes, functions or methods
 *              makes it more difficult for other developers to maintain the code.
 * @kind problem
 * @tags maintainability
 * @problem.severity recommendation
 * @sub-severity low
 * @precision medium
 * @id py/missing-docstring
 */

/*
 * NOTE: precision of 'medium' reflects the lack of precision in the underlying rule.
 * Do we care whether a function has a docstring? That often depends on the reader of that docstring.
 */

import python

predicate needs_docstring(Scope s) {
  s.isPublic() and
  (
    not s instanceof Function
    or
    function_needs_docstring(s)
  )
}

predicate function_needs_docstring(Function f) {
  not exists(FunctionValue fo, FunctionValue base | fo.overrides(base) and fo.getScope() = f |
    not function_needs_docstring(base.getScope())
  ) and
  f.getName() != "lambda" and
  (f.getMetrics().getNumberOfLinesOfCode() - count(f.getADecorator())) > 2 and
  not exists(PythonPropertyObject p |
    p.getGetter().getFunction() = f or
    p.getSetter().getFunction() = f
  )
}

string scope_type(Scope s) {
  result = "Module" and s instanceof Module and not s.(Module).isPackage()
  or
  result = "Class" and s instanceof Class
  or
  result = "Function" and s instanceof Function
}

from Scope s
where needs_docstring(s) and not exists(s.getDocString())
select s, scope_type(s) + " " + s.getName() + " does not have a docstring"
