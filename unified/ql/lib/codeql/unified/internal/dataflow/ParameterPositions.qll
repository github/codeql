private import unified

private newtype TParameterPosition =
  TReceiverParameter() or
  TPositionalParameter(int n) { n = [0 .. 20] } or
  TNamedParameter(string name) {
    name = any(Parameter p).getExternalName()
    or
    name = any(Argument arg).getName()
  }

class ParameterPosition extends TParameterPosition {
  predicate isReceiver() { this = TReceiverParameter() }

  int asPositional() { this = TPositionalParameter(result) }

  string asNamed() { this = TNamedParameter(result) }

  string toString() {
    this.isReceiver() and result = "receiver"
    or
    result = this.asPositional().toString()
    or
    // Suffix with a colon to prevent a confusing name clash with "receiver". This also aligns with MaD syntax.
    result = this.asNamed() + ":"
  }
}

class ArgumentPosition = ParameterPosition;

predicate parameterMatch(ParameterPosition ppos, ArgumentPosition apos) { apos = ppos }
