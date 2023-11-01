/**
 * Provides classes for heuristically identifying expressions that contain
 * 'sensitive' data, meaning that they contain or return a password or other
 * credential, or sensitive private information.
 */

import swift
import internal.SensitiveDataHeuristics

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
    exists(SensitiveDataClassification classification |
      not classification = SensitiveDataClassification::id() and // not accurate enough
      result = HeuristicNames::maybeSensitiveRegexp(classification)
    )
    or
    result = "(?is).*((account|accnt|licen(se|ce)).?(id|key)|one.?time.?code|pass.?phrase).*"
  }
}

/**
 * The type of sensitive expression for private information.
 */
class SensitivePrivateInfo extends SensitiveDataType, TPrivateInfo {
  override string toString() { result = "private information" }

  override string getRegexp() {
    result =
      "(?is).*(" +
        // Inspired by the list on https://cwe.mitre.org/data/definitions/359.html
        // Government identifiers, such as Social Security Numbers
        "social.?security|employer.?identification|national.?insurance|resident.?id|" +
        "passport.?(num|no)|" +
        // Contact information, such as home addresses
        "post.?code|zip.?code|home.?addr|" +
        // and telephone numbers
        "(mob(ile)?|home).?(num|no|tel|phone)|(tel|fax).?(num|no|phone)|" + "emergency.?contact|" +
        // Geographic location - where the user is (or was)
        "l(atitude|ongitude)|nationality|" +
        // Financial data - such as credit card numbers, salary, bank accounts, and debts
        "(credit|debit|bank|visa).?(card|num|no|acc(ou?)nt)|acc(ou)?nt.?(no|num|credit)|" +
        "salary|billing|credit.?(rating|score)|" +
        // Communications - e-mail addresses, private e-mail messages, SMS text messages, chat logs, etc.
        "e(mail|_mail)|" +
        // Health - medical conditions, insurance status, prescription records
        "birth.?da(te|y)|da(te|y).?(of.?)?birth|" +
        "medical|(health|care).?plan|healthkit|appointment|prescription|" +
        "blood.?(type|alcohol|glucose|pressure)|heart.?(rate|rhythm)|body.?(mass|fat)|" +
        "menstrua|pregnan|insulin|inhaler|" +
        // Relationships - work and family
        "employ(er|ee)|spouse|maiden.?name" +
        // ---
        ").*"
  }
}

/**
 * A regexp string to identify variables etc that might be safe because they
 * contain hashed or encrypted data, or are only a reference to data that is
 * actually stored elsewhere.
 */
private string regexpProbablySafe() {
  result = HeuristicNames::notSensitiveRegexp() or
  result = "(?is).*(file|path|url|invalid).*"
}

/**
 * Gets a string that is to be tested for sensitivity.
 */
private string sensitiveCandidateStrings() {
  result = any(VarDecl v).getName()
  or
  result = any(Function f).getShortName()
  or
  result = any(Argument a).getLabel()
}

/**
 * Gets a string from the candidates that is sensitive.
 */
private string sensitiveStrings(SensitiveDataType sensitiveType) {
  result = sensitiveCandidateStrings() and
  result.regexpMatch(sensitiveType.getRegexp())
}

/**
 * A `VarDecl` that might be used to contain sensitive data.
 */
private class SensitiveVarDecl extends VarDecl {
  SensitiveDataType sensitiveType;

  SensitiveVarDecl() { this.getName() = sensitiveStrings(sensitiveType) }

  predicate hasInfo(string label, SensitiveDataType type) {
    label = this.getName() and
    sensitiveType = type
  }
}

/**
 * A `Function` that might be used to contain sensitive data.
 */
private class SensitiveFunction extends Function {
  SensitiveDataType sensitiveType;

  SensitiveFunction() { this.getShortName() = sensitiveStrings(sensitiveType) }

  predicate hasInfo(string label, SensitiveDataType type) {
    label = this.getShortName() and
    sensitiveType = type
  }
}

/**
 * An `Argument` that might be used to contain sensitive data.
 */
private class SensitiveArgument extends Argument {
  SensitiveDataType sensitiveType;

  SensitiveArgument() { this.getLabel() = sensitiveStrings(sensitiveType) }

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
    (
      // variable reference
      this.(DeclRefExpr).getDecl().(SensitiveVarDecl).hasInfo(label, sensitiveType)
      or
      // member variable reference
      this.(MemberRefExpr).getMember().(SensitiveVarDecl).hasInfo(label, sensitiveType)
      or
      // function call
      this.(ApplyExpr).getStaticTarget().(SensitiveFunction).hasInfo(label, sensitiveType)
      or
      // sensitive argument
      exists(SensitiveArgument a |
        a.hasInfo(label, sensitiveType) and
        a.getExpr() = this
      )
    ) and
    // do not mark as sensitive it if it is probably safe
    not label.regexpMatch(regexpProbablySafe())
  }

  /**
   * Gets the label associated with this expression.
   */
  string getLabel() { result = label }

  /**
   * Gets the type of sensitive expression this is.
   */
  SensitiveDataType getSensitiveType() { result = sensitiveType }
}

/**
 * A function that is likely used to encrypt or hash data.
 */
private class EncryptionFunction extends Function {
  cached
  EncryptionFunction() { this.getName().regexpMatch("(?is).*(crypt|hash|encode|protect).*") }
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
