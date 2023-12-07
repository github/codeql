#pragma once

#include <string>
#include <vector>
#include <filesystem>

namespace fs = std::filesystem;

std::vector<fs::path> readProjectsFromWorkspace(const std::string& workspace);
