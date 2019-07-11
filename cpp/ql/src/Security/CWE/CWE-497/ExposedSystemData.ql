/**
 * @name Exposure of system data to an unauthorized control sphere
 * @description Exposing system data or debugging information helps
 *              an adversary learn about the system and form an
 *              attack plan.
 * @kind problem
 * @problem.severity warning
 * @precision medium
 * @id cpp/system-data-exposure
 * @tags security
 *       external/cwe/cwe-497
 */

import cpp
import semmle.code.cpp.commons.Environment
import semmle.code.cpp.security.OutputWrite

/**
 * An element that should not be exposed to an adversary.
 */
abstract class SystemData extends Element {
  /**
   * Gets an expression that is part of this `SystemData`.
   */
  abstract Expr getAnExpr();

  /**
   * Gets an expression whose value originates from, or is used by,
   * this `SystemData`.
   */
  Expr getAnExprIndirect() {
    // direct SystemData
    result = getAnExpr() or
    // flow via global or member variable (conservative approximation)
    result = getAnAffectedVar().getAnAccess() or
    // flow via stack variable
    definitionUsePair(_, getAnExprIndirect(), result) or
    useUsePair(_, getAnExprIndirect(), result) or
    useUsePair(_, result, getAnExprIndirect()) or
    // flow from assigned value to assignment expression
    result.(AssignExpr).getRValue() = getAnExprIndirect()
  }

  /**
   * Gets a global or member variable that may be affected by this system
   * data (conservative approximation).
   */
  private Variable getAnAffectedVar() {
    (
      result.getAnAssignedValue() = this.getAnExprIndirect() or
      result.getAnAccess() = this.getAnExprIndirect()
    ) and
    not result instanceof LocalScopeVariable
  }
}

/**
 * Data originating from the environment.
 */
class EnvData extends SystemData {
  EnvData() { this instanceof EnvironmentRead }

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
  use = source.getAnArgument()
}

/**
 * Data passed into an SQL connect function.
 */
class SQLConnectInfo extends SystemData {
  SQLConnectInfo() { sqlConnectInfo(this, _) }

  override Expr getAnExpr() { sqlConnectInfo(this, result) }
}

private predicate posixSystemInfo(FunctionCall source, Element use) {
  // long sysconf(int name)
  //  - various OS / system values and limits
  source.getTarget().hasName("sysconf") and
  use = source
  or
  // size_t confstr(int name, char *buf, size_t len)
  //  - various OS / system strings, such as the libc version
  // int statvfs(const char *__path, struct statvfs *__buf)
  // int fstatvfs(int __fd, struct statvfs *__buf)
  //  - various filesystem parameters
  // int uname(struct utsname *buf)
  //  - OS name and version
  (
    source.getTarget().hasName("confstr") or
    source.getTarget().hasName("statvfs") or
    source.getTarget().hasName("fstatvfs") or
    source.getTarget().hasName("uname")
  ) and
  use = source.getArgument(1)
}

/**
 * Data obtained from a POSIX system information call.
 */
class PosixSystemInfo extends SystemData {
  PosixSystemInfo() { posixSystemInfo(this, _) }

  override Expr getAnExpr() { posixSystemInfo(this, result) }
}

