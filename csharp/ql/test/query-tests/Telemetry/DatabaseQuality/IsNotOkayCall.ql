/**
 * @id test/missing-call-target
 * @kind problem
 * @problem.severity warning
 */

import csharp
import Telemetry.DatabaseQuality

from Call call
where CallTargetStats::isNotOkCall(call)
select call, "Call without target $@.", call, call.toString()
