private import unified

private int getExternalNameRank(Callable c, Parameter p, string name) {
  p =
    rank[result](Parameter p0, int pos |
      p0 = c.getParameter(pos) and
      name = p0.getExternalName()
    |
      p0 order by pos
    )
}

private predicate parameterPos(Callable c, Parameter p, int pos, string name, int rnk) {
  p = c.getParameter(pos) and
  (
    rnk = getExternalNameRank(c, p, name)
    or
    not exists(p.getExternalName()) and
    name = "" and
    rnk = 1
  )
}

private newtype TParameterPosition =
  TReceiverParameter() or
  TCalleeParameter() or
  TSourceParameter(int pos, string name, int rnk) { parameterPos(_, _, pos, name, rnk) } or
  TSummaryPositionalParameter(int pos) { pos = [0 .. 20] } or
  TSummaryNamedParameter(string name) { name = any(Argument arg).getName() }

class ParameterPosition extends TParameterPosition {
  /** Holds if this represents the receiver passed to a call (usually called `this` or `self`). */
  predicate isReceiver() { this = TReceiverParameter() }

  /** Holds if this represents the function value being invoked in a call. */
  predicate isCallee() { this = TCalleeParameter() }

  /**
   * Holds if this represents a parameter from source code at postion `pos` and
   * with external name `name` and rank `rnk`.
   *
   * `name` is `""` when there is no external name, and `rnk` is the rank of the
   * parameter among parameters with the same external name.
   */
  predicate isSourceParameter(int pos, string name, int rnk) {
    this = TSourceParameter(pos, name, rnk)
  }

  /** Gets the represented positional summary parameter index, if any. */
  int asPositionalSummaryParameter() { this = TSummaryPositionalParameter(result) }

  /** Gets the represented named summary parameter, if any. */
  string asNamedSummaryParameter() { this = TSummaryNamedParameter(result) }

  /** Gets the operand to `Argument` that represents this position in a MaD model. */
  string asModelOperand() {
    this.isReceiver() and result = "self"
    or
    this.isCallee() and result = "callee"
    or
    result = this.asPositionalSummaryParameter().toString()
    or
    // Suffix with a colon to prevent a confusing name clash with "receiver". This also aligns with MaD syntax.
    result = this.asNamedSummaryParameter() + ":"
  }

  /** Gets a textual representation of this position. */
  string toString() {
    result = this.asModelOperand()
    or
    exists(int pos, string name | this.isSourceParameter(pos, name, _) |
      if name = ""
      then result = pos.toString()
      else
        // Suffix with a colon to prevent a confusing name clash with "receiver". This also aligns with MaD syntax.
        result = name + ":"
    )
  }
}

ParameterPosition getParameterPosition(Parameter p) {
  exists(int pos, string name, int rnk |
    parameterPos(_, p, pos, name, rnk) and
    result = TSourceParameter(pos, name, rnk)
  )
}

private predicate positionalArgument(CallExpr ce, Argument arg, int pos) {
  arg = ce.getArgument(pos) and
  not exists(arg.getName())
}

private int getNameRank(CallExpr ce, Argument arg, string name) {
  arg =
    rank[result](Argument arg0, int pos |
      arg0 = ce.getArgument(pos) and
      name = arg0.getName()
    |
      arg0 order by pos
    )
}

private newtype TArgumentPosition =
  TReceiverArgument() or
  TCalleeArgument() or
  TPositionalArgument(int pos) { positionalArgument(_, _, pos) } or
  TNamedArgument(string name, int rnk) { rnk = getNameRank(_, _, name) }

class ArgumentPosition extends TArgumentPosition {
  /** Holds if this represents the receiver passed to a call (usually called `this` or `self`). */
  predicate isReceiver() { this = TReceiverArgument() }

  /** Holds if this represents the function value being invoked in a call. */
  predicate isCallee() { this = TCalleeArgument() }

  int asPositional() { this = TPositionalArgument(result) }

  string asNamed(int rnk) { this = TNamedArgument(result, rnk) }

  /** Gets the operand to `Parameter` that represents this position in a MaD model. */
  string asModelOperand() {
    this.isReceiver() and result = "self"
    or
    this.isCallee() and result = "callee"
    or
    result = this.asPositional().toString()
    or
    // Suffix with a colon to prevent a confusing name clash with "receiver". This also aligns with MaD syntax.
    result = this.asNamed(_) + ":"
  }

  /** Gets a textual representation of this position. */
  string toString() { result = this.asModelOperand() }
}

pragma[nomagic]
ArgumentPosition getArgumentPosition(CallExpr ce, Argument arg) {
  positionalArgument(ce, arg, result.asPositional())
  or
  exists(string name | result.asNamed(getNameRank(ce, arg, name)) = name)
}

/** A parameter position that is either `receiver` or `callee`. */
class ImplicitParameterPosition extends ParameterPosition {
  ImplicitParameterPosition() { this.isReceiver() or this.isCallee() }
}

/** An argument position that is either `receiver` or `callee`. */
class ImplicitArgumentPosition extends ArgumentPosition {
  ImplicitArgumentPosition() { this.isReceiver() or this.isCallee() }
}

predicate parameterMatch(ParameterPosition ppos, ArgumentPosition apos) {
  ppos.isReceiver() and apos.isReceiver()
  or
  ppos.isCallee() and apos.isCallee()
  or
  ppos = TSourceParameter(apos.asPositional(), _, _)
  or
  ppos = TSummaryPositionalParameter(apos.asPositional())
  or
  exists(int rnk | ppos = TSourceParameter(_, apos.asNamed(rnk), rnk))
  or
  ppos = TSummaryNamedParameter(apos.asNamed(_))
}
