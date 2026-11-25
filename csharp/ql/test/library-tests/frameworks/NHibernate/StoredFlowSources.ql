import csharp
import semmle.code.csharp.security.dataflow.flowsources.Stored

from StoredFlowSource source
where not source.getLocation().getFile().getAbsolutePath().contains("/resources/stubs/")
select source
