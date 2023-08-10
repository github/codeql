import swift
private import codeql.swift.dataflow.ExternalFlow

/**
 * An instance of the `Dictionary` type.
 */
class CanonicalDictionaryType extends BoundGenericType {
  CanonicalDictionaryType() { this.getName().matches("Dictionary<%") }
}
