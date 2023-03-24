#include "swift/xcode-autobuilder/XcodeBuildRunner.h"

#include <vector>
#include <iostream>
#include <spawn.h>

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
    for (auto& arg : argv) {
      std::cout << arg + " ";
    }
    std::cout << "\n";
  } else {
    if (!exec(argv)) {
      std::cerr << "Build failed\n";
      exit(1);
    }
  }
}
