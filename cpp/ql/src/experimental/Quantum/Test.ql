/**
 * @name "PQC Test"
 * @kind graph
 */

import experimental.Quantum.Language

query predicate nodes(Crypto::NodeBase node) { any() }

query predicate edges(Crypto::NodeBase source, Crypto::NodeBase target, string key, string value) {
  target = source.getChild(value) and
  key = "semmle.label"
}

query predicate graphProperties(string key, string value) {
  key = "semmle.graphKind" and value = "tree"
}
