#include "swift/extractor/invocation/SwiftDiagnosticsConsumer.h"
#include "swift/extractor/trap/generated/TrapEntries.h"

#include <swift/AST/DiagnosticEngine.h>
#include <swift/Basic/SourceManager.h>
#include <llvm/ADT/SmallString.h>
#include <llvm/Support/raw_ostream.h>
#include <string>

using namespace codeql;

static int diagnosticsKind(const swift::DiagnosticInfo& diagInfo) {
  switch (diagInfo.Kind) {
    case swift::DiagnosticKind::Error:
      return 1;
    case swift::DiagnosticKind::Warning:
      return 2;

    case swift::DiagnosticKind::Note:
      return 3;

    case swift::DiagnosticKind::Remark:
      return 4;
  }
  return 0;
}

void SwiftDiagnosticsConsumer::handleDiagnostic(swift::SourceManager& sourceManager,
                                                const swift::DiagnosticInfo& diagInfo) {
  auto message = getDiagMessage(sourceManager, diagInfo);
  DiagnosticsTrap diag{};
  diag.id = trap.createLabel<DiagnosticsTag>();
  diag.kind = diagnosticsKind(diagInfo);
  diag.text = message;
  trap.emit(diag);
  locationExtractor.attachLocation(sourceManager, diagInfo.Loc, diagInfo.Loc, diag.id);
}

std::string SwiftDiagnosticsConsumer::getDiagMessage(swift::SourceManager& sourceManager,
                                                     const swift::DiagnosticInfo& diagInfo) {
  // Translate ranges.
  llvm::SmallVector<llvm::SMRange, 2> ranges;
  for (auto R : diagInfo.Ranges)
    ranges.push_back(getRawRange(sourceManager, R));

  // Translate fix-its.
  llvm::SmallVector<llvm::SMFixIt, 2> fixIts;
  for (const swift::DiagnosticInfo::FixIt& F : diagInfo.FixIts)
    fixIts.push_back(getRawFixIt(sourceManager, F));

  // Actually substitute the diagnostic arguments into the diagnostic text.
  llvm::SmallString<256> Text;
  {
    llvm::raw_svector_ostream Out(Text);
    swift::DiagnosticEngine::formatDiagnosticText(Out, diagInfo.FormatString, diagInfo.FormatArgs);
  }

  return Text.str().str();
}
