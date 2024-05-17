/*
 *  GLR parser framework.
 *  This is purely for fun.
 */

signature string grammar();

signature string input(int i);

// A GLR parser
module GLR<grammar/0 g> {
  // We need to add a special rule that includes the end of file symbol $
  string initialRule() { result = "Start_ -> G $" }

  // Gets the left hand side of a rule - for internal use
  string getRuleLhs(Rule rule) { result = rule.splitAt(" ", 0) }

  // Gets a right hand side of a rule - for internal use
  string getRuleRhs(Rule rule, int i) { i >= 0 and result = rule.splitAt(" ", 2 + i) }

  // A rule, which is either from the supplied rules, or the bootstrap rule
  class Rule extends string {
    Rule() { this = [g(), initialRule()] }

    NonTerminal getLhs() { result = getRuleLhs(this) }

    Symbol getRhs(int i) { result = getRuleRhs(this, i) }

    int getLength() { result = count(int i | exists(this.getRhs(i))) }
  }

  // Any symbol in the grammar
  class Symbol extends string {
    Symbol() { exists(Rule rule | this = getRuleLhs(rule) or this = getRuleRhs(rule, _)) }

    // Determines whether this symbol can be empty
    // There must exist one rule that may be empty
    // For terminal symbols, with no rules, this will be false
    predicate maybeEmpty() {
      exists(Rule rule |
        rule.getLhs() = this and
        forall(int i | exists(rule.getRhs(i)) | rule.getRhs(i).(NonTerminal).maybeEmpty())
      )
    }

    // Gets a terminal symbol that may start this rule.
    // This is needed in order to find lookahead symbols
    Terminal getFirst() {
      // We are a terminal
      result = this
      or
      // We are a nonterminal
      // Also handle the possibility that symbols may be empty
      exists(Rule rule, int i |
        rule.getLhs() = this and
        forall(int j | j in [0 .. i - 1] | rule.getRhs(j).(Symbol).maybeEmpty()) and
        result = rule.getRhs(i).(Symbol).getFirst()
      )
    }
  }

  // A non-terminal symbol, which means it has at leaset one rule in the grammar
  class NonTerminal extends Symbol {
    NonTerminal() { this = getRuleLhs(any(Rule r)) }
  }

  // A terminal symbol, as implied by the fact that it has no rules in the grammar
  class Terminal extends Symbol {
    Terminal() { not this instanceof NonTerminal }
  }

  // The end of file symbol
  class Eof extends Terminal {
    Eof() { this = "$" }
  }

  private Terminal follows(Rule rule, int dot, Terminal lookahead) {
    dot >= 0 and
    (
      dot + 1 = rule.getLength() and lookahead = result
      or
      rule.getRhs(dot).maybeEmpty() and result = follows(rule, dot + 1, lookahead)
      or
      result = rule.getRhs(dot + 1).getFirst()
    )
  }

  // Modify the idea of a transition so that we don't need to compute the closure
  private predicate transition(
    Rule rule1, int dot1, Terminal lookahead1, Symbol symbol, Rule rule2, int dot2,
    Terminal lookahead2
  ) {
    // We shift the symbol directly (a terminal or non-terminal)
    rule1.getRhs(dot1) = symbol and
    rule2 = rule1 and
    dot2 = dot1 + 1 and
    lookahead2 = lookahead1
    or
    exists(Rule rule3 | rule3.getLhs() = rule1.getRhs(dot1) |
      transition(rule3, 0, follows(rule1, dot1, lookahead1), symbol, rule2, dot2, lookahead2)
    )
  }

  bindingset[dot, lookahead]
  string itemToString(Rule rule, int dot, Terminal lookahead) {
    // item(rule, dot, lookahead) and
    result =
      rule.getLhs() + " -> " + concat(int i | i in [0 .. dot - 1] | rule.getRhs(i) + " " order by i)
        + ". " +
        concat(int i | i in [dot .. rule.getLength() - 1] | rule.getRhs(i) + " " order by i) + "{" +
        lookahead + "}"
  }

