import ruby
import codeql.ruby.DataFlow

from DataFlow::Node pred, DataFlow::Node succ
where DataFlow::localFlowStep(pred, succ)
select pred, succ
