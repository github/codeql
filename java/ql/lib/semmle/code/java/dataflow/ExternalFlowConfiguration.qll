/**
 * This module provides extensible predicates for configuring which kinds of MaD models
 * are applicable to a given query.
 */

import ExternalFlowExtensions

extensible predicate supportedThreatModel(string kind);

extensible predicate threatModelGrouping(string kind, string group);

/**
 * Finds all of the threat models that are ancestors of the specified kind.
 */
private string parentThreatModel(string kind) {
  threatModelGrouping(kind, result)
  or
  exists(string parent | parentThreatModel(kind) = parent | threatModelGrouping(parent, result))
}

/**
 * Finds all of the threat models that are children of the specified group.
 */
private string childThreatModel(string group) {
  threatModelGrouping(result, group)
  or
  exists(string child | childThreatModel(group) = child | threatModelGrouping(result, child))
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
}
