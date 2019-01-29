import javascript
import semmle.javascript.security.dataflow.DomBasedXss

from DomBasedXss::VHtmlSourceWrite w, DataFlow::Node pred, DataFlow::Node succ
where w.step(pred, succ)
select w, pred, succ
