import csharp
import semmle.code.csharp.security.dataflow.flowsources.Stored

from StoredFlowSource source
where not source.getLocation().getFile().getAbsolutePath().matches("%/resources/stubs/%")
select source
