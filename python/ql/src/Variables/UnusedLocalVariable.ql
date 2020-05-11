/**
 * @name Unused local variable
 * @description Local variable is defined but not used
 * @kind problem
 * @tags maintainability
 *       useless-code
 *       external/cwe/cwe-563
 * @problem.severity recommendation
 * @sub-severity high
 * @precision very-high
 * @id py/unused-local-variable
 */

import python
import Definition

predicate unused_local(Name unused, LocalVariable v) {
  forex(Definition def | def.getNode() = unused |
    def.getVariable() = v and
    def.isUnused() and
    not exists(def.getARedef()) and
    def.isRelevant() and
    not v = any(Nonlocal n).getAVariable() and
    not exists(def.getNode().getParentNode().(FunctionDef).getDefinedFunction().getADecorator()) and
    not exists(def.getNode().getParentNode().(ClassDef).getDefinedClass().getADecorator())
  )
}

from Name unused, LocalVariable v
where
  unused_local(unused, v) and
  // If unused is part of a tuple, count it as unused if all elements of that tuple are unused.
  forall(Name el | el = unused.getParentNode().(Tuple).getAnElt() | unused_local(el, _))
select unused, "The value assigned to local variable '" + v.getId() + "' is never used."
