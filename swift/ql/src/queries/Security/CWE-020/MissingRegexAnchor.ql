/**
 * @name Missing regular expression anchor
 * @description Regular expressions without anchors can be vulnerable to bypassing.
 * @kind problem
 * @problem.severity warning
 * @security-severity 7.8
 * @precision medium
 * @id swift/missing-regexp-anchor
 * @tags correctness
 *       security
 *       external/cwe/cwe-020
 */

private import swift
private import codeql.swift.dataflow.DataFlow
private import codeql.swift.regex.Regex
private import codeql.swift.regex.RegexTreeView::RegexTreeView as TreeImpl
private import codeql.swift.security.regex.HostnameRegex as HostnameRegex
private import codeql.regex.MissingRegExpAnchor as MissingRegExpAnchor

private module Impl implements
  MissingRegExpAnchor::MissingRegExpAnchorSig<TreeImpl, HostnameRegex::Impl>
{
  predicate isUsedAsReplace(RegexPatternSource pattern) {
    none()
/* java   // is used for capture or replace
    exists(DataFlow::MethodCallNode mcn, string name | name = mcn.getMethodName() |
      name = "exec" and
      mcn = pattern.getARegExpObject().getAMethodCall() and
      exists(mcn.getAPropertyRead())
      or
      exists(DataFlow::Node arg |
        arg = mcn.getArgument(0) and
        (
          pattern.getARegExpObject().flowsTo(arg) or
          pattern.getAParse() = arg
        )
      |
        name = "replace"
        or
        name = "match" and exists(mcn.getAPropertyRead())
      )
    )*/
/* rb   exists(DataFlow::CallNode mcn, DataFlow::Node arg, string name |
      name = mcn.getMethodName() and
      arg = mcn.getArgument(0)
    |
      (
        pattern.getAParse().(DataFlow::LocalSourceNode).flowsTo(arg) or
        pattern.getAParse() = arg
      ) and
      name = ["sub", "sub!", "gsub", "gsub!"]
    )*/
  }

  string getEndAnchorText() { result = "$" }
}

import MissingRegExpAnchor::Make<TreeImpl, HostnameRegex::Impl, Impl>

from DataFlow::Node node, string msg
where
  isUnanchoredHostnameRegExp(node, msg)
  or
  isSemiAnchoredHostnameRegExp(node, msg)
  or
  hasMisleadingAnchorPrecedence(node, msg)
// isLineAnchoredHostnameRegExp is not used here, as it is not relevant to JS.
select node, msg
