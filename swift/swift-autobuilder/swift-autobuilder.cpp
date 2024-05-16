#include <iostream>
#include <vector>
#include <filesystem>
#include "swift/swift-autobuilder/XcodeTarget.h"
#include "swift/swift-autobuilder/BuildRunner.h"
#include "swift/swift-autobuilder/ProjectParser.h"
#include "swift/logging/SwiftLogging.h"
#include "swift/swift-autobuilder/CustomizingBuildLink.h"

static constexpr std::string_view uiTest = "com.apple.product-type.bundle.ui-testing";
static constexpr std::string_view unitTest = "com.apple.product-type.bundle.unit-test";
static constexpr std::string_view unknownType = "<unknown_target_type>";

const std::string_view codeql::programName = "autobuilder";
const std::string_view codeql::extractorName = "swift";

constexpr codeql::Diagnostic noProjectFound{
    .id = "no-project-found",
    .name = "No Xcode project or workspace found",
    .action = "Set up a [manual build command][1].\n\n[1]: " MANUAL_BUILD_COMMAND_HELP_LINK};

constexpr codeql::Diagnostic noSwiftTarget{
    .id = "no-swift-target",
    .name = "No Swift compilation target found",
    .action = "To analyze a custom set of source files, set up a [manual build "
              "command][1].\n\n[1]: " MANUAL_BUILD_COMMAND_HELP_LINK};

static codeql::Logger& logger() {
  static codeql::Logger ret{"main"};
  return ret;
}

struct CLIArgs {
  std::string workingDir;
  bool dryRun;
};

static bool endsWith(std::string_view s, std::string_view suffix) {
  return s.size() >= suffix.size() && s.substr(s.size() - suffix.size()) == suffix;
}

static bool isNonSwiftOrTestTarget(const XcodeTarget& t) {
  return t.fileCount == 0 || t.type == uiTest || t.type == unitTest ||
         // unknown target types can be legitimate, let's do a name-based heuristic then
         (t.type == unknownType && (endsWith(t.name, "Tests") || endsWith(t.name, "Test")));
}

static bool buildSwiftPackages(const std::vector<std::filesystem::path>& swiftPackages,
                               bool dryRun) {
  auto any_successful =
      std::any_of(std::begin(swiftPackages), std::end(swiftPackages), [&](auto& packageFile) {
        LOG_INFO("Building Swift package: {}", packageFile);
        return buildSwiftPackage(packageFile, dryRun);
      });
  return any_successful;
}

static bool autobuild(const CLIArgs& args) {
  auto structure = scanProjectStructure(args.workingDir);
  auto& xcodeTargets = structure.xcodeTargets;
  auto& swiftPackages = structure.swiftPackages;
  for (const auto& t : xcodeTargets) {
    LOG_INFO("{}", t);
  }
  // Filter out targets that are tests or have no swift source files
  xcodeTargets.erase(
      std::remove_if(std::begin(xcodeTargets), std::end(xcodeTargets), isNonSwiftOrTestTarget),
      std::end(xcodeTargets));

  // Sort targets by the amount of files in each
  std::sort(std::begin(xcodeTargets), std::end(xcodeTargets),
            [](XcodeTarget& lhs, XcodeTarget& rhs) { return lhs.fileCount > rhs.fileCount; });

  if (structure.xcodeEncountered && xcodeTargets.empty() && swiftPackages.empty()) {
    // Report error only when there are no Xcode targets and no Swift packages
    DIAGNOSE_ERROR(noSwiftTarget, "All targets found within Xcode projects or workspaces either "
                                  "contain no Swift source files, or are tests.");
    return false;
  } else if (!structure.xcodeEncountered && swiftPackages.empty()) {
    DIAGNOSE_ERROR(
        noProjectFound,
        "`autobuild` detected neither an Xcode project or workspace, nor a Swift package");
    return false;
  } else if (!xcodeTargets.empty()) {
    LOG_INFO("Building Xcode target: {}", xcodeTargets.front());
    installDependencies(structure, args.dryRun);
    auto buildSucceeded = buildXcodeTarget(xcodeTargets.front(), args.dryRun);
    // If build failed, try to build Swift packages
    if (!buildSucceeded && !swiftPackages.empty()) {
      return buildSwiftPackages(swiftPackages, args.dryRun);
    }
    return buildSucceeded;
  } else if (!swiftPackages.empty()) {
    return buildSwiftPackages(swiftPackages, args.dryRun);
  }
  return true;
}

static CLIArgs parseCLIArgs(int argc, char** argv) {
  bool dryRun = false;
  std::string path;
  if (argc == 3) {
    path = argv[2];
    if (std::string(argv[1]) == "-dry-run") {
      dryRun = true;
    }
  } else if (argc == 2) {
    path = argv[1];
  } else {
    path = std::filesystem::current_path();
  }
  return CLIArgs{path, dryRun};
}

int main(int argc, char** argv) {
  auto args = parseCLIArgs(argc, argv);
  auto success = autobuild(args);
  codeql::Log::flush();
  if (!success) {
    return 1;
  }
  return 0;
}
