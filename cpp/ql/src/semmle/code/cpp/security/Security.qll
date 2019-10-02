/**
 * Definitions related to security queries.
 * These can be extended for specific code bases.
 */

import semmle.code.cpp.exprs.Expr
import semmle.code.cpp.commons.Environment
import semmle.code.cpp.security.SecurityOptions

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
    name = "abs" or
    name = "atof" or
    name = "atoi" or
    name = "atol" or
    name = "atoll" or
    name = "labs" or
    name = "strcasestr" or
    name = "strcat" or
    name = "strchnul" or
    name = "strchr" or
    name = "strchrnul" or
    name = "strcmp" or
    name = "strcpy" or
    name = "strcspn" or
    name = "strdup" or
    name = "strlen" or
    name = "strncat" or
    name = "strncmp" or
    name = "strncpy" or
    name = "strndup" or
    name = "strnlen" or
    name = "strrchr" or
    name = "strspn" or
    name = "strstr" or
    name = "strtod" or
    name = "strtof" or
    name = "strtol" or
    name = "strtoll" or
    name = "strtoq" or
    name = "strtoul"
  }

  /**
   * An argument to a function that is passed to a SQL server.
   */
  predicate sqlArgument(string function, int arg) {
    // MySQL C API
    function = "mysql_query" and arg = 1
    or
    function = "mysql_real_query" and arg = 1
    or
    // SQLite3 C API
    function = "sqlite3_exec" and arg = 1
  }

  /**
   * The argument of the given function is filled in from user input.
   */
  predicate userInputArgument(FunctionCall functionCall, int arg) {
    exists(string fname |
      functionCall.getTarget().hasGlobalOrStdName(fname) and
      exists(functionCall.getArgument(arg)) and
      (
        fname = "fread" and arg = 0
        or
        fname = "fgets" and arg = 0
        or
        fname = "fgetws" and arg = 0
        or
        fname = "gets" and arg = 0
        or
        fname = "scanf" and arg >= 1
        or
        fname = "fscanf" and arg >= 2
      )
      or
      functionCall.getTarget().hasGlobalName(fname) and
      exists(functionCall.getArgument(arg)) and
      (
        fname = "read" and arg = 1
        or
        fname = "getaddrinfo" and arg = 3
        or
        fname = "recv" and arg = 1
        or
        fname = "recvfrom" and
        (arg = 1 or arg = 4 or arg = 5)
        or
        fname = "recvmsg" and arg = 1
      )
    )
  }

  /**
   * The return value of the given function is filled in from user input.
   */
  predicate userInputReturned(FunctionCall functionCall) {
    exists(string fname |
      functionCall.getTarget().getName() = fname and
      (
        fname = "fgets" or
        fname = "gets" or
        userInputReturn(fname)
      )
    )
  }

  /**
   * DEPRECATED: Users should override `userInputReturned()` instead.
   *
   * note: this function is not formally tagged as `deprecated` since the
   * new `userInputReturned` uses it to provide compatibility with older
   * custom SecurityOptions.qll files.
   */
  predicate userInputReturn(string function) { none() }

  /**
   * The argument of the given function is used for running a process or loading
   * a library.
   */
  predicate isProcessOperationArgument(string function, int arg) {
    // POSIX
    function = "system" and arg = 0
    or
    function = "popen" and arg = 0
    or
    function = "execl" and arg = 0
    or
    function = "execlp" and arg = 0
    or
    function = "execle" and arg = 0
    or
    function = "execv" and arg = 0
    or
    function = "execvp" and arg = 0
    or
    function = "execvpe" and arg = 0
    or
    function = "dlopen" and arg = 0
    or
    // Windows
    function = "LoadLibrary" and arg = 0
    or
    function = "LoadLibraryA" and arg = 0
    or
    function = "LoadLibraryW" and arg = 0
  }

  /**
   * This predicate should hold if the expression is directly
   * computed from user input. Such expressions are treated as
   * sources of taint.
   */
  predicate isUserInput(Expr expr, string cause) {
    exists(FunctionCall fc, int i |
      this.userInputArgument(fc, i) and
      expr = fc.getArgument(i) and
      cause = fc.getTarget().getName()
    )
    or
    exists(FunctionCall fc |
      this.userInputReturned(fc) and
      expr = fc and
      cause = fc.getTarget().getName()
    )
    or
    commandLineArg(expr) and cause = "argv"
    or
    expr.(EnvironmentRead).getSourceDescription() = cause
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

/**
 * An access to the argv argument to main().
 */
private predicate commandLineArg(Expr e) {
  exists(Parameter argv |
    argv(argv) and
    argv.getAnAccess() = e
  )
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

/** Convenience accessor for SecurityOptions.userInputArgument */
predicate userInputArgument(FunctionCall functionCall, int arg) {
  exists(SecurityOptions opts | opts.userInputArgument(functionCall, arg))
}

/** Convenience accessor for SecurityOptions.userInputReturn */
predicate userInputReturned(FunctionCall functionCall) {
  exists(SecurityOptions opts | opts.userInputReturned(functionCall))
}

/** Convenience accessor for SecurityOptions.isUserInput */
predicate isUserInput(Expr expr, string cause) {
  exists(SecurityOptions opts | opts.isUserInput(expr, cause))
}

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
