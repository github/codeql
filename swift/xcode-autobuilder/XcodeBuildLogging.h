#pragma once

#include "swift/logging/SwiftLogging.h"

namespace codeql_diagnostics {
constexpr codeql::SwiftDiagnosticsSource build_command_failed{
    "build_command_failed",
    "Detected build command failed",
    "Set up a manual build command",
    "https://docs.github.com/en/enterprise-server/code-security/code-scanning/"
    "automatically-scanning-your-code-for-vulnerabilities-and-errors/customizing-code-scanning",
};
}  // namespace codeql_diagnostics
