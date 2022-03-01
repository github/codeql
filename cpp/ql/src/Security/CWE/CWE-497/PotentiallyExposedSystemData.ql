/**
 * @name Potential exposure of sensitive system data to an unauthorized control sphere
 * @description Exposing sensitive system data helps
 *              an adversary learn about the system and form an
 *              attack plan.
 * @kind problem
 * @problem.severity warning
 * @security-severity TODO
 * @precision medium
 * @id cpp/potential-system-data-exposure
 * @tags security
 *       external/cwe/cwe-497
 */

/*
 * These queries are closely related:
 *  - `cpp/system-data-exposure`, which flags exposure of system information
 *    to a remote sink (i.e. focusses on qualiy of the sink).
 *  - `cpp/potential-system-data-exposure`, which flags on exposure of the most
 *    sensitive information to a local sink (i.e. focusses on quality of the
 *    sensitive information).
 *
 * This used to be a single query with neither focus, which was too noisy and
 * gave the user less control.
 */

// TODO: use a library to reduce duplication between the queries.
import cpp
import semmle.code.cpp.commons.Environment
import semmle.code.cpp.ir.dataflow.TaintTracking
import semmle.code.cpp.models.interfaces.FlowSource
import semmle.code.cpp.security.OutputWrite
import DataFlow::PathGraph

/**
 * An element that should not be exposed to an adversary.
 */
abstract class SystemData extends Element {
  /**
   * Gets an expression that is part of this `SystemData`.
   */
  abstract Expr getAnExpr();
}

/**
 * Data that is likely to be sensitive, originating from the environment.
 */
class EnvData extends SystemData {
  EnvData() {
    // identify risky looking environment variables only
    this.(EnvironmentRead)
        .getEnvironmentVariable()
        .toLowerCase()
        .regexpMatch(".*(pass|token|key).*")
  }

  override Expr getAnExpr() { result = this }
}

/**
 * Data originating from a call to `mysql_get_client_info()`.
 */
class SQLClientInfo extends SystemData {
  SQLClientInfo() { this.(FunctionCall).getTarget().hasName("mysql_get_client_info") }

  override Expr getAnExpr() { result = this }
}

private predicate sqlConnectInfo(FunctionCall source, VariableAccess use) {
  (
    source.getTarget().hasName("mysql_connect") or
    source.getTarget().hasName("mysql_real_connect")
  ) and
  use = source.getArgument(3) // passwd
}

/**
 * Sensitive data passed into an SQL connect function.
 */
class SQLConnectInfo extends SystemData {
  SQLConnectInfo() { sqlConnectInfo(this, _) }

  override Expr getAnExpr() { sqlConnectInfo(this, result) }
}

private predicate posixPWInfo(FunctionCall source, Element use) {
  // struct passwd *getpwnam(const char *name);
  // struct passwd *getpwuid(uid_t uid);
  // struct passwd *getpwent(void);
  // struct group  *getgrnam(const char *name);
  // struct group  *getgrgid(gid_t);
  // struct group  *getgrent(void);
  source
      .getTarget()
      .hasName(["getpwnam", "getpwuid", "getpwent", "getgrnam", "getgrgid", "getgrent"]) and
  use = source
  or
  // int getpwnam_r(const char *name, struct passwd *pwd,
  //                char *buf, size_t buflen, struct passwd **result);
  // int getpwuid_r(uid_t uid, struct passwd *pwd,
  //                char *buf, size_t buflen, struct passwd **result);
  // int getgrgid_r(gid_t gid, struct group *grp,
  //                char *buf, size_t buflen, struct group **result);
  // int getgrnam_r(const char *name, struct group *grp,
  //                char *buf, size_t buflen, struct group **result);
  source.getTarget().hasName(["getpwnam_r", "getpwuid_r", "getgrgid_r", "getgrnam_r"]) and
  use = source.getArgument([1, 2, 4])
  or
  // int getpwent_r(struct passwd *pwd, char *buffer, size_t bufsize,
  //                struct passwd **result);
  // int getgrent_r(struct group *gbuf, char *buf,
  //                size_t buflen, struct group **gbufp);
  source.getTarget().hasName(["getpwent_r", "getgrent_r"]) and
  use = source.getArgument([0, 1, 3])
}

