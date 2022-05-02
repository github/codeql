/**
 * @kind graph
 * @id rb/test/ancestors
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

Module getATarget(Module source, string value) {
  result = source.getSuperClass() and value = "super"
  or
  result = source.getAPrependedModule() and value = "prepend"
  or
  result = source.getAnIncludedModule() and value = "include"
}

query predicate edges(Module source, Module target, string key, string value) {
  key = "semmle.label" and
  target = getATarget(source, value)
  or
  key = "semmle.order" and
  value =
    any(int i |
      target =
        rank[i](Module t, Location l |
          t = getATarget(source, _) and
          l = t.getLocation()
        |
          t
          order by
            l.getFile().getBaseName(), l.getFile().getAbsolutePath(), l.getStartLine(),
            l.getStartColumn(), l.getEndLine(), l.getEndColumn(), t.toString()
        )
    ).toString()
}
