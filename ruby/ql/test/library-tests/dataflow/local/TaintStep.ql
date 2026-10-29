import codeql.ruby.DataFlow
import codeql.ruby.TaintTracking

from DataFlow::Node pred, DataFlow::Node succ
where TaintTracking::localTaintStep(pred, succ)
select pred, succ
