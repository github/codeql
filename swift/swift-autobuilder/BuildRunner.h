#pragma once

#include "swift/swift-autobuilder/XcodeTarget.h"
#include "swift/swift-autobuilder/ProjectParser.h"
#include <filesystem>

void installDependencies(const ProjectStructure& target, bool dryRun);
bool buildXcodeTarget(const XcodeTarget& target, bool dryRun);
bool buildSwiftPackage(const std::filesystem::path& packageFile, bool dryRun);
