package com.semmle.js.extractor;

import com.semmle.util.exception.UserError;
import com.semmle.util.process.Env;
import com.semmle.util.process.Env.Var;

public class EnvironmentVariables {
  public static final String CODEQL_EXTRACTOR_JAVASCRIPT_ROOT_ENV_VAR =
      "CODEQL_EXTRACTOR_JAVASCRIPT_ROOT";

  /**
   * Gets the extractor root based on the <code>CODEQL_EXTRACTOR_JAVASCRIPT_ROOT</code> or <code>
   * SEMMLE_DIST</code> or environment variable, or <code>null</code> if neither is set.
   */
  public static String tryGetExtractorRoot() {
    String env = Env.systemEnv().get(CODEQL_EXTRACTOR_JAVASCRIPT_ROOT_ENV_VAR);
    if (env != null && !env.isEmpty()) return env;
    env = Env.systemEnv().get(Var.SEMMLE_DIST);
    if (env != null && !env.isEmpty()) return env;
    return null;
  }

  /**
   * Gets the extractor root based on the <code>CODEQL_EXTRACTOR_JAVASCRIPT_ROOT</code> or <code>
   * SEMMLE_DIST</code> or environment variable, or throws a UserError if neither is set.
   */
  public static String getExtractorRoot() {
    String env = tryGetExtractorRoot();
    if (env == null) {
      throw new UserError("SEMMLE_DIST or CODEQL_EXTRACTOR_JAVASCRIPT_ROOT must be set");
    }
    return env;
  }
}
