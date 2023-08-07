/**
 * INTERNAL use only. This is an experimental API subject to change without notice.
 *
 * This module provides extensible predicates for configuring which kinds of MaD models
 * are applicable to generic queries.
 */

private import ExternalFlowExtensions

/**
 * Holds if the specified kind of source model is supported for the current query.
 */
extensible private predicate supportedThreatModels(string kind);

/**
 * Holds if the specified kind of source model is containted within the specified group.
 */
extensible private predicate threatModelGrouping(string kind, string group);

/**
 * Gets the threat models that are direct descendants of the specified kind/group.
 */
private string getChildThreatModel(string group) { threatModelGrouping(result, group) }

/**
 * Holds if the source model kind `kind` is relevant for generic queries
 * under the current threat model configuration.
 */
predicate sourceModelKindConfig(string kind) {
  exists(string group | supportedThreatModels(group) and kind = getChildThreatModel*(group))
}
