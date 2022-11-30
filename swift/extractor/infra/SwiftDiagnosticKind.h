#pragma once

#include <swift/AST/DiagnosticConsumer.h>

namespace codeql {

inline int translateDiagnosticsKind(swift::DiagnosticKind kind) {
  using Kind = swift::DiagnosticKind;
  switch (kind) {
    case Kind::Error:
      return 1;
    case Kind::Warning:
      return 2;
    case Kind::Note:
      return 3;
    case Kind::Remark:
      return 4;
    default:
      return 0;
  }
}

}  // namespace codeql
