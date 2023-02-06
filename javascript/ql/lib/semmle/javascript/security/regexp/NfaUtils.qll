/**
 * Provides classes and predicates for constructing an NFA from
 * a regular expression, and various utilities for reasoning about
 * the resulting NFA.
 *
 * These utilities are used both by the ReDoS queries and by
 * other queries that benefit from reasoning about NFAs.
 */

private import RegExpTreeView::RegExpTreeView as TreeView
// NfaUtils should be used directly from the shared pack, and not from this file.
deprecated private import codeql.regex.nfa.NfaUtils::Make<TreeView> as Dep
import Dep
