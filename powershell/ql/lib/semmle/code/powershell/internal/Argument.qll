private import powershell

module Private {
  /**
   * An argument to a call.
   *
   * The argument may be named or positional.
   */
  abstract class AbstractArgument extends Expr {
    Call call;

    /** Gets the call that this is an argumnt of. */
    final Call getCall() { result = call }

    /** Gets the position if this is a positional argument. */
    abstract int getPosition();

    /** Gets the name if this is a keyword argument. */
    abstract string getName();

    /** Holds if this is a qualifier of a call */
    abstract predicate isQualifier();
  }

  class CmdArgument extends AbstractArgument {
    override CmdCall call;

    CmdArgument() { call.getAnArgument() = this }

    override int getPosition() { call.getPositionalArgument(result) = this }

    override string getName() { call.getNamedArgument(result) = this }

    final override predicate isQualifier() { none() }
  }

  class MethodArgument extends AbstractArgument {
    override MethodCall call;

    MethodArgument() { call.getAnArgument() = this or call.getQualifier() = this }

    override int getPosition() { call.getArgument(result) = this }

    override string getName() { none() }

    final override predicate isQualifier() { call.getQualifier() = this }
  }
}

private import Private

module Public {
  final class Argument = AbstractArgument;

  /** A positional argument to a command. */
  class PositionalArgument extends Argument {
    PositionalArgument() {
      not this instanceof NamedArgument and not this instanceof QualifierArgument
    }
  }

  /** A named argument to a command. */
  class NamedArgument extends Argument {
    NamedArgument() { exists(this.getName()) }
  }

  /** An argument that is a qualifier to a method. */
  class QualifierArgument extends Argument {
    QualifierArgument() { this.isQualifier() }
  }
}
