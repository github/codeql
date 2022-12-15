/**
 * Provides predicates for reasoning about regular expressions
 * that match URLs and hostname patterns.
 */

private import python
private import semmle.python.dataflow.new.DataFlow
private import semmle.python.RegexTreeView::RegexTreeView as TreeImpl
private import semmle.python.dataflow.new.Regexp as Regexp
private import codeql.regex.HostnameRegexp as Shared

private module Impl implements Shared::HostnameRegexpSig<TreeImpl> {
  class DataFlowNode = DataFlow::Node;

  class RegExpPatternSource = Regexp::RegExpPatternSource;
}

import Shared::Make<TreeImpl, Impl>
