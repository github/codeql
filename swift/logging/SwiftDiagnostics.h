#pragma once

#include "shared/cpp/Diagnostics.h"

namespace codeql {

constexpr Diagnostic internalError{
    .id = "internal-error",
    .name = "Internal error",
    .action =
        "Some or all of the Swift analysis may have failed.\n"
        "\n"
        "If the error persists, contact support, quoting the error message and describing what "
        "happened, or [open an issue in our open source repository][1].\n"
        "\n"
        "[1]: https://github.com/github/codeql/issues/new?labels=bug&template=ql---general.md",
    .severity = Diagnostic::Severity::warning};

}  // namespace codeql
