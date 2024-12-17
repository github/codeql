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
    this.asExpr()
        .getExpr()
        .(CallExpr)
        .getFunction()
        .(PathExpr)
        .resolvesToStandardPath("std::env", ["args", "args_os"])
  }
}

/**
 * A call to `std::env::current_dir`, `std::env::current_exe` or `std::env::home_dir`.
 */
private class StdEnvDir extends CommandLineArgsSource::Range {
  StdEnvDir() {
    this.asExpr()
        .getExpr()
        .(CallExpr)
        .getFunction()
        .(PathExpr)
        .resolvesToStandardPath("std::env", ["current_dir", "current_exe", "home_dir"])
  }
}

/**
 * A call to `std::env::var`, `std::env::var_os`, `std::env::vars` or `std::env::vars_os`.
 */
private class StdEnvVar extends EnvironmentSource::Range {
  StdEnvVar() {
    this.asExpr()
        .getExpr()
        .(CallExpr)
        .getFunction()
        .(PathExpr)
        .resolvesToStandardPath("std::env", ["var", "var_os", "vars", "vars_os"])
  }
}
