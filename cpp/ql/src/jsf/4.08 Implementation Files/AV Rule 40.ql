/**
 * @name AV Rule 40
 * @description Every implementation file shall include the header files that uniquely define the inline functions, types, and templates used.
 * @kind problem
 * @id cpp/jsf/av-rule-40
 * @problem.severity error
 * @tags correctness
 *       external/jsf
 */

import cpp

/*
 * The rule appears a bit under-specified, but looking at the rationale and examples
 * it is quite straightforward: the rule is intended to require the one-definition rule.
 * We check for types, inline functions and templates:
 *  - The definition is in a header file (not an implementation file)
 *  - There is only one definition
 *
 * Note: non-defining declarations are allowed to be repeated.
 *
 * LIMITATION: currently templates are not checked (extractor limitation)
 */

predicate relevant(Declaration d) {
  d instanceof UserType or
  d.(Function).hasSpecifier("inline")
}

predicate hasTwoDefinitions(Declaration d) {
  exists(Location l1, Location l2 |
    l1 = d.getDefinitionLocation() and
    l2 = d.getDefinitionLocation() and
    l1 != l2
  )
}

predicate definedInImplementationFile(Declaration d) {
  d.getDefinitionLocation().getFile() instanceof CppFile or
  d.getDefinitionLocation().getFile() instanceof CFile
}

from Declaration d, string message
where
  relevant(d) and
  (
    hasTwoDefinitions(d) and message = " should not have several definitions."
    or
    definedInImplementationFile(d) and message = " should be defined in a header file."
  ) and
  // Don't count member functions - the only way they can match this rule is by
  // being in a class definition that already matches, so it would be redundant
  not d instanceof MemberFunction
select d.getDefinitionLocation(), "AV Rule 40: " + d.getName() + message
