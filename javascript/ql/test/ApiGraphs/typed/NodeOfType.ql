import javascript

query DataFlow::Node getANodeOfType(string package, string type) {
  result = API::Node::ofType(package, type).asSource()
}

query DataFlow::Node getANodeOfTypeRaw(string package, string type) {
  result = API::Internal::getANodeOfTypeRaw(package, type).asSource()
}
