/**
 * @name Import shadowed by loop variable
 * @description A loop variable shadows an import.
 * @kind problem
 * @tags maintainability
 * @problem.severity recommendation
 * @sub-severity low
 * @deprecated
 * @precision very-high
 * @id py/import-shadowed-loop-variable
 */

import python

predicate shadowsImport(Variable l) {
  exists(Import i, Name shadow |
    shadow = i.getAName().getAsname() and
    shadow.getId() = l.getId() and
    i.getScope() = l.getScope().getScope*()
  )
}

from Variable l, Name defn
where shadowsImport(l) and defn.defines(l) and exists(For for | defn = for.getTarget())
select defn, "Loop variable '" + l.getId() + "' shadows an import"
