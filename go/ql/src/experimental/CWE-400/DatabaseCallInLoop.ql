/**
 * @name Database call in loop
 * @description Detects database operations within loops.
 *              Doing operations in series can be slow and lead to N+1 situations.
 * @kind path-problem
 * @problem.severity warning
 * @precision high
 * @id go/examples/database-call-in-loop
 */

import go

class DatabaseAccess extends DataFlow::MethodCallNode {
  DatabaseAccess() {
    exists(string name |
      this.getTarget().hasQualifiedName(Gorm::packagePath(), "DB", name) and
      // all terminating Gorm methods
      name =
        [
          "Find", "Take", "Last", "Scan", "Row", "Rows", "ScanRows", "Pluck", "Count", "First",
          "FirstOrInit", "FindOrCreate", "Update", "Updates", "UpdateColumn", "UpdateColumns",
          "Save", "Create", "Delete", "Exec"
        ]
    )
  }
}

class CallGraphNode extends Locatable {
  CallGraphNode() {
    this instanceof LoopStmt
    or
    this instanceof CallExpr
    or
    this instanceof FuncDef
  }
}

/**
 * Holds if `pred` calls `succ`, i.e. is an edge in the call graph,
 * This includes explicit edges from call -> callee, to produce better paths.
 */
predicate callGraphEdge(CallGraphNode pred, CallGraphNode succ) {
  // Go from a loop to an enclosed expression.
  pred.(LoopStmt).getBody().getAChild*() = succ.(CallExpr)
  or
  // Go from a call to the called function.
  pred.(CallExpr) = succ.(FuncDef).getACall().asExpr()
  or
  // Go from a function to an enclosed loop.
  pred = succ.(LoopStmt).getEnclosingFunction()
  or
  // Go from a function to an enclosed call.
  pred = succ.(CallExpr).getEnclosingFunction()
}

query predicate edges(CallGraphNode pred, CallGraphNode succ) {
  callGraphEdge(pred, succ) and
  // Limit the range of edges to only those that are relevant.
  // This helps to speed up the query by reducing the size of the outputted path information.
  exists(LoopStmt loop, DatabaseAccess dbAccess |
    // is between a loop and a db access
    callGraphEdge*(loop, pred) and
    callGraphEdge*(succ, dbAccess.asExpr())
  )
}

from LoopStmt loop, DatabaseAccess dbAccess
where edges*(loop, dbAccess.asExpr())
select dbAccess, loop, dbAccess, "$@ is called in $@", dbAccess, dbAccess.toString(), loop, "a loop"
