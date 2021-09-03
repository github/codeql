/**
 * @name External libraries
 * @description A list of external libraries used in the code
 * @kind metric
 * @metricType callable
 * @id java/telemetry/external-libs
 */

import java
import ExternalAPI

from int Usages, string jarname
where
  Usages =
    strictcount(Call c, ExternalAPI a |
      c.getCallee() = a and
      not c.getFile() instanceof GeneratedFile and
      a.jarContainer() = jarname and
      not a.isTestLibrary()
    )
select jarname, Usages order by Usages desc
