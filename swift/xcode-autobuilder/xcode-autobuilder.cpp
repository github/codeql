#include <iostream>
#include <vector>
#include <filesystem>
#include "swift/xcode-autobuilder/XcodeTarget.h"
#include "swift/xcode-autobuilder/XcodeBuildRunner.h"
#include "swift/xcode-autobuilder/XcodeProjectParser.h"
#include "swift/logging/SwiftLogging.h"
#include "swift/xcode-autobuilder/CustomizingBuildLink.h"

static constexpr std::string_view uiTest = "com.apple.product-type.bundle.ui-testing";
static constexpr std::string_view unitTest = "com.apple.product-type.bundle.unit-test";
static constexpr std::string_view unknownType = "<unknown_target_type>";

const std::string_view codeql::programName = "autobuilder";

constexpr codeql::SwiftDiagnostic noProjectFound{
    .id = "no-project-found",
    .name = "No Xcode project or workspace found",
    .action = "Set up a [manual build command][1].\n\n[1]: " MANUAL_BUILD_COMMAND_HELP_LINK};

constexpr codeql::SwiftDiagnostic noSwiftTarget{
    .id = "no-swift-target",
    .name = "No Swift compilation target found",
    .action = "To analyze a custom set of source files, set up a [manual build "
              "command][1].\n\n[1]: " MANUAL_BUILD_COMMAND_HELP_LINK};

constexpr codeql::SwiftDiagnostic spmNotSupported{
    .id = "spm-not-supported",
    .name = "Swift Package Manager is not supported",
    .action = "Swift Package Manager builds are not currently supported by `autobuild`. Set up a "
              "[manual build command][1].\n\n[1]: " MANUAL_BUILD_COMMAND_HELP_LINK};

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

static bool isNonSwiftOrTestTarget(const Target& t) {
  return t.fileCount == 0 || t.type == uiTest || t.type == unitTest ||
         // unknown target types can be legitimate, let's do a name-based heuristic then
         (t.type == unknownType && (endsWith(t.name, "Tests") || endsWith(t.name, "Test")));
}

static void autobuild(const CLIArgs& args) {
  auto collected = collectTargets(args.workingDir);
  auto& targets = collected.targets;
  for (const auto& t : targets) {
    LOG_INFO("{}", t);
  }
  // Filter out targets that are tests or have no swift source files
  targets.erase(std::remove_if(std::begin(targets), std::end(targets), isNonSwiftOrTestTarget),
                std::end(targets));

  // Sort targets by the amount of files in each
  std::sort(std::begin(targets), std::end(targets),
            [](Target& lhs, Target& rhs) { return lhs.fileCount > rhs.fileCount; });
  if ((!collected.xcodeEncountered || targets.empty()) && collected.swiftPackageEncountered) {
    DIAGNOSE_ERROR(spmNotSupported,
                   "A Swift package was detected, but no viable Xcode target was found.");
  } else if (!collected.xcodeEncountered) {
    DIAGNOSE_ERROR(noProjectFound, "`autobuild` could not detect an Xcode project or workspace.");
  } else if (targets.empty()) {
    DIAGNOSE_ERROR(noSwiftTarget, "All targets found within Xcode projects or workspaces either "
                                  "contain no Swift source files, or are tests.");
  } else {
    LOG_INFO("Selected {}", targets.front());
    buildTarget(targets.front(), args.dryRun);
    return;
  }
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
  autobuild(args);
  codeql::Log::flush();
  return 0;
}
