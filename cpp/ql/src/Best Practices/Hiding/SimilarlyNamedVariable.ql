import cpp

/**
 * Gets a string with characters that might be mistaken for one-another replaced with a
 * representative character.  For example for "v1" or "vl", we get "vl".
 */
bindingset[s]
string representativeString(string s) {
  result = s
    .replaceAll("0", "O")
    .replaceAll("1", "l")
    .replaceAll("I", "l")
    //.replaceAll("2", "Z")
    .replaceAll("5", "S")
    //.replaceAll("6", "b")
    //.replaceAll("9", "q")
    //.replaceAll("g", "q")
}

/**
 * Holds if `v` is called `name`, with representative name `repName`.
 */
predicate varHasName(Variable v, Element scope, string name, string repName) {
  v.getParentScope() = scope and
  v.getName() = name and
  representativeString(name) = repName and

  // exclusions
  not v.isInMacroExpansion()
}

from
  Variable v1, Element scope1, string name1,
  Variable v2, Element scope2, string name2,
  string repName
where
  varHasName(v1, scope1, name1, repName) and
  varHasName(v2, scope2, name2, repName) and
  name1 != name2 and
  scope2 = scope1.getParentScope*()
select
  v1, "This variable has name '" + name1 + "', which could be confused with similarly named '$@'.", v2, name2
