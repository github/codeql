/**
 * @name External libraries
 * @description A list of external libraries used in the code
 * @kind metric
 * @tags summary telemetry
 * @id java/telemetry/external-libs
 */

import java
import ExternalApi

private predicate getRelevantUsages(string jarname, int usages) {
  usages =
    strictcount(Call c, ExternalApi a |
      c.getCallee().getSourceDeclaration() = a and
      not c.getFile() instanceof GeneratedFile and
      a.jarContainer() = jarname
    )
}

private int getOrder(string jarname) {
  jarname =
    rank[result](string jar, int usages |
      getRelevantUsages(jar, usages)
    |
      jar order by usages desc, jar
    )
}

from ExternalApi api, string jarname, int usages
where
  jarname = api.jarContainer() and
  getRelevantUsages(jarname, usages) and
  getOrder(jarname) <= resultLimit()
select jarname, usages order by usages desc
