/**
 * @kind graph
 */

import ruby

query predicate nodes(Module node, string key, string value) {
  key = "semmle.label" and value = node.toString()
}

query predicate edges(Module source, Module target) { target = source.getSuperClass() }
