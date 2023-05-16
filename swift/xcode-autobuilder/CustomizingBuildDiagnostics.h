#include <string_view>
#include "swift/logging/SwiftDiagnostics.h"

namespace codeql {
constexpr std::string_view customizingBuildAction = "Set up a manual build command.";
constexpr SwiftDiagnostic::HelpLinks customizingBuildHelpLinks{
    "https://docs.github.com/en/enterprise-server/code-security/code-scanning/"
    "automatically-scanning-your-code-for-vulnerabilities-and-errors/customizing-code-scanning "
    "https://docs.github.com/en/enterprise-server/code-security/code-scanning/"
    "automatically-scanning-your-code-for-vulnerabilities-and-errors/"
    "configuring-the-codeql-workflow-for-compiled-languages#adding-build-steps-for-a-compiled-"
    "language"};
}  // namespace codeql
