/**
 * @name Usage of APIs coming from external libraries
 * @description A list of 3rd party APIs used in the codebase. Excludes test and generated code.
 * @id java/telemetry/external-api
 * @kind diagnostic
 */

import java
import APIUsage
import ExternalAPI
import semmle.code.java.GeneratedFiles

// TODO [bm]: decide whether to drop the order by or
// turn Usage into string for diagnostic kind
// https://github.slack.com/archives/C01JJP3EF8E/p1627910071013000
from ExternalAPI api
where
  not api.isTestLibrary() and
  api.isInteresting()
select api.asCSV(api) as csv,
  count(Call c |
    c.getCallee() = api and
    not c.getFile() instanceof GeneratedFile
  ) as Usages, supportKind(api) as Kind order by Usages desc
