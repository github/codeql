import javascript
import ExampleConfiguration

from ExampleConfiguration cfg, DataFlow::Node n
where cfg.isBarrier(n)
select n, cfg
