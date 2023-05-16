#include <iostream>
#include <vector>
#include <filesystem>
#include "swift/xcode-autobuilder/XcodeTarget.h"
#include "swift/xcode-autobuilder/XcodeBuildRunner.h"
#include "swift/xcode-autobuilder/XcodeProjectParser.h"
#include "swift/logging/SwiftLogging.h"
#include "swift/xcode-autobuilder/CustomizingBuildDiagnostics.h"

static const char* uiTest = "com.apple.product-type.bundle.ui-testing";
static const char* unitTest = "com.apple.product-type.bundle.unit-test";

const std::string_view codeql::programName = "autobuilder";

constexpr codeql::SwiftDiagnostic noProjectFound{
    "no-project-found", "No Xcode project or workspace detected", codeql::customizingBuildAction,
    codeql::SwiftDiagnostic::Format::plaintext, codeql::customizingBuildHelpLinks};

constexpr codeql::SwiftDiagnostic noSwiftTarget{
    "no-swift-target", "No Swift compilation target found", codeql::customizingBuildAction,
    codeql::SwiftDiagnostic::Format::plaintext, codeql::customizingBuildHelpLinks};

constexpr codeql::SwiftDiagnostic spmNotSupported{
    "spm-not-supported", "Swift Package Manager build unsupported by autobuild",
    codeql::customizingBuildAction, codeql::SwiftDiagnostic::Format::plaintext,
    codeql::customizingBuildHelpLinks};

static codeql::Logger& logger() {
  static codeql::Logger ret{"main"};
  return ret;
}

struct CLIArgs {
  std::string workingDir;
  bool dryRun;
};

static void autobuild(const CLIArgs& args) {
  auto collected = collectTargets(args.workingDir);
  auto& targets = collected.targets;
  for (const auto& t : targets) {
    LOG_INFO("{}", t);
  }
  // Filter out targets that are tests or have no swift source files
  targets.erase(std::remove_if(std::begin(targets), std::end(targets),
                               [&](Target& t) -> bool {
                                 return t.fileCount == 0 || t.type == uiTest || t.type == unitTest;
                               }),
                std::end(targets));

  // Sort targets by the amount of files in each
  std::sort(std::begin(targets), std::end(targets),
            [](Target& lhs, Target& rhs) { return lhs.fileCount > rhs.fileCount; });
  if ((!collected.xcodeEncountered || targets.empty()) && collected.swiftPackageEncountered) {
    DIAGNOSE_ERROR(spmNotSupported,
                   "No viable Swift Xcode target was found but a Swift package was detected. Swift "
                   "Package Manager builds are not yet supported by the autobuilder");
  } else if (!collected.xcodeEncountered) {
    DIAGNOSE_ERROR(noProjectFound, "No Xcode project or workspace was found");
  } else if (targets.empty()) {
    DIAGNOSE_ERROR(noSwiftTarget, "All targets found within Xcode projects or workspaces either "
                                  "have no Swift sources or are tests");
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
