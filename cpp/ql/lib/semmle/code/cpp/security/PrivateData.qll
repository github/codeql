/**
 * Provides classes for heuristically identifying variables and functions that
 * might contain or return sensitive private data.
 *
 * 'Private' data in general is anything that would compromise user privacy if
 * exposed. This library tries to guess where private data may either be stored
 * in a variable or returned by a function call.
 *
 * This library is not concerned with credentials. See `SensitiveExprs.qll` for
 * expressions related to credentials.
 */

import cpp

/**
 * A string for `regexpMatch` that identifies strings that look like they
 * represent private data.
 */
private string privateNames() {
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

/**
 * A variable that might contain sensitive private information.
 */
class PrivateDataVariable extends Variable {
  PrivateDataVariable() {
    this.getName().toLowerCase().regexpMatch(privateNames()) and
    not this.getUnspecifiedType() instanceof IntegralType
  }
}

/**
 * A function that might return sensitive private information.
 */
class PrivateDataFunction extends Function {
  PrivateDataFunction() {
    this.getName().toLowerCase().regexpMatch(privateNames()) and
    not this.getUnspecifiedType() instanceof IntegralType
  }
}

/**
 * An expression whose value might be sensitive private information.
 */
class PrivateDataExpr extends Expr {
  PrivateDataExpr() {
    this.(VariableAccess).getTarget() instanceof PrivateDataVariable or
    this.(FunctionCall).getTarget() instanceof PrivateDataFunction
  }
}
