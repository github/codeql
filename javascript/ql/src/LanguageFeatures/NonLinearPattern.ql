/**
 * @name Non-linear pattern
 * @description If the same pattern variable appears twice in an array or object pattern,
 *              the second binding will silently overwrite the first binding, which is probably
 *              unintentional.
 * @kind problem
 * @problem.severity error
 * @id js/non-linear-pattern
 * @tags reliability
 *       correctness
 *       language-features
 * @precision very-high
 */

import javascript

from BindingPattern p, string n, VarDecl v, VarDecl w
where
  v = p.getABindingVarRef() and
  w = p.getABindingVarRef() and
  v.getName() = n and
  w.getName() = n and
  v != w and
  v.getLocation().startsBefore(w.getLocation())
select w, "Repeated binding of pattern variable '" + n + "' previously bound $@.", v, "here"
