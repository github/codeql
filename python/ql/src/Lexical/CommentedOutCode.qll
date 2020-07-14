import python

private predicate def_statement(Comment c) {
  c.getText().regexpMatch("#(\\S*\\s+)?def\\s.*\\(.*\\).*:\\s*(#.*)?")
}

private predicate if_statement(Comment c) {
  c.getText().regexpMatch("#(\\S*\\s+)?(el)?if\\s.*:\\s*(#.*)?")
  or
  c.getText().regexpMatch("#(\\S*\\s+)?else:\\s*(#.*)?")
}

private predicate for_statement(Comment c) {
  c.getText().regexpMatch("#(\\S*\\s+)?for\\s.*\\sin\\s.*:\\s*(#.*)?")
}

private predicate with_statement(Comment c) {
  c.getText().regexpMatch("#(\\S*\\s+)?with\\s+.*:\\s*(#.*)?")
}

private predicate try_statement(Comment c) {
  c.getText().regexpMatch("#(\\S*\\s+)?try:\\s*(#.*)?")
  or
  c.getText().regexpMatch("#(\\S*\\s+)?except\\s*(\\w+\\s*(\\sas\\s+\\w+\\s*)?)?:\\s*(#.*)?")
  or
  c.getText().regexpMatch("#(\\S*\\s+)?finally:\\s*(#.*)?")
}

private int indentation(Comment c) {
  exists(int offset |
    maybe_code(c) and
    exists(c.getText().regexpFind("[^\\s#]", 1, offset)) and
    result = offset + c.getLocation().getStartColumn()
  )
}

private predicate class_statement(Comment c) {
  c.getText().regexpMatch("#(\\S*\\s+)?class\\s+\\w+.*:\\s*(#.*)?")
}

private predicate triple_quote(Comment c) { c.getText().regexpMatch("#.*(\"\"\"|''').*") }

private predicate triple_quoted_string_part(Comment start, Comment end) {
  triple_quote(start) and end = start
  or
  exists(Comment mid |
    triple_quoted_string_part(start, mid) and
    end = non_empty_following(mid) and
    not triple_quote(end)
  )
}

private predicate maybe_code(Comment c) {
  not non_code(c) and not filler(c) and not endline_comment(c) and not file_or_url(c)
  or
  commented_out_comment(c)
}

private predicate commented_out_comment(Comment c) { c.getText().regexpMatch("#+\\s+#.*") }

private int scope_start(Comment start) {
  (
    def_statement(start) or
    class_statement(start)
  ) and
  result = indentation(start) and
  not non_code(start)
}

private int block_start(Comment start) {
  (
    if_statement(start) or
    for_statement(start) or
    try_statement(start) or
    with_statement(start)
  ) and
  result = indentation(start) and
  not non_code(start)
}

private int scope_doc_string_part(Comment start, Comment end) {
  result = scope_start(start) and
  triple_quote(end) and
  end = non_empty_following(start)
  or
  exists(Comment mid |
    result = scope_doc_string_part(start, mid) and
    end = non_empty_following(mid)
  |
    not triple_quote(end)
  )
}

private int scope_part(Comment start, Comment end) {
  result = scope_start(start) and end = start
  or
  exists(Comment mid |
    result = scope_doc_string_part(start, mid) and
    end = non_empty_following(mid) and
    triple_quote(end)
  )
  or
  exists(Comment mid |
    result = scope_part(start, mid) and
    end = non_empty_following(mid)
  |
    indentation(end) > result
  )
}

private int block_part(Comment start, Comment end) {
  result = block_start(start) and
  end = non_empty_following(start) and
  indentation(end) > result
  or
  exists(Comment mid |
    result = block_part(start, mid) and
    end = non_empty_following(mid)
  |
    indentation(end) > result
    or
    result = block_start(end)
  )
}

private predicate commented_out_scope_part(Comment start, Comment end) {
  exists(scope_doc_string_part(start, end))
  or
  exists(scope_part(start, end))
}

private predicate commented_out_code(Comment c) {
  commented_out_scope_part(c, _)
  or
  commented_out_scope_part(_, c)
  or
  exists(block_part(c, _))
  or
  exists(block_part(_, c))
}

private predicate commented_out_code_part(Comment start, Comment end) {
  commented_out_code(start) and
  end = start and
  not exists(Comment prev | non_empty_following(prev) = start | commented_out_code(prev))
  or
  exists(Comment mid |
    commented_out_code_part(start, mid) and
    non_empty_following(mid) = end and
    commented_out_code(end)
  )
}

private predicate commented_out_code_block(Comment start, Comment end) {
  /* A block must be at least 2 comments long. */
  start != end and
  commented_out_code_part(start, end) and
  not commented_out_code(non_empty_following(end))
}

/* A single line comment that appears to be commented out code */
class CommentedOutCodeLine extends Comment {
  CommentedOutCodeLine() { exists(CommentedOutCodeBlock b | b.contains(this)) }

  /* Whether this commented-out code line is likely to be example code embedded in a larger comment. */
  predicate maybeExampleCode() {
    exists(CommentedOutCodeBlock block |
      block.contains(this) and
      block.maybeExampleCode()
    )
  }
}

