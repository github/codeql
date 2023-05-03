/**
 * This module provides extensible predicates for configuring which kinds of MaD models
 * are applicable to a given query.
 */

private import ExternalFlowExtensions

/**
 * Holds if the specified kind of source model is supported for the current query.
 */
extensible private predicate supportedThreatModel(string kind);

/**
 * Holds if the specified kind of source model is containted within the specified group.
 */
extensible predicate threatModelGrouping(string kind, string group);

/**
 * Finds all of the threat models that are ancestors of the specified kind.
 */
private string parentThreatModel(string kind) {
  exists(string parent | threatModelGrouping(kind, parent) |
    result = parent or result = parentThreatModel(parent)
  )
}

/**
 * Finds all of the threat models that are descendants of the specified kind/group.
 */
private string childThreatModel(string group) {
  exists(string child | threatModelGrouping(child, group) |
    result = child or result = childThreatModel(child)
  )
}

/**
 * Holds if source models of the specified kind are
 * supported for the current query.
 */
bindingset[kind]
predicate supportedSourceModel(string kind) {
  // expansive threat model includes all kinds
  supportedThreatModel("expansive")
  or
  // check if this kind is supported directly
  supportedThreatModel(kind)
  or
  // check if one of this kind's ancestors are supported
  exists(string group | group = parentThreatModel(kind) | supportedThreatModel(group))
  or
  // if supportedThreatModel is empty, check if kind is a subtype of "standard"
  not supportedThreatModel(_) and
  ("standard" = parentThreatModel(kind) or "standard" = kind)
}

private string getGlobalGroups() { result = ["standard", "expansive"] }

/**
 * A class that represents a kind of any model or group.
 */
private class Kind extends string {
  Kind() {
    sourceModel(_, _, _, _, _, _, _, this, _) or
    sinkModel(_, _, _, _, _, _, _, this, _) or
    summaryModel(_, _, _, _, _, _, _, _, this, _) or
    experimentalSourceModel(_, _, _, _, _, _, _, this, _, _) or
    experimentalSinkModel(_, _, _, _, _, _, _, this, _, _) or
    experimentalSummaryModel(_, _, _, _, _, _, _, _, this, _, _) or
    supportedThreatModel(this) or
    threatModelGrouping(this, _) or
    threatModelGrouping(_, this) or
    this = getGlobalGroups()
  }
}

/**
 * Gets the related source model kind(s) under the specified threat model.
 */
string relatedSourceModel(Kind kind) {
  // Use the kinds provided by the query
  result = kind
  or
  // Use all kinds regardless of the query.
  supportedThreatModel("expansive") and
  result = kind and
  sourceModel(_, _, _, _, _, _, _, result, _)
  or
  // Use the kinds that are provided by the threat model in case it is not standard or expansive.
  exists(string model | not model = getGlobalGroups() and supportedThreatModel(model) |
    result = model
    or
    exists(string child | child = childThreatModel(model) | result = child)
  )
}
