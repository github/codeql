#include "SwiftOutputRewrite.h"
#include "swift/extractor/SwiftExtractorConfiguration.h"
#include "swift/extractor/TargetTrapFile.h"

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
    const codeql::SwiftExtractorConfiguration& config,
    const std::string& outputFileMapPath,
    const std::vector<std::string>& inputs,
    std::unordered_map<std::string, std::string>& remapping) {
  auto newMapPath = config.getTempArtifactDir() + '/' + outputFileMapPath;

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
      auto newPath = config.getTempArtifactDir() + '/' + oldPath;
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

// This is an Xcode-specific workaround to produce alias names for an existing .swiftmodule file.
// In the case of Xcode, it calls the Swift compiler and asks it to produce a Swift module.
// Once it's done, Xcode moves the .swiftmodule file in another location, and the location is
// rather arbitrary. Here are examples of such locations:
// Original file produced by the frontend:
//  DerivedData/<Project>/Build/Intermediates.noindex/<Project>.build/<BuiltType>-<Target>/<Project>.build/Objects-normal/<Arch>/<ModuleName>.swiftmodule
// where:
//  Project: name of a project, target, or scheme
//  BuildType: Debug, Release, etc.
//  Target: macOS, iphoneos, appletvsimulator, etc.
//  Arch: arm64, x86_64, etc.
//
// So far we observed that Xcode can move the module into different locations, and it's not
// entirely clear how to deduce the destination from the context available for the extractor.
// 1. First case:
//  DerivedData/<Project>/Build/Products/<BuiltType>-<Target>/<ModuleName>.swiftmodule/<Arch>.swiftmodule
//  DerivedData/<Project>/Build/Products/<BuiltType>-<Target>/<ModuleName>.swiftmodule/<Triple>.swiftmodule
// 2. Second case:
//  DerivedData/<Project>/Build/Products/<BuiltType>-<Target>/<ModuleName>/<ModuleName>.swiftmodule/<Arch>.swiftmodule
//  DerivedData/<Project>/Build/Products/<BuiltType>-<Target>/<ModuleName>/<ModuleName>.swiftmodule/<Triple>.swiftmodule
// 2. Third case:
//  DerivedData/<Project>/Build/Products/<BuiltType>-<Target>/<ModuleName>/<ModuleName>.framework/Modules/<ModuleName>.swiftmodule/<Arch>.swiftmodule
//  DerivedData/<Project>/Build/Products/<BuiltType>-<Target>/<ModuleName>/<ModuleName>.framework/Modules/<ModuleName>.swiftmodule/<Triple>.swiftmodule
// The <Triple> here is a normalized target triple (e.g. arm64-apple-iphoneos15.4 ->
// arm64-apple-iphoneos).
//
// This method constructs those aliases for a module only if it comes from Xcode, which is detected
// by the presence of an `Intermediates.noindex` directory in the module path.
//
// In the case of the Swift Package Manager (`swift build`) this is not needed.
static std::vector<std::string> computeModuleAliases(llvm::StringRef modulePath,
                                                     const std::string& targetTriple) {
  if (modulePath.empty()) {
    return {};
  }
  if (!modulePath.endswith(".swiftmodule")) {
    return {};
  }
  // Deconstructing the Xcode generated path
  //
  // clang-format off
  //                          intermediatesDirIndex               destinationDir (2)                              arch(5)
  // DerivedData/FooBar/Build/Intermediates.noindex/FooBar.build/Debug-iphonesimulator/FooBar.build/Objects-normal/x86_64/FooBar.swiftmodule
  // clang-format on
  llvm::SmallVector<llvm::StringRef> chunks;
  modulePath.split(chunks, '/');
  size_t intermediatesDirIndex = 0;
  for (size_t i = 0; i < chunks.size(); i++) {
    if (chunks[i] == "Intermediates.noindex") {
      intermediatesDirIndex = i;
      break;
    }
  }
  // Not built by Xcode, skipping
  if (intermediatesDirIndex == 0) {
    return {};
  }
  size_t destinationDirIndex = intermediatesDirIndex + 2;
  size_t archIndex = intermediatesDirIndex + 5;
  if (archIndex >= chunks.size()) {
    return {};
  }
  // e.g. Debug-iphoneos, Release-iphonesimulator, etc.
  auto destinationDir = chunks[destinationDirIndex].str();
  auto arch = chunks[archIndex].str();
  auto moduleNameWithExt = chunks.back();
  auto moduleName = moduleNameWithExt.substr(0, moduleNameWithExt.find_last_of('.'));
  std::string relocatedModulePath = chunks[0].str();
  for (size_t i = 1; i < intermediatesDirIndex; i++) {
    relocatedModulePath += '/' + chunks[i].str();
  }
  relocatedModulePath += "/Products/";
  relocatedModulePath += destinationDir + '/';

  // clang-format off
  std::vector<std::string> moduleLocations = {
    // First case
    relocatedModulePath + moduleNameWithExt.str() + '/',
    // Second case
    relocatedModulePath + moduleName.str() + '/' + moduleNameWithExt.str() + '/',
    // Third case
    relocatedModulePath + moduleName.str() + '/' + moduleName.str() + ".framework/Modules/" + moduleNameWithExt.str() + '/',
  };
  // clang-format on

  std::vector<std::string> archs({arch});
  if (!targetTriple.empty()) {
    llvm::Triple triple(targetTriple);
    archs.push_back(swift::getTargetSpecificModuleTriple(triple).normalize());
  }

  std::vector<std::string> aliases;
  for (auto& location : moduleLocations) {
    for (auto& a : archs) {
      aliases.push_back(location + a + ".swiftmodule");
    }
  }

  return aliases;
}

namespace codeql {

std::unordered_map<std::string, std::string> rewriteOutputsInPlace(
    const SwiftExtractorConfiguration& config,
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
      auto newPath = config.getTempArtifactDir() + '/' + oldPath;
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
    auto maybeNewPath = rewriteOutputFileMap(config, oldPath, maybeInput, remapping);
    if (maybeNewPath) {
      auto newPath = maybeNewPath.value();
      CLIArgs[index] = newPath;
      remapping[oldPath] = newPath;
    }
  }

  // This doesn't really belong here, but we've got Xcode...
  for (const auto& [oldPath, newPath] : remapping) {
    llvm::StringRef path(oldPath);
    auto aliases = computeModuleAliases(path, targetTriple);
    for (auto& alias : aliases) {
      remapping[alias] = newPath;
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

void storeRemappingForVFS(const SwiftExtractorConfiguration& config,
                          const std::unordered_map<std::string, std::string>& remapping) {
  // Only create remapping for the .swiftmodule files
  std::unordered_map<std::string, std::string> modules;
  for (const auto& [oldPath, newPath] : remapping) {
    if (llvm::StringRef(oldPath).endswith(".swiftmodule")) {
      modules.emplace(oldPath, newPath);
    }
  }

  if (modules.empty()) {
    return;
  }

  if (std::error_code ec = llvm::sys::fs::create_directories(config.getTempVFSDir())) {
    std::cerr << "Cannot create temp VFS directory: " << ec.message() << "\n";
    return;
  }

  if (std::error_code ec = llvm::sys::fs::create_directories(config.getVFSDir())) {
    std::cerr << "Cannot create VFS directory: " << ec.message() << "\n";
    return;
  }

  // Constructing the VFS yaml file in a temp folder so that the other process doesn't read it
  // while it is not complete
  // TODO: Pick a more robust way to not collide with files from other processes
  auto tempVfsPath = config.getTempVFSDir() + '/' + std::to_string(getpid()) + "-vfs.yaml";
  std::error_code ec;
  llvm::raw_fd_ostream fd(tempVfsPath, ec, llvm::sys::fs::OF_None);
  if (ec) {
    std::cerr << "Cannot create temp VFS file: '" << tempVfsPath << "': " << ec.message() << "\n";
    return;
  }
  // TODO: there must be a better API than this
  // LLVM expects the version to be 0
  fd << "{ version: 0,\n";
  // This tells the FS not to fallback to the physical file system in case the remapped file is not
  // present
  fd << "  fallthrough: false,\n";
  fd << "  roots: [\n";
  for (auto& [oldPath, newPath] : modules) {
    fd << "  {\n";
    fd << "    type: 'file',\n";
    fd << "    name: '" << oldPath << "\',\n";
    fd << "    external-contents: '" << newPath << "\'\n";
    fd << "  },\n";
  }
  fd << "  ]\n";
  fd << "}\n";

  fd.flush();
  auto vfsPath = config.getVFSDir() + '/' + std::to_string(getpid()) + "-vfs.yaml";
  if (std::error_code ec = llvm::sys::fs::rename(tempVfsPath, vfsPath)) {
    std::cerr << "Cannot move temp VFS file '" << tempVfsPath << "' -> '" << vfsPath
              << "': " << ec.message() << "\n";
    return;
  }
}

std::vector<std::string> collectVFSFiles(const SwiftExtractorConfiguration& config) {
  auto vfsDir = config.getVFSDir() + '/';
  if (!llvm::sys::fs::exists(vfsDir)) {
    return {};
  }
  std::vector<std::string> overlays;
  std::error_code ec;
  llvm::sys::fs::directory_iterator it(vfsDir, ec);
  while (!ec && it != llvm::sys::fs::directory_iterator()) {
    llvm::StringRef path(it->path());
    if (path.endswith("vfs.yaml")) {
      overlays.push_back(path.str());
    }
    it.increment(ec);
  }

  return overlays;
}

void lockOutputSwiftModuleTraps(const SwiftExtractorConfiguration& config,
                                const std::unordered_map<std::string, std::string>& remapping) {
  for (const auto& [oldPath, newPath] : remapping) {
    if (llvm::StringRef(oldPath).endswith(".swiftmodule")) {
      if (auto target = createTargetTrapFile(config, oldPath)) {
        *target << "// trap file deliberately empty\n"
                   "// this swiftmodule was created during the build, so its entities must have"
                   " been extracted directly from source files";
      }
    }
  }
}

}  // namespace codeql
