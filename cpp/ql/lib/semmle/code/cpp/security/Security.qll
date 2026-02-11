/**
 * Definitions related to security queries.
 * These can be extended for specific code bases.
 */

import semmle.code.cpp.exprs.Expr
import semmle.code.cpp.commons.Environment
import semmle.code.cpp.security.SecurityOptions
import semmle.code.cpp.models.interfaces.FlowSource
import semmle.code.cpp.models.interfaces.Sql

/**
 * Extend this class to customize the security queries for
 * a particular code base. Provide no constructor in the
 * subclass, and override any methods that need customizing.
 */
class SecurityOptions extends string {
  SecurityOptions() { this = "SecurityOptions" }

  /**
   * This predicate should hold if the function with the given
   * name is a pure function of its arguments.
   */
  predicate isPureFunction(string name) {
    name =
      [
        "abs", "atof", "atoi", "atol", "atoll", "labs", "strcasestr", "strcat", "strchnul",
        "strchr", "strchrnul", "strcmp", "strcpy", "strcspn", "strdup", "strlen", "strncat",
        "strncmp", "strncpy", "strndup", "strnlen", "strrchr", "strspn", "strstr", "strtod",
        "strtof", "strtol", "strtoll", "strtoq", "strtoul"
      ]
  }

  /**
   * An argument to a function that is passed to a SQL server.
   */
  predicate sqlArgument(string function, int arg) {
    exists(FunctionInput input, SqlExecutionFunction sql |
      sql.hasName(function) and
      input.isParameterDeref(arg) and
      sql.hasSqlArgument(input)
    )
  }

  /**
   * The argument of the given function is used for running a process or loading
   * a library.
   */
  predicate isProcessOperationArgument(string function, int arg) {
    // POSIX
    function =
      ["system", "popen", "execl", "execlp", "execle", "execv", "execvp", "execvpe", "dlopen"] and
    arg = 0
    or
    // Windows
    function = ["LoadLibrary", "LoadLibraryA", "LoadLibraryW"] and arg = 0
  }

  /**
   * This predicate should hold if the expression raises privilege for the
   * current session. The default definition only holds true for some
   * example code in the test suite. This predicate must be extended for
   * a particular code base to be useful.
   */
  predicate raisesPrivilege(Expr expr) {
    exists(ReturnStmt ret | ret.getExpr() = expr |
      ret.getEnclosingFunction().getName() = "checkPinCode" and
      ret.getExpr().getValue() = "1"
    )
    or
    exists(AssignExpr assign, Variable adminPrivileges |
      assign = expr and
      adminPrivileges.hasName("adminPrivileges") and
      assign.getLValue().(Access).getTarget() = adminPrivileges and
      not assign.getRValue().(Literal).getValue() = "0"
    )
  }
}

/** The argv parameter to the main function */
predicate argv(Parameter argv) {
  exists(Function f |
    f.hasGlobalName("main") and
    f.getParameter(1) = argv
  )
}

/** Convenience accessor for SecurityOptions.isPureFunction */
predicate isPureFunction(string name) { exists(SecurityOptions opts | opts.isPureFunction(name)) }

/** Convenience accessor for SecurityOptions.isProcessOperationArgument */
predicate isProcessOperationArgument(string function, int arg) {
  exists(SecurityOptions opts | opts.isProcessOperationArgument(function, arg))
}

/** Convenient accessor for SecurityOptions.raisesPrivilege */
predicate raisesPrivilege(Expr expr) { exists(SecurityOptions opts | opts.raisesPrivilege(expr)) }

/** Convenience accessor for SecurityOptions.sqlArgument */
predicate sqlArgument(string function, int arg) {
  exists(SecurityOptions opts | opts.sqlArgument(function, arg))
}
