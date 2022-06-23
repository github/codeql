#pragma once

#include <vector>
#include <string>
#include <unordered_map>

namespace codeql {

struct SwiftExtractorConfiguration;

// Rewrites all the output CLI args to point to a scratch dir instead of the actual locations.
// This is needed to ensure that the artifacts produced by the extractor do not collide with the
// artifacts produced by the actual Swift compiler.
// Returns the map containing remapping oldpath -> newPath.
std::unordered_map<std::string, std::string> rewriteOutputsInPlace(
    SwiftExtractorConfiguration& config,
    std::vector<std::string>& CLIArgs);

// Recreate all the redirected new paths as the Swift compiler expects them to be present
void ensureNewPathsExist(const std::unordered_map<std::string, std::string>& remapping);

// Stores remapped `.swiftmoduile`s in a YAML file for later consumption by the
// llvm::RedirectingFileSystem via Swift's VFSOverlayFiles.
void storeRemappingForVFS(const SwiftExtractorConfiguration& config,
                          const std::unordered_map<std::string, std::string>& remapping);

// Returns a list of VFS YAML files produced by all the extractor processes.
std::vector<std::string> collectVFSFiles(const SwiftExtractorConfiguration& config);

}  // namespace codeql
