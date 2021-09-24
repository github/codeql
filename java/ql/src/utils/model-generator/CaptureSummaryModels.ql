/**
 * @name TBD
 * @description TBD
 * @id TBD
 */

import java
import ModelGeneratorUtils

string captureFlow(Callable api) { result = captureQualifierFlow(api) }

string captureQualifierFlow(Callable api) {
  exists(ReturnStmt rtn |
    rtn.getEnclosingCallable() = api and
    rtn.getResult() instanceof ThisAccess
  ) and
  result = asValueModel(api, "Argument[-1]", "ReturnValue")
}

// TODO: handle cases like Ticker
// TODO: "com.google.common.base;Converter;true;convertAll;(Iterable);;Element of Argument[0];Element of ReturnValue;taint",
// TODO: infer interface from multiple implementations? e.g. UriComponentsContributor
// TODO: distinguish between taint and value flows. If we find a value flow, omit the taint flow
class TargetAPI extends Callable {
  TargetAPI() {
    this.isPublic() and
    this.fromSource() and
    this.getDeclaringType().isPublic() and
    not this.getCompilationUnit().getFile().getAbsolutePath().matches("%src/test/%") and
    not this.getCompilationUnit().getFile().getAbsolutePath().matches("%src/guava-tests/%")
  }
}

from TargetAPI api, string flow
where flow = captureFlow(api)
select flow order by flow
