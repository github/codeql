/**
 * Parsing framework for QL
 *
 * Parser is performed as follows:
 * 1. Search for all tokens using `ParsedString.tokens`
 * 2. Perform a left-right tokenization, rejecting spurious tokens
 * 3. Remove all tokens marked as whitespace or comments.
 * 4. Put all tokens into sequence.
 * 5. Perform a bottom-up parse of the text.
 *
 * The parsing algorithm is as follows:
 * - all tokens are nodes.
 * - for all pairs of adjacent nodes, merge them according to the rules of the grammar
 *      specifed by `ParserConfiguraiton.rule(...)`
 * - iterate until there are no more nodes to generate.
 *
 * Steps to implement a parser:
 *
 * 1) Implement a parser configuration by extending the `ParserConfiguration` class.
 *
 * 1a) Specify the tokenizer.
 *
 * Specify the tokenizer by providing regexes to match keywords and tokens in the language.
 * override `ParserConfiguration.hasTokenRegex`, `ParserConfiguration.hasWhitespaceRegex`
 * and `ParserConfiguration.hasCommentRegex`.
 *
 * For tokens like keywords, the id of the token/node is equal to the matched string.
 *
 * For tokens like identifiers, use `ParserConfiguration.hasTokenRegex/2` to specify the id of
 * the matched token.
 *
 * 1b) Specify the grammar rules.
 *
 * Override `ParserConfiguration.rule(...)` to specify the grammar rules.
 *
 * 2) Extend the class `ParsedString` with strings that contain the text you want to parse.
 * Initially, these will simply be test cases.
 * Then, it can be literals from a snapshot.
 * Then, it will be whole files from the universal extractor matching the right file extension.
 *
 * 3) Create QL classes for interesting nodes.  These will be of the form
 * ```
 *  abstract class ArithmeticExpr extends ExprNode {
 *    // All nodes are binary. `this.getLeftNode()` is an intermediate node.
 *    ExprNode getLeft() { result = this.getLeftNode().getLeftNode() }
 *
 *    ExprNode getRight() { result = this.getRightNode() }
 *  }
 *
 * class SqlAddExpr extends ArithmeticExpr {
 *   SqlAddExpr() { id="expr+expr" }  // The exact synthesized node id.
 * }
 * ```
 */

/**
 * The configuration of a parser.
 *
 * Extend this class with each language you need to parse.
 */
abstract class ParserConfiguration extends string {
  bindingset[this]
  ParserConfiguration() { any() }

  predicate hasFileExtension(string ext) { none() }

  /** Tokens whose id is the same as the token text. */
  predicate hasTokenRegex(string regex) { none() }

  /** Whitespace tokens. */
  predicate hasWhitespaceRegex(string regex) { none() }

  /** Coment tokens. */
  predicate hasCommentRegex(string regex) { none() }

  /** Any other tokens not covered can map to a given token-id. */
  predicate hasTokenRegex(string regex, string id) { none() }

  /**
   * Grammar rules of the form
   *   result -> a
   *
   * The parser does not generate rules of id=`result`, but instead it
   * searches for nodes of id=`a` when considering nodes to create.
   */
  string rule(string a) { none() }

  /**
   * Grammar rules of the form
   *   result -> a b
   *
   * If the parser sees a node id=`a` next to a node of id=`b`,
   * then the parser creates a node of id=`a+b`.
   * Nodes of id=`a+b` are considered to be nodes of id=`result`
   * when considering nodes to create.
   */
  string rule(string a, string b) { none() }

  /**
   * Grammar rules of the form
   *   result -> a b c
   */
  string rule(string a, string b, string c) { none() }

  private string convert(string a) {
    result = rule(a)
    or
    exists(string a0, string b0, string c0 | result = rule(a0, b0, c0) and a = a0 + b0 + c0)
    or
    exists(string a0, string b0 | result = rule(a0, b0) and a = a0 + b0)
  }

  bindingset[fromKind]
  private string convertS(string fromKind) {
    result = fromKind
    or
    result = convert(fromKind)
    or
    result = convert(convert(fromKind))
    or
    result = convert(convert(convert(fromKind)))
    or
    result = convert(convert(convert(convert(fromKind))))
  }

  private string merge(string a, string b) {
    exists(rule(a, b)) and result = a + b
    or
    exists(string a1, string b1, string c1 | exists(rule(a1, b1, c1)) |
      a = a1 and b = b1 and result = a1 + b1
      or
      a = a1 + b1 and b = c1 and result = a1 + b1 + c1
    )
  }

  predicate validSrc(string src) {
    src = convert(_) or
    exists(convert(src)) or
    exists(merge(src, _)) or
    exists(merge(_, src))
  }

  string convert2(string s) {
    validSrc(s) and result = s
    or
    result = this.convert(s)
    or
    result = this.convert(convert2(s))
  }

