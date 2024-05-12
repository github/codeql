/**
 * This file contains query predicates for use when gathering metrics at scale using Multi Repo
 * Variant Analysis.
 */

private import java
private import AutomodelAlertSinkUtil

/**
 * Holds if `alertCount` is the number of alerts for the query with ID `queryId` for which the
 * sinks correspond to the given `ai-generated` sink model.
 */
query predicate sinkModelCountPerQuery(
  string queryId, int alertCount, string package, string type, boolean subtypes, string name,
  string signature, string input, string ext, string kind, string provenance
) {
  exists(SinkModel s |
    sinkModelTallyPerQuery(queryId, alertCount, s) and
    s.getProvenance() = "ai-generated" and
    s.getPackage() = package and
    s.getType() = type and
    s.getSubtypes() = subtypes and
    s.getName() = name and
    s.getSignature() = signature and
    s.getInput() = input and
    s.getExt() = ext and
    s.getKind() = kind and
    s.getProvenance() = provenance
  )
}

/**
 * Holds if `instanceCount` is the number of instances corresponding to the given `ai-generated`
 * sink model (as identified by the `package`, `name`, `input`, etc.).
 */
query predicate instanceCount(
  int instanceCount, string package, string type, boolean subtypes, string name, string signature,
  string input, string ext, string kind, string provenance
) {
  exists(SinkModel s |
    instanceCount = s.getInstanceCount() and
    instanceCount > 0 and
    s.getProvenance() = "ai-generated" and
    s.getPackage() = package and
    s.getType() = type and
    s.getSubtypes() = subtypes and
    s.getName() = name and
    s.getSignature() = signature and
    s.getInput() = input and
    s.getExt() = ext and
    s.getKind() = kind and
    s.getProvenance() = provenance
  )
}

// MRVA requires a select clause, so we repurpose it to tell us which query predicates had results.
from string hadResults
where
  sinkModelCountPerQuery(_, _, _, _, _, _, _, _, _, _, _) and hadResults = "sinkModelCountPerQuery"
  or
  instanceCount(_, _, _, _, _, _, _, _, _, _) and hadResults = "instanceCount"
select hadResults
