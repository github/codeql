/**
 * @name External libraries
 * @description A list of external libraries used in the code
 * @kind metric
 * @tags summary
 * @id java/telemetry/external-libs
 */

import java
import ExternalApi

from int usages, string jarname
where
  usages =
    strictcount(Call c, ExternalApi a |
      c.getCallee().getSourceDeclaration() = a and
      not c.getFile() instanceof GeneratedFile and
      a.jarContainer() = jarname and
      not a.isUninteresting()
    )
select jarname, usages order by usages desc