  string kernelItem(Rule rule, int dot) {
    dot = [0 .. rule.getLength()] and
    result =
      rule.getLhs() + " -> " + concat(int i | i in [0 .. dot - 1] | rule.getRhs(i) + " " order by i)
        + ". " +
        concat(int i | i in [dot .. rule.getLength() - 1] | rule.getRhs(i) + " " order by i)
  }

  predicate initialState(Rule rule, int dot, Terminal lookahead) {
    rule = initialRule() and dot = 0 and lookahead = "$"
  }

  predicate item(Rule rule, int dot, Terminal lookahead) {
    initialState(rule, dot, lookahead)
    or
    exists(Rule rule0, int dot0, Terminal lookahead0, Symbol s |
      item(rule0, dot0, lookahead0) and
      transition(rule0, dot0, lookahead0, s, rule, dot, lookahead)
    )
  }

  string getInitialState(Rule rule, int dot, Terminal lookahead) {
    initialState(rule, dot, lookahead) and
    result = " " + kernelItem(rule, dot)
  }

  string transitionState(string previous, Symbol s, Rule rule, int dot, Terminal lookahead) {
    exists(Rule rule0, int dot0, Terminal lookahead0 | item(rule0, dot0, lookahead0) |
      previous =
        [transitionState(_, _, rule0, dot0, lookahead0), getInitialState(rule0, dot0, lookahead0)] and
      transition(rule0, dot0, lookahead0, s, rule, dot, lookahead) and
      result =
        concat(string itemstring |
          exists(Rule rule3, int dot3, Terminal lookahead3 |
            transition(rule0, dot0, lookahead0, s, rule3, dot3, lookahead3) and
            itemstring = kernelItem(rule3, dot3)
          )
        |
          itemstring + "; " order by itemstring
        )
    )
  }

  class State extends string {
    State() {
      this = getInitialState(_, _, _)
      or
      this = transitionState(_, _, _, _, _)
    }

    predicate hasItem(Rule rule, int dot, Terminal lookahead) {
      this = getInitialState(rule, dot, lookahead)
      or
      this = transitionState(_, _, rule, dot, lookahead)
    }

    State getTransition(Symbol s) { result = transitionState(this, s, _, _, _) }

    int getNumber() { this = rank[result](State s) }

    State goto(NonTerminal s) { result = this.getTransition(s) }

    // In this state, when the lookahead symbol is `s`, we can shift to `result`
    State shift(Terminal s) { result = this.getTransition(s) }

    // In this state, when the lookahead symbol is `s`, we can reduce rule `result`
    Rule reduce(Terminal s) { this.hasItem(result, result.getLength(), s) }

    // This state has a reduce/reduce conflict, given by the possible shift to `state` or reduce by `rule`
    predicate shiftReduceConflict(Terminal s, State state, Rule rule) {
      this.shift(s) = state and this.reduce(s) = rule
    }

    // This state has a reduce/reduce conflict, given by the possible reduce by `rule1` or `rule2`
    predicate reduceReduceConflict(Terminal s, Rule rule1, Rule rule2) {
      this.reduce(s) = rule1 and this.reduce(s) = rule2 and rule1 != rule2
    }

    predicate hasClosure(Rule rule, int dot, Terminal lookahead) {
      this.hasItem(rule, dot, lookahead)
      or
      exists(Rule rule0, int dot0, Terminal lookahead0 |
        this.hasClosure(rule0, dot0, lookahead0) and
        rule.getLhs() = rule0.getRhs(dot0) and
        dot = 0 and
        lookahead = follows(rule0, dot0, lookahead0)
      )
    }

    string getClosureString() {
      result =
        concat(string s |
          exists(Rule rule, int dot, Terminal lookahead | this.hasClosure(rule, dot, lookahead) |
            s = itemToString(rule, dot, lookahead)
          )
        |
          s + "; "
        )
    }
  }

  class InitialState extends State {
    InitialState() { this = getInitialState(_, _, _) }
  }

  module GLRparser<input/1 i> {
    // We need to insert $ at the end of the input
    string getInputToken(int inputPosition) {
      result = i(inputPosition)
      or
      inputPosition = max(int p | exists(i(p)))+1 and result = "$"
    }

