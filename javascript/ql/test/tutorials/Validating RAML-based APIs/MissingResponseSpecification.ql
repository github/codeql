/**
 * @name Missing status code specification
 * @description Using undocumented status codes in REST API methods may confuse client applications.
 * @kind problem
 * @problem.severity warning
 */

import javascript
import Osprey
import RAML

RAMLMethod getSpecification(OspreyMethod om) {
  exists(RAMLResource rr, File f, string rPath |
    rr.getLocation().getFile() = f and
    f = om.getDefinition().getAPI().getSpecFile() and
    rPath = om.getResourcePath() and
    rr.getPath() = rPath.regexpReplaceAll("/:([^/]+)/", "/{$1}/") and
    result = rr.getMethod(om.getVerb())
  )
}

from MethodResponseSetStatus mrss, RAMLMethod rm
where
  rm = getSpecification(mrss.getMethod()) and
  not exists(rm.getResponse(mrss.getStatusCode()))
select mrss, "Response " + mrss.getStatusCode() + " is not specified by $@.", rm, rm.toString()
