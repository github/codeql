private import unified

private newtype TParameterPosition =
  TReceiverParameter() or
  TCalleeParameter() or
  TPositionalParameter(int n) { n = [0 .. 20] } or
  TNamedParameter(string name) {
    name = any(Parameter p).getExternalName()
    or
    name = any(Argument arg).getName()
  }

class ParameterPosition extends TParameterPosition {
  /** Holds if this represents the receiver passed to a call (usually called `this` or `self`). */
  predicate isReceiver() { this = TReceiverParameter() }

  /** Holds if this represents the function value being invoked in a call. */
  predicate isCallee() { this = TCalleeParameter() }

  int asPositional() { this = TPositionalParameter(result) }

  string asNamed() { this = TNamedParameter(result) }

  string toString() {
    this.isReceiver() and result = "receiver"
    or
    this.isCallee() and result = "callee"
    or
    result = this.asPositional().toString()
    or
    // Suffix with a colon to prevent a confusing name clash with "receiver". This also aligns with MaD syntax.
    result = this.asNamed() + ":"
  }
}

class ArgumentPosition = ParameterPosition;

/** A parameter position that is either `receiver` or `callee`. */
class ImplicitParameterPosition extends ParameterPosition {
  ImplicitParameterPosition() { this.isReceiver() or this.isCallee() }
}

/** An argument position that is either `receiver` or `callee`. */
class ImplicitArgumentPosition = ImplicitParameterPosition;

predicate parameterMatch(ParameterPosition ppos, ArgumentPosition apos) { apos = ppos }
