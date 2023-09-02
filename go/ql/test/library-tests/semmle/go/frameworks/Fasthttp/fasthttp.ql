import go
import semmle.go.frameworks.Fasthttp

from Fasthttp::AdditionalStep a, DataFlow::Node pred, DataFlow::Node succ
where a.hasTaintStep(pred, succ)
select pred, succ, any(UntrustedFlowSource s)
