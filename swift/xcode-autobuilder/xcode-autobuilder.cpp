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

namespace codeql_diagnostics {
constexpr codeql::SwiftDiagnosticsSource no_swift_target{
    "no_swift_target", "No Swift compilation target found", customizingBuildAction,
    customizingBuildHelpLinks};
}  // namespace codeql_diagnostics

static codeql::Logger& logger() {
  static codeql::Logger ret{"main"};
  return ret;
}

struct CLIArgs {
  std::string workingDir;
  bool dryRun;
};

static void autobuild(const CLIArgs& args) {
  auto targets = collectTargets(args.workingDir);
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

  if (targets.empty()) {
    DIAGNOSE_ERROR(no_swift_target, "All targets found within Xcode projects or workspaces either "
                                    "have no Swift sources or are tests");
    exit(1);
  }
  LOG_INFO("Selected {}", targets.front());
  buildTarget(targets.front(), args.dryRun);
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
