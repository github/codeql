/**
 * Provides classes for modeling data flow in PHP.
 *
 * This module enables data flow and taint analysis by modeling how values
 * propagate through the PHP program, including:
 * - Variable assignments
 * - Function arguments and returns
 * - Array access and mutations
 * - Object property access
 * - Superglobals and external input sources
 */

private import codeql.php.ast.internal.TreeSitter as TS
private import codeql.php.ast.Expr
import codeql.php.dataflow.internal.DataFlowPublic
import codeql.php.dataflow.internal.DataFlowPrivate
private import codeql.php.dataflow.internal.DataFlowImpl

/**
 * A data flow node (alias for use in queries).
 */
class DataFlowNode extends Node {
  /** Gets the expression, if any. */
  override TS::PHP::Expression asExpr() { result = super.asExpr() }
}

/**
 * A superglobal variable that contains user input.
 */
class SuperglobalVariable extends TS::PHP::VariableName {
  SuperglobalVariable() {
    exists(string name | name = this.getChild().(TS::PHP::Name).getValue() |
      name in [
        "$_GET", "$_POST", "$_REQUEST", "$_SERVER", "$_FILES",
        "$_COOKIE", "$_SESSION", "$_ENV", "$GLOBALS"
      ]
    )
  }

  /** Gets the superglobal name. */
  string getSuperglobalName() { result = this.getChild().(TS::PHP::Name).getValue() }

  /** Holds if this is a user input superglobal. */
  predicate isUserInput() {
    this.getSuperglobalName() in ["$_GET", "$_POST", "$_REQUEST", "$_COOKIE", "$_FILES"]
  }
}

/**
 * An array access on a superglobal.
 */
class SuperglobalArrayAccess extends TS::PHP::SubscriptExpression {
  SuperglobalVariable superglobal;

  SuperglobalArrayAccess() { superglobal = this.getChild(0) }

  /** Gets the superglobal being accessed. */
  SuperglobalVariable getSuperglobal() { result = superglobal }

  /** Gets the index expression, if any. */
  TS::PHP::AstNode getIndex() { result = this.getChild(1) }

  /** Gets the key being accessed, if it's a string literal. */
  string getKey() {
    result = this.getIndex().(TS::PHP::EncapsedString).getChild(_).(TS::PHP::StringContent).getValue()
    or
    result = this.getIndex().(TS::PHP::String).getChild(_).(TS::PHP::StringContent).getValue()
  }
}

/**
 * A superglobal access (legacy alias).
 */
class SuperglobalAccess extends Variable {
  SuperglobalAccess() {
    this.getName() in [
      "_GET", "_POST", "_REQUEST", "_SERVER", "_FILES", "_COOKIE", "_SESSION", "_ENV", "GLOBALS"
    ]
  }

  /** Gets the superglobal type. */
  string getSuperglobalType() { result = this.getName() }

  /** Holds if this is a user input superglobal. */
  predicate isUserInput() {
    this.getName() in ["_GET", "_POST", "_REQUEST", "_COOKIE", "_FILES"]
  }
}

/**
 * A command execution function.
 */
class CommandExecutionFunction extends FunctionCall {
  CommandExecutionFunction() {
    this.getFunctionName() in [
      "exec", "system", "passthru", "shell_exec", "popen", "proc_open", "pcntl_exec"
    ]
  }
}

/**
 * A database query function.
 */
class DatabaseFunction extends FunctionCall {
  DatabaseFunction() {
    this.getFunctionName() in [
      "mysql_query", "mysqli_query", "mysqli_real_query", "mysqli_multi_query",
      "pg_query", "pg_query_params", "sqlite_query", "sqlite3_query"
    ]
  }
}

/**
 * A sanitization function.
 */
class SanitizationFunction extends FunctionCall {
  string sanitizationType;

  SanitizationFunction() {
    exists(string name | name = this.getFunctionName() |
      // HTML encoding
      name in ["htmlspecialchars", "htmlentities", "strip_tags"] and
      sanitizationType = "HTML"
      or
      // SQL escaping
      name in [
        "mysqli_real_escape_string", "mysql_real_escape_string", "addslashes",
        "pg_escape_string", "sqlite_escape_string"
      ] and
      sanitizationType = "SQL"
      or
      // URL encoding
      name in ["urlencode", "rawurlencode"] and
      sanitizationType = "URL"
      or
      // Shell escaping
      name in ["escapeshellarg", "escapeshellcmd"] and
      sanitizationType = "Shell"
      or
      // General filtering
      name in ["filter_var", "filter_input"] and
      sanitizationType = "Filter"
      or
      // Regex escaping
      name in ["preg_quote", "quotemeta"] and
      sanitizationType = "Regex"
    )
  }