/** A block of comments that appears to be commented out code */
class CommentedOutCodeBlock extends @py_comment {
  CommentedOutCodeBlock() { commented_out_code_block(this, _) }

  /** Gets a textual representation of this element. */
  string toString() { result = "Commented out code" }

  /** Whether this commented-out code block contains the comment c */
  predicate contains(Comment c) {
    this = c
    or
    exists(Comment prev |
      non_empty_following(prev) = c and
      not commented_out_code_block(this, prev) and
      this.contains(prev)
    )
  }

  /** The length of this comment block (in comments) */
  int length() { result = count(Comment c | this.contains(c)) }

  /**
   * Holds if this element is at the specified location.
   * The location spans column `startcolumn` of line `startline` to
   * column `endcolumn` of line `endline` in file `filepath`.
   * For more information, see
   * [Locations](https://help.semmle.com/QL/learn-ql/ql/locations.html).
   */
  predicate hasLocationInfo(
    string filepath, int startline, int startcolumn, int endline, int endcolumn
  ) {
    this.(Comment).getLocation().hasLocationInfo(filepath, startline, startcolumn, _, _) and
    exists(Comment end | commented_out_code_block(this, end) |
      end.getLocation().hasLocationInfo(_, _, _, endline, endcolumn)
    )
  }

  /** Whether this commented-out code block is likely to be example code embedded in a larger comment. */
  predicate maybeExampleCode() {
    exists(CommentBlock block | block.contains(this.(Comment)) |
      exists(int all_code |
        all_code = sum(CommentedOutCodeBlock code | block.contains(code.(Comment)) | code.length()) and
        /* This ratio may need fine tuning */
        block.length() > all_code * 2
      )
    )
  }
}

/** Does c contain the pair of words "s1 s2" with only whitespace between them */
private predicate word_pair(Comment c, string s1, string s2) {
  exists(int i1, int i2, int o1, int o2 |
    s1 = c.getText().regexpFind("\\w+", i1, o1) and
    s2 = c.getText().regexpFind("\\w+", i2, o2) and
    i2 = i1 + 1 and
    c.getText().prefix(o1).regexpMatch("[^'\"]*") and
    c.getText().substring(o1 + s1.length(), o2).regexpMatch("\\s+")
  )
}

/**
 * The comment c cannot be code if it contains a word pair "word1 word2" and
 * either:
 * 1. word1 is not a keyword and word2 is not an operator:
 *    "x is" could be code, "return y" could be code, but "isnt code" cannot be code.
 * or
 * 2. word1 is a keyword requiring a colon and there is no colon:
 *    "with spam" can only be code if the comment contains a colon.
 */
private predicate non_code(Comment c) {
  exists(string word1, string word2 |
    word_pair(c, word1, word2) and
    not word2 = operator_keyword()
  |
    not word1 = a_keyword()
    or
    word1 = keyword_requiring_colon() and not c.getText().matches("%:%")
  ) and
  /* Except comments of the form: # (maybe code) # some comment */
  not c.getText().regexpMatch("#\\S+\\s.*#.*")
  or
  /* Don't count doctests as code */
  c.getText().matches("%>>>%")
  or
  c.getText().matches("%...%")
}

private predicate filler(Comment c) { c.getText().regexpMatch("#+[\\s*#-_=+]*") }

/** Gets the first non empty comment following c */
private Comment non_empty_following(Comment c) {
  not empty(result) and
  (
    result = empty_following(c).getFollowing()
    or
    not empty(c) and result = c.getFollowing()
  )
}

/* Helper for non_empty_following() */
private Comment empty_following(Comment c) {
  not empty(c) and
  empty(result) and
  exists(Comment prev | result = prev.getFollowing() |
    prev = c
    or
    prev = empty_following(c)
  )
}

private predicate empty(Comment c) { c.getText().regexpMatch("#+\\s*") }

/* A comment following code on the same line */
private predicate endline_comment(Comment c) {
  exists(Expr e, string f, int line |
    e.getLocation().hasLocationInfo(f, line, _, _, _) and
    c.getLocation().hasLocationInfo(f, line, _, _, _)
  )
}

private predicate file_or_url(Comment c) {
  c.getText().regexpMatch("#[^'\"]+(https?|file)://.*") or
  c.getText().regexpMatch("#[^'\"]+(/[a-zA-Z]\\w*)+\\.[a-zA-Z]+.*") or
  c.getText().regexpMatch("#[^'\"]+(\\[a-zA-Z]\\w*)+\\.[a-zA-Z]+.*")
}

private string operator_keyword() {
  result = "import" or
  result = "and" or
  result = "is" or
  result = "or" or
  result = "in" or
  result = "not" or
  result = "as"
}

private string keyword_requiring_colon() {
  result = "try" or
  result = "while" or
  result = "elif" or
  result = "else" or
  result = "if" or
  result = "except" or
  result = "def" or
  result = "class"
}

private string other_keyword() {
  result = "del" or
  result = "lambda" or
  result = "from" or
  result = "global" or
  result = "with" or
  result = "assert" or
  result = "yield" or
  result = "finally" or
  result = "print" or
  result = "exec" or
  result = "raise" or
  result = "return" or
  result = "for"
}

private string a_keyword() {
  result = keyword_requiring_colon() or result = other_keyword() or result = operator_keyword()
}
