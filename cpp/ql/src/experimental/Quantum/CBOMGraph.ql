/**
 * @name "Print CBOM Graph"
 * @description "Outputs a graph representation of the cryptographic bill of materials."
 * @kind graph
 * @id cbomgraph
 */

import experimental.Quantum.Language

string getPropertyString(Crypto::NodeBase node, string key) {
  result =
    strictconcat(any(string value, Location location, string parsed |
          node.properties(key, value, location) and
          parsed = "(" + value + "," + location.toString() + ")"
        |
          parsed
        ), ","
    )
}

string getLabel(Crypto::NodeBase node) { result = node.toString() }

query predicate nodes(Crypto::NodeBase node, string key, string value) {
  key = "semmle.label" and
  value = getLabel(node)
  or
  // CodeQL's DGML output does not include a location
  key = "Location" and
  value = node.getLocation().toString()
  or
  // Known unknown edges should be reported as properties rather than edges
  node = node.getChild(key) and
  value = "<unknown>"
  or
  // Report properties
  value = getPropertyString(node, key)
}

query predicate edges(Crypto::NodeBase source, Crypto::NodeBase target, string key, string value) {
  key = "semmle.label" and
  target = source.getChild(value) and
  // Known unknowns are reported as properties rather than edges
  not source = target
}

query predicate graphProperties(string key, string value) {
  key = "semmle.graphKind" and value = "graph"
}
