/**
 * @name Assignment to exports variable
 * @description Assigning to the special 'exports' variable only overwrites its value and does not export
 *              anything. Such an assignment is hence most likely unintentional.
 * @kind problem
 * @problem.severity warning
 * @id js/node/assignment-to-exports-variable
 * @tags maintainability
 *       frameworks/node.js
 *       external/cwe/cwe-563
 * @precision very-high
 */

import javascript

/**
 * Holds if `assign` assigns the value of `nd` to `exportsVar`, which is an `exports` variable
 */
predicate exportsAssign(Assignment assgn, Variable exportsVar, DataFlow::Node nd) {
  exists(NodeModule m |
    exportsVar = m.getScope().getVariable("exports") and
    assgn.getLhs() = exportsVar.getAnAccess() and
    nd = assgn.getRhs().flow()
  )
  or
  exportsAssign(assgn, exportsVar, nd.getASuccessor())
}

/**
 * Holds if `pw` assigns the value of `nd` to `module.exports`.
 */
predicate moduleExportsAssign(DataFlow::PropWrite pw, DataFlow::Node nd) {
  pw.getBase().asExpr() instanceof ModuleAccess and
  pw.getPropertyName() = "exports" and
  nd = pw.getRhs()
  or
  moduleExportsAssign(pw, nd.getASuccessor())
}

from Assignment assgn, Variable exportsVar, DataFlow::Node exportsVal
where
  exportsAssign(assgn, exportsVar, exportsVal) and
  not exists(exportsVal.getAPredecessor()) and
  // this is OK if `exportsVal` flows into `module.exports`
  not moduleExportsAssign(_, exportsVal) and
  // export assignments do work in closure modules
  not assgn.getTopLevel() instanceof Closure::ClosureModule
select assgn, "Assigning to 'exports' does not export anything."
