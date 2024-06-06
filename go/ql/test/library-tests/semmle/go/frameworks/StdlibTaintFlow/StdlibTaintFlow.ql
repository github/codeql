/**
 * @kind problem
 */

import go

/* A special helper function used inside the test code */
class Link extends TaintTracking::FunctionModel {
  Link() { this.hasQualifiedName(_, "link") }

  override predicate hasTaintFlow(FunctionInput inp, FunctionOutput outp) {
    inp.isParameter(0) and outp.isParameter(1)
  }
}

predicate callResultisSource(DataFlow::Node source, DataFlow::CallNode call) {
  exists(Function fn | fn.hasQualifiedName(_, "newSource") |
    call = fn.getACall() and source = call.getResult()
  )
}

predicate callArgumentisSink(DataFlow::Node sink, DataFlow::CallNode call) {
  exists(Function fn | fn.hasQualifiedName(_, "sink") |
    call = fn.getACall() and sink = call.getArgument(1)
  )
}

module Config implements DataFlow::ConfigSig {
  predicate isSource(DataFlow::Node source) { callResultisSource(source, _) }

  predicate isSink(DataFlow::Node sink) { callArgumentisSink(sink, _) }
}

module Flow = TaintTracking::Global<Config>;

/**
 * True if the result of the provided sourceCall flows to the corresponding sink,
 * both marked by the same numeric first argument.
 */
predicate flowsToSink(DataFlow::CallNode sourceCall) {
  exists(DataFlow::Node source, DataFlow::Node sink, DataFlow::CallNode sinkCall |
    Flow::flow(source, sink) and
    (
      callResultisSource(source, sourceCall) and
      callArgumentisSink(sink, sinkCall) and
      sourceCall.getArgument(0).getIntValue() = sinkCall.getArgument(0).getIntValue()
    )
  )
}

/* Show only flow sources that DON'T flow to their dedicated sink. */
from DataFlow::CallNode sourceCall
where callResultisSource(_, sourceCall) and not flowsToSink(sourceCall)
select sourceCall, "No flow to its sink"
