#include "swift/xcode-autobuilder/XcodeBuildRunner.h"

#include <vector>
#include <iostream>
#include <spawn.h>
#include "absl/strings/str_join.h"

#include "swift/logging/SwiftLogging.h"
#include "swift/xcode-autobuilder/CustomizingBuildLink.h"

constexpr codeql::SwiftDiagnostic buildCommandFailed{
    .id = "build-command-failed",
    .name = "Detected build command failed",
    .action = "Set up a [manual build command][1] or [check the logs of the autobuild step][2].\n"
              "\n[1]: " MANUAL_BUILD_COMMAND_HELP_LINK "\n[2]: " CHECK_LOGS_HELP_LINK};

static codeql::Logger& logger() {
  static codeql::Logger ret{"build"};
  return ret;
}

static int waitpid_status(pid_t child) {
  int status;
  while (waitpid(child, &status, 0) == -1) {
    if (errno != EINTR) break;
  }
  return status;
}

extern char** environ;

static bool exec(const std::vector<std::string>& argv) {
  const char** c_argv = (const char**)calloc(argv.size() + 1, sizeof(char*));
  for (size_t i = 0; i < argv.size(); i++) {
    c_argv[i] = argv[i].c_str();
  }
  c_argv[argv.size()] = nullptr;

  pid_t pid = 0;
  if (posix_spawn(&pid, argv.front().c_str(), nullptr, nullptr, (char* const*)c_argv, environ) !=
      0) {
    std::cerr << "[xcode autobuilder] posix_spawn failed: " << strerror(errno) << "\n";
    free(c_argv);
    return false;
  }
  free(c_argv);
  int status = waitpid_status(pid);
  if (!WIFEXITED(status) || WEXITSTATUS(status) != 0) {
    return false;
  }
  return true;
}

void buildTarget(Target& target, bool dryRun) {
  std::vector<std::string> argv({"/usr/bin/xcodebuild", "build"});
  if (!target.workspace.empty()) {
    argv.push_back("-workspace");
    argv.push_back(target.workspace);
    argv.push_back("-scheme");
  } else {
    argv.push_back("-project");
    argv.push_back(target.project);
    argv.push_back("-target");
  }
  argv.push_back(target.name);
  argv.push_back("CODE_SIGNING_REQUIRED=NO");
  argv.push_back("CODE_SIGNING_ALLOWED=NO");

  if (dryRun) {
    std::cout << absl::StrJoin(argv, " ") << "\n";
  } else {
    if (!exec(argv)) {
      DIAGNOSE_ERROR(buildCommandFailed,
                     "`autobuild` failed to run the detected build command:\n\n```\n{}\n```",
                     absl::StrJoin(argv, " "));
      codeql::Log::flush();
      exit(1);
    }
  }
}
