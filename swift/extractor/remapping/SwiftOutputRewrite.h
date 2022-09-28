#pragma once

#include <vector>
#include <string>
#include <unordered_map>

namespace codeql {

// Rewrites all the output CLI args to point to a scratch dir instead of the actual locations.
// This is needed to ensure that the artifacts produced by the extractor do not collide with the
// artifacts produced by the actual Swift compiler.
// Returns the map containing remapping oldpath -> newPath.
std::unordered_map<std::string, std::string> rewriteOutputsInPlace(
    const std::string& scratchDir,
    std::vector<std::string>& CLIArgs);

// Create directories for all the redirected new paths as the Swift compiler expects them to exist.
void ensureDirectoriesForNewPathsExist(
    const std::unordered_map<std::string, std::string>& remapping);

}  // namespace codeql
