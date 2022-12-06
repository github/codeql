/**
 * Provides predicates related to C# qualified names.
 */

/**
 * Returns the concatenation of `qualifier` and `name`, separated by a dot.
 */
bindingset[qualifier, name]
string getQualifiedName(string qualifier, string name) {
  if qualifier = "" then result = name else result = qualifier + "." + name
}

/**
 * Returns the concatenation of `namespace`, `type` and `name`, separated by a dot.
 */
bindingset[namespace, type, name]
string getQualifiedName(string namespace, string type, string name) {
  result = getQualifiedName(namespace, type) + "." + name
}

/**
 * Holds if `qualifiedName` is the concatenation of `qualifier` and `name`, separated by a dot.
 */
bindingset[qualifiedName]
predicate splitQualifiedName(string qualifiedName, string qualifier, string name) {
  exists(string nameSplitter | nameSplitter = "(.*)\\.([^\\.]+)$" |
    qualifier = qualifiedName.regexpCapture(nameSplitter, 1) and
    name = qualifiedName.regexpCapture(nameSplitter, 2)
    or
    not qualifiedName.regexpMatch(nameSplitter) and
    qualifier = "" and
    name = qualifiedName
  )
}
