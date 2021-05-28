import javascript

query predicate firebaseRef(DataFlow::SourceNode ref) { ref = Firebase::Database::ref() }

query predicate firebaseSnapshot(DataFlow::SourceNode snap) { snap = Firebase::snapshot() }

query predicate firebaseVal(Firebase::FirebaseVal val) { any() }

query predicate requestInputAccess(https::RequestInputAccess acc) { any() }

query predicate responseSendArgument(https::ResponseSendArgument send) { any() }

query predicate routeHandler(https::RouteHandler handler) { any() }
