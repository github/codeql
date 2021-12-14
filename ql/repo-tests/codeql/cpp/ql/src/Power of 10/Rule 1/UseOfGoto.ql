/**
 * @name Use of goto
 * @description Using the goto statement complicates function control flow and hinders program understanding.
 * @kind problem
 * @id cpp/power-of-10/use-of-goto
 * @problem.severity warning
 * @tags maintainability
 *       readability
 *       external/powerof10
 */

import cpp

from GotoStmt goto
select goto, "The goto statement should not be used."
