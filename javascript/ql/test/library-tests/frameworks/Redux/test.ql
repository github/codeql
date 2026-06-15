import javascript

query predicate getAffectedStateAccessPath = Redux::getAffectedStateAccessPath/1;

query Redux::ReducerArg reducerArg() { any() }

query Redux::ReducerArg isActionTypeHandler(DataFlow::Node actionType) {
  result.isActionTypeHandler(actionType)
}

query Redux::ReducerArg isTypeTagHandler(string typeTag) { result.isTypeTagHandler(typeTag) }

query Redux::ReducerArg isRootStateHandler() { result.isRootStateHandler() }

query Redux::DelegatingReducer delegatingReducer() { any() }

query DataFlow::Node getStateHandlerArg(Redux::DelegatingReducer reducer, string prop) {
  result = reducer.getStateHandlerArg(prop)
}

query DataFlow::Node getActionHandlerArg(Redux::DelegatingReducer reducer, DataFlow::Node actionType) {
  result = reducer.getActionHandlerArg(actionType)
}

query DataFlow::Node getAPlainHandlerArg(Redux::DelegatingReducer reducer) {
  result = reducer.getAPlainHandlerArg()
}

query Redux::ReducerArg getUseSite(Redux::DelegatingReducer reducer) {
  result = reducer.getUseSite()
}

query predicate getADispatchFunctionNode = Redux::getADispatchFunctionNode/0;

query predicate getADispatchedValueNode = Redux::getADispatchedValueNode/0;

query predicate getAnUntypedActionInReducer = Redux::getAnUntypedActionInReducer/0;

query predicate actionToReducerStep = Redux::actionToReducerStep/2;

query predicate actionToReducerPromiseStep = Redux::actionToReducerPromiseStep/2;

query predicate reducerToStateStep = Redux::reducerToStateStep/2;

query Redux::StoreCreation storeCreation() { any() }

module TestConfig implements DataFlow::ConfigSig {
  predicate isSource(DataFlow::Node node) { node.(DataFlow::CallNode).getCalleeName() = "source" }

  predicate isSink(DataFlow::Node node) {
    node = any(DataFlow::CallNode call | call.getCalleeName() = "sink").getAnArgument()
  }
}

module TestFlow = TaintTracking::Global<TestConfig>;

deprecated class LegacyConfig extends TaintTracking::Configuration {
  LegacyConfig() { this = "LegacyConfig" }

  override predicate isSource(DataFlow::Node source) { TestConfig::isSource(source) }

  override predicate isSink(DataFlow::Node sink) { TestConfig::isSink(sink) }
}

deprecated import utils.test.LegacyDataFlowDiff::DataFlowDiff<TestFlow, LegacyConfig>

query predicate taintFlow(DataFlow::Node source, DataFlow::Node sink) {
  TestFlow::flow(source, sink)
}

query DataFlow::SourceNode reactComponentRef(ReactComponent component) {
  result = component.getAComponentCreatorReference()
}

query predicate ambiguousAccessPath(API::Node node, string path) {
  count(string accessPath | Redux::Internal::getRootStateAccessPath(accessPath) = node) > 1 and
  Redux::Internal::getRootStateAccessPath(path) = node
}

query predicate getRootStateAccessPath = Redux::Internal::getRootStateAccessPath/1;
