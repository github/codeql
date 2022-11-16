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
}

pragma[noinline]
int getLineAboveNodeThatCouldHaveDoc(File file) {
  exists(AstNode node | canHaveQLDoc(node) |
    result = node.getLocation().getStartLine() - 1 and file = node.getLocation().getFile()
  )
}

pragma[noinline]
BlockComment getACommentThatCouldBeQLDoc(File file) {
  file = result.getLocation().getFile() and
  result.getLocation().getFile().getExtension() = "qll" and
  not result.getContents().matches("/**%") and
  (
    // above something that can be commented.
    result.getLocation().getEndLine() = getLineAboveNodeThatCouldHaveDoc(file)
    or
    // toplevel in file.
    result.getLocation().getStartLine() = 1 and
    result.getLocation().getStartColumn() = 1
  )
}

pragma[noinline]
BlockComment getCommentAtEnd(File file, int endLine) {
  result = getACommentThatCouldBeQLDoc(file) and
  result.getLocation().getEndLine() = endLine
}

pragma[noinline]
BlockComment getCommentAtStart(File file, int startLine) {
  result = getACommentThatCouldBeQLDoc(file) and
  result.getLocation().getStartLine() = startLine
}

from AstNode node, BlockComment comment, string nodeDescrip
where
  (
    canHaveQLDoc(node) and
    comment = getCommentAtEnd(node.getLocation().getFile(), node.getLocation().getStartLine() - 1) and
    nodeDescrip = "the below code"
    or
    node instanceof TopLevel and
    comment = getCommentAtStart(node.getLocation().getFile(), 1) and
    nodeDescrip = "the file"
  ) and
  not exists(node.getQLDoc()) and
  not node.(ClassPredicate).isOverride() and // ignore override predicates
  not node.hasAnnotation("deprecated") and // ignore deprecated
  not node.hasAnnotation("private") // ignore private
select comment, "Block comment could be QLDoc for $@.", node, nodeDescrip
