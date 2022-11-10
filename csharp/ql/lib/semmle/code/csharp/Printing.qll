/**
 * Provides predicates to pretty-print a C# qualified name.
 */

/**
 * Returns the concatenation of `qualifier` and `name`, separated by a dot.
 */
bindingset[qualifier, name]
string printQualifiedName(string qualifier, string name) {
  if qualifier = "" then result = name else result = qualifier + "." + name
}

/**
 * Returns the concatenation of `qualifier`, `type` and `name`, separated by a dot.
 */
bindingset[qualifier, type, name]
string printQualifiedName(string qualifier, string type, string name) {
  result = printQualifiedName(qualifier, type) + "." + name
}