  /** Gets the type of sanitization this function provides. */
  string getSanitizationType() { result = sanitizationType }
}

/**
 * A dangerous function call that may be a sink.
 */
class DangerousFunctionCall extends FunctionCall {
  string sinkType;

  DangerousFunctionCall() {
    exists(string name | name = this.getFunctionName() |
      // SQL functions
      name in [
        "mysql_query", "mysqli_query", "mysqli_real_query", "mysqli_multi_query",
        "pg_query", "pg_query_params", "sqlite_query", "sqlite3_query"
      ] and
      sinkType = "SQL Injection"
      or
      // Command execution
      name in ["exec", "system", "passthru", "shell_exec", "popen", "proc_open", "pcntl_exec"] and
      sinkType = "Command Injection"
      or
      // Code execution
      name in ["eval", "create_function", "assert", "preg_replace"] and
      sinkType = "Code Injection"
      or
      // Deserialization
      name in ["unserialize", "yaml_parse"] and
      sinkType = "Deserialization"
      or
      // File operations with user input
      name in ["file_get_contents", "file_put_contents", "fopen", "readfile", "include", "require"] and
      sinkType = "Path Traversal"
      or
      // LDAP
      name in ["ldap_search", "ldap_bind"] and
      sinkType = "LDAP Injection"
      or
      // XPath
      name in ["xpath", "simplexml_load_string"] and
      sinkType = "XPath Injection"
    )
  }

  /** Gets the type of sink this function represents. */
  string getSinkType() { result = sinkType }
}

/**
 * A sanitization function call (alias).
 */
class SanitizationCall extends SanitizationFunction { }

/**
 * A validation function call.
 */
class ValidationCall extends FunctionCall {
  ValidationCall() {
    this.getFunctionName() in [
      "is_numeric", "is_int", "is_integer", "is_long", "is_float", "is_double",
      "is_real", "is_string", "is_array", "is_object", "is_null", "is_bool",
      "isset", "empty", "ctype_digit", "ctype_alpha", "ctype_alnum",
      "filter_var", "preg_match"
    ]
  }
}

/**
 * An input source - where tainted data enters the program.
 */
class InputSource extends TS::PHP::AstNode {
  InputSource() {
    // Superglobal access
    this instanceof SuperglobalVariable
    or
    this instanceof SuperglobalArrayAccess
    or
    // File input functions
    exists(FunctionCall call | call = this |
      call.getFunctionName() in [
        "file_get_contents", "fgets", "fread", "fgetc", "fgetss", "fgetcsv",
        "file", "readfile", "stream_get_contents"
      ]
    )
    or
    // Database input
    exists(FunctionCall call | call = this |
      call.getFunctionName() in [
        "mysql_fetch_array", "mysql_fetch_assoc", "mysql_fetch_row",
        "mysqli_fetch_array", "mysqli_fetch_assoc", "mysqli_fetch_row",
        "mysqli_fetch_all", "mysqli_fetch_object"
      ]
    )
    or
    // Environment/headers
    exists(FunctionCall call | call = this |
      call.getFunctionName() in ["getenv", "apache_request_headers", "getallheaders"]
    )
  }
}

/**
 * An output sink - where data leaves the program to an external system.
 */
class OutputSink extends TS::PHP::AstNode {
  OutputSink() {
    this instanceof DangerousFunctionCall
    or
    // Echo/print statements
    this instanceof TS::PHP::EchoStatement
    or
    this instanceof TS::PHP::PrintIntrinsic
    or
    // Output functions
    exists(FunctionCall call | call = this |
      call.getFunctionName() in ["echo", "print", "printf", "vprintf", "var_dump", "print_r"]
    )
  }
}

/**
 * A method call that may be a sink (for OOP patterns).
 */
class DangerousMethodCall extends MethodCall {
  string sinkType;

  DangerousMethodCall() {
    exists(string name | name = this.getMethodName() |
      // PDO
      name in ["query", "exec", "prepare"] and sinkType = "SQL Injection"
      or
      // mysqli
      name in ["query", "real_query", "multi_query", "prepare"] and sinkType = "SQL Injection"
    )
  }

  /** Gets the type of sink this method call represents. */
  string getSinkType() { result = sinkType }
}

/**
 * Provides taint tracking configuration types.
 * Use TaintFlowMake::Global<YourConfig> directly to instantiate.
 */
module TaintTracking {
  import TaintFlowMake
}

/**
 * Provides data flow configuration types.
 * Use DataFlowMake::Global<YourConfig> directly to instantiate.
 */
module DataFlow {
  import DataFlowMake
}
