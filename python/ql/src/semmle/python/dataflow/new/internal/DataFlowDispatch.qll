import python
private import DataFlowPrivate as DataFlowPrivate

class DataFlowCall = DataFlowPrivate::DataFlowCall;

class DataFlowCallable = DataFlowPrivate::DataFlowCallable;

DataFlowCallable viableCallable(DataFlowCall call) { result = call.getCallable() }
