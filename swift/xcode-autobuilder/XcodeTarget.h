#pragma once

#include <string>
#include <binlog/adapt_struct.hpp>

struct Target {
  std::string workspace;
  std::string project;
  std::string name;
  std::string type;
  size_t fileCount;
};

BINLOG_ADAPT_STRUCT(Target, workspace, project, name, type, fileCount);
