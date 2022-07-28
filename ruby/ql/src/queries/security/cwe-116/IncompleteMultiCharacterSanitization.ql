/**
 * @name Incomplete multi-character sanitization
 * @description A sanitizer that removes a sequence of characters may reintroduce the dangerous sequence.
 * @kind problem
 * @problem.severity warning
 * @security-severity 7.8
 * @precision high
 * @id rb/incomplete-multi-character-sanitization
 * @tags correctness
 *       security
 *       external/cwe/cwe-020
 *       external/cwe/cwe-080
 *       external/cwe/cwe-116
 */

import ruby
import codeql.ruby.frameworks.core.String
import codeql.ruby.DataFlow
import codeql.ruby.security.IncompleteMultiCharacterSanitizationQuery
import codeql.ruby.security.IncompleteMultiCharacterSanitizationSpecific as Specific

from
  StringSubstitutionCall replace, Specific::EmptyReplaceRegExpTerm dangerous, string prefix,
  string kind
where hasResult(replace, dangerous, prefix, kind)
select replace, "This string may still contain $@, which may cause a " + kind + " vulnerability.",
  dangerous, prefix
