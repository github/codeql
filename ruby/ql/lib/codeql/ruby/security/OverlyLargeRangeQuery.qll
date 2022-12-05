/**
 * Classes and predicates for working with suspicious character ranges.
 */

private import codeql.ruby.regexp.RegExpTreeView::RegexTreeView as TreeView
// OverlyLargeRangeQuery should be used directly from the shared pack, and not from this file.
deprecated import codeql.regex.OverlyLargeRangeQuery::Make<TreeView> as Dep
import Dep
