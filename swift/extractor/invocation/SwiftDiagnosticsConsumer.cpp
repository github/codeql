#include "swift/extractor/invocation/SwiftDiagnosticsConsumer.h"
#include "swift/extractor/trap/generated/TrapClasses.h"
#include "swift/extractor/trap/TrapDomain.h"
#include "swift/extractor/infra/SwiftDiagnosticKind.h"

#include <swift/AST/DiagnosticEngine.h>
#include <swift/Basic/SourceManager.h>
#include <llvm/ADT/SmallString.h>
#include <llvm/Support/raw_ostream.h>
#include <string>

using namespace codeql;

namespace {
struct DisplayLoc {
  llvm::StringRef file;
  unsigned line;
  unsigned column;

  static DisplayLoc from(swift::SourceManager& sourceManager, swift::SourceLoc loc) {
    if (loc.isInvalid()) {
      return {"<invalid loc>", 0, 0};
    }
    auto file = sourceManager.getDisplayNameForLoc(loc);
    auto [line, column] = sourceManager.getLineAndColumnInBuffer(loc);
    return {file, line, column};
  }
};

}  // namespace

void SwiftDiagnosticsConsumer::handleDiagnostic(swift::SourceManager& sourceManager,
                                                const swift::DiagnosticInfo& diagInfo) {
  if (diagInfo.IsChildNote) return;
  Diagnostics diag{trap.createTypedLabel<DiagnosticsTag>()};
  diag.kind = translateDiagnosticsKind(diagInfo.Kind);
  diag.text = getDiagMessage(sourceManager, diagInfo);
  trap.emit(diag);
  locationExtractor.attachLocation(sourceManager, diagInfo, diag.id);

  forwardToLog(sourceManager, diagInfo, diag.text);
  for (const auto& child : diagInfo.ChildDiagnosticInfo) {
    forwardToLog(sourceManager, *child);
  }
}

std::string SwiftDiagnosticsConsumer::getDiagMessage(swift::SourceManager& sourceManager,
                                                     const swift::DiagnosticInfo& diagInfo) {
  llvm::SmallString<256> text;
  llvm::raw_svector_ostream out(text);
  swift::DiagnosticEngine::formatDiagnosticText(out, diagInfo.FormatString, diagInfo.FormatArgs);
  return text.str().str();
}

void SwiftDiagnosticsConsumer::forwardToLog(swift::SourceManager& sourceManager,
                                            const swift::DiagnosticInfo& diagInfo,
                                            const std::string& message) {
  auto [file, line, column] = DisplayLoc::from(sourceManager, diagInfo.Loc);
  using Kind = swift::DiagnosticKind;
  switch (diagInfo.Kind) {
    case Kind::Error:
      LOG_ERROR("{}:{}:{} {}", file, line, column, message);
      break;
    case Kind::Warning:
      LOG_WARNING("{}:{}:{} {}", file, line, column, message);
      break;
    case Kind::Remark:
      LOG_INFO("{}:{}:{} {}", file, line, column, message);
      break;
    case Kind::Note:
      LOG_DEBUG("{}:{}:{} {}", file, line, column, message);
      break;
    default:
      LOG_ERROR("unknown diagnostic kind {}, {}:{}:{} {}", diagInfo.Kind, file, line, column,
                message);
      break;
  }
}
