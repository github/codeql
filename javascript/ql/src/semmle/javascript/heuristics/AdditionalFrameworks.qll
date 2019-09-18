/**
 * Provides classes that heuristically identify uses of common frameworks.
 *
 * Note: This module should not be a permanent part of the standard library imports.
 */

import javascript

/**
 * An import of a module whose name ends in `-lodash` or `-underscore`, interpreted
 * as a likely import of the lodash or underscore library.
 */
private class ImpreciseLodashMember extends LodashUnderscore::Member {
  string name;

  ImpreciseLodashMember() {
    exists(string lodash | this = DataFlow::moduleMember(lodash, name) |
      lodash.matches("%-lodash") or lodash.matches("%-underscore")
    )
  }

  override string getName() { result = name }
}
