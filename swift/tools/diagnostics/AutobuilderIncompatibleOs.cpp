// Unconditionally emits a diagnostic about running the autobuilder on an incompatible, non-macOS OS
// and exits with an error code.
//
// This is implemented as a C++ binary instead of a hardcoded JSON file so we can leverage existing
// diagnostic machinery for emitting correct timestamps, generating correct file names, etc.

#include "swift/logging/SwiftLogging.h"

const std::string_view codeql::programName = "autobuilder";

constexpr codeql::SwiftDiagnostic incompatibleOs{
    .id = "incompatible-os",
    .name = "Incompatible operating system (expected macOS)",
    .action =
        "[Change the Actions runner][1] to run on macOS.\n"
        "\n"
        "You may be able to run analysis on Linux by setting up a [manual build command][2].\n"
        "\n"
        "[1]: "
        "https://docs.github.com/en/actions/using-workflows/"
        "workflow-syntax-for-github-actions#jobsjob_idruns-on\n"
        "[2]: "
        "https://docs.github.com/en/enterprise-server/code-security/code-scanning/"
        "automatically-scanning-your-code-for-vulnerabilities-and-errors/"
        "configuring-the-codeql-workflow-for-compiled-languages#adding-build-steps-for-a-compiled-"
        "language",
};

static codeql::Logger& logger() {
  static codeql::Logger ret{"main"};
  return ret;
}

int main() {
  DIAGNOSE_ERROR(incompatibleOs,
                 "Currently, `autobuild` for Swift analysis is only supported on macOS.");
  return 1;
}
