#include "swift/xcode-autobuilder/XcodeProjectParser.h"
#include "swift/xcode-autobuilder/XcodeWorkspaceParser.h"
#include "swift/xcode-autobuilder/CFHelpers.h"

#include <iostream>
#include <filesystem>
#include <unordered_map>
#include <unordered_set>
#include <fstream>
#include <CoreFoundation/CoreFoundation.h>

namespace fs = std::filesystem;

struct TargetData {
  std::string workspace;
  std::string project;
  std::string type;
};

typedef std::unordered_map<std::string, CFDictionaryRef> Targets;
typedef std::unordered_map<std::string, std::vector<std::string>> Dependencies;
typedef std::unordered_map<std::string, std::vector<std::pair<std::string, CFDictionaryRef>>>
    BuildFiles;

static size_t totalFilesCount(const std::string& target,
                              const Dependencies& dependencies,
                              const BuildFiles& buildFiles) {
  size_t sum = buildFiles.at(target).size();
  for (auto& dep : dependencies.at(target)) {
    sum += totalFilesCount(dep, dependencies, buildFiles);
  }
  return sum;
}

static bool objectIsTarget(CFDictionaryRef object) {
  auto isa = cf_string_ref(CFDictionaryGetValue(object, CFSTR("isa")));
  if (isa) {
    for (auto target :
         {CFSTR("PBXAggregateTarget"), CFSTR("PBXNativeTarget"), CFSTR("PBXLegacyTarget")}) {
      if (CFStringCompare(isa, target, 0) == kCFCompareEqualTo) {
        return true;
      }
    }
  }
  return false;
}

static void mapTargetsToSourceFiles(CFDictionaryRef objects,
                                    std::unordered_map<std::string, size_t>& fileCounts) {
  Targets targets;
  Dependencies dependencies;
  BuildFiles buildFiles;

  auto kv = CFKeyValues::fromDictionary(objects);
  for (size_t i = 0; i < kv.size; i++) {
    auto object = cf_dictionary_ref(kv.values[i]);
    if (objectIsTarget(object)) {
      auto name = stringValueForKey(object, CFSTR("name"));
      dependencies[name] = {};
      buildFiles[name] = {};
      targets.emplace(name, object);
    }
  }

  for (auto& [targetName, targetObject] : targets) {
    auto deps = cf_array_ref(CFDictionaryGetValue(targetObject, CFSTR("dependencies")));
    auto size = CFArrayGetCount(deps);
    for (CFIndex i = 0; i < size; i++) {
      auto dependencyID = cf_string_ref(CFArrayGetValueAtIndex(deps, i));
      auto dependency = cf_dictionary_ref(CFDictionaryGetValue(objects, dependencyID));
      auto targetID = cf_string_ref(CFDictionaryGetValue(dependency, CFSTR("target")));
      if (!targetID) {
        // Skipping non-targets (e.g., productRef)
        continue;
      }
      auto targetDependency = cf_dictionary_ref(CFDictionaryGetValue(objects, targetID));
      auto dependencyName = stringValueForKey(targetDependency, CFSTR("name"));
      if (!dependencyName.empty()) {
        dependencies[targetName].push_back(dependencyName);
      }
    }
  }

  for (auto& [targetName, targetObject] : targets) {
    auto buildPhases = cf_array_ref(CFDictionaryGetValue(targetObject, CFSTR("buildPhases")));
    auto buildPhaseCount = CFArrayGetCount(buildPhases);
    for (CFIndex buildPhaseIndex = 0; buildPhaseIndex < buildPhaseCount; buildPhaseIndex++) {
      auto buildPhaseID = cf_string_ref(CFArrayGetValueAtIndex(buildPhases, buildPhaseIndex));
      auto buildPhase = cf_dictionary_ref(CFDictionaryGetValue(objects, buildPhaseID));
      auto fileRefs = cf_array_ref(CFDictionaryGetValue(buildPhase, CFSTR("files")));
      if (!fileRefs) {
        continue;
      }
      auto fileRefsCount = CFArrayGetCount(fileRefs);
      for (CFIndex fileRefIndex = 0; fileRefIndex < fileRefsCount; fileRefIndex++) {
        auto fileRefID = cf_string_ref(CFArrayGetValueAtIndex(fileRefs, fileRefIndex));
        auto fileRef = cf_dictionary_ref(CFDictionaryGetValue(objects, fileRefID));
        auto fileID = cf_string_ref(CFDictionaryGetValue(fileRef, CFSTR("fileRef")));
        if (!fileID) {
          // FileRef is not a reference to a file (e.g., PBXBuildFile)
          continue;
        }
        auto file = cf_dictionary_ref(CFDictionaryGetValue(objects, fileID));
        if (!file) {
          // Sometimes the references file belongs to another project, which is not present for
          // various reasons
          continue;
        }
        auto isa = stringValueForKey(file, CFSTR("isa"));
        if (isa != "PBXFileReference") {
          // Skipping anything that is not a 'file', e.g. PBXVariantGroup
          continue;
        }
        auto fileType = stringValueForKey(file, CFSTR("lastKnownFileType"));
        auto path = stringValueForKey(file, CFSTR("path"));
        if (fileType == "sourcecode.swift" && !path.empty()) {
          buildFiles[targetName].emplace_back(path, file);
        }
      }
    }
  }

  for (auto& [targetName, _] : targets) {
    fileCounts[targetName] = totalFilesCount(targetName, dependencies, buildFiles);
  }
}

