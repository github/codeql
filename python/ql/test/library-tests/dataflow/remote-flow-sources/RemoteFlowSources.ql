import python
import semmle.python.Concepts

from ThreatModelSource src
where src.getThreatModel() = "ai" and exists(src.getLocation().getFile().getRelativePath())
select src, src.getSourceType()
