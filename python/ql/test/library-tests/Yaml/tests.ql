import semmle.python.Yaml

query predicate anchors(YamlNode n, string anchor) { n.getAnchor() = anchor }

query predicate eval(YamlNode n, YamlValue eval) {
  not n.eval() = n and
  eval = n.eval()
}

query predicate yamlParseError(YamlParseError err) { any() }

query predicate yamlMapping_maps(YamlMapping m, YamlValue k, YamlValue v) { m.maps(k, v) }

query predicate yamlNode(YamlNode n, string tag) { tag = n.getTag() }

query predicate yamlScalar(YamlScalar s, string style, string value) {
  style = s.getStyle() and value = s.getValue()
}
