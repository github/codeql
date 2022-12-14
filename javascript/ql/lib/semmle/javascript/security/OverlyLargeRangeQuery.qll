/**
 * Classes and predicates for working with suspicious character ranges.
 */

private import regexp.RegExpTreeView::RegExpTreeView as TreeView
// OverlyLargeRangeQuery should be used directly from the shared pack, and not from this file.
deprecated private import codeql.regex.OverlyLargeRangeQuery::Make<TreeView> as Dep
import Dep
