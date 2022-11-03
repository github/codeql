#include "swift/extractor/invocation/CodeQLDiagnosticsConsumer.h"
#include "swift/extractor/trap/TrapDomain.h"
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

static std::filesystem::path getFilePath(std::string_view path) {
  // TODO: this needs more testing
  // TODO: check canonicalization of names on a case insensitive filesystems
  // TODO: make symlink resolution conditional on CODEQL_PRESERVE_SYMLINKS=true
  std::error_code ec;
  auto ret = std::filesystem::canonical(path, ec);
  if (ec) {
    std::cerr << "Cannot get real path: " << std::quoted(path) << ": " << ec.message() << "\n";
    return {};
  }
  return ret;
}

static void attachLocation(TrapDomain& trap,
                           swift::SourceManager& sourceManager,
                           const swift::DiagnosticInfo& diagInfo,
                           DiagnosticsTrap& locatable) {
  auto loc = diagInfo.Loc;
  if (!loc.isValid()) {
    return;
  }
  auto filepath = getFilePath(sourceManager.getDisplayNameForLoc(loc));
  FilesTrap file;
  file.id = trap.createLabel<FileTag>();
  file.name = filepath;
  trap.emit(file);

  LocationsTrap location;
  location.id = trap.createLabel<LocationTag>();
  location.file = file.id;
  std::tie(location.start_line, location.start_column) =
      sourceManager.getLineAndColumnInBuffer(loc);
  std::tie(location.end_line, location.end_column) = sourceManager.getLineAndColumnInBuffer(loc);
  trap.emit(location);
  trap.emit(LocatableLocationsTrap{locatable.id, location.id});
}

void CodeQLDiagnosticsConsumer::handleDiagnostic(swift::SourceManager& sourceManager,
                                                 const swift::DiagnosticInfo& diagInfo) {
  auto message = getDiagMessage(sourceManager, diagInfo);
  DiagnosticsTrap diag{};
  diag.id = trap.createLabel<DiagnosticsTag>();
  diag.kind = diagnosticsKind(diagInfo);
  diag.text = message;
  trap.emit(diag);
  attachLocation(trap, sourceManager, diagInfo, diag);
}

std::string CodeQLDiagnosticsConsumer::getDiagMessage(swift::SourceManager& sourceManager,
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
