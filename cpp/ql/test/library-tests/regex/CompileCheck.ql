/**
 * Compile-check: verifies that the C++ `RegexTreeView` implementation satisfies
 * the `RegexTreeViewSig` signature and can be used to instantiate the shared
 * ReDoS analysis engines.
 *
 * This query produces no results; its sole purpose is to ensure the modules
 * compile without type errors.
 *
 * @kind table
 */

import cpp
import semmle.code.cpp.regex.RegexTreeView
private import codeql.regex.nfa.SuperlinearBackTracking as SuperlinearBackTracking
private import codeql.regex.nfa.NfaUtils as NfaUtils

// Instantiate the shared analysis modules with our RegexTreeView.
// If RegexTreeView does not satisfy RegexTreeViewSig, these lines cause a compile error.
private module TestSuperlinear = SuperlinearBackTracking::Make<RegexTreeView>;

private module TestNfaUtils = NfaUtils::Make<RegexTreeView>;

// No results are selected; this is a compile-only check.
select "x" where 1 = 0
