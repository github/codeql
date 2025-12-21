/**
 * Provides classes and utilities for modeling core PHP library functions.
 *
 * This module covers dangerous functions in the PHP standard library that
 * can be sources or sinks for security vulnerabilities.
 */

private import codeql.php.ast.internal.TreeSitter as TS
private import codeql.php.ast.Expr

/**
 * A call to a database function.
 */
class DatabaseFunction extends FunctionCall {
  DatabaseFunction() {
    this.getFunctionName() in [
      "mysql_query", "mysql_fetch_array", "mysql_fetch_assoc", "mysql_fetch_row",
      "mysqli_query", "mysqli_real_query", "mysqli_multi_query", "mysqli_prepare",
      "mysqli_fetch_array", "mysqli_fetch_assoc", "mysqli_fetch_row", "mysqli_fetch_all",
      "pg_query", "pg_query_params", "pg_prepare", "pg_execute",
      "sqlite_query", "sqlite_exec", "sqlite3_query"
    ]
  }
}

/**
 * A call to a command execution function.
 */
class CommandExecutionFunction extends FunctionCall {
  CommandExecutionFunction() {
    this.getFunctionName() in [
      "exec", "system", "passthru", "shell_exec", "popen", "proc_open", "pcntl_exec"
    ]
  }
}

/**
 * A call to an eval-like code execution function.
 */
class CodeExecutionFunction extends FunctionCall {
  CodeExecutionFunction() {
    this.getFunctionName() in [
      "eval", "create_function", "assert", "call_user_func", "call_user_func_array",
      "array_map", "array_filter", "array_walk", "preg_replace_callback",
      "usort", "uasort", "uksort"
    ]
  }
}

/**
 * A call to an output function.
 */
class OutputFunction extends FunctionCall {
  OutputFunction() {
    this.getFunctionName() in [
      "printf", "vprintf", "sprintf", "var_dump", "print_r", "var_export"
    ]
  }
}

/**
 * A call to a file operation function.
 */
class FileOperationFunction extends FunctionCall {
  FileOperationFunction() {
    this.getFunctionName() in [
      "file_get_contents", "file_put_contents", "file", "readfile",
      "fopen", "fread", "fgets", "fgetc", "fwrite", "fputcsv",
      "copy", "rename", "unlink", "rmdir", "mkdir"
    ]
  }
}

/**
 * A call to a serialization function.
 */
class SerializationFunction extends FunctionCall {
  SerializationFunction() {
    this.getFunctionName() in [
      "unserialize", "json_decode", "simplexml_load_string", "yaml_parse"
    ]
  }
}

/**
 * A call to a regular expression function.
 */
class RegexFunction extends FunctionCall {
  RegexFunction() {
    this.getFunctionName() in [
      "preg_match", "preg_match_all", "preg_replace", "preg_replace_callback",
      "preg_split", "preg_grep"
    ]
  }
}

/**
 * A call to a sanitization function.
 */
class SanitizationFunction extends FunctionCall {
  SanitizationFunction() {
    this.getFunctionName() in [
      "htmlspecialchars", "htmlentities", "strip_tags",
      "mysqli_escape_string", "mysqli_real_escape_string", "addslashes",
      "quotemeta", "preg_quote", "urlencode", "rawurlencode",
      "base64_encode", "json_encode",
      "escapeshellarg", "escapeshellcmd",
      "filter_var", "filter_input"
    ]
  }
}

/**
 * A call to a validation function.
 */
class ValidationFunction extends FunctionCall {
  ValidationFunction() {
    this.getFunctionName() in [
      "is_numeric", "is_int", "is_integer", "is_long",
      "is_float", "is_double", "is_real",
      "is_string", "is_array", "is_object", "is_bool", "is_null",
      "is_scalar", "is_callable", "is_iterable", "is_countable",
      "ctype_digit", "ctype_alpha", "ctype_alnum"
    ]
  }
}

/**
 * A call to an input access function.
 */
class InputAccessFunction extends FunctionCall {
  InputAccessFunction() {
    this.getFunctionName() in [
      "getenv", "filter_input", "filter_input_array",
      "apache_request_headers", "getallheaders"
    ]
  }
}

/**
 * A reference to a superglobal variable.
 */
class SuperglobalVariable extends Variable {
  string superglobalType;

  SuperglobalVariable() {
    exists(string name | name = this.getName() |
      name = "_GET" and superglobalType = "GET parameter"
      or
      name = "_POST" and superglobalType = "POST parameter"
      or
      name = "_REQUEST" and superglobalType = "request parameter"
      or
      name = "_SERVER" and superglobalType = "server variable"
      or
      name = "_FILES" and superglobalType = "uploaded file"
      or
      name = "_COOKIE" and superglobalType = "cookie"
      or
      name = "_SESSION" and superglobalType = "session variable"
      or
      name = "GLOBALS" and superglobalType = "global variable"
      or
      name = "_ENV" and superglobalType = "environment variable"
    )
  }

  /** Gets the type of superglobal. */
  string getSuperglobalType() { result = superglobalType }

  /** Holds if this is a user input superglobal. */
  predicate isUserInput() {
    this.getName() in ["_GET", "_POST", "_REQUEST", "_COOKIE", "_FILES"]
  }
}

/**
 * A superglobal array access (e.g., $_GET['id']).
 */
class SuperglobalArrayAccess extends SubscriptExpr {
  SuperglobalArrayAccess() {
    this.getBase() instanceof SuperglobalVariable or
    this.getBase() instanceof SuperglobalArrayAccess
  }

  /** Gets the root superglobal variable. */
  SuperglobalVariable getSuperglobal() {
    result = this.getBase()
    or
    result = this.getBase().(SuperglobalArrayAccess).getSuperglobal()
  }
}

/**
 * A call to a cryptographic hash function.
 */
class HashFunction extends FunctionCall {
  HashFunction() {
    this.getFunctionName() in [
      "md5", "sha1", "sha256", "sha512", "hash", "hash_hmac",
      "crypt", "password_hash", "password_verify"
    ]
  }

  /** Holds if this uses a weak hash algorithm. */
  predicate usesWeakAlgorithm() {
    this.getFunctionName() in ["md5", "sha1"]
  }
}

/**
 * A call to an encryption function.
 */
class EncryptionFunction extends FunctionCall {
  EncryptionFunction() {
    this.getFunctionName() in [
      "openssl_encrypt", "openssl_decrypt",
      "sodium_crypto_secretbox", "sodium_crypto_secretbox_open",
      "sodium_crypto_box", "sodium_crypto_box_open"
    ]
  }
}

/**
 * A call to a random generation function.
 */
class RandomFunction extends FunctionCall {
  RandomFunction() {
    this.getFunctionName() in [
      "random_bytes", "random_int", "openssl_random_pseudo_bytes",
      "mt_rand", "rand"
    ]
  }

  /** Holds if this uses a cryptographically insecure random generator. */
  predicate isInsecure() {
    this.getFunctionName() in ["mt_rand", "rand"]
  }
}
