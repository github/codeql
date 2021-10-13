/**
 * @name GORM error not checked
 * @description A call that interacts with the database using the GORM library
 *              without checking whether there was an error.
 * @kind problem
 * @problem.severity warning
 * @id go/examples/gorm-error-not-checked
 * @precision high
 */

import go
import semmle.go.frameworks.SQL

from DataFlow::MethodCallNode call
where
  exists(string name | call.getTarget().hasQualifiedName(Gorm::packagePath(), "DB", name) |
    name != "InstantSet" and
    name != "LogMode"
  ) and
  // the value from the call does not:
  not exists(DataFlow::Node succ | TaintTracking::localTaintStep*(call, succ) |
    // get assigned to any variables
    succ = any(Write w).getRhs()
    or
    // get returned
    succ instanceof DataFlow::ResultNode
    or
    // have any methods chained on it
    exists(DataFlow::MethodCallNode m | succ = m.getReceiver())
    or
    // have its `Error` field read
    exists(DataFlow::FieldReadNode fr | fr.readsField(succ, _, _, "Error"))
  )
select call,
  "This call appears to interact with the database without checking whether an error was encountered."
