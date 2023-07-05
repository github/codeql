import javascript
import API
import DataFlow::PathGraph

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
    sink = API::moduleImport("jsonwebtoken").getMember("decode").getParameter(0).asSink() or
    sink = API::moduleImport("jsonwebtoken").getMember("verify").getParameter(0).asSink()
  }
}

from JWTDecodeConfig cfg, DataFlow::Node source
where
  if
    forall(DataFlow::Node sink | cfg.hasFlow(source, sink) |
      sink = API::moduleImport("jsonwebtoken").getMember("verify").getParameter(0).asSink()
    )
  then not source = source
  else source = source
select source
