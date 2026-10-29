import javascript

query predicate firebaseRef(DataFlow::SourceNode ref) { ref = Firebase::Database::ref() }

query predicate firebaseSnapshot(DataFlow::SourceNode snap) { snap = Firebase::snapshot() }

query predicate firebaseVal(Firebase::FirebaseVal val) { any() }

query predicate requestInputAccess(Http::RequestInputAccess acc) { any() }

query predicate responseSendArgument(Http::ResponseSendArgument send) { any() }

query predicate routeHandler(Http::RouteHandler handler) { any() }
