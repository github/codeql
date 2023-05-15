// Unconditionally emits a diagnostic about running the autobuilder on an incompatible, non-macOS OS
// and exits with an error code.
//
// This is implemented as a C++ binary instead of a hardcoded JSON file so we can leverage existing
// diagnostic machinery for emitting correct timestamps, generating correct file names, etc.

#include "swift/logging/SwiftLogging.h"

const std::string_view codeql::programName = "autobuilder";

namespace codeql_diagnostics {
constexpr codeql::SwiftDiagnosticsSource incompatible_os{
    "incompatible_os", "Incompatible operating system for autobuild (expected macOS)",
    "Change the action runner to a macOS one. Analysis on Linux might work, but requires setting "
    "up a custom build command",
    "https://docs.github.com/en/actions/using-workflows/"
    "workflow-syntax-for-github-actions#jobsjob_idruns-on "
    "https://docs.github.com/en/enterprise-server/code-security/code-scanning/"
    "automatically-scanning-your-code-for-vulnerabilities-and-errors/customizing-code-scanning "
    "https://docs.github.com/en/enterprise-server/code-security/code-scanning/"
    "automatically-scanning-your-code-for-vulnerabilities-and-errors/"
    "configuring-the-codeql-workflow-for-compiled-languages#adding-build-steps-for-a-compiled-"
    "language"};
}  // namespace codeql_diagnostics

static codeql::Logger& logger() {
  static codeql::Logger ret{"main"};
  return ret;
}

int main() {
  DIAGNOSE_ERROR(incompatible_os,
                 "CodeQL Swift analysis is currently only officially supported on macOS");
  return 1;
}
