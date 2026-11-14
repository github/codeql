import python
import semmle.python.Concepts

from ThreatModelSource src
where
  src.getThreatModel() = "ai" and
  src.getSourceType() = "MCP server handler parameter" and
  exists(src.getLocation().getFile().getRelativePath())
select src, src.getSourceType()
