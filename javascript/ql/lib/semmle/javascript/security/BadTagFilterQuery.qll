/**
 * Provides predicates for reasoning about bad tag filter vulnerabilities.
 */

private import regexp.RegExpTreeView::RegExpTreeView as TreeView
// BadTagFilterQuery should be used directly from the shared pack, and not from this file.
deprecated private import codeql.regex.nfa.BadTagFilterQuery::Make<TreeView> as Dep
import Dep
