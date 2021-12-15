/**
 * @name Misspelled variable name
 * @description Misspelling a variable name implicitly introduces a global
 *              variable, which may not lead to a runtime error, but is
 *              likely to give wrong results.
 * @kind problem
 * @problem.severity warning
 * @id js/misspelled-variable-name
 * @tags maintainability
 *       readability
 *       correctness
 * @precision very-high
 */

import Misspelling

/**
 * Gets the number of times a local variable with name `name` occurs in the program.
 */
bindingset[name]
int localAcceses(string name) {
  result = count(VarAccess acc | acc.getName() = name and not acc instanceof GlobalVarAccess)
}

/**
 * Gets the number of times a global variable with name `name` occurs in the program.
 */
bindingset[name]
int globalAccesses(string name) { result = count(GlobalVarAccess acc | acc.getName() = name) }

/**
 * Holds if our heuristic says that the local variable `lvd` seems to be a misspelling of the global variable `gva`.
 * Otherwise the global variable is likely the misspelling.
 */
predicate globalIsLikelyCorrect(GlobalVarAccess gva, VarDecl lvd) {
  // If there are more occurrences of the global (by a margin of at least 2), and the local is missing one letter compared to the global.
  globalAccesses(gva.getName()) >= localAcceses(lvd.getName()) + 2 and
  lvd.getName().length() = gva.getName().length() - 1
  or
  // Or if there are many more of the global.
  globalAccesses(gva.getName()) > 2 * localAcceses(lvd.getName()) + 2
}

from GlobalVarAccess gva, VarDecl lvd, string msg
where
  misspelledVariableName(gva, lvd) and
  if globalIsLikelyCorrect(gva, lvd)
  then msg = "$@ may be a typo for '" + gva + "'."
  else msg = "'" + gva + "' may be a typo for variable $@."
select gva, msg, lvd, lvd.getName()
