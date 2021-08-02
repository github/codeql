/**
 * @name Usage of APIs coming from external libraries
 * @description A list of 3rd party APIs used in the codebase. Excludes test and generated code.
 * @id java/telemetry/external-api
 */

import java
import ExternalAPI
import semmle.code.java.GeneratedFiles

from ExternalAPI api
where
  not api.getDeclaringType() instanceof TestLibrary and
  isInterestingAPI(api)
select api.simpleName() as API,
  count(Call c |
    c.getCallee() = api and
    not c.getFile() instanceof GeneratedFile
  ) as Usages, supportKind(api) as Kind, api.getReturnType() as ReturnType,
  api.getDeclaringType().getPackage() as Package order by Usages desc
