import javascript
import utils.test.InlineExpectationsTest

module StreamPipeConfig implements DataFlow::ConfigSig {
  predicate isSource(DataFlow::Node source) {
    source.getFile().getBaseName() = "stream-pipe.js" and
    source.(DataFlow::CallNode).getCalleeName() = "source"
  }

  predicate isSink(DataFlow::Node sink) {
    exists(DataFlow::CallNode call |
      call.getFile().getBaseName() = "stream-pipe.js" and
      call.getCalleeName() = "sink" and
      sink = call.getArgument(0)
    )
  }
}

module Flow = DataFlow::Global<StreamPipeConfig>;

module InlineTest implements TestSig {
  string getARelevantTag() { result = "flow" }

  predicate hasActualResult(Location location, string element, string tag, string value) {
    tag = "flow" and
    element = "" and
    exists(DataFlow::CallNode source, DataFlow::Node sink |
      Flow::flow(source, sink) and
      value = source.getArgument(0).getStringValue() and
      location = sink.getLocation()
    )
  }
}

import MakeTest<InlineTest>
