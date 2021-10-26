/**
 * Provides classes and predicates for identifying private data and functions for security.
 *
 * 'Private' data in general is anything that would compromise user privacy if exposed. This
 * library tries to guess where private data may either be stored in a variable or produced by a
 * function.
 *
 * This library is not concerned with credentials. See `SensitiveActions` for expressions related
 * to credentials.
 */

import cpp

/** A string for `match` that identifies strings that look like they represent private data. */
private string privateNames() {
  result =
    [
      // Inspired by the list on https://cwe.mitre.org/data/definitions/359.html
      // Government identifiers, such as Social Security Numbers
      "%social%security%number%",
      // Contact information, such as home addresses and telephone numbers
      "%postcode%", "%zipcode%",
      // result = "%telephone%" or
      // Geographic location - where the user is (or was)
      "%latitude%", "%longitude%",
      // Financial data - such as credit card numbers, salary, bank accounts, and debts
      "%creditcard%", "%salary%", "%bankaccount%",
      // Communications - e-mail addresses, private e-mail messages, SMS text messages, chat logs, etc.
      // result = "%email%" or
      // result = "%mobile%" or
      "%employer%",
      // Health - medical conditions, insurance status, prescription records
      "%medical%"
    ]
}

/** An expression that might contain private data. */
abstract class PrivateDataExpr extends Expr { }

/** A functiond call that might produce private data. */
class PrivateFunctionCall extends PrivateDataExpr, FunctionCall {
  PrivateFunctionCall() {
    exists(string s | this.getTarget().getName().toLowerCase() = s | s.matches(privateNames()))
  }
}

/** An access to a variable that might contain private data. */
class PrivateVariableAccess extends PrivateDataExpr, VariableAccess {
  PrivateVariableAccess() {
    exists(string s | this.getTarget().getName().toLowerCase() = s | s.matches(privateNames()))
  }
}
