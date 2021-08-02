/**
 * @name External libraries
 * @description A list of external libraries used in the code
 * @kind diagnostic
 * @id java/telemetry/external-libs
 */

import java
import ExternalAPI

from int Usages, JarFile jar
where
  jar = any(ExternalAPI api).getCompilationUnit().getParentContainer*() and
  Usages =
    strictcount(Call c, ExternalAPI a |
      c.getCallee() = a and
      not c.getFile() instanceof GeneratedFile and
      a.getCompilationUnit().getParentContainer*() = jar and
      not a.isTestLibrary()
    )
select jar.getFile().getStem() + "." + jar.getFile().getExtension(), Usages order by Usages desc
