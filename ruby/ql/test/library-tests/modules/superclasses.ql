/**
 * @kind graph
 * @id rb/test/supertypes
 */

import ruby

query predicate nodes(Module node, string key, string value) {
  key = "semmle.label" and value = node.toString()
  or
  key = "semmle.order" and
  value =
    any(int i |
      node =
        rank[i](Module m, Location l |
          l = m.getLocation()
        |
          m
          order by
            l.getFile().getBaseName(), l.getFile().getAbsolutePath(), l.getStartLine(),
            l.getStartColumn(), l.getEndLine(), l.getEndColumn(), m.toString()
        )
    ).toString()
}

query predicate edges(Module source, Module target, string key, string value) {
  key = "semmle.label" and
  value = "" and
  target = source.getSuperClass()
  or
  key = "semmle.order" and
  value =
    any(int i |
      target =
        rank[i](Module t, Location l |
          t = source.getSuperClass() and
          l = source.getLocation()
        |
          t
          order by
            l.getFile().getBaseName(), l.getFile().getAbsolutePath(), l.getStartLine(),
            l.getStartColumn(), l.getEndLine(), l.getEndColumn(), t.toString()
        )
    ).toString()
}
