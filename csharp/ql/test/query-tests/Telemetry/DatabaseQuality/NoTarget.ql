/**
 * @id test/missing-call-target
 * @kind problem
 * @problem.severity warning
 */

import csharp
import Telemetry.DatabaseQuality

from Call call
where not exists(call.getTarget())
select call, "Call without target $@.", call, call.toString()
