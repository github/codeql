import codeql.php.ast.Calls

/** Very small syntactic model of risky sinks for the MVP. */
module PhpSecuritySinks {
  predicate isDangerousBuiltinName(string name) {
    name in ["eval", "assert", "unserialize", "system", "exec"]
  }

  predicate isDangerousBuiltinCall(FunctionCall call) {
    isDangerousBuiltinName(call.getCalleeName())
  }
}
