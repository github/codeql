/**
 * Provides a Java-specific instantiation of the `AlertFiltering` module.
 */

private import codeql.util.AlertFiltering
private import semmle.code.Location

module AlertFiltering = AlertFilteringImpl<Location>;
