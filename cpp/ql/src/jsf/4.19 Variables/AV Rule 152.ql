/**
 * @name AV Rule 152
 * @description Multiple variable declarations shall not be allowed on the same line.
 * @kind problem
 * @id cpp/jsf/av-rule-152
 * @problem.severity recommendation
 * @tags maintainability
 *       readability
 *       external/jsf
 */

import cpp

predicate isNonSolitary(Declaration d) {
  exists(DeclStmt ds, Variable v |
    ds.fromSource() and
    d = ds.getADeclaration() and
    d instanceof Variable and
    v = ds.getADeclaration() and
    v != d
  )
  or
  exists(GlobalVariable g |
    g.fromSource() and
    g.getLocation().getStartLine() = d.(GlobalVariable).getLocation().getStartLine() and
    g.getLocation().getFile() = d.getLocation().getFile() and
    g != d
  )
  or
  exists(Field f |
    f.fromSource() and
    f.getLocation().getStartLine() = d.(Field).getLocation().getStartLine() and
    f.getLocation().getFile() = d.getLocation().getFile() and
    f != d
  )
}

from Declaration d
where isNonSolitary(d)
select d, "AV Rule 152: Multiple variable declarations shall not be allowed on the same line."
