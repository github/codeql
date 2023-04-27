import csharp
import Common

from DataFlow::Node source, DataFlow::Node sink
where Flow::flow(source, sink)
select sink
