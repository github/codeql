/**
 * Provides classes and predicates for reasoning about exponential-time
 * regular-expression denial-of-service (ReDoS) vulnerabilities in C++.
 *
 * The library mirrors the JavaScript `js/redos` query: it plugs the C++
 * regex parse-tree view (`semmle.code.cpp.regex.RegexTreeView`) into the
 * shared `ExponentialBackTracking` analysis, and exposes the
 * `hasReDoSResult` predicate that identifies regex terms whose worst-case
 * matching is exponential in the input length.
 *
 * Unlike the polynomial ReDoS query, no data-flow path from a
 * user-controlled source is required: the vulnerable regex term itself is
 * the alert. The parse-tree view already restricts to string literals used
 * as `std::regex` patterns (see Phase 1's `RegExp` class in
 * `semmle.code.cpp.regex.internal.ParseRegExp`), so only regexes that are
 * actually used with `std::regex` are considered.
 */

import semmle.code.cpp.regex.RegexTreeView
private import semmle.code.cpp.regex.RegexTreeView::RegexTreeView as TreeView
private import codeql.regex.nfa.ExponentialBackTracking
private import semmle.code.cpp.regex.RegexFlowConfigs

private module Impl = Make<TreeView>;

/** A state of the NFA constructed for a regular expression. */
class State = Impl::State;

/**
 * Holds if `t` is a regex term whose worst-case matching is exponential in
 * the input length, with `pump` being an example pumping string that
 * triggers the backtracking from state `s`, and `prefixMsg` describing any
 * required prefix.
 *
 * The result is restricted to terms whose root regex satisfies
 * `isBacktrackingEngine`, so that regexes constructed with a non-backtracking
 * `std::regex` grammar flag (`awk`, `grep`, or `egrep`) are excluded.
 */
predicate hasReDoSResult(RegExpTerm t, string pump, State s, string prefixMsg) {
  Impl::hasReDoSResult(t, pump, s, prefixMsg) and
  isBacktrackingEngine(t.getRootTerm().getLiteral().getRegex())
}
