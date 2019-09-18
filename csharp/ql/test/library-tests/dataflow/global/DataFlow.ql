import csharp
import Common

from Config c, DataFlow::Node source, DataFlow::Node sink
where c.hasFlow(source, sink)
select sink
