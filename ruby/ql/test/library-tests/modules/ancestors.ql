/**
 * @kind graph
 * @id rb/test/ancestors
 */

import ruby

query predicate nodes(Module node, string key, string value) {
  key = "semmle.label" and value = node.toString()
}

query predicate edges(Module source, Module target, string key, string value) {
  key = "semmle.label" and
  (
    target = source.getSuperClass() and value = "super"
    or
    target = source.getAPrependedModule() and value = "prepend"
    or
    target = source.getAnIncludedModule() and value = "include"
  )
}