/**
 * Data obtained from a POSIX user/password/group database information call.
 */
class PosixPWInfo extends SystemData {
  PosixPWInfo() { posixPWInfo(this, _) }

  override Expr getAnExpr() { posixPWInfo(this, result) }
}

private predicate logonUser(FunctionCall source, VariableAccess use) {
  source.getTarget().hasGlobalName(["LogonUser", "LogonUserW", "LogonUserA"]) and
  use = source.getAnArgument()
}

/**
 * Data passed into a `LogonUser` (Windows) function.
 */
class LogonUser extends SystemData {
  LogonUser() { logonUser(this, _) }

  override Expr getAnExpr() { logonUser(this, result) }
}

private predicate regQuery(FunctionCall source, VariableAccess use) {
  // LONG WINAPI RegQueryValue(
  //   _In_        HKEY    hKey,
  //   _In_opt_    LPCTSTR lpSubKey,
  //   _Out_opt_   LPTSTR  lpValue,
  //   _Inout_opt_ PLONG   lpcbValue
  // );
  source.getTarget().hasGlobalName(["RegQueryValue", "RegQueryValueA", "RegQueryValueW"]) and
  use = source.getArgument(2)
  or
  // LONG WINAPI RegQueryMultipleValues(
  //   _In_        HKEY    hKey,
  //   _Out_       PVALENT val_list,
  //   _In_        DWORD   num_vals,
  //   _Out_opt_   LPTSTR  lpValueBuf,
  //   _Inout_opt_ LPDWORD ldwTotsize
  // );
  source
      .getTarget()
      .hasGlobalName([
          "RegQueryMultipleValues", "RegQueryMultipleValuesA", "RegQueryMultipleValuesW"
        ]) and
  use = source.getArgument(3)
  or
  // LONG WINAPI RegQueryValueEx(
  //   _In_        HKEY    hKey,
  //   _In_opt_    LPCTSTR lpValueName,
  //   _Reserved_  LPDWORD lpReserved,
  //   _Out_opt_   LPDWORD lpType,
  //   _Out_opt_   LPBYTE  lpData,
  //   _Inout_opt_ LPDWORD lpcbData
  // );
  source.getTarget().hasGlobalName(["RegQueryValueEx", "RegQueryValueExA", "RegQueryValueExW"]) and
  use = source.getArgument(4)
  or
  // LONG WINAPI RegGetValue(
  //   _In_        HKEY    hkey,
  //   _In_opt_    LPCTSTR lpSubKey,
  //   _In_opt_    LPCTSTR lpValue,
  //   _In_opt_    DWORD   dwFlags,
  //   _Out_opt_   LPDWORD pdwType,
  //   _Out_opt_   PVOID   pvData,
  //   _Inout_opt_ LPDWORD pcbData
  // );
  source.getTarget().hasGlobalName(["RegGetValue", "RegGetValueA", "RegGetValueW"]) and
  use = source.getArgument(5)
}

/**
 * Data read from the Windows registry.
 */
class RegQuery extends SystemData {
  RegQuery() { regQuery(this, _) }

  override Expr getAnExpr() {
    regQuery(this, result) and
    this.(FunctionCall).getAnArgument().getValue().toLowerCase().regexpMatch(".*(pass|token|key).*")
  }
}

class PotentiallyExposedSystemDataConfiguration extends TaintTracking::Configuration {
  PotentiallyExposedSystemDataConfiguration() { this = "PotentiallyExposedSystemDataConfiguration" }

  override predicate isSource(DataFlow::Node source) {
    source.asExpr() = any(SystemData sd).getAnExpr()
  }

  override predicate isSink(DataFlow::Node sink) {
    exists(OutputWrite ow | ow.getASource() = sink.asExpr())
    // TODO: eliminate duplication on remote flow sources?
  }
}

from
  PotentiallyExposedSystemDataConfiguration config, DataFlow::PathNode source,
  DataFlow::PathNode sink
where config.hasFlowPath(source, sink)
select sink, source, sink,
  "This operation potentially exposes sensitive system data (a password or token) from $@.", source,
  source.getNode().toString()
