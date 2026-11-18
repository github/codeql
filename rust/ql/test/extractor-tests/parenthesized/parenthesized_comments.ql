import codeql.rust.elements

from Comment comment
where
  comment.getText() = "/* expression parentheses */" or
  comment.getText() = "/* pattern parentheses */"
select comment, comment.getParent()
