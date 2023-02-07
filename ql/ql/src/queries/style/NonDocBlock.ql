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
  exists(Location loc | loc = result.getLocation() |
    file = loc.getFile() and
    loc.getFile().getExtension() = "qll" and
    not result.getContents().matches("/**%") and
    not [loc.getStartLine(), loc.getEndLine()] = getLinesWithNonComment(file) and
    (
      // above something that can be commented.
      loc.getEndLine() = getLineAboveNodeThatCouldHaveDoc(file)
      or
      // toplevel in file.
      loc.getStartLine() = 1 and
      loc.getStartColumn() = 1
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
