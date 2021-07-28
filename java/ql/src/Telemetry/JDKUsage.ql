/**
 * @name JDK API Usage
 * @description A list of JDK APIs used in the source code.
 * @id java/telemetry/jdk-apis
 */

import java
import APIUsage

from Callable call, CompilationUnit cu
where
  cu = call.getCompilationUnit() and
  isJavaRuntime(call) and
  isInterestingAPI(call)
select cu, call as API, count(Call c | c.getCallee() = call) as calls order by calls desc
