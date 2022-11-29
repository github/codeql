/**
 * @name Block comment that is not QLDoc
 * @description Placing a block comment that could have been a QLDoc comment is an indication that it should have been a QLDoc comment.
 * @kind problem
 * @problem.severity warning
 * @id ql/non-doc-block
 * @tags maintainability
 * @precision very-high
 */

import ql

predicate canHaveQLDoc(AstNode node) {
  node instanceof Class
  or
  node instanceof Module
  or
  node instanceof ClasslessPredicate
  or
  node instanceof ClassPredicate
  or
  node instanceof TopLevel
}

pragma[noinline]
int getLineAboveNodeThatCouldHaveDoc(File file) {
  exists(AstNode node | canHaveQLDoc(node) |
    result = node.getLocation().getStartLine() - 1 and file = node.getLocation().getFile()
  )
}

pragma[noinline]
BlockComment getACommentThatCouldBeQLDoc(File file, int line, string descrip) {
  exists(Location loc | loc = result.getLocation() |
    file = loc.getFile() and
    loc.getFile().getExtension() = "qll" and
    not result.getContents().matches("/**%") and
    not [loc.getStartLine(), loc.getEndLine()] = getLinesWithNonComment(file) and
    (
      // above something that can be commented.
      loc.getEndLine() = getLineAboveNodeThatCouldHaveDoc(file) and
      descrip = "the below code" and
      line = loc.getEndLine() + 1
      or
      // toplevel in file.
      loc.getStartLine() = 1 and
      loc.getStartColumn() = 1 and
      descrip = "the file" and
      line = 1
    )
  )
}

pragma[noinline]
int getLinesWithNonComment(File f) {
  exists(AstNode n, Location loc |
    not n instanceof Comment and
    not n instanceof TopLevel and
    loc = n.getLocation() and
    loc.getFile() = f
  |
    result = [loc.getEndLine(), loc.getStartLine()]
  )
}

from AstNode node, BlockComment comment, string nodeDescrip
where
  (
    canHaveQLDoc(node) and
    comment =
      getACommentThatCouldBeQLDoc(node.getLocation().getFile(), node.getLocation().getStartLine(),
        nodeDescrip)
  ) and
  not exists(node.getQLDoc()) and
  not node.(ClassPredicate).isOverride() and // ignore override predicates
  not node.hasAnnotation("deprecated") and // ignore deprecated
  not node.hasAnnotation("private") // ignore private
select comment, "Block comment could be QLDoc for $@.", node, nodeDescrip
