/**
 * Provides predicates for reasoning about bad tag filter vulnerabilities.
 */

private import codeql.ruby.regexp.RegExpTreeView::RegexTreeView as TreeView
// BadTagFilterQuery should be used directly from the shared pack, and not from this file.
deprecated import codeql.regex.nfa.BadTagFilterQuery::Make<TreeView> as Dep
import Dep
