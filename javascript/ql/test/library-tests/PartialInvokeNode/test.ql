import javascript

query DataFlow::Node getBoundFunction(
  DataFlow::PartialInvokeNode invoke, DataFlow::Node callback, int boundArgs
) {
  result = invoke.getBoundFunction(callback, boundArgs)
}

query predicate isPartialArgument(
  DataFlow::PartialInvokeNode invoke, DataFlow::Node callback, DataFlow::Node argument, int index
) {
  invoke.isPartialArgument(callback, argument, index)
}

query DataFlow::Node getBoundReceiver(DataFlow::PartialInvokeNode invoke) {
  result = invoke.getBoundReceiver()
}

query DataFlow::Node clickEvent() {
  result = DataFlow::globalVarRef("addEventListener").getACall().getABoundCallbackParameter(1, 0)
}
