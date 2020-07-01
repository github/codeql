/**
 * @name Incorrect constructor delegation
 * @description A constructor in C++ cannot delegate part of the object
 *              initialization to another by calling it. This is likely to
 *              leave part of the object uninitialized.
 * @kind problem
 * @problem.severity warning
 * @precision high
 * @id cpp/constructor-delegation
 * @tags maintainability
 *       readability
 *       language-features
 */

import cpp

from FunctionCall call
where
  call.getTarget() = call.getEnclosingFunction().(Constructor).getDeclaringType().getAConstructor() and
  call.getParent() instanceof ExprStmt
select call,
  "The constructor " + call.getTarget().getName() +
    " may leave the instance uninitialized, as it tries to delegate to another constructor."
