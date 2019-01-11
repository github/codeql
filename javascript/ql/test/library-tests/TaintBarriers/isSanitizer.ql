import javascript
import ExampleConfiguration

from ExampleConfiguration cfg, DataFlow::Node n
where cfg.isSanitizer(n)
select n, cfg
