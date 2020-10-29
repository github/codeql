/**
 * Sensitive data and methods for security.
 *
 * 'Sensitive' data in general is anything that should not be
 * sent around in unencrypted form. This library tries to guess
 * where sensitive data may either be stored in a variable or
 * produced by a method.
 *
 * In addition, there are methods that ought not to be executed or not
 * in a fashion that the user can control. This includes authorization
 * methods such as logins, and sending of data, etc.
 */

import java

private string suspicious() {
  result = "%password%" or
  result = "%passwd%" or
  result = "%account%" or
  result = "%accnt%" or
  result = "%trusted%"
}

private string nonSuspicious() {
  result = "%hashed%" or
  result = "%encrypted%" or
  result = "%crypt%"
}

/**
 * Gets a regular expression for matching common names of variables that indicate the value being held contains sensitive information.
 */
string getCommonSensitiveInfoRegex() {
  result = "(?i).*challenge|pass(wd|word|code|phrase)(?!.*question).*" or
  result = "(?i).*(token|secret).*"
}

/** An expression that might contain sensitive data. */
abstract class SensitiveExpr extends Expr { }

/** A method access that might produce sensitive data. */
class SensitiveMethodAccess extends SensitiveExpr, MethodAccess {
  SensitiveMethodAccess() {
    this.getMethod() instanceof SensitiveDataMethod
    or
    // This is particularly to pick up methods with an argument like "password", which
    // may indicate a lookup.
    exists(string s |
      this.getAnArgument().(StringLiteral).getRepresentedString().toLowerCase() = s
    |
      s.matches(suspicious()) and
      not s.matches(nonSuspicious())
    )
  }
}

/** Access to a variable that might contain sensitive data. */
class SensitiveVarAccess extends SensitiveExpr, VarAccess {
  SensitiveVarAccess() {
    exists(string s | this.getVariable().getName().toLowerCase() = s |
      s.matches(suspicious()) and
      not s.matches(nonSuspicious())
    )
  }
}

/** A method that may produce sensitive data. */
abstract class SensitiveDataMethod extends Method { }

class CredentialsMethod extends SensitiveDataMethod {
  CredentialsMethod() {
    exists(string s | s = this.getName().toLowerCase() | s.matches(suspicious()))
  }
}

/** A method whose execution may be sensitive. */
abstract class SensitiveExecutionMethod extends Method { }

/** A method that may perform authorization. */
class AuthMethod extends SensitiveExecutionMethod {
  AuthMethod() {
    exists(string s | s = this.getName().toLowerCase() |
      (
        s.matches("%login%") or
        s.matches("%auth%")
      ) and
      not (
        s.matches("get%") or
        s.matches("set%") or
        s.matches("parse%") or
        s.matches("%loginfo%")
      )
    )
  }
}

/** A method that sends data, and so should not be run conditionally on user input. */
class SendingMethod extends SensitiveExecutionMethod {
  SendingMethod() {
    exists(string s | s.matches("%Socket") |
      this.getDeclaringType().hasQualifiedName("java.net", s) and
      this.hasName("send")
    )
  }
}
