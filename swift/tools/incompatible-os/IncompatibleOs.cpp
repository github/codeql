// Unconditionally emits a diagnostic about running the autobuilder on an incompatible, non-macOS OS
// and exits with an error code.
//
// This is implemented as a C++ binary instead of a hardcoded JSON file so we can leverage existing
// diagnostic machinery for emitting correct timestamps, generating correct file names, etc.

#include "swift/logging/SwiftLogging.h"

const std::string_view codeql::programName = "extractor";
const std::string_view codeql::extractorName = "swift";

constexpr codeql::Diagnostic incompatibleOs{
    .id = "incompatible-os",
    .name = "Incompatible operating system (expected macOS)",
    .action = "[Change the Actions runner][1] to run on macOS.\n\n"
              "[1]: "
              "https://docs.github.com/en/actions/using-workflows/"
              "workflow-syntax-for-github-actions#jobsjob_idruns-on"};

static codeql::Logger& logger() {
  static codeql::Logger ret{"main"};
  return ret;
}

int main() {
  DIAGNOSE_ERROR(incompatibleOs, "Currently, Swift analysis is only supported on macOS.");
  return 1;
}
