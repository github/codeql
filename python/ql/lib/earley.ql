/**
 * @kind graph
 * @id shared/earley
 */
string input() { result = "[a][b-c][e-][f-g---h][i-j-k]" } //[b-c][-d][e-][^f-g]" }

/** The production that matches the empty string. */
string epsilon() { result = "" }

extensible predicate grammar(string line);

string grammar_line() { exists(string grm | grammar(grm) | result = grm.splitAt("\n")) }

predicate rule(string lhs, string prod) {
  exists(string line, string delimiter |
    line = grammar_line() and delimiter = " ::= " and line.charAt(0) != "#"
  |
    lhs = line.splitAt(delimiter, 0) and
    prod = line.splitAt(delimiter, 1)
  )
}

bindingset[s]
string getStringToken(string s) { s.charAt(0) = "'" and result = s.substring(1, s.length() - 1) }

bindingset[s]
string getRegexToken(string s) { s.charAt(0) = "r" and result = s.substring(2, s.length() - 1) }

bindingset[s]
predicate is_nonterminal(string s) { s.charAt(0).toUpperCase() = s.charAt(0) }

predicate valid_index(string lhs, string prod, int index) {
  rule(lhs, prod) and
  if prod = epsilon()
  then index = 0
  else index in [0 .. max(int i | exists(prod.splitAt(" ", i)) | i) + 1]
}

string start_symbol() {
  result = "S"
  or
  none() and
  result = unique(string s | rule(s, _) and not s = any(Item i).getNextPart())
}

newtype TItem = TEarleyItem(string lhs, string prod, int index) { valid_index(lhs, prod, index) }

/**
 * An item in an Earley-style parser. Each item consists of a grammar production rule (which we
 * write `lhs -> prod`) and an index indicating how far into the production we have successfully
 * parsed. As is customary, we indicate this by putting a marker (`*`) in that spot.
 *
 * Thus, the item `S -> A b * C d` has `lhs` equal to `S`, `prod` equal to `A b C d`, and `index`
 * equal to `2`. The possible values for `index` range from zero (indicating no right-hand
 * side parts have been parsed) to the number of right-hand side parts (indicating that
 * all parts have been parsed successfully).
 */
class Item extends TItem {
  string lhs;
  string prod;
  int index;

  Item() { this = TEarleyItem(lhs, prod, index) }

  /** Gets the `i`th item in the production for this item. */
  string getRhsPart(int i) { prod != epsilon() and result = prod.splitAt(" ", i) }

  /** Holds if the production for this item has no more parts left after the index. */
  predicate isComplete() { not exists(this.getNextPart()) }

  /**
   * Holds if this item is the entry point for parsing. Its lhs is the root nonterminal for the
   * grammar, and its index is 0.
   */
  predicate isStartItem() {
    lhs = start_symbol() and
    index = 0
  }

  /** Gets the nonterminal for this item. */
  string getLhs() { result = lhs }

  /** Gets the production for this item. */
  string getProduction() { result = prod }

  /** Gets the index for this item. */
  int getIndex() { result = index }

  predicate isHidden() { this.getLhs().charAt(0) = "_" }

  /**
   * Gets the item that precedes this one, if one exists. Has the same lhs and production, but the
   * index is one lower.
   */
  Item getPredecessor() {
    result.getLhs() = this.getLhs() and
    result.getProduction() = this.getProduction() and
    result.getIndex() = this.getIndex() - 1
  }

  Item getSuccessor() { result.getPredecessor() = this }

  /** Gets the part (token or nonterminal) that is needed for this item to continue its parse. */
  string getNextPart() { result = this.getRhsPart(index) }

  /** Gets the part (token or nonterminal) just before the index. */
  string getPreviousPart() { result = this.getRhsPart(index - 1) }

  predicate isPreviousPartNonterminal() { is_nonterminal(this.getPreviousPart()) }

