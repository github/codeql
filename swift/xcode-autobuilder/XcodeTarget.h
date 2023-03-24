#pragma once

#include <string>

struct Target {
  std::string workspace;
  std::string project;
  std::string name;
  std::string type;
  size_t fileCount;
};
