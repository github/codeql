/**
 * @name Bad HTML filtering regexp
 * @description Matching HTML tags using regular expressions is hard to do right, and can easily lead to security issues.
 * @kind problem
 * @problem.severity warning
 * @security-severity 7.8
 * @precision high
 * @id py/bad-tag-filter
 * @tags correctness
 *       security
 *       external/cwe/cwe-116
 *       external/cwe/cwe-020
 *       external/cwe/cwe-185
 *       external/cwe/cwe-186
 */

import semmle.python.security.BadTagFilterQuery

from HtmlMatchingRegExp regexp, string msg
where msg = min(string m | isBadRegexpFilter(regexp, m) | m order by m.length(), m) // there might be multiple, we arbitrarily pick the shortest one
select regexp, msg
