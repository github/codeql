import python
import semmle.python.Concepts

from ActiveThreatModelSource source
where source.getThreatModel() = "database"
select source
