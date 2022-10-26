#pragma once

#include <vector>
#include <string>
#include <unordered_map>
#include "swift/extractor/infra/file/PathHash.h"

namespace codeql {

using PathRemapping = std::unordered_map<std::filesystem::path, std::filesystem::path>;
// Rewrites all the output CLI args to point to a scratch dir instead of the actual locations.
// This is needed to ensure that the artifacts produced by the extractor do not collide with the
// artifacts produced by the actual Swift compiler.
// Returns the map containing remapping oldpath -> newPath.
PathRemapping rewriteOutputsInPlace(const std::filesystem::path& scratchDir,
                                    std::vector<std::string>& CLIArgs);

// Create directories for all the redirected new paths as the Swift compiler expects them to exist.
void ensureDirectoriesForNewPathsExist(const PathRemapping& remapping);

}  // namespace codeql
