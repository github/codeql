/**
 * @name "PQC Test"
 * @kind graph
 */

import experimental.Quantum.Language

string getValueAndLocationPairs(Crypto::NodeBase node, string key) {
  exists(string value, Location location |
    node.properties(key, value, location) and
    result = "(" + value + "," + location.toString() + ")"
  )
}

string properties(Crypto::NodeBase node) {
  forex(string key | node.properties(key, _, _) |
    result = key + ":" + strictconcat(getValueAndLocationPairs(node, key), ",")
  )
}

string getLabel(Crypto::NodeBase node) {
  result =
    "[" + node.toString() + "]" +
      any(string prop |
        if exists(properties(node)) then prop = " " + properties(node) else prop = ""
      |
        prop
      )
}

query predicate nodes(Crypto::NodeBase node, string key, string value) {
  key = "semmle.label" and
  value = getLabel(node)
}

query predicate edges(Crypto::NodeBase source, Crypto::NodeBase target, string key, string value) {
  target = source.getChild(value) and
  key = "semmle.label"
}

query predicate graphProperties(string key, string value) {
  key = "semmle.graphKind" and value = "tree"
}
