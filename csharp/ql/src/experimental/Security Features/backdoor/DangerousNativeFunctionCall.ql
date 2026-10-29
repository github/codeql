/**
 * @name Potential dangerous use of native functions
 * @description Detects the use of native functions that can be used for malicious intent or unsafe handling.
 * @kind problem
 * @problem.severity warning
 * @precision low
 * @id cs/backdoor/dangerous-native-functions
 * @tags security
 *       experimental
 *       solorigate
 */

import csharp
import semmle.code.csharp.frameworks.system.runtime.InteropServices

predicate isDangerousMethod(Method m) {
  m.getName() = "OpenProcessToken" or
  m.getName() = "OpenThreadToken" or
  m.getName() = "DuplicateToken" or
  m.getName() = "DuplicateTokenEx" or
  m.getName().matches("LogonUser%") or
  m.getName().matches("WNetAddConnection%") or
  m.getName() = "DeviceIoControl" or
  m.getName().matches("LoadLibrary%") or
  m.getName() = "GetProcAddress" or
  m.getName().matches("CreateProcess%") or
  m.getName().matches("InitiateSystemShutdown%") or
  m.getName() = "GetCurrentProcess" or
  m.getName() = "GetCurrentProcessToken" or
  m.getName() = "GetCurrentThreadToken" or
  m.getName() = "GetCurrentThreadEffectiveToken" or
  m.getName() = "OpenThreadToken" or
  m.getName() = "SetTokenInformation" or
  m.getName().matches("LookupPrivilegeValue%") or
  m.getName() = "AdjustTokenPrivileges" or
  m.getName() = "SetProcessPrivilege" or
  m.getName() = "ImpersonateLoggedOnUser" or
  m.getName().matches("Add%Ace%")
}

predicate isExternMethod(Method externMethod) {
  externMethod.isExtern()
  or
  externMethod.getAnAttribute().getType() instanceof
    SystemRuntimeInteropServicesDllImportAttributeClass
  or
  externMethod.getDeclaringType().getAnAttribute().getType() instanceof
    SystemRuntimeInteropServicesComImportAttributeClass
}

deprecated query predicate problems(MethodCall mc, string message) {
  isExternMethod(mc.getTarget()) and
  isDangerousMethod(mc.getTarget()) and
  message = "Call to an external method '" + mc.getTarget().getName() + "'."
}
