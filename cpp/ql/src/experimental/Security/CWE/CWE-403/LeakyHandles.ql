/**
 * @name Memory leak on failed call to realloc
 * @description An unprivileged child process may gain access to restricted resources by inheriting sensitive handles 
 *              from a privileged parent process.
 * @kind problem
 * @id cpp/windows-handle-leak
 * @problem.severity error
 * @precision low
 * @tags security
 *       experimental
 *       external/cwe/cwe-403
 */

import cpp

// Base class to identify function calls with required permissions
abstract class HandleOpeningCall extends FunctionCall {
  // Method to check if the permissions argument has at least one of the specified permissions
  predicate hasRequiredPermissions() { 1 != 1 }
}

// Class to identify OpenProcess calls
class OpenProcessCall extends HandleOpeningCall {
  OpenProcessCall() { this.getTarget().hasName("OpenProcess") }

  override predicate hasRequiredPermissions() {
    exists(Expr permArg |
      this.getArgument(0) = permArg and
      (
        permArg.getValueText().indexOf("PROCESS_ALL_ACCESS") >= 0 or
        permArg.getValueText().indexOf("PROCESS_CREATE_PROCESS") >= 0 or
        permArg.getValueText().indexOf("PROCESS_CREATE_THREAD") >= 0 or
        permArg.getValueText().indexOf("PROCESS_DUP_HANDLE") >= 0 or
        permArg.getValueText().indexOf("PROCESS_VM_WRITE") >= 0
      )
    )
  }
}

// Class to identify OpenThread calls
class OpenThreadCall extends HandleOpeningCall {
  OpenThreadCall() { this.getTarget().hasName("OpenThread") }

  override predicate hasRequiredPermissions() {
    exists(Expr permArg |
      this.getArgument(0) = permArg and
      (
        permArg.getValueText().indexOf("THREAD_ALL_ACCESS") >= 0 or
        permArg.getValueText().indexOf("THREAD_DIRECT_IMPERSONATION") >= 0 or
        permArg.getValueText().indexOf("THREAD_SET_CONTEXT") >= 0
      )
    )
  }
}

// Class to identify CreateFile calls
class CreateFileCall extends HandleOpeningCall {
  CreateFileCall() {
    this.getTarget().hasName("CreateFile") or
    this.getTarget().hasName("CreateFileA") or
    this.getTarget().hasName("CreateFileW")
  }

  override predicate hasRequiredPermissions() {
    exists(Expr permArg |
      this.getArgument(0) = permArg and
      (
        permArg.getValueText().indexOf("GENERIC_WRITE") >= 0 or
        permArg.getValueText().indexOf("FILE_GENERIC_WRITE") >= 0 or
        permArg.getValueText().indexOf("WRITE_OWNER") >= 0 or
        permArg.getValueText().indexOf("WRITE_DAC") >= 0
      )
    )
  }
}

// Class to identify CreateProcessAsUser calls
class CreateProcessAsUserCall extends FunctionCall {
  CreateProcessAsUserCall() {
    this.getTarget().hasName("CreateProcessAsUser") or
    this.getTarget().hasName("CreateProcessAsUserA") or
    this.getTarget().hasName("CreateProcessAsUserW")
  }

  // Method to check if the sixth argument is TRUE
  predicate isHandleInheritanceEnabled() {
    exists(Expr arg6 | this.getArgument(5) = arg6 and arg6.getValueText().toUpperCase() = "TRUE")
  }
}

// Class to identify CloseHandle calls
class CloseHandleCall extends FunctionCall {
  CloseHandleCall() { this.getTarget().hasName("CloseHandle") }
}

// Function to find if CreateProcessAsUser is preceded by a handle opening call within the same function
// and ensure CloseHandle is not called on the handle before CreateProcessAsUser
predicate hasPrecedingHandleOpeningWithoutClose(
  CreateProcessAsUserCall createProcessAsUserCall, HandleOpeningCall handleOpeningCall
) {
  createProcessAsUserCall.isHandleInheritanceEnabled() and
  createProcessAsUserCall.getEnclosingFunction() = handleOpeningCall.getEnclosingFunction() and
  handleOpeningCall.getLocation().getStartLine() <
    createProcessAsUserCall.getLocation().getStartLine() and
  handleOpeningCall.hasRequiredPermissions() and
  not exists(CloseHandleCall closeHandleCall |
    closeHandleCall.getEnclosingFunction() = handleOpeningCall.getEnclosingFunction() and
    closeHandleCall.getArgument(0) = handleOpeningCall.getAnArgument() and
    closeHandleCall.getLocation().getStartLine() <
      createProcessAsUserCall.getLocation().getStartLine()
  )
}

from CreateProcessAsUserCall createProcessCall, HandleOpeningCall handleOpeningCall
where hasPrecedingHandleOpeningWithoutClose(createProcessCall, handleOpeningCall)
select createProcessCall, handleOpeningCall,
  "The " + handleOpeningCall.getTarget().getName() +
    " may leak a privileged handle to a child process through the " +
    createProcessCall.getTarget().getName() + "."
