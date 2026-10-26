/**
 * @name Use of setjmp or longjmp
 * @description Using the setjmp and longjmp functions complicates control flow and hinders program understanding.
 * @kind problem
 * @id cpp/jpl-c/simple-control-flow-jmp
 * @problem.severity warning
 * @tags correctness
 *       portability
 *       readability
 *       external/jpl
 */

import cpp

class ForbiddenFunction extends Function {
  ForbiddenFunction() { this.getName() = ["setjmp", "longjmp", "sigsetjmp", "siglongjmp"] }
}

from FunctionCall call
where call.getTarget() instanceof ForbiddenFunction
select call, "The " + call.getTarget().getName() + " function should not be used."
