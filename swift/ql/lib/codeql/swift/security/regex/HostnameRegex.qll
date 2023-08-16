/**
 * Provides predicates for reasoning about regular expressions
 * that match URLs and hostname patterns.
 */

private import swift
private import codeql.swift.dataflow.DataFlow
private import codeql.swift.regex.Regex as Regex
private import codeql.swift.regex.RegexTreeView::RegexTreeView as TreeImpl
private import codeql.regex.HostnameRegexp as Shared

/**
 * An implementation of the signature that allows the Hostname analysis to run.
 */
module Impl implements Shared::HostnameRegexpSig<TreeImpl> {
  class DataFlowNode = DataFlow::Node;

  class RegExpPatternSource = Regex::RegexPatternSource;
}

import Shared::Make<TreeImpl, Impl>
