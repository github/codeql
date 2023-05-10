#include <string_view>

namespace codeql_diagnostics {
constexpr std::string_view customizingBuildAction = "Set up a manual build command";
constexpr std::string_view customizingBuildHelpLinks =
    "https://docs.github.com/en/enterprise-server/code-security/code-scanning/"
    "automatically-scanning-your-code-for-vulnerabilities-and-errors/customizing-code-scanning "
    "https://docs.github.com/en/enterprise-server/code-security/code-scanning/"
    "automatically-scanning-your-code-for-vulnerabilities-and-errors/"
    "configuring-the-codeql-workflow-for-compiled-languages#adding-build-steps-for-a-compiled-"
    "language";
}  // namespace codeql_diagnostics
