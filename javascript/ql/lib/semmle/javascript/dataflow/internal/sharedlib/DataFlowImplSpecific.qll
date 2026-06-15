private import javascript

// This file provides the input to FlowSummaryImpl.qll, which is shared via identical-files.json.
module Private {
  import semmle.javascript.dataflow.internal.DataFlowPrivate
}

module Public {
  import semmle.javascript.dataflow.internal.Contents::Public

  class Node = DataFlow::Node;
}
