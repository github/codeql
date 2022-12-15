/**
 * Provides predicates for reasoning about regular expressions
 * that match URLs and hostname patterns.
 */

private import ruby
private import codeql.ruby.regexp.RegExpTreeView::RegexTreeView as TreeImpl
private import codeql.ruby.Regexp as Regexp
private import codeql.regex.HostnameRegexp as Shared

private module Impl implements Shared::HostnameRegexpSig<TreeImpl> {
  class DataFlowNode = DataFlow::Node;

  class RegExpPatternSource = Regexp::RegExpPatternSource;

  string getACommonTld() { result = Regexp::RegExpPatterns::getACommonTld() }
}

import Shared::Make<TreeImpl, Impl>
