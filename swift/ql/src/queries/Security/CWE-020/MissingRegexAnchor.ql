/**
 * @name Missing regular expression anchor
 * @description Regular expressions without anchors can be vulnerable to bypassing.
 * @kind problem
 * @problem.severity warning
 * @security-severity 7.8
 * @precision high
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
    exists(RegexEval eval |
      eval.getARegex() = pattern.asExpr() and
      eval.isUsedAsReplace()
    )
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
  or
  isLineAnchoredHostnameRegExp(node, msg)
select node, msg
