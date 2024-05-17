/*
 *  Problem: How do I request the closure of a new state?
 *  A state is a set of items.
 *
 *  Problem: How do I group together items from the same origin?
 *  state = transition(previousState, symbol)
 *  How do I represent a "set" in the traditional sense?
 *  Maybe I don't??
 *
 *  It's a bit like GVN - we need to number all possible states.
 *
 *  State = a set if items.
 */

signature string grammar();

module GLR<grammar/0 g> {
  string initialRule() { result = "Start_ -> G $" }

  string getRuleLhs(Rule rule) { result = rule.splitAt(" ", 0) }

  string getRuleRhs(Rule rule, int i) { i >= 0 and result = rule.splitAt(" ", 2 + i) }

  class Rule extends string {
    Rule() { this = [g(), initialRule()] }

    NonTerminal getLhs() { result = getRuleLhs(this) }

    Symbol getRhs(int i) { result = getRuleRhs(this, i) }

    int getLength() { result = count(int i | exists(this.getRhs(i))) }
  }

  class Symbol extends string {
    Symbol() { exists(Rule rule | this = getRuleLhs(rule) or this = getRuleRhs(rule, _)) }

    predicate maybeEmpty() {
      exists(Rule rule |
        rule.getLhs() = this and
        forall(int i | exists(rule.getRhs(i)) | rule.getRhs(i).(NonTerminal).maybeEmpty())
      )
    }

    Terminal getFirst() {
      // We are a terminal
      result = this
      or
      // We are a nonterminal
      exists(Rule rule, int i |
        rule.getLhs() = this and
        forall(int j | j in [0 .. i - 1] | rule.getRhs(j).(Symbol).maybeEmpty()) and
        result = rule.getRhs(i).(Symbol).getFirst()
      )
    }
  }

  class Terminal extends Symbol {
    Terminal() { not this instanceof NonTerminal }
  }

  class NonTerminal extends Symbol {
    NonTerminal() { this = getRuleLhs(any(Rule r)) }
  }

  class Eof extends Terminal {
    Eof() { this = "$" }
  }

  // Parser table construction
  language[monotonicAggregates]
  predicate closure(string state, Rule rule, int dot, Terminal follows) {
    // Base case
    state = "0" and rule = initialRule() and dot = 0 and follows = "$"
    or
    // Closure rule
    exists(Rule rule0, int dot0, Terminal follows0 |
      // Find an existing rule in this state
      closure(state, rule0, dot0, follows0) and
      // We start from the dot position
      rule0.getRhs(dot0) = rule.getLhs() and
      dot = 0
    |
      // TODO: We don't handle empty symbols yet
      follows = follows0 and dot0 + 1 = rule0.getLength()
      or
      follows = rule0.getRhs(dot0 + 1).(Symbol).getFirst()
    )
    // This doesn't work due to nonmonotonic recursion
    //or exists(string state0 | state0 = makeTransition(state, _) |
    //  closure(state0, rule, dot, follows))
  }

  predicate kernel(string state, Rule rule, int dot) { closure(state, rule, dot, _) }

  language[monotonicAggregates]
  predicate transitions(string state, Symbol symbol, Rule rule, int dot, Terminal follows) {
    exists(Terminal follows0 | closure(state, rule, dot - 1, follows0) |
      rule.getRhs(dot - 1) = symbol and
      // TODO: Follows isn't computed correctly here with empty symbols
      (
        follows = rule.getRhs(dot).(Symbol).getFirst()
        or
        dot = rule.getLength() and follows = follows0
      )
    )
  }

  predicate shifts(string state, Terminal terminal, Rule rule, int dot, Terminal follows) {
    transitions(state, terminal, rule, dot, follows)
  }

  string initialState() {
    result =
      concat(string itemstring |
        exists(Rule rule, int dot | closure("0", rule, dot, _) | itemstring = kernelItem(rule, dot))
      |
        itemstring + "; " order by itemstring
      )
  }

  language[monotonicAggregates]
  string makeTransition(string state, Symbol transition) {
    state = "0" and
    result =
      concat(string itemstring |
        exists(Rule rule, int dot, Terminal follows |
          transitions(state, transition, rule, dot, follows)
        |
          itemstring = kernelItem(rule, dot) // Use itemToString for CLR
        )
      |
        itemstring + "; "
      )
  }

  predicate stateKernelItem(string state, Rule rule, int dot, Terminal lookahead) {
    exists(string state0, Symbol transition | state = makeTransition(state0, transition) |
      transitions(state0, transition, rule, dot, lookahead)
    )
    or
    state = "0" and rule = initialRule() and dot = 0 and lookahead = "$"
  }

  predicate stateClosureItem(string state, Rule rule, int dot, Terminal lookahead) {
    stateKernelItem(state, rule, dot, lookahead)
    or
    exists(Rule rule0, int dot0, Terminal lookahead0 |
      stateClosureItem(state, rule0, dot0, lookahead0) and
      rule0.getRhs(dot0) = rule.getLhs() and
      dot = 0 and
      (
        dot0 = rule0.getLength() and lookahead = lookahead0
        or
        lookahead = rule0.getRhs(dot0).(Symbol).getFirst()
      /*TODO: Empty symbols*/ )
    )
  }

