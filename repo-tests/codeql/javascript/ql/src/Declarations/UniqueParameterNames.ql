/**
 * @name Duplicate parameter names
 * @description If a function has two parameters with the same name, the second parameter
 *              shadows the first one, which makes the code hard to understand and error-prone.
 * @kind problem
 * @problem.severity error
 * @id js/duplicate-parameter-name
 * @tags reliability
 *       correctness
 * @precision very-high
 */

import javascript

/**
 * Holds if `p`, which is the `i`th parameter of `f`, binds a variable `name`.
 */
predicate parmBinds(Function f, int i, Parameter p, string name) {
  p = f.getParameter(i) and
  p.getAVariable().getName() = name
}

/**
 * Holds if parameter `p` is a dummy parameter, that is, its name is `_`,
 * and it is never accessed.
 */
predicate isDummy(SimpleParameter p) {
  p.getName() = "_" and
  not exists(p.getVariable().getAnAccess())
}

from Function f, Parameter p, Parameter q, int i, int j, string name
where
  parmBinds(f, i, p, name) and
  parmBinds(f, j, q, name) and
  i < j and
  j = max(int k | parmBinds(f, k, _, name) | k) and
  not isDummy(p) and
  // ignore functions without bodies or empty bodies
  f.hasBody() and
  exists(f.getABodyStmt()) and
  // duplicate parameters in strict mode functions are flagged by the 'Syntax error' rule
  not f.isStrict()
select p, "This parameter has the same name as $@ of the same function.", q, "another parameter"
