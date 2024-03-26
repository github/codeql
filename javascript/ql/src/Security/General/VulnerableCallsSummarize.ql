/**
 * @name Summarize calls to vulnerable functions
 * @kind table
 * @id js/vulnerable-calls-summarize
 */

import javascript
import semmle.javascript.security.VulnerableCalls

query predicate vulnerableCallModel(string type, string path, string id) {
  ExportedVulnerableCalls::pathToNode(type, path, getAVulnerableFunctionApiNode(id))
}

query predicate vulnerableCallLocations(DataFlow::InvokeNode invoke, string id) {
  invoke = ModelOutput::getAVulnerableCall(id)
}

query predicate typeModel = ExportedVulnerableCalls::typeModel/3;
