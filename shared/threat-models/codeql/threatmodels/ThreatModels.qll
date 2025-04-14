/**
 * INTERNAL use only. This is an experimental API subject to change without notice.
 *
 * This module provides extensible predicates for configuring which kinds of MaD models
 * are applicable to generic queries.
 */

/**
 * Holds configuration entries to specify which threat models are enabled.
 *
 * - `kind` - Specifies the threat model to configure. This can be the name of a specific threat
 *   model (for example, `environment`), a group (`local`), or `all`.
 * - `enable` - `true` to enable the specified threat model (and its children), or `false` to disable it.
 * - `priority` - The order in which the configuration should be applied. Lower values are applied first.
 *
 * The final configuration is the result of processing each row in ascending order of its `priority` column.
 * For example:
 * - `{ kind: "all", enable: true, priority: 0 }`
 * - `{ kind: "remote", enable: false, priority: 1 }`
 * - `{ kind: "environment", enable: true, priority: 2 }`
 * This configuration first enables all threat models, then disables the `remote` group, and finally re-enables
 * the `environment` threat model.
 */
extensible predicate threatModelConfiguration(string kind, boolean enable, int priority);

/**
 * Holds if the specified kind of source model is containted within the specified group.
 */
extensible private predicate threatModelGrouping(string kind, string group);

/** Holds if the specified threat model kind is mentioned in either the configuration or grouping table. */
predicate knownThreatModel(string kind) {
  threatModelConfiguration(kind, _, _) or
  threatModelGrouping(kind, _) or
  threatModelGrouping(_, kind) or
  kind = "all"
}

/**
 * Gets the threat model group that directly contains the specified threat model.
 */
private string getParentThreatModel(string child) {
  threatModelGrouping(child, result)
  or
  knownThreatModel(child) and child != "all" and result = "all"
}

/**
 * Holds if the `enabled` column is set to `true` of the highest-priority configuration row
 * whose `kind` column includes the specified threat model kind.
 */
private predicate threatModelEnabled(string kind) {
  // Find the highest-priority configuration row whose `kind` column includes the specified threat
  // model kind. If such a row exists and its `enabled` column is `true`, then the threat model is
  // enabled.
  knownThreatModel(kind) and
  max(boolean enabled, int priority |
    exists(string configuredKind | configuredKind = getParentThreatModel*(kind) |
      threatModelConfiguration(configuredKind, enabled, priority)
    )
  |
    enabled order by priority
  ) = true
}

/**
 * Holds if the source model kind `kind` is relevant for generic queries
 * under the current threat model configuration.
 */
bindingset[kind]
predicate currentThreatModel(string kind) {
  threatModelEnabled(kind)
  or
  // For any threat model kind not mentioned in the configuration or grouping tables, its state of
  // enablement is controlled only by the entries that specifiy the "all" kind.
  not knownThreatModel(kind) and threatModelEnabled("all")
}
