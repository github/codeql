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
 * Gets all kinds of threat models.
 */
private string getAllKinds() { sourceModel(_, _, _, _, _, _, _, result, _) }

/**
 * Gets the related source model kinds under the current threat model.
 */
bindingset[kind]
string getSourceModelKinds(string kind) {
  supportedThreatModel("standard") and
  result = kind
  or
  // expansive threat model includes all kinds.
  supportedThreatModel("expansive") and
  result = getAllKinds()
  or
  // check if one of this kind's ancestors are supported
  exists(string group | group = parentThreatModel(kind) |
    supportedThreatModel(group) and result = childThreatModel(group)
  )
}