private predicate posixPWInfo(FunctionCall source, Element use) {
  // struct passwd *getpwnam(const char *name);
  // struct passwd *getpwuid(uid_t uid);
  // struct passwd *getpwent(void);
  // struct group  *getgrnam(const char *name);
  // struct group  *getgrgid(gid_t);
  // struct group  *getgrent(void);
  (
    source.getTarget().hasName("getpwnam") or
    source.getTarget().hasName("getpwuid") or
    source.getTarget().hasName("getpwent") or
    source.getTarget().hasName("getgrnam") or
    source.getTarget().hasName("getgrgid") or
    source.getTarget().hasName("getgrent")
  ) and
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
  (
    source.getTarget().hasName("getpwnam_r") or
    source.getTarget().hasName("getpwuid_r") or
    source.getTarget().hasName("getgrgid_r") or
    source.getTarget().hasName("getgrnam_r")
  ) and
  (
    use = source.getArgument(1) or
    use = source.getArgument(2) or
    use = source.getArgument(4)
  )
  or
  // int getpwent_r(struct passwd *pwd, char *buffer, size_t bufsize,
  //                struct passwd **result);
  // int getgrent_r(struct group *gbuf, char *buf,
  //                size_t buflen, struct group **gbufp);
  (
    source.getTarget().hasName("getpwent_r") or
    source.getTarget().hasName("getgrent_r")
  ) and
  (
    use = source.getArgument(0) or
    use = source.getArgument(1) or
    use = source.getArgument(3)
  )
}

/**
 * Data obtained from a POSIX user/password/group database information call.
 */
class PosixPWInfo extends SystemData {
  PosixPWInfo() { posixPWInfo(this, _) }

  override Expr getAnExpr() { posixPWInfo(this, result) }
}

private predicate windowsSystemInfo(FunctionCall source, Element use) {
  // DWORD WINAPI GetVersion(void);
  source.getTarget().hasGlobalName("GetVersion") and
  use = source
  or
  // BOOL WINAPI GetVersionEx(_Inout_ LPOSVERSIONINFO lpVersionInfo);
  // void WINAPI GetSystemInfo(_Out_ LPSYSTEM_INFO lpSystemInfo);
  // void WINAPI GetNativeSystemInfo(_Out_ LPSYSTEM_INFO lpSystemInfo);
  (
    source.getTarget().hasGlobalName("GetVersionEx") or
    source.getTarget().hasGlobalName("GetVersionExA") or
    source.getTarget().hasGlobalName("GetVersionExW") or
    source.getTarget().hasGlobalName("GetSystemInfo") or
    source.getTarget().hasGlobalName("GetNativeSystemInfo")
  ) and
  use = source.getArgument(0)
}

/**
 * Data obtained from a Windows system information call.
 */
class WindowsSystemInfo extends SystemData {
  WindowsSystemInfo() { windowsSystemInfo(this, _) }

  override Expr getAnExpr() { windowsSystemInfo(this, result) }
}

private predicate windowsFolderPath(FunctionCall source, Element use) {
  // BOOL SHGetSpecialFolderPath(
  //         HWND   hwndOwner,
  //   _Out_ LPTSTR lpszPath,
  //   _In_  int    csidl,
  //   _In_  BOOL   fCreate
  // );
  (
    source.getTarget().hasGlobalName("SHGetSpecialFolderPath") or
    source.getTarget().hasGlobalName("SHGetSpecialFolderPathA") or
    source.getTarget().hasGlobalName("SHGetSpecialFolderPathW")
  ) and
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
  (
    source.getTarget().hasGlobalName("SHGetFolderPath") or
    source.getTarget().hasGlobalName("SHGetFolderPathA") or
    source.getTarget().hasGlobalName("SHGetFolderPathW")
  ) and
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
  (
    source.getTarget().hasGlobalName("SHGetFolderPathAndSubDir") or
    source.getTarget().hasGlobalName("SHGetFolderPathAndSubDirA") or
    source.getTarget().hasGlobalName("SHGetFolderPathAndSubDirW")
  ) and
  use = source.getArgument(5)
}

/**
 * Data obtained about Windows special paths (for example, the
 * location of `System32`).
 */
class WindowsFolderPath extends SystemData {
  WindowsFolderPath() { windowsFolderPath(this, _) }

  override Expr getAnExpr() { windowsFolderPath(this, result) }
}

