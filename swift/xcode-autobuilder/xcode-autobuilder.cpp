#include <iostream>
#include <vector>
#include <filesystem>
#include "swift/xcode-autobuilder/XcodeTarget.h"
#include "swift/xcode-autobuilder/XcodeBuildRunner.h"
#include "swift/xcode-autobuilder/XcodeProjectParser.h"

static const char* Application = "com.apple.product-type.application";
static const char* Framework = "com.apple.product-type.framework";

struct CLIArgs {
  std::string workingDir;
  bool dryRun;
};

static void autobuild(const CLIArgs& args) {
  auto targets = collectTargets(args.workingDir);

  // Filter out non-application/framework targets
  targets.erase(std::remove_if(std::begin(targets), std::end(targets),
                               [&](Target& t) -> bool {
                                 return t.type != Application && t.type != Framework;
                               }),
                std::end(targets));

  // Sort targets by the amount of files in each
  std::sort(std::begin(targets), std::end(targets),
            [](Target& lhs, Target& rhs) { return lhs.fileCount > rhs.fileCount; });

  for (auto& t : targets) {
    std::cerr << t.workspace << " " << t.project << " " << t.type << " " << t.name << " "
              << t.fileCount << "\n";
  }
  if (targets.empty()) {
    std::cerr << "[xcode autobuilder] Suitable targets not found\n";
    exit(1);
  }

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
  return 0;
}
