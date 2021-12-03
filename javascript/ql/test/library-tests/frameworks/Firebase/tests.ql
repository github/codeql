import javascript

query predicate firebaseRef(DataFlow::SourceNode ref) { ref = Firebase::Database::ref() }

query predicate firebaseSnapshot(DataFlow::SourceNode snap) { snap = Firebase::snapshot() }

query predicate firebaseVal(Firebase::FirebaseVal val) { any() }

query predicate requestInputAccess(HTTP::RequestInputAccess acc) { any() }

query predicate responseSendArgument(HTTP::ResponseSendArgument send) { any() }

query predicate routeHandler(HTTP::RouteHandler handler) { any() }