  string merge2(string a, string b) { result = merge(convert2(a), convert2(b)) }

  predicate hasInterpolationRegex(string regex, string id) { none() }
}

/**
 * A string to be parsed.
 */
abstract class ParsedString extends string {
  bindingset[this]
  ParsedString() { any() }

  abstract ParserConfiguration getConfiguration();

  /**
   * Gets the tokens in the string.
   * Override this predicate to implement your tokenizer.
   * `start` is the offset of the token in this string.
   * `id` is a meaningful identifier.
   */
  cached
  string tokens(int pos, string id) {
    exists(ParserConfiguration config | config = this.getConfiguration() |
      result = this.keywordToken(pos) and id = result.toUpperCase()
      or
      exists(string regex | config.hasWhitespaceRegex(regex) |
        result = this.regexpFind(regex, _, pos) and id = "ws"
      )
      or
      exists(string regex | config.hasCommentRegex(regex) |
        result = this.regexpFind(regex, _, pos) and id = "comment"
      )
      or
      exists(string regex | config.hasTokenRegex(regex, id) |
        result = this.regexpFind(regex, _, pos) and
        not result = this.keywordToken(pos)
      )
    )
  }

  // Shouldn't need to cache this
  cached
  private string keywordToken(int pos) {
    exists(string regex | this.getConfiguration().hasTokenRegex(regex) |
      result = this.regexpFind(regex, _, pos)
    )
  }

  /**
   * Gets the syntax nodes in this parsed string.
   * override this predicate with the grammar rules.
   */
  abstract predicate getLocationInfo(
    string file, int startLine, int startCol, int endLine, int endCol
  );

  // This is basically the parsing algorithm.
  // - All tokens are nodes.
  // - If you find two adjcacent nodes that can be merged, create a new node.
  predicate nodes(int start, int next, string id) {
    exists(tokenize(this, id, _, start)) and next = start + 1
    or
    exists(ParserConfiguration config, int mid, string id0, string id1 |
      this.nodes(start, mid, id0) and
      this.nodes(mid, next, id1) and
      config = this.getConfiguration() and
      id = config.merge2(id0, id1)
      //id = config.merge(config.convertS(id0), config.convertS(id1))
    )
  }
}

private predicate lines(ParsedString str, int index, int line) {
  line = 0 and index = 0
  or
  index = rank[line](int x | x = str.indexOf("\n") or x = str.length())
}

// Maps the position `pos` to a row and column
// within the string `text`. This is used for computing
// locations to nodes.
private predicate rowCol(ParsedString str, int index, int line, int col) {
  exists(int index1, int index2 |
    lines(str, index1, line - 1) and
    lines(str, index2, line) and
    index in [index1 .. index2 - 1] and
    col = index - index1
  )
}

newtype TNode =
  TNonterminalNode(ParsedString text, int startIndex, int endIndex, string id) {
    text.nodes(startIndex, endIndex, id)
  }

/**
 * Recursive predicate representing all nodes in the parse tree.
 */
predicate nodes(TNode node, ParsedString text, int start, int next, string id) {
  node = TNonterminalNode(text, start, next, id)
}

/**
 * A syntax node.
 */
class Node extends TNode {
  ParsedString text;
  int start;
  int next;
  string id;

  /** Gets the token- or node- id of this node. */
  string getId() { result = id }

  /** Holds if this node is convertible to `toid`. */
  predicate hasId(string toid) { toid = text.getConfiguration().convert2(id) }

  /** Gets the offset of the text in the string. */
  int getStartOffset() { exists(tokenize(text, _, result, start)) }

  /** Gets the offset of the end of the text in the string. */
  int getEndOffset1() { exists(int pos | result = tokenize(text, _, pos, next - 1).length() + pos) }

  int getEndOffset2() {
    // The offset of the end of the first token!
    exists(int startPos | result = tokenize(text, _, startPos, start).length() + startPos)
  }

  int getEndOffset() {
    // The end offset isn't the end of the last token
    // if this node is an interpolated string.
    if this.getEndOffset1() < this.getEndOffset2()
    then result = this.getEndOffset2()
    else result = this.getEndOffset1()
  }

  Node() { nodes(this, text, start, next, id) }

  predicate isBefore(Node other) {
    exists(int otherstart |
      nodes(other, text, otherstart, _, _) and
      start < otherstart
    )
  }

  string toString() { result = this.getText() }

  string getText() { result = text.substring(this.getStartOffset(), this.getEndOffset()) }

  /**
   * Creates a location for the node using the location of the text,
   * then adjust the starts and ends based on `start` and `end`.
   */
  predicate hasLocationInfo(string file, int startLine, int startCol, int endLine, int endCol) {
    exists(int line, int col |
      text.getLocationInfo(file, line, col, _, _) and
      nodeLocation(text, this.getStartOffset(), line, col, startLine, startCol) and
      nodeLocation(text, this.getEndOffset() - 1, line, col, endLine, endCol)
    )
  }

