/**
 * @name Use of goto
 * @description Using the goto statement complicates function control flow and hinders program understanding.
 * @kind problem
 * @id cpp/jpl-c/simple-control-flow-goto
 * @problem.severity warning
 * @tags maintainability
 *       readability
 *       external/jpl
 */

import cpp

from GotoStmt goto
select goto, "The goto statement should not be used."
