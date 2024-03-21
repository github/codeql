/**
 * @kind graph
 * @id shared/earley
 */
//string input() { result = "[------------------------------------]" } //"[a][b-c][e-][f-g---h][i-j-k]" } //[b-c][-d][e-][^f-g]" }
string input() { grammar("grammars", result) }

/** The production that matches the empty string. */
string epsilon() { result = "" }

extensible predicate grammar(string name, string lines);

string grammar_line(int i) {
  exists(string grm | grammar("grammars", grm) | result = grm.splitAt("\n", i))
}

predicate rule(string lhs, string rhs, int priority) {
  exists(string line, string delimiter |
    line = grammar_line(priority) and delimiter = " ::= " and line.charAt(0) != "#"
  |
    lhs = line.splitAt(delimiter, 0) and
    rhs = line.splitAt(delimiter, 1)
  )
}

bindingset[s]
string getStringToken(string s) { s.charAt(0) = "'" and result = s.substring(1, s.length() - 1) }

bindingset[s]
string getRegexToken(string s) { s.charAt(0) = "r" and result = s.substring(2, s.length() - 1) }

bindingset[s]
predicate is_nonterminal(string s) { s.charAt(0).toUpperCase() = s.charAt(0) }

predicate valid_index(string lhs, string rhs, int index, int priority) {
  rule(lhs, rhs, priority) and
  if rhs = epsilon()
  then index = 0
  else index in [0 .. max(int i | exists(rhs.splitAt(" ", i)) | i) + 1]
}

string rhs_part(string lhs, string rhs, int index) {
  valid_index(lhs, rhs, index, _) and
  result = rhs.splitAt(" ", index)
}

string start_symbol() {
  result = "S"
  or
  none() and
  result = unique(string s | rule(s, _, _) and not s = any(EarleyProduction i).getNextPart())
}

string left_corner(string nonterminal) { result = rhs_part(nonterminal, _, 0) }

string left_corner_token(string nonterminal) {
  result = left_corner+(nonterminal) and
  result.charAt(0) in ["'", "r"]
}

newtype TProduction =
  TEarleyProduction(string lhs, string rhs, int index, int priority) {
    valid_index(lhs, rhs, index, priority)
  } or
  TTokenProduction(string token, int index) {
    index in [0, 1] and
    token = any(rhs_part(_, _, _)) and
    (exists(getRegexToken(token)) or exists(getStringToken(token)))
  }

class Production extends TProduction {
  abstract string toString();

  abstract predicate isComplete();

  abstract predicate isPrediction();

  abstract predicate isStartItem();

  abstract predicate isHidden();

  abstract int getPriority();

  abstract string getLhs();
}

class TokenProduction extends TTokenProduction, Production {
  string token;
  int index;

  TokenProduction() { this = TTokenProduction(token, index) }

  override string getLhs() { result = token }

  override predicate isComplete() { index = 1 }

  override predicate isPrediction() { index = 0 }

  override predicate isStartItem() { none() }

  override predicate isHidden() { none() }

  override int getPriority() { result = 0 }

  TokenProduction asPrediction() { result.getLhs() = this.getLhs() and result.isPrediction() }

  override string toString() {
    if index = 0 then result = token + " (predicted)" else result = token + " (completed)"
  }

  bindingset[specific, start, end]
  string toStringAsSpecificInstance(string specific, int start, int end) {
    result =
      "'" + specific + "' : " + this.getLhs() + " @ [" + start.toString() + ", " + end.toString() +
        "]"
  }
}

/**
 * An item in an Earley-style parser. Each item consists of a grammar production rule (which we
 * write `lhs -> rhs`) and an index indicating how far into the production we have successfully
 * parsed. As is customary, we indicate this by putting a marker (`*`) in that spot.
 *
 * Thus, the item `S -> A b * C d` has `lhs` equal to `S`, `rhs` equal to `A b C d`, and `index`
 * equal to `2`. The possible values for `index` range from zero (indicating no right-hand
 * side parts have been parsed) to the number of right-hand side parts (indicating that
 * all parts have been parsed successfully).
 */
class EarleyProduction extends TEarleyProduction, Production {
  string lhs;
  string rhs;
  int index;
  int priority;

