#pragma once

#include "swift/xcode-autobuilder/XcodeTarget.h"
#include "swift/xcode-autobuilder/XcodeProjectParser.h"
#include <filesystem>

void installDependencies(const ProjectStructure& target, bool dryRun);
bool buildXcodeTarget(const XcodeTarget& target, bool dryRun);
bool buildSwiftPackage(const std::filesystem::path& packageFile, bool dryRun);
