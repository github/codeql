import unified

query predicate comments(Comment c, string text) { text = c.getCommentText() }
