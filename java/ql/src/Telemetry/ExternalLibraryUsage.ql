/**
 * @name External libraries
 * @description A list of external libraries used in the code
 * @id java/telemetry/external-libs
 * @kind metric
 * @tags summary
 */

import java
import ExternalAPI

from int usages, string jarname
where
  usages =
    strictcount(Call c, ExternalAPI a |
      c.getCallee().getSourceDeclaration() = a and
      not c.getFile() instanceof GeneratedFile and
      a.jarContainer() = jarname and
      not a.isUninteresting()
    )
select jarname, usages order by usages desc
