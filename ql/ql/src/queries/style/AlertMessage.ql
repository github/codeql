/**
 * @name Alert message style violation
 * @description An alert message that doesn't follow the style guide is harder for end users to digest.
 *              See the style guide here: https://github.com/github/codeql/blob/main/docs/query-metadata-style-guide.md#alert-messages
 * @kind problem
 * @problem.severity warning
 * @id ql/alert-message-style-violation
 * @precision high
 */

import ql

AstNode getASubExpression(Select sel) {
  result = sel.getExpr(_)
  or
  result = getASubExpression(sel).getAChild()
}

/** Gets the `index`th part of the select statement. */
private AstNode getSelectPart(Select sel, int index) {
  result =
    rank[index](AstNode n, Location loc |
      (
        n = getASubExpression(sel) and loc = n.getLocation()
        or
        // TODO: Use dataflow instead.
        // the strings are behind a predicate call.
        exists(Call c, Predicate target | c = getASubExpression(sel) and loc = c.getLocation() |
          c.getTarget() = target and
          (
            target.getBody().(ComparisonFormula).getAnOperand() = n
            or
            exists(ClassPredicate sub | sub.overrides(target) |
              sub.getBody().(ComparisonFormula).getAnOperand() = n
            )
          )
        )
        or
        // the string is a variable that is assigned in the `where` clause.
        exists(VarAccess v, ComparisonFormula comp, String str |
          v = getASubExpression(sel) and
          loc = v.getLocation() and
          comp.hasOperands(v.getDeclaration().getAnAccess(), str) and
          n = str
        )
      )
    |
      n
      order by
        loc.getStartLine(), loc.getStartColumn(), loc.getEndLine(), loc.getEndColumn(),
        loc.getFile().getRelativePath()
    )
}

/**
 * Gets a string element that is the last part of the message, that doesn't end with a period.
 *
 * For example:
 * ```CodeQL
 * select foo(), "This is a description" // <- bad
 *
 * select foo(), "This is a description." // <- good
 * ```
 */
String shouldHaveFullStop(Select sel) {
  result =
    max(AstNode str, int i |
      str.getParent*() = sel.getMessage() and str = getSelectPart(sel, i)
    |
      str order by i
    ) and
  not result.getValue().matches("%.") and
  not result.getValue().matches("%?")
}

/**
 * Gets a string element that is the first part of the message, that starts with a lower case letter.
 *
 * For example:
 * ```CodeQL
 * select foo(), "this is a description." // <- bad
 *
 * select foo(), "This is a description." // <- good
 * ```
 */
String shouldStartCapital(Select sel) {
  result =
    min(AstNode str, int i |
      str.getParent*() = sel.getMessage() and str = getSelectPart(sel, i)
    |
      str order by i
    ) and
  result.getValue().regexpMatch("^[a-z].*")
}

/**
 * Gets a string element that is used in a message that contains "here" or "this location".
 *
 * For example:
 * ```CodeQL
 * select foo(), "XSS happens here from using a unsafe value." // <- bad
 *
 * select foo(), "XSS from using a unsafe value." // <- good
 * ```
 */
String avoidHere(Select sel, string part) {
  part = ["here", "this location"] and
  (
    result.getValue().regexpMatch(".*\\b" + part + "\\b.*") and
    result = getSelectPart(sel, _)
  )
}

/**
 * Avoid using an indefinite article ("a" or "an") in a link text.
 *
 * For example:
 * ```CodeQL
 * select foo(), "XSS from $@", val, "an unsafe value." // <- bad
 *
 * select foo(), "XSS from a $@", val, "unsafe value." // <- good
 * ```
 *
 * See https://www.w3.org/WAI/WCAG22/Understanding/link-purpose-in-context.html for the W3C guideline on link text. a
 */
String avoidArticleInLinkText(Select sel) {
  result = sel.getExpr((any(int i | i > 1))) and
  result = getSelectPart(sel, _) and
  result.getValue().regexpMatch("(a|an) .*")
}

