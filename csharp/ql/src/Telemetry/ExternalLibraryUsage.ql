/**
 * @name External libraries
 * @description A list of external libraries used in the code
 * @kind metric
 * @tags summary
 * @id csharp/telemetry/external-libs
 */

import csharp
import ExternalAPI

from int usages, string info
where
  usages =
    strictcount(Call c, ExternalAPI api |
      c.getTarget() = api and
      api.getInfoPrefix() = info and
      not api.isUninteresting()
    )
select info, usages order by usages desc
