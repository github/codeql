/**
 * @name AV Rule 99
 * @description Namespaces will not be nested more than two levels deep
 * @kind problem
 * @id cpp/jsf/av-rule-99
 * @problem.severity recommendation
 * @tags maintainability
 *       readability
 *       external/jsf
 */

import cpp

// Pick a representative file for a namespace - more than a bit dodgy, but otherwise
// the results don't show up anywhere which is less than helpful
predicate namespaceRepresentative(Namespace ns, File rep) {
  rep.getAbsolutePath() =
    min(File f |
      exists(Declaration d | d = ns.getADeclaration() | d.getFile() = f)
    |
      f.getAbsolutePath()
    )
}

from Namespace ns, File rep
where
  exists(ns.getParentNamespace().getParentNamespace().getParentNamespace()) and
  namespaceRepresentative(ns, rep)
select rep, "AV Rule 99: namespace " + ns.toString() + " is nested more than two levels deep"