/**
 * Don't quote substitutions in a message.
 *
 * For example:
 * ```CodeQL
 * select foo(), "XSS from '$@'", val, "an unsafe value." // <- bad
 *
 * select foo(), "XSS from $@", val, "an unsafe value." // <- good
 * ```
 */
String dontQuoteSubstitutions(Select sel) {
  result = getSelectPart(sel, _) and
  result.getValue().matches(["%'$@'%", "%\"$@\"%"])
}

/**
 * Gets the kind of the path-query represented by `sel`.
 * Either "data" for a dataflow query or "taint" for a taint-tracking query.
 */
private string getQueryKind(Select sel) {
  exists(TypeExpr sup |
    sup = sel.getVarDecl(_).getType().(ClassType).getDeclaration().getASuperType() and
    sup.getResolvedType().(ClassType).getName() = "Configuration"
  |
    result = "data" and
    sup.getModule().getName() = "DataFlow"
    or
    result = "taint" and
    sup.getModule().getName() = "TaintTracking"
  )
}

/**
 * Gets a string element from a message that uses the wrong phrase for a path query.
 * A dataflow query should use "flows to" and a taint-tracking query should use "depends on".
 */
String wrongFlowsPhrase(Select sel, string kind) {
  result = getSelectPart(sel, _) and
  kind = getQueryKind(sel) and
  (
    kind = "data" and
    result.getValue().matches(["% depends %", "% depend %"])
    or
    kind = "taint" and
    result.getValue().matches(["% flows to %", "% flow to %"])
  )
}

/**
 * Gets a string element that contains double whitespace.
 */
String doubleWhitespace(Select sel) {
  result = getSelectPart(sel, _) and
  result.getValue().regexpMatch(".*\\s\\s.*")
}

import codeql.GlobalValueNumbering as GVN

/**
 * Gets an expression that repeats the alert-loc as a link.
 */
AstNode getAlertLocLink(Select sel) {
  exists(GVN::ValueNumber vn |
    result = vn.getAnExpr() and
    sel.getExpr(0) = vn.getAnExpr()
  ) and
  exists(int msgIndex | sel.getExpr(msgIndex) = sel.getMessage() |
    result = sel.getExpr(any(int i | i > msgIndex))
  )
}

from AstNode node, string msg, Select sel
where
  not node.getLocation().getFile().getAbsolutePath().matches("%/test/%") and
  not node.getLocation().getFile().getAbsolutePath().matches("%/examples/%") and
  not node.getLocation().getFile().getAbsolutePath().matches("%/experimental/%") and
  not node.getLocation().getFile().getAbsolutePath().matches("%/meta/%") and
  sel.getQueryDoc().getQueryKind() = ["problem", "path-problem"] and
  (
    node = shouldHaveFullStop(sel) and
    msg = "Alert message should end with a full stop."
    or
    node = shouldStartCapital(sel) and
    msg = "Alert message should start with a capital letter."
    or
    exists(string part | node = avoidHere(sel, part) |
      part = "here" and
      msg =
        "Try to use a descriptive phrase instead of \"here\". Use \"this location\" if you can't get around mentioning the current location."
      or
      part = "this location" and
      msg = "Try to more descriptive phrase instead of \"this location\" if possible."
    )
    or
    node = avoidArticleInLinkText(sel) and
    msg = "Avoid starting a link text with an indefinite article."
    or
    node = dontQuoteSubstitutions(sel) and
    msg = "Don't quote substitutions in alert messages."
    or
    node = wrongFlowsPhrase(sel, "data") and
    msg = "Use \"flows to\" instead of \"depends on\" in data flow queries."
    or
    node = wrongFlowsPhrase(sel, "taint") and
    msg = "Use \"depends on\" instead of \"flows to\" in taint tracking queries."
    or
    node = doubleWhitespace(sel) and
    msg = "Avoid using double whitespace in alert messages."
    or
    node = getAlertLocLink(sel) and
    msg = "Don't repeat the alert location as a link."
  )
select node, msg
