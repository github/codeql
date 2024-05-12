#pragma once

#include "swift/swift-autobuilder/XcodeTarget.h"
#include <vector>
#include <string>
#include <filesystem>

struct ProjectStructure {
  std::vector<XcodeTarget> xcodeTargets;
  bool xcodeEncountered;
  // Swift Package Manager support
  std::vector<std::filesystem::path> swiftPackages;
  // CocoaPods support
  std::vector<std::filesystem::path> podfiles;
  // Carthage support
  std::vector<std::filesystem::path> cartfiles;
};

ProjectStructure scanProjectStructure(const std::string& workingDir);
