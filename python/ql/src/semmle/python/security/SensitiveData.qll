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

import python
import semmle.python.security.TaintTracking


/** A regular expression that identifies strings that look like they represent secret data that are not passwords. */
private string suspiciousNonPassword() {
  result = "(?is).*(account|accnt|(?<!un)trusted).*"
}
/** A regular expression that identifies strings that look like they represent secret data that are passwords. */
private string suspiciousPassword() {
  result = "(?is).*(password|passwd).*"
}

/** A regular expression that identifies strings that look like they represent secret data. */
private string suspicious() {
  result = suspiciousPassword() or result = suspiciousNonPassword()
}

/**
 * A string for `match` that identifies strings that look like they represent secret data that is
 * hashed or encrypted.
 */
private string nonSuspicious() {
  result = "(?is).*(hash|(?<!un)encrypted|\\bcrypt\\b).*"
}

/** An expression that might contain sensitive data. */
abstract class SensitiveExpr extends Expr { }

/** A method access that might produce sensitive data. */
class SensitiveCall extends SensitiveExpr, Call {
    SensitiveCall() {
        exists(string name |
            name = this.getFunc().(Name).getId() or
            name = this.getFunc().(Attribute).getName() or
            exists(StringObject s |
                this.getAnArg().refersTo(s) |
                name = s.getText()
            )
            |
            name.regexpMatch(suspicious()) and
            not name.regexpMatch(nonSuspicious())
        )
    }
}

/** An access to a variable or property that might contain sensitive data. */
abstract class SensitiveVariableAccess extends SensitiveExpr {

  string name;

  SensitiveVariableAccess() {
    this.(Name).getId() = name or
    this.(Attribute).getName() = name
  }

}

/** An access to a variable or property that might contain sensitive data. */
private class BasicSensitiveVariableAccess extends SensitiveVariableAccess {

  BasicSensitiveVariableAccess() {
    name.regexpMatch(suspicious()) and not name.regexpMatch(nonSuspicious())
  }

}

class SensitiveData extends TaintKind {

    SensitiveData() {
        this = "sensitive.data"
    }

}


class SensitiveDataSource extends TaintSource {

    SensitiveDataSource() {
        this.(ControlFlowNode).getNode() instanceof SensitiveExpr
    }

    string toString() {
        result = "sensitive.data.source"
    }

    predicate isSourceOf(TaintKind kind) {
        kind instanceof SensitiveData
    }

}