static CFDictionaryRef xcodeProjectObjects(const std::string& xcodeProject) {
  auto allocator = CFAllocatorGetDefault();
  auto pbxproj = fs::path(xcodeProject) / "project.pbxproj";
  if (!fs::exists(pbxproj)) {
    return CFDictionaryCreate(allocator, nullptr, nullptr, 0, nullptr, nullptr);
  }
  std::ifstream ifs(pbxproj, std::ios::in);
  std::string content((std::istreambuf_iterator<char>(ifs)), (std::istreambuf_iterator<char>()));
  auto data = CFDataCreate(allocator, reinterpret_cast<UInt8*>(content.data()), content.size());
  CFErrorRef error = nullptr;
  auto plist = CFPropertyListCreateWithData(allocator, data, 0, nullptr, &error);
  if (error) {
    std::cerr << "[xcode autobuilder] Cannot read Xcode project: ";
    CFShow(error);
    std::cerr << ": " << pbxproj << "\n";
    return CFDictionaryCreate(allocator, nullptr, nullptr, 0, nullptr, nullptr);
  }

  return cf_dictionary_ref(CFDictionaryGetValue((CFDictionaryRef)plist, CFSTR("objects")));
}

// Maps each target to the number of Swift source files it contains transitively
static std::unordered_map<std::string, size_t> mapTargetsToSourceFiles(
    const std::unordered_map<std::string, std::vector<std::string>>& workspaces) {
  std::unordered_map<std::string, size_t> fileCounts;
  for (auto& [workspace, projects] : workspaces) {
    // All targets/dependencies should be resolved in the context of the same workspace
    // As different projects in the same workspace may reference each other for dependencies
    auto allocator = CFAllocatorGetDefault();
    auto allObjects = CFDictionaryCreateMutable(allocator, 0, nullptr, nullptr);
    for (auto& project : projects) {
      CFDictionaryRef objects = xcodeProjectObjects(project);
      auto kv = CFKeyValues::fromDictionary(objects);
      for (size_t i = 0; i < kv.size; i++) {
        CFDictionaryAddValue(allObjects, kv.keys[i], kv.values[i]);
      }
    }
    mapTargetsToSourceFiles(allObjects, fileCounts);
  }
  return fileCounts;
}

