/**
 * @name Null dereference from a function result
 * @description A function parameter is dereferenced,
 *              while it comes from a function that may return NULL,
 *              and is not checked for nullness by the caller.
 * @kind problem
 * @id cpp/deref-null-result
 * @problem.severity recommendation
 * @tags reliability
 *       security
 *       external/cwe/cwe-476
 */

import cpp
import semmle.code.cpp.dataflow.new.DataFlow

from Function nuller, Parameter pd, FunctionCall fc, Variable v
where
  mayReturnNull(nuller) and
  functionDereferences(pd.getFunction(), pd.getIndex()) and
  // there is a function call which will deref parameter pd
  fc.getTarget() = pd.getFunction() and
  // the parameter pd comes from a variable v
  DataFlow::localFlow(DataFlow::exprNode(v.getAnAccess()),
    DataFlow::exprNode(fc.getArgument(pd.getIndex()))) and
  // this variable v was assigned by a call to the nuller function
  unique( | | v.getAnAssignedValue()) = nuller.getACallToThisFunction() and
  // this variable v is not accessed for an operation (check for NULLness)
  not exists(VariableAccess vc |
    vc.getTarget() = v and
    (vc.getParent() instanceof Operation or vc.getParent() instanceof IfStmt)
  )
select fc, "This function call may deref $@ when it can be NULL from $@", v, v.getName(), nuller,
  nuller.getName()
