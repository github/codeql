/**
 * Provides classes and predicates related to jump-to-definition links
 * in the code viewer.
 */

private import codeql.rust.elements.Variable
private import codeql.rust.elements.Locatable

private predicate localVariable(Locatable e, Variable def) { e = def.getAnAccess() }

/**
 * Gets an element, of kind `kind`, that element `use` uses, if any.
 */
cached
Variable definitionOf(Locatable use, string kind) {
  localVariable(use, result) and kind = "local variable"
}