  predicate isPreviousPartTerminal() {
    exists(getStringToken(this.getPreviousPart())) or exists(getRegexToken(this.getPreviousPart()))
  }

  private string beforeIndex() {
    index = 0 and result = ""
    or
    result = strictconcat(int i | i < index | this.getRhsPart(i), " " order by i)
  }

  private string afterIndex() {
    this.isComplete() and result = ""
    or
    result = strictconcat(int i | i >= index | this.getRhsPart(i), " " order by i)
  }

  /** Gets a string representation of this element. */
  string toString() { result = lhs + " -> " + this.beforeIndex() + " * " + this.afterIndex() }

  bindingset[i, j]
  string toStringWithIndices(int i, int j) {
    result = lhs + " -> [" + i + "] " + this.beforeIndex() + " [" + j + "] " + this.afterIndex()
  }
}

/**
 * Holds if the grammar rule `lhs -> prod` can be matched until the `index`th position of `prod`
 * (with all three of these represented as the single item `item`) starting just before
 * the `start`th token, and ending just after the `end`th token. Moreover, the length of the last
 * part of the item is recorded in `last_part_length`.
 */
predicate earleySet(Item item, int start, int end, int last_part_length) {
  // Start
  // Add Root_node -> * Root_prod (from 0 to 0)
  item.isStartItem() and start = 0 and end = 0 and last_part_length = 0
  or
  // Scanning
  // If Lhs -> ... * token ... (from start to end - length)
  // and token is equal to the (end - length)'th token
  // then Lhs -> ... token * ... (from start to end)
  //
  // where length is the length of the matched nonterminal (this is just the length of the string
  // for simple string matches, or the length of the regular expression match for regex matches).
  exists(Item pred, string next_part |
    pred = item.getPredecessor() and next_part = pred.getNextPart()
  |
    exists(string token | token = getStringToken(next_part) |
      earleySet(pred, start, end - token.length(), _) and
      token = input().substring(end - token.length(), end) and
      last_part_length = token.length()
    )
    or
    exists(string token, string match, int prev_end | token = getRegexToken(next_part) |
      earleySet(pred, start, prev_end, _) and
      match = input().suffix(prev_end).regexpFind(token, _, 0) and
      end = prev_end + match.length() and
      last_part_length = match.length()
    )
  )
  or
  // Prediction
  // If Outer_lhs -> ... * Lhs ... (from start to end)
  // we want to add Lhs -> * Prod (from end to end)
  // for all possible productions Prod for Lhs
  exists(Item outer |
    earleySet(outer, _, end, _) and
    outer.getNextPart() = item.getLhs() and
    item.getIndex() = 0 and
    start = end and
    last_part_length = 0
  )
  or
  // Completion
  // If Lhs -> ... * Inner_lhs ... (from start to mid)
  // and Inner_lhs -> Prod * (from mid to end)
  // then Lhs -> ... Inner_lhs * ... (from start to end)
  exists(Item inner, int mid |
    inner.isComplete() and
    item.getPreviousPart() = inner.getLhs() and
    earleySet(item.getPredecessor(), start, mid, _) and
    earleySet(inner, mid, end, _) and
    last_part_length = end - mid
  )
}

newtype TNode =
  TItemNode(Item item, int start, int end, int last_part_length) {
    earleySet(item, start, end, last_part_length)
  } or
  TTokenNode(string terminal, int start, int end, string token) {
    exists(Item item, int last_part_length |
      earleySet(item, _, end, last_part_length) and
      terminal = item.getPreviousPart() and
      start = end - last_part_length and
      token = input().substring(start, end) and
      item.isPreviousPartTerminal()
    )
  }

class Node extends TNode {
  abstract string toString();

  abstract int getEnd();

  abstract int getStart();

  abstract predicate isVisible();
}

class ItemNode extends TItemNode, Node {
  Item item;
  int start;
  int end;
  int last_part_length;

  ItemNode() { this = TItemNode(item, start, end, last_part_length) }

  Item getItem() { result = item }

