import javascript

query predicate anchors(YAMLNode n, string anchor) { n.getAnchor() = anchor }

query predicate eval(YAMLNode n, YAMLValue eval) {
  not n.eval() = n and
  eval = n.eval()
}

query predicate yamlParseError(YAMLParseError err) { any() }

query predicate yamlMapping_maps(YAMLMapping m, YAMLValue k, YAMLValue v) { m.maps(k, v) }

query predicate yamlNode(YAMLNode n, string tag) { tag = n.getTag() }

query predicate yamlScalar(YAMLScalar s, string style, string value) {
  style = s.getStyle() and value = s.getValue()
}
