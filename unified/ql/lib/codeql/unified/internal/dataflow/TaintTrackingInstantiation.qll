private import unified
private import AllDataFlow
private import codeql.dataflow.TaintTracking

module TaintTrackingInput implements InputSig<Location, DataFlowInput> {
  predicate defaultTaintSanitizer(Node node) { none() } // TODO

  predicate defaultAdditionalTaintStep(Node src, Node sink, string model) { none() } // TODO

  bindingset[node]
  predicate defaultImplicitTaintRead(Node node, ContentSet c) { none() } // TODO

  predicate speculativeTaintStep(Node src, Node sink) { none() } // TODO
}

module TaintTrackingOutput = TaintFlowMake<Location, DataFlowInput, TaintTrackingInput>;
