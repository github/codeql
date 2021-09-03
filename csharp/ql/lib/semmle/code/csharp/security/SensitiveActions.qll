/**
 * Provides classes and predicates for identifying sensitive data and methods for security.
 *
 * 'Sensitive' data in general is anything that should not be sent around in unencrypted form. This
 * library tries to guess where sensitive data may either be stored in a variable or produced by a
 * method.
 *
 * In addition, there are methods that ought not to be executed or not in a fashion that the user
 * can control. This includes authorization methods such as logins, and sending of data, etc.
 */

import csharp
import semmle.code.csharp.frameworks.system.windows.Forms

/**
 * A string for `match` that identifies strings that look like they represent secret data.
 */
abstract class AdditionalSensitiveStrings extends string {
  bindingset[this]
  AdditionalSensitiveStrings() { any() }
}

/**
 * A string for `match` that identifies strings that look like they don't represent secret data.
 */
abstract class AdditionalNonSensitiveStrings extends string {
  bindingset[this]
  AdditionalNonSensitiveStrings() { any() }
}

/** A string for `match` that identifies strings that look like they represent secret data. */
private string suspicious() {
  result = "%password%" or
  result = "%passwd%" or
  result = "%account%id%" or
  result = "%accnt%id%" or
  result = "%account%key%" or
  result = "%accnt%key%" or
  result = "%license%key%" or
  result = "%licence%key%" or
  result = "%voucher%code%" or
  result = "%trusted%" or
  result instanceof AdditionalSensitiveStrings
}

/**
 * A string for `match` that identifies strings that look like they represent secret data that is
 * hashed or encrypted.
 */
private string nonSuspicious() {
  result = "%hashed%" or
  result = "%encrypted%" or
  result = "%crypt%" or
  result = "%invalid%" or
  result instanceof AdditionalNonSensitiveStrings
}

/** A variable that may hold a sensitive value. */
class SensitiveVariable extends Variable {
  SensitiveVariable() {
    exists(string s | this.getName().toLowerCase() = s | s.matches(suspicious()))
  }
}

/** A property that may hold a sensitive value. */
class SensitiveProperty extends Property {
  SensitiveProperty() {
    exists(string s | this.getName().toLowerCase() = s | s.matches(suspicious()))
  }
}

/** A parameter to a library method that may hold a sensitive value. */
class SensitiveLibraryParameter extends Parameter {
  SensitiveLibraryParameter() {
    fromLibrary() and
    exists(string s | this.getName().toLowerCase() = s | s.matches(suspicious()))
  }
}

/** A `match` pattern for a password. */
private string password() {
  // A trailing % is too general. E.g. "passwordLength", "passwordComplexity"
  result = "%password" or
  result = "%passwd"
}

/** A string that matches suspicious but not non-suspicious. */
bindingset[str]
private predicate isSuspicious(string str) {
  str.toLowerCase().matches(suspicious()) and
  not str.toLowerCase().matches(nonSuspicious())
}

/** A string that matches a password. */
bindingset[p]
private predicate isPassword(string p) {
  p.toLowerCase().matches(password()) and
  not p.toLowerCase().matches(nonSuspicious())
}

/** Holds if the expression `expr` uses an element with the name `name`. */
private predicate expressionHasName(Expr expr, string name) {
  name = expr.(MethodCall).getTarget().getName()
  or
  name = expr.(MethodCall).getAnArgument().getValue()
  or
  name = expr.(VariableAccess).getTarget().getName()
}

/** An expression that may contain a password. */
class PasswordExpr extends Expr {
  PasswordExpr() {
    exists(string name | expressionHasName(this, name) and isPassword(name))
    or
    this instanceof PasswordTextboxText
  }
}

/** An expression that might contain sensitive data. */
abstract class SensitiveExpr extends Expr { }

/** A method access that might produce sensitive data. */
class SensitiveMethodAccess extends SensitiveExpr, MethodCall {
  SensitiveMethodAccess() {
    this.getTarget() instanceof SensitiveDataMethod
    or
    // This is particularly to pick up methods with an argument like "password", which
    // may indicate a lookup.
    isSuspicious(this.getAnArgument().getValue())
  }
}

/** An access to a variable that might contain sensitive data. */
class SensitiveVariableAccess extends SensitiveExpr, VariableAccess {
  SensitiveVariableAccess() { isSuspicious(this.getTarget().getName()) }
}

/** Reading the `Text` property of a password text box. */
class PasswordTextboxText extends SensitiveExpr, PropertyRead {
  PasswordTextboxText() { this = any(PasswordField p).getARead() }
}

/** A field containing a text box used as a password. */
class PasswordField extends TextControl {
  PasswordField() {
    isSuspicious(this.getName())
    or
    exists(PropertyWrite write | write.getQualifier() = this.getAnAccess() |
      write.getTarget().getName() = "UseSystemPasswordChar" or
      write.getTarget().getName() = "PasswordChar"
    )
  }
}

/** A method that may produce sensitive data. */
abstract class SensitiveDataMethod extends Method { }

/** A method that might return sensitive data, based on the name. */
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
        s.matches("%loginfo%")
      )
    )
  }
}

/** A method that sends data, and so should not be run conditionally on user input. */
class SendingMethod extends SensitiveExecutionMethod {
  SendingMethod() {
    exists(string s | s.matches("%Socket") |
      this.getDeclaringType().hasQualifiedName("System.Net.Sockets", s) and
      this.hasName("Send")
    )
  }
}

/** A call to a method that sends data, and so should not be run conditionally on user input. */
class SensitiveExecutionMethodCall extends MethodCall {
  SensitiveExecutionMethodCall() { this.getTarget() instanceof SensitiveExecutionMethod }
}
