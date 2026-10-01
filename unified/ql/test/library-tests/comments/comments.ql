import unified

query predicate comments(Comment c, string text) { c.fromSource() and text = c.getCommentText() }
