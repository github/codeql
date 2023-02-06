/**
 * @name Names only differing by case
 * @description Names only differing by case can cause confusion.
 * @kind problem
 * @problem.severity warning
 * @id ql/names-only-differing-by-case
 * @tags correctness
 *       maintainability
 * @precision high
 */

import ql
import codeql_ql.style.AcronymsShouldBeCamelCaseQuery as Acronyms
private import codeql_ql.style.NodeName as NodeName

string getName(AstNode node, string kind, YAML::QLPack pack) {
  result = NodeName::getName(node, kind) and
  node.getLocation().getFile() = pack.getAFileInPack() and
  not node.hasAnnotation("deprecated") and // deprecated nodes are not interesting
  not node.getLocation().getFile().getBaseName() = "TreeSitter.qll" and // auto-generated, is sometimes bad.
  not node.getLocation().getFile().getExtension() = "ql" // .ql files cannot be imported, so no risk of conflict
}

// get better join-order by getting all the relevant information in a single utility predicate
pragma[nomagic]
string getNameAndPack(AstNode node, string kind, string lower, YAML::QLPack pack) {
  result = getName(node, kind, pack) and lower = result.toLowerCase()
}

predicate problem(string name1, AstNode node1, string name2, string kind) {
  exists(string lower, YAML::QLPack pack1, YAML::QLPack pack2 |
    name1 = getNameAndPack(node1, kind, lower, pack1) and
    name1.length() >= 2 and
    pack2 = pack1.getADependency*() and
    name2 = getNameAndPack(_, kind, lower, pack2) and // TODO: Get if it's a dependency pack in the alert-message.
    name1 != name2 and
    kind != "variable" // these are benign, and plentiful...
  )
}

string prettyPluralKind(string kind) {
  kind = "class" and result = "classes"
  or
  kind = "classlessPredicate" and result = "predicates"
  or
  kind = "classPredicate" and result = "class predicates"
  or
  kind = "newtypeBranch" and result = "newtype branches"
  or
  kind = "newtype" and result = "newtypes"
  or
  kind = "variable" and result = "variables"
  or
  kind = "field" and result = "fields"
  or
  kind = "module" and result = "modules"
}

from string name1, AstNode node, string name2, string kind
where problem(name1, node, name2, kind) and not name1.toLowerCase() = "geturl"
select node,
  name1 + " is only different by casing from " + name2 + " that is used elsewhere for " +
    prettyPluralKind(kind) + "."
