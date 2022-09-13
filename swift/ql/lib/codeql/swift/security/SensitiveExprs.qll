/**
 * Provides classes for heuristically identifying expressions that contain
 * 'sensitive' data, meaning that they contain or return a password or other
 * credential, or sensitive private information.
 */

import swift

private newtype TSensitiveDataType =
  TCredential() or
  TPrivateInfo()

/**
 * A type of sensitive expression.
 */
abstract class SensitiveDataType extends TSensitiveDataType {
  abstract string toString();

  /**
   * Gets a regexp for identifying expressions of this type.
   */
  abstract string getRegexp();
}

/**
 * The type of sensitive expression for passwords and other credentials.
 */
class SensitiveCredential extends SensitiveDataType, TCredential {
  override string toString() { result = "credential" }

  override string getRegexp() {
    result = ".*(password|passwd|accountid|account.?key|accnt.?key|license.?key|trusted).*"
  }
}

/**
 * The type of sensitive expression for private information.
 */
class SensitivePrivateInfo extends SensitiveDataType, TPrivateInfo {
  override string toString() { result = "private information" }

  override string getRegexp() {
    result =
      ".*(" +
        // Inspired by the list on https://cwe.mitre.org/data/definitions/359.html
        // Government identifiers, such as Social Security Numbers
        "social.?security|national.?insurance|" +
        // Contact information, such as home addresses
        "post.?code|zip.?code|home.?address|" +
        // and telephone numbers
        "telephone|home.?phone|mobile|fax.?no|fax.?number|" +
        // Geographic location - where the user is (or was)
        "latitude|longitude|" +
        // Financial data - such as credit card numbers, salary, bank accounts, and debts
        "credit.?card|debit.?card|salary|bank.?account|" +
        // Communications - e-mail addresses, private e-mail messages, SMS text messages, chat logs, etc.
        "email|" +
        // Health - medical conditions, insurance status, prescription records
        "birthday|birth.?date|date.?of.?birth|medical|" +
        // Relationships - work and family
        "employer|spouse" +
        // ---
        ").*"
  }
}

/**
 * A regexp string to identify variables etc that might be safe because they
 * contain hashed or encrypted data, or are only a reference to data that is
 * actually stored elsewhere.
 */
private string regexpProbablySafe() { result = ".*(hash|crypt|file|path|invalid).*" }

/**
 * A `VarDecl` that might be used to contain sensitive data.
 */
private class SensitiveVarDecl extends VarDecl {
  SensitiveDataType sensitiveType;

  SensitiveVarDecl() { this.getName().toLowerCase().regexpMatch(sensitiveType.getRegexp()) }

  predicate hasInfo(string label, SensitiveDataType type) {
    label = this.getName() and
    sensitiveType = type
  }
}

/**
 * An `AbstractFunctionDecl` that might be used to contain sensitive data.
 */
private class SensitiveFunctionDecl extends AbstractFunctionDecl {
  SensitiveDataType sensitiveType;

  SensitiveFunctionDecl() { this.getName().toLowerCase().regexpMatch(sensitiveType.getRegexp()) }

  predicate hasInfo(string label, SensitiveDataType type) {
    label = this.getName() and
    sensitiveType = type
  }
}

/**
 * An `Argument` that might be used to contain sensitive data.
 */
private class SensitiveArgument extends Argument {
  SensitiveDataType sensitiveType;

  SensitiveArgument() { this.getLabel().toLowerCase().regexpMatch(sensitiveType.getRegexp()) }

  predicate hasInfo(string label, SensitiveDataType type) {
    label = this.getLabel() and
    sensitiveType = type
  }
}

/**
 * An expression whose value might be sensitive data.
 */
class SensitiveExpr extends Expr {
  string label;
  SensitiveDataType sensitiveType;

  SensitiveExpr() {
    // variable reference
    this.(DeclRefExpr).getDecl().(SensitiveVarDecl).hasInfo(label, sensitiveType)
    or
    // member variable reference
    this.(MemberRefExpr).getMember().(SensitiveVarDecl).hasInfo(label, sensitiveType)
    or
    // function call
    this.(ApplyExpr).getStaticTarget().(SensitiveFunctionDecl).hasInfo(label, sensitiveType)
    or
    // sensitive argument
    exists(SensitiveArgument a |
      a.hasInfo(label, sensitiveType) and
      a.getExpr() = this
    )
  }

  /**
   * Gets the label associated with this expression.
   */
  string getLabel() { result = label }

  /**
   * Gets the type of sensitive expression this is.
   */
  SensitiveDataType getSensitiveType() { result = sensitiveType }

  /**
   * Holds if this sensitive expression might be safe because it contains
   * hashed or encrypted data, or is only a reference to data that is stored
   * elsewhere.
   */
  predicate isProbablySafe() { label.toLowerCase().regexpMatch(regexpProbablySafe()) }
}

/**
 * A function that is likely used to encrypt or hash data.
 */
private class EncryptionFunction extends AbstractFunctionDecl {
  EncryptionFunction() { this.getName().regexpMatch(".*(crypt|hash|encode|protect).*") }
}

/**
 * An expression that may be protected with encryption, for example an
 * argument to a function called "encrypt".
 */
class EncryptedExpr extends Expr {
  EncryptedExpr() {
    exists(CallExpr call |
      call.getStaticTarget() instanceof EncryptionFunction and
      call.getAnArgument().getExpr() = this
    )
  }
}
