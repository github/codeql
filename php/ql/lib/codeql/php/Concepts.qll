/**
 * Provides classes for modeling framework and library APIs in PHP.
 *
 * Framework concepts model common patterns like:
 * - Request/response handling
 * - Database queries
 * - Template rendering
 * - Authentication/authorization
 */

private import codeql.php.ast.internal.TreeSitter as TS
private import codeql.php.ast.Expr
private import codeql.php.ast.Declaration

/**
 * A framework request class.
 */
class RequestClass extends ClassDef {
  RequestClass() {
    this.getName() in [
      "Request", "HttpRequest", "ServerRequest", "Illuminate\\Http\\Request",
      "Symfony\\Component\\HttpFoundation\\Request"
    ]
  }
}

/**
 * A framework response class.
 */
class ResponseClass extends ClassDef {
  ResponseClass() {
    this.getName() in [
      "Response", "HttpResponse", "ServerResponse", "Illuminate\\Http\\Response",
      "Symfony\\Component\\HttpFoundation\\Response"
    ]
  }
}

/**
 * A database query execution (function call).
 */
class DatabaseQueryCall extends FunctionCall {
  DatabaseQueryCall() {
    this.getFunctionName() in [
      "mysql_query", "mysqli_query", "mysqli_prepare", "mysqli_real_query",
      "pg_query", "pg_query_params", "pg_prepare",
      "sqlite_query", "sqlite_exec"
    ]
  }

  /** Gets the query argument. */
  TS::PHP::AstNode getQueryArgument() {
    result = this.getArgument(0)
    or
    // mysqli_query has connection as first arg
    this.getFunctionName() = "mysqli_query" and result = this.getArgument(1)
  }
}

/**
 * A database query method call (OOP style).
 */
class DatabaseQueryMethodCall extends MethodCall {
  DatabaseQueryMethodCall() {
    this.getMethodName() in ["query", "exec", "prepare", "execute"]
  }

  /** Gets the query argument. */
  TS::PHP::AstNode getQueryArgument() { result = this.getArgument(0) }
}

/**
 * A template rendering function call.
 */
class TemplateRenderCall extends FunctionCall {
  TemplateRenderCall() {
    this.getFunctionName() in [
      "render", "display", "parse", "include", "require",
      "include_once", "require_once", "extract"
    ]
  }
}

/**
 * A template rendering method call.
 */
class TemplateRenderMethodCall extends MethodCall {
  TemplateRenderMethodCall() {
    this.getMethodName() in ["render", "display", "make", "view", "parse"]
  }
}

/**
 * An authentication check function.
 */
class AuthCheckCall extends FunctionCall {
  AuthCheckCall() {
    this.getFunctionName() in [
      "authenticate", "authorize", "check", "login", "logout",
      "session_start", "session_regenerate_id"
    ]
  }
}

/**
 * An authentication check method.
 */
class AuthCheckMethodCall extends MethodCall {
  AuthCheckMethodCall() {
    this.getMethodName() in [
      "authenticate", "authorize", "can", "cannot", "check",
      "login", "logout", "attempt", "guard", "user"
    ]
  }
}

/**
 * A file operation function call.
 */
class FileOperationCall extends FunctionCall {
  string operationType;

  FileOperationCall() {
    exists(string name | name = this.getFunctionName() |
      name in ["fopen", "file_get_contents", "file", "readfile", "fread", "fgets"] and
      operationType = "read"
      or
      name in ["fwrite", "file_put_contents", "fputs"] and operationType = "write"
      or
      name in ["unlink", "rmdir", "rename", "copy", "move_uploaded_file"] and
      operationType = "modify"
      or
      name in ["is_file", "file_exists", "is_readable", "is_writable", "stat", "lstat"] and
      operationType = "check"
    )
  }

  /** Gets the type of file operation. */
  string getOperationType() { result = operationType }

  /** Gets the path argument. */
  TS::PHP::AstNode getPathArgument() { result = this.getArgument(0) }
}

/**
 * A session operation function call.
 */
class SessionOperationCall extends FunctionCall {
  SessionOperationCall() {
    this.getFunctionName() in [
      "session_start", "session_destroy", "session_regenerate_id",
      "session_id", "session_name", "session_unset"
    ]
  }
}

/**
 * A cookie operation function call.
 */
class CookieOperationCall extends FunctionCall {
  CookieOperationCall() {
    this.getFunctionName() in ["setcookie", "setrawcookie"]
  }

  /** Gets the cookie name argument. */
  TS::PHP::AstNode getNameArgument() { result = this.getArgument(0) }

  /** Gets the cookie value argument. */
  TS::PHP::AstNode getValueArgument() { result = this.getArgument(1) }
}

/**
 * A header operation function call.
 */
class HeaderOperationCall extends FunctionCall {
  HeaderOperationCall() {
    this.getFunctionName() in ["header", "header_remove"]
  }

  /** Gets the header string argument. */
  TS::PHP::AstNode getHeaderArgument() { result = this.getArgument(0) }
}

/**
 * A redirect operation.
 */
class RedirectCall extends FunctionCall {
  RedirectCall() {
    this.getFunctionName() = "header" and
    exists(TS::PHP::AstNode arg | arg = this.getArgument(0) |
      // Check if it looks like a Location header
      arg.(StringLiteral).getValue().toLowerCase().matches("location:%")
    )
  }
}

/**
 * A JSON operation function call.
 */
class JsonOperationCall extends FunctionCall {
  string operationType;

  JsonOperationCall() {
    exists(string name | name = this.getFunctionName() |
      name = "json_encode" and operationType = "encode"
      or
      name = "json_decode" and operationType = "decode"
    )
  }

  /** Gets the type of JSON operation. */
  string getOperationType() { result = operationType }
}

/**
 * A cryptographic operation function call.
 */
class CryptoOperationCall extends FunctionCall {
  string operationType;

  CryptoOperationCall() {
    exists(string name | name = this.getFunctionName() |
      name in ["password_hash", "crypt", "hash", "md5", "sha1", "sha256"] and
      operationType = "hash"
      or
      name in ["password_verify", "hash_equals"] and operationType = "verify"
      or
      name in ["openssl_encrypt", "mcrypt_encrypt", "sodium_crypto_secretbox"] and
      operationType = "encrypt"
      or
      name in ["openssl_decrypt", "mcrypt_decrypt", "sodium_crypto_secretbox_open"] and
      operationType = "decrypt"
      or
      name in ["random_bytes", "openssl_random_pseudo_bytes", "random_int"] and
      operationType = "random"
    )
  }

  /** Gets the type of cryptographic operation. */
  string getOperationType() { result = operationType }
}

/**
 * A logging operation.
 */
class LoggingCall extends FunctionCall {
  LoggingCall() {
    this.getFunctionName() in [
      "error_log", "syslog", "openlog", "trigger_error", "user_error"
    ]
  }
}

/**
 * A logging method call.
 */
class LoggingMethodCall extends MethodCall {
  LoggingMethodCall() {
    this.getMethodName() in [
      "log", "debug", "info", "notice", "warning", "error", "critical",
      "alert", "emergency"
    ]
  }
}
