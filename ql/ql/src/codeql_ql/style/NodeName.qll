import ql

/**
 * Gets the name for a `node` that defines something in a QL program.
 * E.g. a predicate, class, or module definition.
 */
string getName(AstNode node, string kind) {
  result = node.(Class).getName() and kind = "class"
  or
  // not including CharPreds or db relations. The remaining are: classlessPredicate, classPredicate, newTypeBranch.
  result = node.(ClasslessPredicate).getName() and
  kind = "classlessPredicate"
  or
  result = node.(ClassPredicate).getName() and
  kind = "classPredicate"
  or
  result = node.(NewTypeBranch).getName() and
  kind = "newtypeBranch"
  or
  result = node.(NewType).getName() and
  kind = "newtype"
  or
  result = node.(VarDecl).getName() and
  kind = "variable" and
  not node = any(FieldDecl f).getVarDecl()
  or
  result = node.(FieldDecl).getName() and kind = "field"
  or
  result = node.(Module).getName() and kind = "module"
  or
  result = node.(Import).importedAs() and kind = "import"
}
