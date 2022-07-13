import ql
private import NodeName

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
  or
  kind = "import" and result = "imports"
}

/**
 * Holds if `name` seems to contain an upper-cased acronym that could be pascal-cased.
 * `name` is the name of `node`, and `kind` describes what kind of definition `node` is.
 */
predicate shouldBePascalCased(string name, AstNode node, string kind) {
  name = getName(node, kind) and
  (
    // when the acronym is followed by something, then there must be 4 upper-case letters
    name.regexpMatch(".*[A-Z]{4,}([^A-Z]).*")
    or
    // when the acronym is the last part, then we only require 3 upper-case letters
    name.regexpMatch(".*[A-Z]{3,}$")
  ) and
  not node.hasAnnotation("deprecated") and
  // allowed upper-case acronyms.
  not name.regexpMatch(".*(PEP|AES|DES|EOF).*") and
  not (name.regexpMatch("T[A-Z]{3}[^A-Z].*") and node instanceof NewTypeBranch) and
  not (name.regexpMatch("T[A-Z]{3}[^A-Z].*") and node instanceof NewType) and
  not name.toUpperCase() = name // We are OK with fully-uppercase names.
}
