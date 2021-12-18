/**
 * @name Missing QLDoc for parameter
 * @description It is suspicious when a predicate has a parameter that is
 *              unmentioned in the qldoc, and the qldoc contains a
 *              code-fragment mentioning a non-parameter.
 * @kind problem
 * @problem.severity warning
 * @precision high
 * @id ql/missing-parameter-qldoc
 * @tags maintainability
 */

import ql

/**
 * Gets a fragment enclosed in backticks (`) from a QLDoc of the predicate `p`.
 * Skips code-blocks that are triple-quoted.
 */
private string getACodeFragment(Predicate p) {
  result = p.getQLDoc().getContents().regexpFind("`([^`]*)`(?!`)", _, _)
}

/** Gets a parameter name from `p`. */
private string getAParameterName(Predicate p) { result = p.getParameter(_).getName() }

/**
 * Gets the name of a parameter of `p` that is mentioned in any way in the QLDoc of `p`.
 * Also includes names that are mentioned in non-code fragments.
 */
private string getADocumentedParameter(Predicate p) {
  result = p.getQLDoc().getContents().regexpFind("\\b\\w[\\w_]*\\b", _, _) and
  result.toLowerCase() = getAParameterName(p).toLowerCase()
}

/**
 * Get something that looks like a parameter name from the QLDoc,
 * but which is not a parameter of `p`.
 */
private string getAMentionedNonParameter(Predicate p) {
  exists(string fragment | fragment = getACodeFragment(p) |
    result = fragment.substring(1, fragment.length() - 1)
  ) and
  result.regexpMatch("^[a-z]\\w+$") and
  not result.toLowerCase() = getAParameterName(p).toLowerCase() and
  not result = ["true", "false", "NaN"] and // keywords
  not result.regexpMatch("\\d+") and // numbers
  // predicates get mentioned all the time, it's fine.
  not result =
    any(Predicate pred | pred.getLocation().getFile() = p.getLocation().getFile()).getName() and
  // classes get mentioned all the time, it's fine.
  not result =
    any(TypeExpr t | t.getLocation().getFile() = p.getLocation().getFile())
        .getResolvedType()
        .getName()
}

/** Gets a parameter name from `p` that is not mentioned in the qldoc. */
private string getAnUndocumentedParameter(Predicate p) {
  result = getAParameterName(p) and
  not result.toLowerCase() = getADocumentedParameter(p).toLowerCase() and
  not result = ["config", "conf", "cfg"] // DataFlow configurations are often undocumented, and that's fine.
}

/** Holds if `p` has documented parameters, but `param` is undocumented */
private predicate missingDocumentation(Predicate p, string param) {
  param = getAnUndocumentedParameter(p) and
  exists(getADocumentedParameter(p))
}

/** Gets the one string containing the undocumented parameters from `p` */
private string getUndocumentedParameters(Predicate p) {
  result = strictconcat(string param | missingDocumentation(p, param) | param, ", or ")
}

/** Gets the parameter-like names mentioned in the QLDoc of `p` that are not parameters. */
private string getMentionedNonParameters(Predicate p) {
  result = strictconcat(string param | param = getAMentionedNonParameter(p) | param, ", and ")
}

from Predicate p
select p,
  "The QLDoc has no documentation for " + getUndocumentedParameters(p) + ", but the QLDoc mentions "
    + getMentionedNonParameters(p)
