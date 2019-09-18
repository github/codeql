import javascript
import ExampleConfiguration

from TaintTracking::SanitizerGuardNode g, Expr e, boolean b, ExampleConfiguration cfg
where g.sanitizes(b, e)
select g, cfg, b, e
