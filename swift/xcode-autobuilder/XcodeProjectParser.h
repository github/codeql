#pragma once

#include "XcodeTarget.h"
#include <vector>
#include <string>

std::vector<Target> collectTargets(const std::string& workingDir);
