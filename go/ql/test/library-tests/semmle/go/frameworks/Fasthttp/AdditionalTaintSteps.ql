import go
import TestUtilities.InlineFlowTest
import semmle.go.security.RequestForgeryCustomizations

module Config implements DataFlow::ConfigSig {
  predicate isSource(DataFlow::Node source) {
    exists(DataFlow::MethodCallNode m |
      m.getTarget()
          .hasQualifiedName("github.com/valyala/fasthttp", "URI",
            ["SetHost", "SetHostBytes", "Update", "UpdateBytes"]) and
      source = m.getArgument(0)
      or
      m.getTarget().hasQualifiedName("github.com/valyala/fasthttp", "URI", "Parse") and
      source = m.getArgument([0, 1])
    )
    or
    exists(DataFlow::MethodCallNode m |
      m.getTarget()
          .hasQualifiedName("github.com/valyala/fasthttp", "Request",
            ["SetRequestURI", "SetRequestURIBytes", "SetURI", "String", "SetHost", "SetHostBytes"]) and
      source = m.getArgument(0)
    )
  }

  predicate isSink(DataFlow::Node source) {
    exists(DataFlow::MethodCallNode m, DataFlow::Variable frn |
      (
        m.getTarget()
            .hasQualifiedName("github.com/valyala/fasthttp", "URI",
              ["SetHost", "SetHostBytes", "Update", "UpdateBytes"])
        or
        m.getTarget().hasQualifiedName("github.com/valyala/fasthttp", "URI", "Parse")
      ) and
      frn.getARead() = m.getReceiver() and
      source = frn.getARead()
    )
    or
    exists(DataFlow::MethodCallNode m, DataFlow::Variable frn |
      m.getTarget()
          .hasQualifiedName("github.com/valyala/fasthttp", "Request",
            ["SetRequestURI", "SetRequestURIBytes", "SetURI", "String", "SetHost", "SetHostBytes"]) and
      frn.getARead() = m.getReceiver() and
      source = frn.getARead()
    )
  }
}

import TaintFlowTest<Config>
