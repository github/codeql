/**
 * @kind test-postprocess
 */

import semmle.code.java.dataflow.ExternalFlow

string sinkModuleNamespaceRoots() {
  exists(string namespace, int dotIdx |
    sinkModel(namespace, _, _, _, _, _, _, _, _, _) and
    dotIdx = namespace.indexOf(".", 0, 0) and
    result = namespace.substring(0, dotIdx)
  )
}

from int line, string content
where content = rank[line](string c | c = sinkModuleNamespaceRoots() | c)
select "#select", line, 0, content
