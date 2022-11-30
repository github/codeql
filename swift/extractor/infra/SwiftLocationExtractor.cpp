#include <swift/AST/SourceFile.h>
#include <swift/Basic/SourceManager.h>

#include "swift/extractor/trap/TrapDomain.h"
#include "swift/extractor/trap/generated/TrapEntries.h"
#include "swift/extractor/trap/generated/TrapClasses.h"
#include "swift/extractor/infra/SwiftLocationExtractor.h"

using namespace codeql;

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

void SwiftLocationExtractor::attachLocation(const swift::SourceManager& sourceManager,
                                            swift::SourceLoc start,
                                            swift::SourceLoc end,
                                            TrapLabel<LocatableTag> locatableLabel) {
  if (!start.isValid() || !end.isValid()) {
    // invalid locations seem to come from entities synthesized by the compiler
    return;
  }
  auto file = getFilePath(sourceManager.getDisplayNameForLoc(start));
  DbLocation entry{{}};
  entry.file = fetchFileLabel(file);
  std::tie(entry.start_line, entry.start_column) = sourceManager.getLineAndColumnInBuffer(start);
  std::tie(entry.end_line, entry.end_column) = sourceManager.getLineAndColumnInBuffer(end);
  entry.id = trap.createLabel<DbLocationTag>('{', entry.file, "}:", entry.start_line, ':',
                                             entry.start_column, ':', entry.end_line, ':',
                                             entry.end_column);
  trap.emit(entry);
  trap.emit(LocatableLocationsTrap{locatableLabel, entry.id});
}

void SwiftLocationExtractor::emitFile(llvm::StringRef path) {
  fetchFileLabel(getFilePath(path));
}

TrapLabel<FileTag> SwiftLocationExtractor::fetchFileLabel(const std::filesystem::path& file) {
  if (store.count(file)) {
    return store[file];
  }

  DbFile entry({});
  entry.id = trap.createLabel<DbFileTag>(file.string());
  entry.name = file.string();
  trap.emit(entry);
  store[file] = entry.id;
  return entry.id;
}
