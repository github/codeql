/**
 * Provides classes and predicates for identifying private data and methods for security.
 *
 * 'Private' data in general is anything that would compromise user privacy if exposed. This
 * library tries to guess where private data may either be stored in a variable or produced by a
 * method.
 *
 * This library is not concerned with credentials. See `SensitiveActions` for expressions related
 * to credentials.
 */

import csharp
import semmle.code.csharp.frameworks.system.windows.Forms

/** A string for `match` that identifies strings that look like they represent private data. */
private string privateNames() {
  result =
    [
      // Inspired by the list on https://cwe.mitre.org/data/definitions/359.html
      // Government identifiers, such as Social Security Numbers
      "%social%security%number%",
      // Contact information, such as home addresses and telephone numbers
      "%postcode%", "%zipcode%", "%telephone%",
      // Geographic location - where the user is (or was)
      "%latitude%", "%longitude%",
      // Financial data - such as credit card numbers, salary, bank accounts, and debts
      "%creditcard%", "%salary%", "%bankaccount%",
      // Communications - e-mail addresses, private e-mail messages, SMS text messages, chat logs, etc.
      "%email%", "%mobile%", "%employer%",
      // Health - medical conditions, insurance status, prescription records
      "%medical%"
    ]
}

/** An expression that might contain private data. */
abstract class PrivateDataExpr extends Expr { }

/** A method call that might produce private data. */
class PrivateMethodCall extends PrivateDataExpr, MethodCall {
  PrivateMethodCall() {
    exists(string s | this.getTarget().getName().toLowerCase() = s | s.matches(privateNames()))
  }
}

/** An indexer access that might produce private data. */
class PrivateIndexerAccess extends PrivateDataExpr, IndexerAccess {
  PrivateIndexerAccess() {
    exists(string s | this.getAnIndex().getValue().toLowerCase() = s | s.matches(privateNames()))
  }
}

/** An access to a variable that might contain private data. */
class PrivateVariableAccess extends PrivateDataExpr, VariableAccess {
  PrivateVariableAccess() {
    exists(string s | this.getTarget().getName().toLowerCase() = s | s.matches(privateNames()))
  }
}

/** Reading the text property of a control that might contain private data. */
class PrivateControlAccess extends PrivateDataExpr {
  PrivateControlAccess() {
    exists(TextControl c |
      this = c.getARead() and c.getName().toLowerCase().matches(privateNames())
    )
  }
}
