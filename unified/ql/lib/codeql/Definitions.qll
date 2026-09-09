/**
 * Provides predicates related to jump-to-definition links in the code viewer.
 */

private import unified
private import codeql.unified.internal.StaticNameBinding

/**
 * Holds if `reference` refers to `definition`.
 */
cached
predicate definitionOf(Identifier reference, NameBinding definition, string kind) {
  definition = getStaticBindingTarget(reference) and
  not reference instanceof NameBinding and
  kind = "name"
}