private predicate logonUser(FunctionCall source, VariableAccess use) {
  (
    source.getTarget().hasGlobalName("LogonUser") or
    source.getTarget().hasGlobalName("LogonUserW") or
    source.getTarget().hasGlobalName("LogonUserA")
  ) and
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
  (
    source.getTarget().hasGlobalName("RegQueryValue") or
    source.getTarget().hasGlobalName("RegQueryValueA") or
    source.getTarget().hasGlobalName("RegQueryValueW")
  ) and
  use = source.getArgument(2)
  or
  // LONG WINAPI RegQueryMultipleValues(
  //   _In_        HKEY    hKey,
  //   _Out_       PVALENT val_list,
  //   _In_        DWORD   num_vals,
  //   _Out_opt_   LPTSTR  lpValueBuf,
  //   _Inout_opt_ LPDWORD ldwTotsize
  // );
  (
    source.getTarget().hasGlobalName("RegQueryMultipleValues") or
    source.getTarget().hasGlobalName("RegQueryMultipleValuesA") or
    source.getTarget().hasGlobalName("RegQueryMultipleValuesW")
  ) and
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
  (
    source.getTarget().hasGlobalName("RegQueryValueEx") or
    source.getTarget().hasGlobalName("RegQueryValueExA") or
    source.getTarget().hasGlobalName("RegQueryValueExW")
  ) and
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
  (
    source.getTarget().hasGlobalName("RegGetValue") or
    source.getTarget().hasGlobalName("RegGetValueA") or
    source.getTarget().hasGlobalName("RegGetValueW")
  ) and
  use = source.getArgument(5)
}

/**
 * Data read from the Windows registry.
 */
class RegQuery extends SystemData {
  RegQuery() { regQuery(this, _) }

  override Expr getAnExpr() { regQuery(this, result) }
}

/**
 * Somewhere data is output.
 */
abstract class DataOutput extends Element {
  /**
   * Get an expression containing data that is output.
   */
  abstract Expr getASource();
}

/**
 * Data that is output via standard output or standard error.
 */
class StandardOutput extends DataOutput {
  StandardOutput() { this instanceof OutputWrite }

  override Expr getASource() { result = this.(OutputWrite).getASource() }
}

private predicate socketCallOrIndirect(FunctionCall call) {
  // direct socket call
  // int socket(int domain, int type, int protocol);
  call.getTarget().getName() = "socket"
  or
  exists(ReturnStmt rtn |
    // indirect socket call
    call.getTarget() = rtn.getEnclosingFunction() and
    (
      socketCallOrIndirect(rtn.getExpr()) or
      socketCallOrIndirect(rtn.getExpr().(VariableAccess).getTarget().getAnAssignedValue())
    )
  )
}

private predicate socketFileDescriptor(Expr e) {
  exists(Variable var, FunctionCall socket |
    socketCallOrIndirect(socket) and
    var.getAnAssignedValue() = socket and
    e = var.getAnAccess()
  )
}

private predicate socketOutput(FunctionCall call, Expr data) {
  (
    // ssize_t send(int sockfd, const void *buf, size_t len, int flags);
    // ssize_t sendto(int sockfd, const void *buf, size_t len, int flags,
    //                const struct sockaddr *dest_addr, socklen_t addrlen);
    // ssize_t sendmsg(int sockfd, const struct msghdr *msg, int flags);
    // int write(int handle, void *buffer, int nbyte);
    (
      call.getTarget().hasGlobalName("send") or
      call.getTarget().hasGlobalName("sendto") or
      call.getTarget().hasGlobalName("sendmsg") or
      call.getTarget().hasGlobalName("write")
    ) and
    data = call.getArgument(1) and
    socketFileDescriptor(call.getArgument(0))
  )
}

/**
 * Data that is output via a socket.
 */
class SocketOutput extends DataOutput {
  SocketOutput() { socketOutput(this, _) }

  override Expr getASource() { socketOutput(this, result) }
}

from SystemData sd, DataOutput ow
where
  sd.getAnExprIndirect() = ow.getASource() or
  sd.getAnExprIndirect() = ow.getASource().(Expr).getAChild*()
select ow, "This operation exposes system data from $@.", sd, sd.toString()
