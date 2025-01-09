/**
 * @name Syntax error
 * @description A piece of code could not be parsed due to syntax errors.
 * @kind problem
 * @problem.severity recommendation
 * @id actions/syntax-error
 * @tags reliability
 *       correctness
 *       language-features
 *       debug
 * @precision very-high
 */

private import codeql.actions.ast.internal.Yaml

from YamlParseError pe
select pe, pe.getMessage()
