/**
 * @name Incomplete regular expression for hostnames
 * @description Matching a URL or hostname against a regular expression that contains an unescaped dot as part of the hostname might match more hostnames than expected.
 * @kind problem
 * @problem.severity warning
 * @security-severity 7.8
 * @precision high
 * @id py/incomplete-hostname-regexp
 * @tags correctness
 *       security
 *       external/cwe/cwe-020
 */

private import semmle.python.security.regexp.HostnameRegex as HostnameRegex

query predicate problems = HostnameRegex::incompleteHostnameRegExp/4;
