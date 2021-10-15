/**
 * @name Use of delay function
 * @description Task synchronization shall not be performed through the use of task delays.
 * @kind problem
 * @id cpp/jpl-c/thread-safety
 * @problem.severity warning
 * @tags correctness
 *       concurrency
 *       external/jpl
 */

import cpp

class ForbiddenCall extends FunctionCall {
  ForbiddenCall() {
    this.getTarget().getName() =
      ["task_delay", "taskDelay", "sleep", "nanosleep", "clock_nanosleep"]
  }
}

from ForbiddenCall call
select call, "Task synchronization shall not be performed through task delays."