static std::vector<std::pair<std::string, std::string>> readTargets(const std::string& project) {
  auto objects = xcodeProjectObjects(project);
  std::vector<std::pair<std::string, std::string>> targets;
  auto kv = CFKeyValues::fromDictionary(objects);
  for (size_t i = 0; i < kv.size; i++) {
    auto object = (CFDictionaryRef)kv.values[i];
    if (objectIsTarget(object)) {
      auto name = stringValueForKey(object, CFSTR("name"));
      auto type = stringValueForKey(object, CFSTR("productType"));
      targets.emplace_back(name, type.empty() ? "<unknown_target_type>" : type);
    }
  }
  return targets;
}

static std::unordered_map<std::string, TargetData> mapTargetsToWorkspace(
    const std::unordered_map<std::string, std::vector<std::string>>& workspaces) {
  std::unordered_map<std::string, TargetData> targetMapping;
  for (auto& [workspace, projects] : workspaces) {
    for (auto& project : projects) {
      auto targets = readTargets(project);
      for (auto& [target, type] : targets) {
        targetMapping[target] = TargetData{workspace, project, type};
      }
    }
  }
  return targetMapping;
}

static std::vector<fs::path> collectFiles(const std::string& workingDir) {
  fs::path workDir(workingDir);
  std::vector<fs::path> files;
  auto iterator = fs::recursive_directory_iterator(workDir);
  auto end = fs::recursive_directory_iterator();
  for (; iterator != end; iterator++) {
    auto filename = iterator->path().filename();
    if (filename == "DerivedData" || filename == ".git" || filename == "build") {
      // Skip these folders
      iterator.disable_recursion_pending();
      continue;
    }
    auto dirEntry = *iterator;
    if (!dirEntry.is_directory()) {
      continue;
    }
    if (dirEntry.path().extension() != fs::path(".xcodeproj") &&
        dirEntry.path().extension() != fs::path(".xcworkspace")) {
      continue;
    }
    files.push_back(dirEntry.path());
  }
  return files;
}

static std::unordered_map<std::string, std::vector<std::string>> collectWorkspaces(
    const std::string& workingDir) {
  // Here we are collecting list of all workspaces and Xcode projects corresponding to them
  // Projects without workspaces go into the same "empty-workspace" bucket
  std::unordered_map<std::string, std::vector<std::string>> workspaces;
  std::unordered_set<std::string> projectsBelongingToWorkspace;
  std::vector<fs::path> files = collectFiles(workingDir);
  for (auto& path : files) {
    if (path.extension() == ".xcworkspace") {
      auto projects = readProjectsFromWorkspace(path.string());
      for (auto& project : projects) {
        projectsBelongingToWorkspace.insert(project.string());
        workspaces[path.string()].push_back(project.string());
      }
    }
  }
  // Collect all projects not belonging to any workspace into a separate empty bucket
  for (auto& path : files) {
    if (path.extension() == ".xcodeproj") {
      if (projectsBelongingToWorkspace.count(path.string())) {
        continue;
      }
      workspaces[std::string()].push_back(path.string());
    }
  }
  return workspaces;
}

std::vector<Target> collectTargets(const std::string& workingDir) {
  // Getting a list of workspaces and the project that belong to them
  auto workspaces = collectWorkspaces(workingDir);
  if (workspaces.empty()) {
    std::cerr << "[xcode autobuilder] Xcode project or workspace not found\n";
    exit(1);
  }

  // Mapping each target to the workspace/project it belongs to
  auto targetMapping = mapTargetsToWorkspace(workspaces);

  // Mapping each target to the number of source files it contains
  auto targetFilesMapping = mapTargetsToSourceFiles(workspaces);

  std::vector<Target> targets;

  for (auto& [targetName, data] : targetMapping) {
    targets.push_back(Target{data.workspace, data.project, targetName, data.type,
                             targetFilesMapping[targetName]});
  }
  return targets;
}
