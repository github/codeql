/**
 * Provides predicates for reasoning about regular expressions
 * that match URLs and hostname patterns.
 */

private import javascript as JS
private import semmle.javascript.security.regexp.RegExpTreeView::RegExpTreeView as TreeImpl
private import semmle.javascript.Regexp as RegExp
private import codeql.regex.HostnameRegexp as Shared

private module Impl implements Shared::HostnameRegexpSig<TreeImpl> {
  class DataFlowNode = JS::DataFlow::Node;

  class RegExpPatternSource = RegExp::RegExpPatternSource;

  string getACommonTld() { result = RegExp::RegExpPatterns::getACommonTld() }
}

import Shared::Make<TreeImpl, Impl>