  override int getStart() { result = start }

  override int getEnd() { result = end }

  int getLastPartLength() { result = last_part_length }

  override predicate isVisible() {
    not item.isHidden() and
    exists(item.getRhsPart(1))
  }

  predicate isTopNode() { start = 0 and end = input().length() and item.getLhs() = "S" }

  /**
   * Gets the left and right children of this node. The right child corresponds to the nonterminal
   * just before the index in this item. The left child corresponds to the item just _before_ that
   * item.
   *
   * Thus, for the item `A -> Foo Bar * Baz`,
   * the left child corresponds to the item `A -> Foo * Bar Baz`,
   * the right child corresponds to an item `Bar -> Whatever *`,
   * and these two items exactly split up the range of tokens from start to end.
   */
  predicate getNextSpineAndChildForNonterminal(ItemNode left, ItemNode right) {
    item.isPreviousPartNonterminal() and
    left.getItem() = item.getPredecessor() and
    left.getStart() = start and
    left.getEnd() = right.getStart() and
    right.getStart() = end - last_part_length and
    right.getItem().isComplete() and
    right.getItem().getLhs() = item.getPreviousPart() and
    right.getEnd() = end
  }

  predicate getNextSpineItemAndTokenForTerminal(ItemNode left, TokenNode right) {
    left.getItem() = item.getPredecessor() and
    left.getStart() = start and
    left.getEnd() = right.getStart() and
    right.getStart() = end - last_part_length and
    right.getEnd() = end and
    right.getTerminal() = item.getPreviousPart()
  }

  ItemNode getSpineItem() {
    this.getNextSpineAndChildForNonterminal(result, _) or
    this.getNextSpineItemAndTokenForTerminal(result, _)
  }

  Node getAChild() {
    item.isComplete() and
    (
      this.getSpineItem*().getNextSpineAndChildForNonterminal(_, result) or
      this.getSpineItem*().getNextSpineItemAndTokenForTerminal(_, result)
    )
  }

  Node getAVisibleChild() {
    result = this.getAChild() and result.isVisible()
    or
    exists(ItemNode n | n = this.getAChild() and not n.isVisible() | result = n.getAVisibleChild())
  }

  Node getChild(int i) {
    this.isVisible() and
    result = rank[i + 1](Node n | n = this.getAVisibleChild() | n order by n.getStart())
  }

  override string toString() { result = item.toStringWithIndices(start, end) }
}

class TokenNode extends TTokenNode, Node {
  string terminal;
  int start;
  int end;
  string token;

  TokenNode() { this = TTokenNode(terminal, start, end, token) }

  string getTerminal() { result = terminal }

  override int getStart() { result = start }

  override int getEnd() { result = end }

  string getToken() { result = token }

  override predicate isVisible() { terminal.charAt(0) = "r" }

  override string toString() {
    result = token + " : " + terminal + " @ (" + start + ", " + end + ")"
  }
}

/*
 * Parse example
 *
 *
 * S  --> 'a'
 * S  --> S r'b+' 'a'
 *
 * r'b+' @ (i,j)
 * 'a' @ (i,j)
 *
 * 0 1 2 3 4 5 6
 * a b a b b a
 *
 * S(
 *  [S(
 *    [S(['a'], 0, 1),
 *    'b',
 *    'a'],
 *    0, 3
 *    ),
 *    'bb',
 *    'a'],
 *    0, 6
 *  )
 * )
 */

query predicate edges(ItemNode parent, Node child, string label1, string label2) {
  any(ItemNode top | top.isTopNode()).getAChild*() = parent and
  exists(int i |
    child = parent.getChild(i) and
    label1 = "semmle.label" and
    label2 = i.toString() and
    (
      child instanceof ItemNode or
      any() //child.(TokenNode).getTerminal().charAt(0) = "r"
    )
  )
}

query predicate graphProperties(string key, string value) {
  key = "semmle.graphKind" and value = "tree"
}
