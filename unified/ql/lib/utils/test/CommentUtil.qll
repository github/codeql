private import unified

/** Holds if a comment with `text` appears at `filepath:line`, excluding the text in a `$` section. */
predicate plainCommentAt(string filepath, int line, string text) {
  exists(Comment comment |
    comment.getLocation().hasLocationInfo(filepath, line, _, _, _) and
    text = comment.getCommentText().regexpReplaceAll("\\$([^/]|/[^/])*", "")
  )
}

/** Holds if a `key=value` comment appears on `filepath:line` (not in the `$` section). */
predicate keyValueCommentAt(string filepath, int line, string key, string value) {
  exists(string text, string regexp, string match |
    plainCommentAt(filepath, line, text) and
    regexp = "(\\w+)=([\\w.0-9]+)" and
    match = text.regexpFind(regexp, _, _) and
    key = match.regexpCapture(regexp, 1) and
    value = match.regexpCapture(regexp, 2)
  )
}
