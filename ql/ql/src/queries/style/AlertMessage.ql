/**
 * @name Alert messages style violation
 * @description Alert message that doesn't follow some aspect of the style guide.
 *              See the style guide here: https://github.com/github/codeql/blob/main/docs/query-metadata-style-guide.md#alert-messages
 * @kind problem
 * @problem.severity warning
 * @id ql/alert-messages-style-violation
 * @precision high
 */

import ql

/** Gets the `index`th part of the select statement. */
private AstNode getSelectPart(Select sel, int index) {
  result =
    rank[index](AstNode n, Location loc |
      (
        n.getParent*() = sel.getExpr(_) and loc = n.getLocation()
        or
        // the strings are behind a predicate call.
        exists(Call c, Predicate target |
          c.getParent*() = sel.getExpr(_) and loc = c.getLocation()
        |
          c.getTarget() = target and
          (
            target.getBody().(ComparisonFormula).getAnOperand() = n
            or
            exists(ClassPredicate sub | sub.overrides(target) |
              sub.getBody().(ComparisonFormula).getAnOperand() = n
            )
          )
        )
      )
    |
      n
      order by
        loc.getStartLine(), loc.getStartColumn(), loc.getEndLine(), loc.getEndColumn(),
        loc.getFile().getRelativePath()
    )
}

String shouldHaveFullStop(Select sel) {
  result =
    max(AstNode str, int i |
      str.getParent+() = sel.getExpr(1) and str = getSelectPart(sel, i)
    |
      str order by i
    ) and
  not result.getValue().matches("%.") and
  not result.getValue().matches("%?")
}

String shouldStartCapital(Select sel) {
  result =
    min(AstNode str, int i |
      str.getParent+() = sel.getExpr(1) and str = getSelectPart(sel, i)
    |
      str order by i
    ) and
  result.getValue().regexpMatch("^[a-z].*")
}

// see https://www.w3.org/WAI/WCAG22/Understanding/link-purpose-in-context.html
String avoidHere(string part) {
  part = ["here", "this location"] and // TODO: prefer "this location" of the two.
  (
    result.getValue().regexpMatch(".*\\b" + part + "\\b.*") and
    result = getSelectPart(_, _)
  )
}

// see https://www.w3.org/WAI/WCAG22/Understanding/link-purpose-in-context.html
String avoidArticleInLinkText(Select sel) {
  result = sel.getExpr((any(int i | i > 1))) and
  result = getSelectPart(sel, _) and
  result.getValue().regexpMatch("a|an .*")
}

String dontQuoteSubstitutions(Select sel) {
  result = getSelectPart(sel, _) and
  result.getValue().matches(["%'$@'%", "%\"$@\"%"])
}

// "data" or "taint"
string getQueryKind(Select s) {
  exists(TypeExpr sup |
    sup = s.getVarDecl(_).getType().(ClassType).getDeclaration().getASuperType() and
    sup.getResolvedType().(ClassType).getName() = "Configuration"
  |
    result = "data" and
    sup.getModule().getName() = "DataFlow"
    or
    result = "taint" and
    sup.getModule().getName() = "TaintTracking"
  )
}

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

from AstNode node, string msg
where
  not node.getLocation().getFile().getAbsolutePath().matches("%/test/%") and
  (
    node = shouldHaveFullStop(_) and
    msg = "Alert message should end with a full stop."
    or
    node = shouldStartCapital(_) and
    msg = "Alert message should start with a capital letter."
    or
    exists(string part | node = avoidHere(part) |
      part = "here" and
      msg = "Avoid using the phrase \"" + part + "\" in alert messages."
      or
      part != "here" and
      msg = "Try to avoid using the phrase \"" + part + "\" in alert messages if possible."
    )
    or
    node = avoidArticleInLinkText(_) and
    msg = "Avoid starting a link text with an indefinite article."
    or
    node = dontQuoteSubstitutions(_) and
    msg = "Don't quote substitutions in alert messages."
    or
    node = wrongFlowsPhrase(_, "data") and
    msg = "Use \"flows to\" instead of \"depends on\" in taint tracking queries."
    or
    node = wrongFlowsPhrase(_, "taint") and
    msg = "Use \"depends on\" instead of \"flows to\" in data flow queries."
  )
select node, msg
