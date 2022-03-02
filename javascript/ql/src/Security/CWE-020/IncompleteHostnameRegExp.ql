/**
 * @name Incomplete regular expression for hostnames
 * @description Matching a URL or hostname against a regular expression that contains an unescaped dot as part of the hostname might match more hostnames than expected.
 * @kind problem
 * @problem.severity warning
 * @security-severity 7.8
 * @precision high
 * @id js/incomplete-hostname-regexp
 * @tags correctness
 *       security
 *       external/cwe/cwe-020
 */

import HostnameRegexpShared

query predicate problems = incompleteHostnameRegExp/4;
