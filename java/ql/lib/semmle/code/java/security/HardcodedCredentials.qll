/**
 * Provides classes and predicates relating to hardcoded credentials.
 */

import java
import SensitiveApi

/**
 * An array creation expression of type `byte[]` with
 * an initializer containing only compile time constant
 * expressions (and at least one such expression).
 */
private class HardcodedByteArray extends ArrayCreationExpr {
  HardcodedByteArray() {
    this.getType().(Array).getElementType().(PrimitiveType).getName() = "byte" and
    forex(Expr elem | elem = this.getInit().getAChildExpr() |
      elem instanceof CompileTimeConstantExpr
    )
  }
}

/**
 * An array creation expression of type `char[]` with
 * an initializer containing only compile time constant
 * expressions (and at least one such expression).
 */
private class HardcodedCharArray extends ArrayCreationExpr {
  HardcodedCharArray() {
    this.getType().(Array).getElementType().(PrimitiveType).getName() = "char" and
    forex(Expr elem | elem = this.getInit().getAChildExpr() |
      elem instanceof CompileTimeConstantExpr
    )
  }
}

/**
 * An expression that is either a non-empty string literal or a
 * hard-coded `byte` or `char` array.
 */
class HardcodedExpr extends Expr {
  HardcodedExpr() {
    this.(StringLiteral).getValue() != "" or
    this instanceof HardcodedByteArray or
    this instanceof HardcodedCharArray
  }
}

/**
 * An argument to a sensitive call, expected to contain credentials.
 */
abstract class CredentialsSink extends Expr {
  Call getSurroundingCall() { this = result.getAnArgument() }
}

/**
 * An argument to a sensitive call of a known API,
 * expected to contain username, password or cryptographic key
 * credentials.
 */
class CredentialsApiSink extends CredentialsSink {
  CredentialsApiSink() { this = any(CredentialsSinkNode csn).asExpr() }
}

/**
 * A variable whose name indicates that it may hold a password.
 */
class PasswordVariable extends Variable {
  PasswordVariable() {
    this.getName().regexpMatch("(?i)(encrypted|old|new)?pass(wd|word|code|phrase)(chars|value)?")
  }
}

/**
 * A variable whose name indicates that it may hold a user name.
 */
class UsernameVariable extends Variable {
  UsernameVariable() { this.getName().regexpMatch("(?i)(user|username)") }
}

/**
 * An argument to a call, where the parameter name corresponding
 * to the argument indicates that it may contain credentials.
 */
class CredentialsSourceSink extends CredentialsSink {
  CredentialsSourceSink() {
    exists(Call call, int i |
      this = call.getArgument(i) and
      (
        call.getCallee().getParameter(i) instanceof UsernameVariable or
        call.getCallee().getParameter(i) instanceof PasswordVariable
      )
    )
  }
}
