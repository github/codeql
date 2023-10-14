/**
 * Provides predicates for reasoning about regular expressions
 * that match URLs and hostname patterns.
 */

private import python
private import semmle.python.dataflow.new.DataFlow
private import semmle.python.regexp.RegexTreeView::RegexTreeView as TreeImpl
private import semmle.python.dataflow.new.Regexp as Regexp
private import codeql.regex.HostnameRegexp as Shared

private module Impl implements Shared::HostnameRegexpSig<TreeImpl> {
  class DataFlowNode = DataFlow::Node;

  class RegExpPatternSource extends DataFlow::Node instanceof Regexp::RegExpPatternSource {
    /**
     * Gets a node where the pattern of this node is parsed as a part of
     * a regular expression.
     */
    DataFlow::Node getAParse() { result = super.getAParse() }

    /**
     * Gets the root term of the regular expression parsed from this pattern.
     */
    TreeImpl::RegExpTerm getRegExpTerm() { result = super.getRegExpTerm() }
  }
}

import Shared::Make<TreeImpl, Impl>
