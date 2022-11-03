import csharp
import semmle.code.csharp.commons.ConsistencyChecks

from Element e, string m
where SsaChecks::ssaConsistencyFailure(e, m)
select e, m
