/**
 * @id test-id
 * @name Test
 * @description Test description
 * @tags test
 */

import csharp
import semmle.code.csharp.frameworks.microsoft.ServiceStack::ServiceStackSQL

from TaintTrackingConfiguration c, DataFlow::PathNode source, DataFlow::PathNode sink
where c.hasFlowPath(source, sink)
select sink.getNode(), source, sink, "Query might include code from $@.", source,
  ("this " + getSourceType(source.getNode()))
  
