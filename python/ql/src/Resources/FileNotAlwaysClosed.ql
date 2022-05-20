/**
 * @name File is not always closed
 * @description Opening a file without ensuring that it is always closed may cause resource leaks.
 * @kind problem
 * @tags efficiency
 *       correctness
 *       resources
 *       external/cwe/cwe-772
 * @problem.severity warning
 * @sub-severity high
 * @precision medium
 * @id py/file-not-closed
 */

import python
import FileOpen

/**
 * Whether resource is opened and closed in  in a matched pair of methods,
 * either `__enter__` and `__exit__` or `__init__` and `__del__`
 */
predicate opened_in_enter_closed_in_exit(ControlFlowNode open) {
  file_not_closed_at_scope_exit(open) and
  exists(FunctionValue entry, FunctionValue exit |
    open.getScope() = entry.getScope() and
    exists(ClassValue cls |
      cls.declaredAttribute("__enter__") = entry and cls.declaredAttribute("__exit__") = exit
      or
      cls.declaredAttribute("__init__") = entry and cls.declaredAttribute("__del__") = exit
    ) and
    exists(AttrNode attr_open, AttrNode attrclose |
      attr_open.getScope() = entry.getScope() and
      attrclose.getScope() = exit.getScope() and
      expr_is_open(attr_open.(DefinitionNode).getValue(), open) and
      attr_open.getName() = attrclose.getName() and
      close_method_call(_, attrclose)
    )
  )
}

predicate file_not_closed_at_scope_exit(ControlFlowNode open) {
  exists(EssaVariable v |
    BaseFlow::reaches_exit(v) and
    var_is_open(v, open) and
    not file_is_returned(v, open)
  )
  or
  call_to_open(open) and
  not exists(AssignmentDefinition def | def.getValue() = open) and
  not exists(Return r | r.getValue() = open.getNode())
}

predicate file_not_closed_at_exception_exit(ControlFlowNode open, ControlFlowNode exit) {
  exists(EssaVariable v |
    exit.(RaisingNode).viableExceptionalExit(_, _) and
    not closes_arg(exit, v.getSourceVariable()) and
    not close_method_call(exit, v.getAUse().(NameNode)) and
    var_is_open(v, open) and
    v.getAUse() = exit.getAChild*()
  )
}

/* Check to see if a file is opened but not closed or returned */
from ControlFlowNode defn, string message
where
  not opened_in_enter_closed_in_exit(defn) and
  (
    file_not_closed_at_scope_exit(defn) and message = "File is opened but is not closed."
    or
    not file_not_closed_at_scope_exit(defn) and
    file_not_closed_at_exception_exit(defn, _) and
    message = "File may not be closed if an exception is raised."
  )
select defn.getNode(), message
