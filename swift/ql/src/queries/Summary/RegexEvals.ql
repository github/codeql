/**
 * @name Regular Expression Evaluations
 * @description List all regular expression evaluations found in the database.
 * @kind problem
 * @problem.severity info
 * @id swift/summary/regex-evals
 * @tags summary
 */

import swift
import codeql.swift.regex.Regex

from RegexEval e
select e,
  "Regular expression evaluation with " + count(e.getARegex()).toString() + " associated regex(s)."
