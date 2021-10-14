/**
 * Provides a class for modelling expressions used to supply
 * credentials.
 */

import javascript

/**
 * An expression whose value is used to supply credentials such
 * as a user name, a password, or a key.
 */
abstract class CredentialsExpr extends Expr {
  /**
   * Gets a description of the kind of credential this expression is used as,
   * such as `"user name"`, `"password"`, `"key"`.
   */
  abstract string getCredentialsKind();
}
