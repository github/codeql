#include "swift/extractor/remapping/SwiftOutputRewrite.h"

#include <llvm/ADT/SmallString.h>
#include <swift/Basic/OutputFileMap.h>
#include <swift/Basic/Platform.h>
#include <unistd.h>
#include <unordered_set>
#include <optional>
#include <iostream>

#include "swift/extractor/infra/file/PathHash.h"

namespace fs = std::filesystem;

namespace codeql {

// Creates a copy of the output file map and updates remapping table in place
// It does not change the original map file as it is depended upon by the original compiler
// Returns path to the newly created output file map on success, or None in a case of failure
static std::optional<fs::path> rewriteOutputFileMap(const fs::path& scratchDir,
                                                    const fs::path& outputFileMapPath,
                                                    const std::vector<fs::path>& inputs,
                                                    PathRemapping& remapping) {
  auto newMapPath = scratchDir / outputFileMapPath.relative_path();

  // TODO: do not assume absolute path for the second parameter
  auto outputMapOrError = swift::OutputFileMap::loadFromPath(outputFileMapPath.c_str(), "");
  if (!outputMapOrError) {
    std::cerr << "Cannot load output map " << outputFileMapPath << "\n";
    return std::nullopt;
  }
  auto oldOutputMap = outputMapOrError.get();
  swift::OutputFileMap newOutputMap;
  std::vector<llvm::StringRef> keys;
  for (auto& key : inputs) {
    auto oldMap = oldOutputMap.getOutputMapForInput(key.c_str());
    if (!oldMap) {
      continue;
    }
    keys.push_back(key.c_str());
    auto& newMap = newOutputMap.getOrCreateOutputMapForInput(key.c_str());
    newMap.copyFrom(*oldMap);
    for (auto& entry : newMap) {
      fs::path oldPath = entry.getSecond();
      auto newPath = scratchDir / oldPath.relative_path();
      entry.getSecond() = newPath;
      remapping[oldPath] = newPath;
    }
  }
  std::error_code ec;
  fs::create_directories(newMapPath.parent_path(), ec);
  if (ec) {
    std::cerr << "Cannot create relocated output map dir " << newMapPath.parent_path() << ": "
              << ec.message() << "\n";
    return std::nullopt;
  }

  llvm::raw_fd_ostream fd(newMapPath.c_str(), ec, llvm::sys::fs::OF_None);
  newOutputMap.write(fd, keys);
  return newMapPath;
}

PathRemapping rewriteOutputsInPlace(const fs::path& scratchDir, std::vector<std::string>& CLIArgs) {
  PathRemapping remapping;

  // TODO: handle filelists?
  const std::unordered_set<std::string> pathRewriteOptions({
      "-emit-abi-descriptor-path",
      "-emit-dependencies-path",
      "-emit-module-path",
      "-emit-module-doc-path",
      "-emit-module-source-info-path",
      "-emit-objc-header-path",
      "-emit-reference-dependencies-path",
      "-index-store-path",
      "-index-unit-output-path",
      "-module-cache-path",
      "-o",
      "-pch-output-dir",
      "-serialize-diagnostics-path",
  });

  std::unordered_set<std::string> outputFileMaps(
      {"-supplementary-output-file-map", "-output-file-map"});

  std::vector<size_t> outputFileMapIndexes;
  std::vector<fs::path> maybeInput;
  std::string targetTriple;

  std::vector<fs::path> newLocations;
  for (size_t i = 0; i < CLIArgs.size(); i++) {
    if (pathRewriteOptions.count(CLIArgs[i])) {
      fs::path oldPath = CLIArgs[i + 1];
      auto newPath = scratchDir / oldPath.relative_path();
      CLIArgs[++i] = newPath.string();
      newLocations.push_back(newPath);

      remapping[oldPath] = newPath;
    } else if (outputFileMaps.count(CLIArgs[i])) {
      // collect output map indexes for further rewriting and skip the following argument
      // We don't patch the map in place as we need to collect all the input files first
      outputFileMapIndexes.push_back(++i);
    } else if (CLIArgs[i] == "-target") {
      targetTriple = CLIArgs[++i];
    } else if (CLIArgs[i][0] != '-') {
      // TODO: add support for input file lists?
      // We need to collect input file names to later use them to extract information from the
      // output file maps.
      maybeInput.push_back(CLIArgs[i]);
    }
  }

  for (auto index : outputFileMapIndexes) {
    auto oldPath = CLIArgs[index];
    auto maybeNewPath = rewriteOutputFileMap(scratchDir, oldPath, maybeInput, remapping);
    if (maybeNewPath) {
      const auto& newPath = maybeNewPath.value();
      CLIArgs[index] = newPath;
      remapping[oldPath] = newPath;
    }
  }

  return remapping;
}

void ensureDirectoriesForNewPathsExist(const PathRemapping& remapping) {
  for (auto& [_, newPath] : remapping) {
    std::error_code ec;
    fs::create_directories(newPath.parent_path(), ec);
    if (ec) {
      std::cerr << "Cannot create redirected directory " << newPath.parent_path() << ": "
                << ec.message() << "\n";
    }
  }
}

}  // namespace codeql
