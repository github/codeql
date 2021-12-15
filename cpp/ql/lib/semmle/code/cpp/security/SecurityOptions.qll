/**
 * Security pack options.
 *
 * see https://semmle.com/wiki/display/SD/_Configuring+SecurityOptions+for+your+code+base
 *
 * Please note that functions for MySql and SQLite are included by default and do not
 * require any customization here.
 */

import semmle.code.cpp.security.Security

/**
 * This class overrides `SecurityOptions` and can be used to add project
 * specific customization.
 */
class CustomSecurityOptions extends SecurityOptions {
  override predicate sqlArgument(string function, int arg) {
    SecurityOptions.super.sqlArgument(function, arg)
    or
    // --- custom functions that access SQL code via one of their arguments:
    // 'arg' is the 0-based index of the argument that contains an SQL string
    // for example: (function = "MySpecialSqlFunction" and arg = 0)
    none() // rules to match custom functions replace this line
  }

  override predicate userInputArgument(FunctionCall functionCall, int arg) {
    SecurityOptions.super.userInputArgument(functionCall, arg)
    or
    exists(string fname |
      functionCall.getTarget().hasGlobalName(fname) and
      exists(functionCall.getArgument(arg)) and
      // --- custom functions that return user input via one of their arguments:
      // 'arg' is the 0-based index of the argument that is used to return user input
      // for example: (fname = "readXmlInto" and arg = 1)
      none() // rules to match custom functions replace this line
    )
  }

  override predicate userInputReturned(FunctionCall functionCall) {
    SecurityOptions.super.userInputReturned(functionCall)
    or
    exists(string fname |
      functionCall.getTarget().hasGlobalName(fname) and
      // --- custom functions that return user input via their return value:
      // for example: fname = "xmlReadAttribute"
      none() // rules to match custom functions replace this line
    )
  }
}
