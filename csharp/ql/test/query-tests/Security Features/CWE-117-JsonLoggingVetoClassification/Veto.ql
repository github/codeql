import csharp
import semmle.code.csharp.security.dataflow.JsonLoggingConfiguration

from Element element, string reason
where jsonLoggingConfigurationVeto(element, reason)
select element, reason
