/**
 * @name External libraries
 * @description A list of external libraries used in the code
 * @id java/telemetry/external-libs
 */

import java
import ExternalAPI

from ExternalAPI api
where not api.getDeclaringType() instanceof TestLibrary
// TODO [bm]: the count is not aggregated and we have the same jar with multiple usages, e.g.
// 1	protobuf-java-3.17.3.jar	373
// 2	protobuf-java-3.17.3.jar	48
select api.jarName() as jarname, count(Call c | c.getCallee() = api) as Usages
order by Usages desc