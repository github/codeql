/**
 * @name External libraries
 * @description A list of external libraries used in the code
 * @kind metric
 * @metricType callable
 * @id java/telemetry/external-libs
 */

import java
import ExternalAPI

from int usages, string jarname
where
  usages =
    strictcount(Call c, ExternalAPI a |
      c.getCallee() = a and
      not c.getFile() instanceof GeneratedFile and
      a.jarContainer() = jarname and
      a.isWorthSupporting()
    )
select jarname, usages order by usages desc
