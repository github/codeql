import csharp
import Common

from Config c, DataFlow::Node source, DataFlow::Node sink, string s
where c.hasFlow(source, sink)
  and s = sink.toString()
select s
order by s asc
