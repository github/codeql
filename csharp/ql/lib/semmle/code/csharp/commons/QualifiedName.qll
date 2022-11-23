/**
 * Provides predicates related to C# qualified name.
 */

/**
 * Returns the concatenation of `qualifier` and `name`, separated by a dot.
 */
bindingset[namespace, name]
string printQualifiedName(string namespace, string name) {
  if namespace = "" then result = name else result = namespace + "." + name
}

/**
 * Returns the concatenation of `qualifier`, `type` and `name`, separated by a dot.
 */
bindingset[namespace, type, name]
string printQualifiedName(string namespace, string type, string name) {
  result = printQualifiedName(namespace, type) + "." + name
}

private string getNameSplitter() { result = "(.*)\\.([^\\.]+)$" }

/**
 */
bindingset[qualifiedName]
predicate splitQualifiedName(string qualifiedName, string qualifier, string name) {
  if qualifiedName.regexpMatch(getNameSplitter())
  then
    qualifier = qualifiedName.regexpCapture(getNameSplitter(), 1) and
    name = qualifiedName.regexpCapture(getNameSplitter(), 2)
  else (
    qualifier = "" and name = qualifiedName
  )
}
