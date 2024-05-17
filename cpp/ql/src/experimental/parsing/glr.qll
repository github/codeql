signature string grammar();

module GLR<grammar/0 g> {
  string initialRule() { result = "Start_ -> Grammar $" }

  class Rule extends string {
    Rule() { this = [g(), initialRule()] }

    NonTerminal getLhs() { result = this.splitAt(" ", 0) }

    Symbol getRhs(int i) {
      i >= 0 and
      result = this.splitAt(" ", 2 + i)
    }

    int getLength() { result = count(int i | exists(this.getRhs(i))) }
  }

  class Symbol extends string {
    Symbol() {
      exists(Rule rule |
        this = rule.splitAt(" ") and this != "->"
      )
    }

    predicate maybeEmpty() {
      this instanceof NonTerminal and
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
    Terminal() { this.charAt(0).isLowercase() or this = "$" }
  }

  class NonTerminal extends Symbol {
    NonTerminal() { this.charAt(0).isUppercase() }
  }

  class Eof extends Terminal {
    Eof() { this = "$" }
  }

  //string follows(string rule, int dot, string follows)
  //{
  //}
  // Parser table construction
  predicate closure(int state, Rule rule, int dot, Terminal follows) {
    // Base case
    state = 0 and rule = initialRule() and dot = 0 and follows = "$"
    or
    // Closure rule
    exists(Rule rule0, int dot0, string follows0 |
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
  }

  predicate kernel(int state, Rule rule, int dot) { closure(state, rule, dot, _) }

  predicate transitions(int state, Symbol symbol, Rule rule, int dot, Terminal follows) {
    exists(Terminal follows0 | closure(state, rule, dot-1, follows0) | 
        rule.getRhs(dot-1) = symbol and 
        // TODO: Follows isn't computed correctly here with empty symbols
        (follows = rule.getRhs(dot).(Symbol).getFirst() or dot=rule.getLength() and follows = follows0
    ))
  }

  predicate shifts(int state, Terminal terminal, Rule rule, int dot, Terminal follows) {
    transitions(state, terminal, rule, dot, follows)
}

    predicate gotos(int state, NonTerminal terminal, Rule rule, int dot, Terminal follows) {
        transitions(state, terminal, rule, dot, follows)
    }


  // The state `state` has a reduction on `follows` when the rule `rule` is complete
  predicate reductions(int state, Terminal follows, Rule rule)
  {
    closure(state, rule, rule.getLength(), follows)
  }

  predicate dumpStates(int state, string itemstring) {
    exists(Rule rule, int dot, string follows | closure(state, rule, dot, follows) |
      itemstring =
        rule.getLhs() + " -> " +
          concat(int i | i in [0 .. dot - 1] | rule.getRhs(i) + " " order by i) + ". " +
          concat(int i | i in [dot .. rule.getLength() - 1] | rule.getRhs(i) + " " order by i) + "{"
          + follows + "}"
    )
  }
}

string grammar1() { result = ["Grammar -> E", "E -> x", "E -> E x", "X ->", "Y -> X"] }

module GLRTest = GLR<grammar1/0>;