  predicate follows(Node previous) { nodes(previous, text, _, start, _) }

  /**
   * Gets the left child of this node, if any.
   * All nodes are terminal or binary.
   */
  Node getLeftNode() { this.splits(result, _) }

  /**
   * Gets the right child of this node, if any.
   * All nodes are terminal or binary.
   */
  Node getRightNode() { this.splits(_, result) }

  predicate splits(Node left, Node right) {
    exists(ParserConfiguration config, int mid, string id0, string id1 |
      nodes(left, text, start, mid, id0) and
      nodes(right, text, mid, next, id1) and
      id = config.merge2(id0, id1)
    )
  }

  /** Gets a child node of this node, if any. */
  Node getAChildNode() { result = this.getLeftNode() or result = this.getRightNode() }

  /** Gets the parent of this node, if any. */
  Node getParent() { this = result.getAChildNode() }

  /**
   * Holds if this is the root node that spans the entire input.
   * It is not sufficient to not have a parent: that could be a parsed fragment.
   */
  predicate isRoot() { start = 1 and next = getNumberOfTokens(text) + 1 }

  /** Holds if this node has a path to the root node. */
  predicate isRooted() { this.isRoot() or this.getParent().isRooted() }
}

/** A node that is a token. */
class Token extends Node {
  Token() { next = start + 1 }
}

pragma[noopt]
private predicate nodeLocation(ParsedString text, int pos, int line0, int col0, int line, int col) {
  text.getLocationInfo(_, line0, col0, _, _) and
  exists(int l, int c | rowCol(text, pos, l, c) |
    line = line0 + l and
    col = col0 + c
  )
}

/**
 * Performs a tokenization of the source text, ensuring that
 * tokens are contiguous to remove spurious tokens (e.g. contents of strings).
 * This tokenization includes whitespace and comment tokens
 * that we will filter out later (in `nonWs`).
 */
pragma[noopt]
private string leftrightTokenize(ParsedString text, string id, int pos) {
  result = longestToken(text, id, 0) and pos = 0
  or
  exists(string prevText, int prevPos, int prevLength |
    prevText = leftrightTokenize(text, _, prevPos) and
    prevLength = prevText.length() and
    pos = prevPos + prevLength and
    result = longestToken(text, id, pos)
  )
}

private string interpolatedToken(ParsedString text, string id, int pos) {
  exists(string regex | text.getConfiguration().hasInterpolationRegex(regex, id) |
    result = text.regexpFind(regex, _, pos)
  )
}

// Special handling of interpolated strings
private string interpolatedStringTokens(ParsedString text, string id, int pos) {
  exists(string interpolatedString, int start, int end |
    interpolatedString = leftrightTokenize(text, "interpolatedstring", start) and
    end = start + interpolatedString.length()
  |
    result = interpolatedToken(text, id, pos) and
    pos > start and
    pos < start + end - 1
    //    pos in [start + 1, start + end - 1]
  )
}

// Debugging predicate: Indicates which source strings are successfully tokenized.
predicate successfullyTokenized(ParsedString text) { tokenizedLength(text) = text.length() }

// Debugging predicate: Indicates which source strings have not been
// successfully tokenized. Quick-eval this to see where the tokenizer has failed.
predicate unsuccessfullyTokenized(ParsedString text, int length, string failedAt) {
  length = tokenizedLength(text) and
  not successfullyTokenized(text) and
  failedAt = text.suffix(length)
}

// Gets the number of characters that were successfully tokenized in a source string.
// This is useful to debug the tokenizer.
int tokenizedLength(ParsedString text) {
  exists(int maxpos |
    maxpos = max(int pos | exists(leftrightTokenize(text, _, pos))) and
    result = maxpos + leftrightTokenize(text, _, maxpos).length()
  )
}

// Tidy up `tokens`. If the same position can have two different tokens,
// pick the longest token.
private string longestToken(ParsedString text, string id, int pos) {
  result = text.tokens(pos, id) and
  not text.tokens(pos, _).length() > result.length()
}

private string nonWs(ParsedString text, string id, int pos) {
  result = leftrightTokenize(text, id, pos) and
  (id != "ws" and id != "comment")
  or
  result = interpolatedStringTokens(text, id, pos)
}

/**
 * Tokenizes the string left-right, removing whitespace and comments,
 * and creates a rank `seq` for each token for all non-whitespace tokens.
 */
cached
string tokenize(ParsedString text, string id, int pos, int seq) {
  pos = rank[seq](int p | exists(nonWs(text, _, p)) | p) and
  result = nonWs(text, id, pos)
}

int getNumberOfTokens(ParsedString text) { result = max(int n | exists(tokenize(text, _, _, n))) }
