#pragma once

#include "swift/xcode-autobuilder/XcodeTarget.h"
#include <vector>
#include <string>

struct Targets {
  std::vector<Target> targets;
  bool xcodeEncountered;
  bool swiftPackageEncountered;
};

Targets collectTargets(const std::string& workingDir);
