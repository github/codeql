/**
* @name SQL query built from user-controlled sources
* @description Building a SQL query from user-controlled sources is vulnerable to insertion of
*              malicious SQL code by the user.
* @kind problem
* @problem.severity error
* @precision high
* @id cs/sql-injection
* @tags security
*       external/cwe/cwe-089
*/

import csharp
import semmle.code.csharp.security.dataflow.SqlInjection::SqlInjection

from TaintTrackingConfiguration c, RemoteFlowSource source, Sink sink
where c.hasFlow(source, sink)
select sink, "Query might include code from $@.", source, ("this " + source.getSourceType())
