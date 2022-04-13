/**
 * Classes for recognizing system data, used by the exposed system data queries.
 */

import cpp
import semmle.code.cpp.commons.Environment
import semmle.code.cpp.ir.dataflow.TaintTracking

/**
 * An element that should not be exposed to a malicious user.
 */
abstract class SystemData extends Element {
  /**
   * Gets an expression that is part of this `SystemData`.
   */
  abstract DataFlow::Node getAnExpr();

  /**
   * Holds if this system data is considered especially sensitive (for example
   * a password or token).
   */
  predicate isSensitive() { none() }
}

/**
 * Data originating from the environment.
 */
class EnvData extends SystemData {
  EnvData() {
    // identify risky looking environment variables only
    this.(EnvironmentRead)
        .getEnvironmentVariable()
        .toLowerCase()
        .regexpMatch(".*(user|host|admin|root|home|path|http|ssl|snmp|sock|port|proxy|pass|token|crypt|key).*")
  }

  override DataFlow::Node getAnExpr() { result.asConvertedExpr() = this }

  override predicate isSensitive() {
    this.(EnvironmentRead)
        .getEnvironmentVariable()
        .toLowerCase()
        .regexpMatch(".*(pass|token|key).*")
  }
}

/**
 * Data originating from a call to `mysql_get_client_info()`.
 */
class SQLClientInfo extends SystemData {
  SQLClientInfo() { this.(FunctionCall).getTarget().hasName("mysql_get_client_info") }

  override DataFlow::Node getAnExpr() { result.asConvertedExpr() = this }

  override predicate isSensitive() { any() }
}

private predicate sqlConnectInfo(FunctionCall source, Expr use) {
  (
    source.getTarget().hasName("mysql_connect") or
    source.getTarget().hasName("mysql_real_connect")
  ) and
  use = source.getAnArgument()
}

/**
 * Data passed into an SQL connect function.
 */
class SQLConnectInfo extends SystemData {
  SQLConnectInfo() { sqlConnectInfo(this, _) }

  override DataFlow::Node getAnExpr() { sqlConnectInfo(this, result.asConvertedExpr()) }

  override predicate isSensitive() { any() }
}

private predicate posixSystemInfo(FunctionCall source, DataFlow::Node use) {
  // size_t confstr(int name, char *buf, size_t len)
  //  - various OS / system strings, such as the libc version
  // int statvfs(const char *__path, struct statvfs *__buf)
  // int fstatvfs(int __fd, struct statvfs *__buf)
  source.getTarget().hasName(["confstr", "statvfs", "fstatvfs"]) and
  use.asDefiningArgument() = source.getArgument(1)
  or
  //  - various filesystem parameters
  // int uname(struct utsname *buf)
  //  - OS name and version
  source.getTarget().hasName("uname") and
  use.asDefiningArgument() = source.getArgument(0)
}

/**
 * Data obtained from a POSIX system information call.
 */
class PosixSystemInfo extends SystemData {
  PosixSystemInfo() { posixSystemInfo(this, _) }

  override DataFlow::Node getAnExpr() { posixSystemInfo(this, result) }
}

private predicate posixPWInfo(FunctionCall source, DataFlow::Node use) {
  // struct passwd *getpwnam(const char *name);
  // struct passwd *getpwuid(uid_t uid);
  // struct passwd *getpwent(void);
  // struct group  *getgrnam(const char *name);
  // struct group  *getgrgid(gid_t);
  // struct group  *getgrent(void);
  source
      .getTarget()
      .hasName(["getpwnam", "getpwuid", "getpwent", "getgrnam", "getgrgid", "getgrent"]) and
  use.asConvertedExpr() = source
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
  (
    use.asConvertedExpr() = source.getArgument([1, 2]) or
    use.asDefiningArgument() = source.getArgument(4)
  )
  or
  // int getpwent_r(struct passwd *pwd, char *buffer, size_t bufsize,
  //                struct passwd **result);
  // int getgrent_r(struct group *gbuf, char *buf,
  //                size_t buflen, struct group **gbufp);
  source.getTarget().hasName(["getpwent_r", "getgrent_r"]) and
  (
    use.asConvertedExpr() = source.getArgument([0, 1]) or
    use.asDefiningArgument() = source.getArgument(3)
  )
}

/**
 * Data obtained from a POSIX user/password/group database information call.
 */
class PosixPWInfo extends SystemData {
  PosixPWInfo() { posixPWInfo(this, _) }

  override DataFlow::Node getAnExpr() { posixPWInfo(this, result) }

  override predicate isSensitive() { any() }
}

private predicate windowsSystemInfo(FunctionCall source, DataFlow::Node use) {
  // DWORD WINAPI GetVersion(void);
  source.getTarget().hasGlobalName("GetVersion") and
  use.asConvertedExpr() = source
  or
  // BOOL WINAPI GetVersionEx(_Inout_ LPOSVERSIONINFO lpVersionInfo);
  // void WINAPI GetSystemInfo(_Out_ LPSYSTEM_INFO lpSystemInfo);
  // void WINAPI GetNativeSystemInfo(_Out_ LPSYSTEM_INFO lpSystemInfo);
  source
      .getTarget()
      .hasGlobalName([
          "GetVersionEx", "GetVersionExA", "GetVersionExW", "GetSystemInfo", "GetNativeSystemInfo"
        ]) and
  use.asDefiningArgument() = source.getArgument(0)
}

