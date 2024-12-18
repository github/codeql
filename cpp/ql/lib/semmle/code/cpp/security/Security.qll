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
   * The argument of the given function is filled in from user input.
   */
  deprecated predicate userInputArgument(FunctionCall functionCall, int arg) {
    exists(string fname |
      functionCall.getTarget().hasGlobalOrStdName(fname) and
      exists(functionCall.getArgument(arg)) and
      (
        fname = ["fread", "fgets", "fgetws", "gets"] and arg = 0
        or
        fname = "scanf" and arg >= 1
        or
        fname = "fscanf" and arg >= 2
      )
      or
      functionCall.getTarget().hasGlobalName(fname) and
      exists(functionCall.getArgument(arg)) and
      fname = "getaddrinfo" and
      arg = 3
    )
    or
    exists(RemoteFlowSourceFunction remote, FunctionOutput output |
      functionCall.getTarget() = remote and
      output.isParameterDerefOrQualifierObject(arg) and
      remote.hasRemoteFlowSource(output, _)
    )
  }

  /**
   * The return value of the given function is filled in from user input.
   */
  deprecated predicate userInputReturned(FunctionCall functionCall) {
    exists(string fname |
      functionCall.getTarget().getName() = fname and
      (
        fname = ["fgets", "gets"] or
        this.userInputReturn(fname)
      )
    )
    or
    exists(RemoteFlowSourceFunction remote, FunctionOutput output |
      functionCall.getTarget() = remote and
      (output.isReturnValue() or output.isReturnValueDeref()) and
      remote.hasRemoteFlowSource(output, _)
    )
  }

  /**
   * DEPRECATED: Users should override `userInputReturned()` instead.
   */
  deprecated predicate userInputReturn(string function) { none() }

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
   * This predicate should hold if the expression is directly
   * computed from user input. Such expressions are treated as
   * sources of taint.
   */
  deprecated predicate isUserInput(Expr expr, string cause) {
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
deprecated predicate userInputArgument(FunctionCall functionCall, int arg) {
  exists(SecurityOptions opts | opts.userInputArgument(functionCall, arg))
}

/** Convenience accessor for SecurityOptions.userInputReturn */
deprecated predicate userInputReturned(FunctionCall functionCall) {
  exists(SecurityOptions opts | opts.userInputReturned(functionCall))
}

/** Convenience accessor for SecurityOptions.isUserInput */
deprecated predicate isUserInput(Expr expr, string cause) {
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
