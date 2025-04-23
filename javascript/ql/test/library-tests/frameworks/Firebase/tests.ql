import javascript

query predicate firebaseRef(DataFlow::SourceNode ref) {
  ref = ModelOutput::getATypeNode("FirebaseDBRef").asSource()
}

query predicate firebaseSnapshot(DataFlow::SourceNode snap) {
  snap = ModelOutput::getATypeNode("Snapshot").asSource()
}

query predicate firebaseVal(DataFlow::SourceNode val) {
  val = ModelOutput::getASourceNode("remote").asSource()
}

query predicate requestInputAccess(Http::RequestInputAccess acc) { any() }

query predicate responseSendArgument(Http::ResponseSendArgument send) { any() }

query predicate routeHandler(Http::RouteHandler handler) { any() }
