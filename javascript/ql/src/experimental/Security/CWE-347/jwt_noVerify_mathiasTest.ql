import javascript
import DataFlow::PathGraph
import DataFlow

/** Holds if `source` flows to the first parameter of jsonwebtoken.verify */
predicate isSafe(JWTDecodeConfig cfg, DataFlow::Node source) {
  exists(DataFlow::Node sink |
    cfg.hasFlow(source, sink) and
    sink = API::moduleImport("jsonwebtoken").getMember("verify").getParameter(0).asSink()
  )
}

/**
 * Holds if:
 * - `source` does not flow to the first parameter of `jsonwebtoken.verify`, and
 * - `source` flows to the first parameter of `jsonwebtoken.decode`
 */
predicate isVulnerable(JWTDecodeConfig cfg, DataFlow::Node source, DataFlow::Node sink) {
  not isSafe(cfg, source) and // i.e., source does not flow to a verify call
  cfg.hasFlow(source, sink) and // but it does flow to something else
  sink = API::moduleImport("jsonwebtoken").getMember("decode").getParameter(0).asSink() // and that something else is a call to decode.
}

class JWTDecodeConfig extends TaintTracking::Configuration {
  JWTDecodeConfig() { this = "JWTConfig" }

  override predicate isSource(DataFlow::Node source) {
    source =
      API::moduleImport("jsonwebtoken")
          .getMember("decode")
          .getParameter(0)
          .asSink()
          .getALocalSource()
  }

  override predicate isSink(DataFlow::Node sink) {
    sink = API::moduleImport("jsonwebtoken").getMember("decode").getParameter(0).asSink()
    or
    sink = API::moduleImport("jsonwebtoken").getMember("verify").getParameter(0).asSink()
  }
}

from JWTDecodeConfig cfg, DataFlow::PathNode source, DataFlow::PathNode sink
where cfg.hasFlowPath(source, sink)
select source.getNode(), source, sink, "this token $@.", sink.getNode(), "file system operation"