  EarleyProduction() { this = TEarleyProduction(lhs, rhs, index, priority) }

  /** Gets the `i`th item in the production for this item. */
  string getRhsPart(int i) { rhs != epsilon() and result = rhs.splitAt(" ", i) }

  /** Holds if the production for this item has no more parts left after the index. */
  override predicate isComplete() { not exists(this.getNextPart()) }

  /**
   * Holds if this item is the entry point for parsing. Its lhs is the root nonterminal for the
   * grammar, and its index is 0.
   */
  override predicate isStartItem() {
    lhs = start_symbol() and
    index = 0
  }

  /** Gets the nonterminal for this item. */
  override string getLhs() { result = lhs }

  /** Gets the right hand side for this item. */
  string getRhs() { result = rhs }

  /** Gets the index for this item. */
  int getIndex() { result = index }

  override predicate isPrediction() { index = 0 }

  override int getPriority() { result = priority }

  override predicate isHidden() { this.getLhs().charAt(0) = "_" }

  /**
   * Gets the item that precedes this one, if one exists. Has the same lhs and rhs, but the
   * index is one lower.
   */
  EarleyProduction getPredecessor() {
    result.getLhs() = this.getLhs() and
    result.getRhs() = this.getRhs() and
    result.getIndex() = this.getIndex() - 1
  }

  EarleyProduction getSuccessor() { result.getPredecessor() = this }

  /** Gets the part (token or nonterminal) that is needed for this item to continue its parse. */
  string getNextPart() { result = this.getRhsPart(index) }

  /** Gets the part (token or nonterminal) just before the index. */
  string getPreviousPart() { result = this.getRhsPart(index - 1) }

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
  override string toString() {
    result = lhs + " -> " + this.beforeIndex() + " * " + this.afterIndex()
  }

  bindingset[i, j]
  string toStringWithIndices(int i, int j) {
    result = lhs + " -> [" + i + "] " + this.beforeIndex() + " [" + j + "] " + this.afterIndex()
  }
}

/**
 * Holds if `rhs_part` has been predicted (top-down) to appear at position `start` in the input.
 * This is the case if it is the next part of a production that has been completed up to the point * where it next expects `rhs_part` (which may be either a terminal or nonterminal).
 */
predicate predict_rhs_part(string rhs_part, int start) {
  exists(EarleyProduction prod |
    earleyItem(prod, _, start) and
    rhs_part = prod.getNextPart()
  )
}

/**
 * Holds if `prod` has been predicted (bottom-up) to start at position `start` in the input. This
 * is a hybrid of prediction and completion, where we only predict an intermediate item if we have
 * already found a way to complete the first part of the production. Thus, this boils down to
 * finding a production for a left corner (of the outer top-down prediction) for which the first
 * part of the right hand side has a completion. If this is found, we create a normal prediction
 * item for that production at the given position (and this will then in turn be completed
 * immediately).
 */
predicate bottom_up_prediction(EarleyProduction prod, int start) {
  exists(string top_down_predictor, Production completed_left_corner |
    predict_rhs_part(top_down_predictor, start) and
    prod.getLhs() = left_corner*(top_down_predictor) and
    prod.isPrediction() and
    prod.getNextPart() = completed_left_corner.getLhs() and
    earleyItem(completed_left_corner, start, _)
  )
}

/**
 * Holds if the token production `prod` has been predicted to start at position `start` in the
 * input. This requires that the token is a left corner of some outer top-down prediction also
 * starting at `start`.
 */
predicate predict_terminal(TokenProduction prod, int start) {
  exists(string top_down_predictor |
    predict_rhs_part(top_down_predictor, start) and
    prod.getLhs() = left_corner*(top_down_predictor) and
    prod.isPrediction()
  )
}

/**
 * Holds if the token production `prod` matches the input from `start` to `end`. Note that only
 * tokens that are in the `predict_terminal` relation are attempted to be matched.
 */
