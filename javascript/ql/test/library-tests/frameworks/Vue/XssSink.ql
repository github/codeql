import javascript
import semmle.javascript.security.dataflow.DomBasedXss

select any(DomBasedXss::Sink s)