    /*
     *      The parse stack implements a linked list where the "previous" column is the previous node on the stack.
     *      With reductions `TReduce` on the stack, `skip()` skips large chunks of the stack.
     */

    newtype Stack =
      TEmpty() or
      TShift(int position, State state, Symbol terminal, ParseNode previous) {
        position = previous.getInputPosition() + 1 and
        terminal = getInputToken(position - 1) and
        state = previous.getState().shift(terminal)
      } or
      TReduce(int position, State state, Rule rule, ParseNode previous) {
        position = previous.getInputPosition() and
        rule = previous.getState().reduce(getInputToken(position)) and
        state = previous.skip(rule.getLength()).getState().goto(rule.getLhs())
      }

    abstract class ParseNode extends Stack {
      language[monotonicAggregates]
      abstract string toString();

      abstract int getInputPosition();

      abstract State getState();

      abstract ParseNode getPrevious();

      abstract Symbol getSymbol();

      string debugString() { result = this.toString() + "->" + this.getPrevious().debugString() }

      ParseNode skip(int i) {
        i = 0 and result = this
        or
        i > 0 and result = this.getPrevious().skip(i - 1)
      }
    }

    class EmptyNode extends ParseNode, TEmpty {
      override string toString() { result = "Empty" }

      override int getInputPosition() { result = 0 }

      override State getState() { result instanceof InitialState }

      override ParseNode getPrevious() { none() }

      override Symbol getSymbol() { none() }

      override string debugString() { result = "ø" }
    }

    class TerminalNode extends ParseNode, TShift {
      int position;
      State state;
      Terminal terminal;
      ParseNode previous;

      TerminalNode() { this = TShift(position, state, terminal, previous) }

      override string toString() { result = terminal + "@" + position }

      override string debugString() {
        result =
          terminal + "@" + position + " state " + state.getNumber() + "->" + previous.debugString()
      }

      override State getState() { result = state }

      override ParseNode getPrevious() { result = previous }

      override int getInputPosition() { result = position }

      override Symbol getSymbol() { result = terminal }
    }

    class NonTerminalNode extends ParseNode, TReduce {
      int position;
      State state;
      Rule rule;
      ParseNode previous;

      NonTerminalNode() { this = TReduce(position, state, rule, previous) }

      language[monotonicAggregates]
      override string toString() {
        result = rule + "@" + position
      }

      override State getState() { result = state }

      override ParseNode getPrevious() { result = previous.skip(rule.getLength()) }

      override int getInputPosition() { result = position }

      override Symbol getSymbol() { result = rule.getLhs() }

      ParseNode getChild(int i) {
        i in [0 .. rule.getLength() - 1] and
        result = previous.skip(rule.getLength() - i - 1)
      }
    }

    class Root extends NonTerminalNode {
      Root() { rule.getLhs() = "G" }
    }

    predicate dumpNodes(
      ParseNode node, int position, State state, string closure, int stateNumber, string debug
    ) {
      position = node.getInputPosition() and
      state = node.getState() and
      stateNumber = state.getNumber() and
      closure = state.getClosureString() and
      debug = node.debugString()
    }

    predicate tree(NonTerminalNode node, int i, ParseNode child) { node.getChild(i) = child }
  }

  // A combination of the actions and gotos table in one convenient output
  predicate parseTable(int state, string closure, Symbol symbol, string action) {
    exists(State s | s.getNumber() = state and closure = s.getClosureString() |
    
      action = "shift to state " + s.shift(symbol).getNumber()
       or action = "reduce by rule " + s.reduce(symbol)

    
    or action = "goto state " + s.goto(symbol).getNumber()
    )
  }
}

string input2(int i) { result = "I".charAt(i) }

module Test2 = GLR<grammar2/0>::GLRparser<input2/1>;



string grammar1() { result = ["G -> E", "E -> x", "E -> E x"] }

string input1(int i) { result = "xxxxx".charAt(i) }

module GLRTest = GLR<grammar1/0>;

module GLTTest2 = GLR<grammar1/0>::GLRparser<input1/1>;


string grammar2() {
  result = ["G -> E", "E -> E x E", "E -> I"]
}

