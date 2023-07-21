/**
 * @name Missing regular expression anchor
 * @description Regular expressions without anchors can be vulnerable to bypassing.
 * @kind problem
 * @problem.severity warning
 * @security-severity 7.8
 * @precision medium
 * @id rb/regex/missing-regexp-anchor
 * @tags correctness
 *       security
 *       external/cwe/cwe-020
 */

import codeql.ruby.DataFlow
import codeql.ruby.regexp.RegExpTreeView
import codeql.ruby.Regexp
private import codeql.ruby.security.regexp.HostnameRegexp as HostnameRegexp
private import codeql.regex.MissingRegExpAnchor as MissingRegExpAnchor
private import codeql.ruby.regexp.RegExpTreeView::RegexTreeView as TreeImpl

private module Impl implements
  MissingRegExpAnchor::MissingRegExpAnchorSig<TreeImpl, HostnameRegexp::Impl>
{
  predicate isUsedAsReplace(RegExpPatternSource pattern) {
    exists(DataFlow::CallNode mcn, DataFlow::Node arg, string name |
      name = mcn.getMethodName() and
      arg = mcn.getArgument(0)
    |
      (
        pattern.getAParse().(DataFlow::LocalSourceNode).flowsTo(arg) or
        pattern.getAParse() = arg
      ) and
      name = ["sub", "sub!", "gsub", "gsub!"]
    )
  }

  string getEndAnchorText() { result = "\\z" }
}

import MissingRegExpAnchor::Make<TreeImpl, HostnameRegexp::Impl, Impl>

from DataFlow::Node nd, string msg
where
  isUnanchoredHostnameRegExp(nd, msg) or
  isSemiAnchoredHostnameRegExp(nd, msg) or
  isLineAnchoredHostnameRegExp(nd, msg) or
  hasMisleadingAnchorPrecedence(nd, msg)
select nd, msg
