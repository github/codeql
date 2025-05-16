import experimental.quantum.Language

abstract class OpenSSLOperation extends Crypto::OperationInstance instanceof Call {
  abstract Expr getInputArg();

  /**
   * Can be an argument of a call or a return value of a function.
   */
  abstract Expr getOutputArg();

  DataFlow::Node getInputNode() {
    // Assumed to be default to asExpr
    result.asExpr() = this.getInputArg()
  }

  DataFlow::Node getOutputNode() {
    if exists(Call c | c.getAnArgument() = this)
    then result.asDefiningArgument() = this
    else result.asExpr() = this
  }
}
