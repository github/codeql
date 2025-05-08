/**
 * @name Print CBOM Graph
 * @description Outputs a graph representation of the cryptographic bill of materials.
 *              This query only supports DGML output, as CodeQL DOT output omits properties.
 * @kind graph
 * @id cpp/print-cbom-graph
 */

import experimental.quantum.Language

query predicate nodes(Crypto::NodeBase node, string key, string value) {
  Crypto::nodes_graph_impl(node, key, value)
}

query predicate edges(Crypto::NodeBase source, Crypto::NodeBase target, string key, string value) {
  Crypto::edges_graph_impl(source, target, key, value)
}

query predicate graphProperties(string key, string value) {
  key = "semmle.graphKind" and value = "graph"
}
