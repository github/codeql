/**
 * Provides predicates for reasoning about regular expressions
 * that match URLs and hostname patterns.
 */

private import javascript as JS
private import semmle.javascript.security.regexp.RegExpTreeView::RegExpTreeView as TreeImpl
private import semmle.javascript.Regexp as RegExp
private import codeql.regex.HostnameRegexp as Shared

/** An implementation of the signature that allows the Hostname analysis to run. */
module Impl implements Shared::HostnameRegexpSig<TreeImpl> {
  class DataFlowNode = JS::DataFlow::Node;

  class RegExpPatternSource = RegExp::RegExpPatternSource;
}

import Shared::Make<TreeImpl, Impl>
