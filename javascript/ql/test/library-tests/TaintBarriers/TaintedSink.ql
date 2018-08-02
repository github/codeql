import javascript
import ExampleConfiguration

from ExampleConfiguration cfg, DataFlow::Node source, DataFlow::Node sink
where cfg.hasFlow(source, sink)
select sink, source
