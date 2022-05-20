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

class BasicTaint extends TaintTracking::Configuration {
  BasicTaint() { this = "BasicTaint" }

  override predicate isSource(DataFlow::Node node) {
    node.(DataFlow::CallNode).getCalleeName() = "source"
  }

  override predicate isSink(DataFlow::Node node) {
    node = any(DataFlow::CallNode call | call.getCalleeName() = "sink").getAnArgument()
  }
}

query predicate taintFlow(DataFlow::Node source, DataFlow::Node sink) {
  any(BasicTaint cfg).hasFlow(source, sink)
}

query DataFlow::SourceNode reactComponentRef(ReactComponent component) {
  result = component.getAComponentCreatorReference()
}
