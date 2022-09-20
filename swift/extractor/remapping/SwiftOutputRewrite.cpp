#include "swift/extractor/remapping/SwiftOutputRewrite.h"

#include <llvm/ADT/SmallString.h>
#include <llvm/Support/FileSystem.h>
#include <llvm/Support/Path.h>
#include <swift/Basic/OutputFileMap.h>
#include <swift/Basic/Platform.h>
#include <unistd.h>
#include <unordered_set>
#include <optional>
#include <iostream>

// Creates a copy of the output file map and updates remapping table in place
// It does not change the original map file as it is depended upon by the original compiler
// Returns path to the newly created output file map on success, or None in a case of failure
static std::optional<std::string> rewriteOutputFileMap(
    const std::string& scratchDir,
    const std::string& outputFileMapPath,
    const std::vector<std::string>& inputs,
    std::unordered_map<std::string, std::string>& remapping) {
  auto newMapPath = scratchDir + '/' + outputFileMapPath;

  // TODO: do not assume absolute path for the second parameter
  auto outputMapOrError = swift::OutputFileMap::loadFromPath(outputFileMapPath, "");
  if (!outputMapOrError) {
    std::cerr << "Cannot load output map: '" << outputFileMapPath << "'\n";
    return std::nullopt;
  }
  auto oldOutputMap = outputMapOrError.get();
  swift::OutputFileMap newOutputMap;
  std::vector<llvm::StringRef> keys;
  for (auto& key : inputs) {
    auto oldMap = oldOutputMap.getOutputMapForInput(key);
    if (!oldMap) {
      continue;
    }
    keys.push_back(key);
    auto& newMap = newOutputMap.getOrCreateOutputMapForInput(key);
    newMap.copyFrom(*oldMap);
    for (auto& entry : newMap) {
      auto oldPath = entry.getSecond();
      auto newPath = scratchDir + '/' + oldPath;
      entry.getSecond() = newPath;
      remapping[oldPath] = newPath;
    }
  }
  std::error_code ec;
  llvm::SmallString<PATH_MAX> filepath(newMapPath);
  llvm::StringRef parent = llvm::sys::path::parent_path(filepath);
  if (std::error_code ec = llvm::sys::fs::create_directories(parent)) {
    std::cerr << "Cannot create relocated output map dir: '" << parent.str()
              << "': " << ec.message() << "\n";
    return std::nullopt;
  }

  llvm::raw_fd_ostream fd(newMapPath, ec, llvm::sys::fs::OF_None);
  newOutputMap.write(fd, keys);
  return newMapPath;
}

namespace codeql {

std::unordered_map<std::string, std::string> rewriteOutputsInPlace(
    const std::string& scratchDir,
    std::vector<std::string>& CLIArgs) {
  std::unordered_map<std::string, std::string> remapping;

  // TODO: handle filelists?
  const std::unordered_set<std::string> pathRewriteOptions({
      "-emit-dependencies-path",
      "-emit-module-path",
      "-emit-module-doc-path",
      "-emit-module-source-info-path",
      "-emit-objc-header-path",
      "-emit-reference-dependencies-path",
      "-index-store-path",
      "-module-cache-path",
      "-o",
      "-pch-output-dir",
      "-serialize-diagnostics-path",
  });

  std::unordered_set<std::string> outputFileMaps(
      {"-supplementary-output-file-map", "-output-file-map"});

  std::vector<size_t> outputFileMapIndexes;
  std::vector<std::string> maybeInput;
  std::string targetTriple;

  std::vector<std::string> newLocations;
  for (size_t i = 0; i < CLIArgs.size(); i++) {
    if (pathRewriteOptions.count(CLIArgs[i])) {
      auto oldPath = CLIArgs[i + 1];
      auto newPath = scratchDir + '/' + oldPath;
      CLIArgs[++i] = newPath;
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
      auto newPath = maybeNewPath.value();
      CLIArgs[index] = newPath;
      remapping[oldPath] = newPath;
    }
  }

  return remapping;
}

void ensureDirectoriesForNewPathsExist(
    const std::unordered_map<std::string, std::string>& remapping) {
  for (auto& [_, newPath] : remapping) {
    llvm::SmallString<PATH_MAX> filepath(newPath);
    llvm::StringRef parent = llvm::sys::path::parent_path(filepath);
    if (std::error_code ec = llvm::sys::fs::create_directories(parent)) {
      std::cerr << "Cannot create redirected directory: " << ec.message() << "\n";
    }
  }
}

}  // namespace codeql
