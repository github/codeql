/**
 * @name Correct casing on name declarations
 * @description Variables/fields/predicates should be lower-case, classes/modules should be upper-case
 * @kind problem
 * @problem.severity error
 * @id ql/name-casing
 * @tags correctness
 * @precision very-high
 */

import ql
import codeql_ql.style.AcronymsShouldBeCamelCaseQuery as AcronymsQuery

predicate shouldBeUpperCase(AstNode node, string name, string kind) {
  name = AcronymsQuery::getName(node, kind) and
  kind = ["class", "newtypeBranch", "newtype", "module", "import"]
}

predicate shouldBeLowerCase(AstNode node, string name, string kind) {
  name = AcronymsQuery::getName(node, kind) and
  not shouldBeUpperCase(node, name, kind)
}

string prettyKind(string kind) {
  exists(string prettyLower | prettyLower = AcronymsQuery::prettyPluralKind(kind) |
    result = prettyLower.prefix(1).toUpperCase() + prettyLower.suffix(1)
  )
}

from string name, AstNode node, string message, string kind
where
  (
    shouldBeLowerCase(node, name, kind) and
    name.regexpMatch("[^a-z].*") and
    message = "a lowercase"
    or
    shouldBeUpperCase(node, name, kind) and
    name.regexpMatch("[^A-Z].*") and
    message = "an uppercase"
  ) and
  not node.hasAnnotation("deprecated")
select node, prettyKind(kind) + " should start with " + message + " letter."