  Terminal follows(Rule rule, int dot, Terminal lookahead) {
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
  predicate transition(
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

  predicate gotos(string state, NonTerminal terminal, Rule rule, int dot, Terminal follows) {
    transitions(state, terminal, rule, dot, follows)
  }

  // The state `state` has a reduction on `follows` when the rule `rule` is complete
  predicate reductions(string state, Terminal follows, Rule rule) {
    closure(state, rule, rule.getLength(), follows)
  }

  class Dot extends int {
    Dot() { this in [0 .. max(any(Rule r).getLength())] }
  }

  bindingset[dot, follows]
  string itemToString(Rule rule, int dot, Terminal follows) {
    result =
      rule.getLhs() + " -> " + concat(int i | i in [0 .. dot - 1] | rule.getRhs(i) + " " order by i)
        + ". " +
        concat(int i | i in [dot .. rule.getLength() - 1] | rule.getRhs(i) + " " order by i) + "{" +
        follows + "}"
  }

  string kernelItem(Rule rule, int dot) {
    dot = [0 .. rule.getLength()] and
    result =
      rule.getLhs() + " -> " + concat(int i | i in [0 .. dot - 1] | rule.getRhs(i) + " " order by i)
        + ". " +
        concat(int i | i in [dot .. rule.getLength() - 1] | rule.getRhs(i) + " " order by i)
  }

  predicate dumpStates(string state, string itemstring) {
    exists(Rule rule, int dot, string follows | closure(state, rule, dot, follows) |
      itemstring = itemToString(rule, dot, follows)
    )
  }

  class KernelItem extends string {
    Rule rule;
    int dot;

    KernelItem() { this = kernelItem(rule, dot) }
  }

  class InitialItem extends KernelItem {
    InitialItem() { this = kernelItem(initialRule(), 0) }
  }

  predicate initialState(Rule rule, int dot, Terminal lookahead) {
    rule = initialRule() and dot = 0 and lookahead = "$"
  }

  predicate initialTransition(Symbol s, Rule rule, int dot, Terminal lookahead) {
    exists(Rule rule0, int dot0, Terminal lookahead0 | initialState(rule0, dot0, lookahead0) |
      transition(rule0, dot0, lookahead0, s, rule, dot, lookahead)
    )
  }

  string initialState1() {
    result =
      concat(string itemstring |
        exists(Rule rule, int dot, Terminal lookahead | initialState(rule, dot, lookahead) |
          itemstring = kernelItem(rule, dot)
        )
      |
        itemstring + ";" order by itemstring
      )
  }

  predicate sameStateDELETEME(
    Rule rule1, int dot1, Terminal lookahead1, Rule rule2, int dot2, Terminal lookahead2
  ) {
    initialState(rule1, dot1, lookahead1) and
    rule1 = rule2 and
    dot1 = dot2 and
    lookahead1 = lookahead2
    or
    exists(Rule rule0, int dot0, Terminal lookahead0, Symbol s0 |
      transition(rule0, dot0, lookahead0, s0, rule1, dot1, lookahead1) and
      transition(rule0, dot0, lookahead0, s0, rule2, dot2, lookahead2)
    )
  }

  predicate item(Rule rule, int dot, Terminal lookahead) {
    initialState(rule, dot, lookahead)
    or
    exists(Rule rule0, int dot0, Terminal lookahead0, Symbol s |
      item(rule0, dot0, lookahead0) and
      transition(rule0, dot0, lookahead0, s, rule, dot, lookahead)
    )
  }

  string initialStateX(Rule rule, int dot, Terminal lookahead) {
    initialState(rule, dot, lookahead) and
    result = kernelItem(rule, dot)
  }

  string transitionState(string previous, Symbol s, Rule rule, int dot, Terminal lookahead) {
    exists(Rule rule0, int dot0, Terminal lookahead0 | item(rule0, dot0, lookahead0) |
      previous =
        [transitionState(_, _, rule0, dot0, lookahead0), initialStateX(rule0, dot0, lookahead0)] and
      transition(rule0, dot0, lookahead0, s, rule, dot, lookahead) and
      result =
        concat(string itemstring |
          exists(Rule rule3, int dot3, Terminal lookahead3 |
            transition(rule0, dot0, lookahead0, s, rule3, dot3, lookahead3) and
            itemstring = kernelItem(rule, dot)
          )
        |
          itemstring + "; " order by itemstring
        )
    )
  }

  class State extends string {
    State() {
      this = initialStateX(_, _, _)
      or
      this = transitionState(_, _, _, _, _)
    }

    predicate hasItem(Rule rule, int dot, Terminal lookahead) {
      this = initialStateX(rule, dot, lookahead)
      or
      this = transitionState(_, _, rule, dot, lookahead)
    }

    State getTransition(Symbol s) { result = transitionState(this, s, _, _, _) }

    int getNumber() { this = rank[result](State s) }

    
  }

  class InitialState extends State {
    InitialState() { this = initialStateX(_, _, _) }
  }
}

string grammar1() { result = ["G -> E", "E -> x", "E -> E x"] }

module GLRTest = GLR<grammar1/0>;
