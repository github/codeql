#include <swift/AST/Expr.h>
#include <swift/AST/SourceFile.h>
#include <swift/Basic/SourceManager.h>
#include <swift/Parse/Token.h>

#include "swift/extractor/trap/TrapDomain.h"
#include "swift/extractor/trap/generated/TrapEntries.h"
#include "swift/extractor/trap/generated/TrapClasses.h"
#include "swift/extractor/infra/SwiftLocationExtractor.h"
#include "swift/extractor/infra/file/Path.h"
#include "swift/extractor/infra/SwiftMangledName.h"

using namespace codeql;

swift::SourceRange detail::getSourceRange(const swift::Token& token) {
  const auto charRange = token.getRange();
  return {charRange.getStart(), charRange.getEnd()};
}

void SwiftLocationExtractor::attachLocationImpl(const swift::SourceManager& sourceManager,
                                                const swift::SourceRange& range,
                                                TrapLabel<LocatableTag> locatableLabel) {
  if (!range) {
    // invalid locations seem to come from entities synthesized by the compiler
    return;
  }
  auto file = resolvePath(sourceManager.getDisplayNameForLoc(range.Start));
  DbLocation entry{{}};
  entry.file = fetchFileLabel(file);
  std::tie(entry.start_line, entry.start_column) =
      sourceManager.getLineAndColumnInBuffer(range.Start);
  std::tie(entry.end_line, entry.end_column) = sourceManager.getLineAndColumnInBuffer(range.End);
  SwiftMangledName locName{"loc", entry.file,     ':', entry.start_line, ':', entry.start_column,
                           ':',   entry.end_line, ':', entry.end_column};
  entry.id = trap.createTypedLabel<DbLocationTag>(locName);
  trap.emit(entry);
  trap.emit(LocatableLocationsTrap{locatableLabel, entry.id});
}

TrapLabel<FileTag> SwiftLocationExtractor::emitFile(swift::SourceFile* file) {
  if (file) {
    return emitFile(std::string_view{file->getFilename()});
  }
  return undefined_label;
}

TrapLabel<FileTag> SwiftLocationExtractor::emitFile(const std::filesystem::path& file) {
  return fetchFileLabel(resolvePath(file));
}

TrapLabel<FileTag> SwiftLocationExtractor::fetchFileLabel(const std::filesystem::path& file) {
  if (store.count(file)) {
    return store[file];
  }

  DbFile entry({});
  entry.id = trap.createTypedLabel<DbFileTag>({"file_", file.string()});
  entry.name = file.string();
  trap.emit(entry);
  store[file] = entry.id;
  return entry.id;
}
