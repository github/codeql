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
    exists(string name | name = this.getTarget().getName() |
      name = "task_delay" or
      name = "taskDelay" or
      name = "sleep" or
      name = "nanosleep" or
      name = "clock_nanosleep"
    )
  }
}

from ForbiddenCall call
select call, "Task synchronization shall not be performed through task delays."
