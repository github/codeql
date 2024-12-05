/**
 * Provides modeling for the `std::env` library.
 */

private import rust
private import codeql.rust.Concepts

/**
 * A call to `std::env::args` or `std::env::args_os`.
 */
private class StdEnvArgs extends CommandLineArgsSource::Range {
  StdEnvArgs() {
    this.asExpr().getExpr().(CallExpr).getFunction().(PathExpr).getResolvedPath() =
      ["crate::env::args", "crate::env::args_os"]
  }
}

/**
 * A call to `std::env::current_dir`, `std::env::current_exe` or `std::env::home_dir`.
 */
private class StdEnvDir extends CommandLineArgsSource::Range {
  StdEnvDir() {
    this.asExpr().getExpr().(CallExpr).getFunction().(PathExpr).getResolvedPath() =
      ["crate::env::current_dir", "crate::env::current_exe", "crate::env::home_dir"]
  }
}

/**
 * A call to `std::env::var`, `std::env::var_os`, `std::env::vars` or `std::env::vars_os`.
 */
private class StdEnvVar extends EnvironmentSource::Range {
  StdEnvVar() {
    this.asExpr().getExpr().(CallExpr).getFunction().(PathExpr).getResolvedPath() =
      ["crate::env::var", "crate::env::var_os", "crate::env::vars", "crate::env::vars_os"]
  }
}