/**
 * Data obtained from a Windows system information call.
 */
class WindowsSystemInfo extends SystemData {
  WindowsSystemInfo() { windowsSystemInfo(this, _) }

  override DataFlow::Node getAnExpr() { windowsSystemInfo(this, result) }
}

private predicate windowsFolderPath(FunctionCall source, Element use) {
  // BOOL SHGetSpecialFolderPath(
  //         HWND   hwndOwner,
  //   _Out_ LPTSTR lpszPath,
  //   _In_  int    csidl,
  //   _In_  BOOL   fCreate
  // );
  source
      .getTarget()
      .hasGlobalName([
          "SHGetSpecialFolderPath", "SHGetSpecialFolderPathA", "SHGetSpecialFolderPathW"
        ]) and
  use = source.getArgument(1)
  or
  // HRESULT SHGetKnownFolderPath(
  //   _In_     REFKNOWNFOLDERID rfid,
  //   _In_     DWORD            dwFlags,
  //   _In_opt_ HANDLE           hToken,
  //   _Out_    PWSTR            *ppszPath
  // );
  source.getTarget().hasGlobalName("SHGetKnownFolderPath") and
  use = source.getArgument(3)
  or
  // HRESULT SHGetFolderPath(
  //   _In_  HWND   hwndOwner,
  //   _In_  int    nFolder,
  //   _In_  HANDLE hToken,
  //   _In_  DWORD  dwFlags,
  //   _Out_ LPTSTR pszPath
  // );
  source.getTarget().hasGlobalName(["SHGetFolderPath", "SHGetFolderPathA", "SHGetFolderPathW"]) and
  use = source.getArgument(4)
  or
  // HRESULT SHGetFolderPathAndSubDir(
  //   _In_  HWND    hwnd,
  //   _In_  int     csidl,
  //   _In_  HANDLE  hToken,
  //   _In_  DWORD   dwFlags,
  //   _In_  LPCTSTR pszSubDir,
  //   _Out_ LPTSTR  pszPath
  // );
  source
      .getTarget()
      .hasGlobalName([
          "SHGetFolderPathAndSubDir", "SHGetFolderPathAndSubDirA", "SHGetFolderPathAndSubDirW"
        ]) and
  use = source.getArgument(5)
}

/**
 * Data obtained about Windows special paths (for example, the
 * location of `System32`).
 */
class WindowsFolderPath extends SystemData {
  WindowsFolderPath() { windowsFolderPath(this, _) }

  override DataFlow::Node getAnExpr() { windowsFolderPath(this, result.asDefiningArgument()) }
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

  override DataFlow::Node getAnExpr() { logonUser(this, result.asConvertedExpr()) }

  override predicate isSensitive() { any() }
}

/**
 * The type of a registry query parameter, if it is of interest to us. This
 * is used to express information about registry query parameters in the
 * `regQuery` predicate concisely.
 */
private newtype TRegQueryParameter =
  TSubKeyName() or
  TValueName() or
  TReturnData()

/**
 * Registry query call (`source`) with information about parameters (`param`).
 */
private predicate regQuery(FunctionCall source, TRegQueryParameter paramType, Expr param) {
  // LONG WINAPI RegQueryValue(
  //   _In_        HKEY    hKey,
  //   _In_opt_    LPCTSTR lpSubKey,
  //   _Out_opt_   LPTSTR  lpValue,
  //   _Inout_opt_ PLONG   lpcbValue
  // );
  source.getTarget().hasGlobalName(["RegQueryValue", "RegQueryValueA", "RegQueryValueW"]) and
  (
    paramType = TSubKeyName() and param = source.getArgument(1)
    or
    paramType = TReturnData() and param = source.getArgument(2)
  )
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
  paramType = TReturnData() and
  param = source.getArgument(3)
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
  (
    paramType = TValueName() and param = source.getArgument(1)
    or
    paramType = TReturnData() and param = source.getArgument(4)
  )
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
  (
    paramType = TSubKeyName() and param = source.getArgument(1)
    or
    paramType = TValueName() and param = source.getArgument(2)
    or
    paramType = TReturnData() and param = source.getArgument(5)
  )
}

/**
 * Data read from the Windows registry.
 */
class RegQuery extends SystemData {
  RegQuery() { regQuery(this, _, _) }

  override DataFlow::Node getAnExpr() { regQuery(this, TReturnData(), result.asDefiningArgument()) }

  override predicate isSensitive() {
    exists(Expr e |
      (
        regQuery(this, TSubKeyName(), e) or
        regQuery(this, TValueName(), e)
      ) and
      e.getValue().toLowerCase().regexpMatch(".*(pass|token|key).*")
    )
  }
}
