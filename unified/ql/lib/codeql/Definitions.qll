/**
 * Provides predicates related to jump-to-definition links in the code viewer.
 */

private import unified
private import codeql.unified.internal.StaticNameBinding

/**
 * Holds if `reference` refers to `definition`.
 */
cached
predicate definitionOf(Identifier reference, NameDeclaration definition, string kind) {
  reference = trackNameDeclaration(definition).asIdentifier() and
  not reference instanceof NameDeclaration and
  kind = "name"
}
