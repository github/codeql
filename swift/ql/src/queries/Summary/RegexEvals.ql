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

from RegexEval e, string message, Expr regex
where
  message = "Regular expression evaluation with source $@." and regex = e.getARegex()
  or
  message = "Regular expression evaluation with no identified source." and
  not exists(e.getARegex()) and
  regex = e
select e, message, regex, regex.toString()