predicate scan(TokenProduction prod, int start, int end) {
  prod.isComplete() and
  predict_terminal(prod.asPrediction(), start) and
  (
    exists(string token | token = getStringToken(prod.getLhs()) |
      token = input().substring(start, end) and
      end = token.length() + start
    )
    or
    exists(string regex, string match | regex = getRegexToken(prod.getLhs()) |
      match = input().suffix(start).regexpFind(regex, _, 0) and
      end = match.length() + start
    )
  )
}

/**
 * Holds if the grammar rule `lhs -> rhs` can be matched until the `index`th position of `rhs`
 * (with all three of these represented as the single dotted production `prod`) starting just before
 * the `start`th token, and ending just after the `end`th token.
 */
predicate earleyItem(Production prod, int start, int end) {
  start = 0 and
  start = end and
  prod.isStartItem()
  or
  // Scanning
  // If Lhs -> ... * token ... (from start to end - length)
  // and token is equal to the (end - length)'th token
  // then Lhs -> ... token * ... (from start to end)
  //
  // where length is the length of the matched nonterminal (this is just the length of the string
  // for simple string matches, or the length of the regular expression match for regex matches).
  scan(prod, start, end)
  or
  // Prediction
  // If Outer_lhs -> ... * Lhs ... (from start to end)
  // we want to add Lhs -> * Rhs (from end to end)
  // for all possible right hand sides Rhs for Lhs
  bottom_up_prediction(prod, start) and
  end = start
  or
  none() and
  // Normal prediction
  exists(EarleyProduction outer_prod |
    earleyItem(outer_prod, _, start) and
    start = end and
    outer_prod.getNextPart() = prod.getLhs() and
    prod.isPrediction()
  )
  or
  // Completion
  // If Lhs -> ... * Inner_lhs ... (from start to mid)
  // and Inner_lhs -> Rhs * (from mid to end)
  // then Lhs -> ... Inner_lhs * ... (from start to end)
  exists(Production inner, int mid |
    inner.isComplete() and
    prod.(EarleyProduction).getPreviousPart() = inner.getLhs() and
    earleyItem(prod.(EarleyProduction).getPredecessor(), start, mid) and
    earleyItem(inner, mid, end)
  )
}

newtype TNode = TItemNode(Production prod, int start, int end) { earleyItem(prod, start, end) }

class Node extends TNode {
  abstract string toString();

  abstract int getEnd();

  abstract int getStart();

  abstract predicate isVisible();
}

// Gets the lowest priority item that matches the given nonterminal at the given end position.
ItemNode best_match(string rhs_part, int start, int end) {
  result =
    min(ItemNode right, ItemNode left |
      right.getItem().getLhs() = rhs_part and
      right.getItem().isComplete() and
      right.getEnd() = end and
      left.getStart() = start and
      left.getEnd() = right.getStart() and
      left.getItem().(EarleyProduction).getNextPart() = rhs_part
    |
      right order by right.getItem().getPriority()
    )
}

class ItemNode extends TItemNode, Node {
  Production prod;
  int start;
  int end;

  ItemNode() { this = TItemNode(prod, start, end) }

  Production getItem() { result = prod }

  override int getStart() { result = start }

  override int getEnd() { result = end }

  override predicate isVisible() {
    prod instanceof TokenProduction
    or
    not prod.isHidden() and
    exists(prod.(EarleyProduction).getRhsPart(1))
  }

  predicate isTopNode() { start = 0 and end = input().length() and prod.getLhs() = "S" }

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
    left.getItem() = prod.(EarleyProduction).getPredecessor() and
    left.getStart() = start and
    left.getEnd() = right.getStart() and
    right.getItem().isComplete() and
    right.getItem().getLhs() = prod.(EarleyProduction).getPreviousPart() and
    right.getEnd() = end and
    right = best_match(prod.(EarleyProduction).getPreviousPart(), start, end)
  }

  ItemNode getSpineItem() { this.getNextSpineAndChildForNonterminal(result, _) }

  Node getAChild() {
    prod.isComplete() and
    this.getSpineItem*().getNextSpineAndChildForNonterminal(_, result)
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

  override string toString() {
    result in [
        prod.(EarleyProduction).toStringWithIndices(start, end),
        prod.(TokenProduction).toStringAsSpecificInstance(input().substring(start, end), start, end)
      ]
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
