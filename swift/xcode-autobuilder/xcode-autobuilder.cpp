#include <CoreFoundation/CoreFoundation.h>
#include <iostream>
#include <unordered_map>
#include <unordered_set>
#include <vector>
#include <filesystem>
#include <libxml/tree.h>
#include <libxml/parser.h>
#import <fstream>
#include <spawn.h>

static const char* Application = "com.apple.product-type.application";
static const char* Framework = "com.apple.product-type.framework";

typedef std::unordered_map<std::string, CFDictionaryRef> Targets;
typedef std::unordered_map<std::string, std::vector<std::string>> Dependencies;
typedef std::unordered_map<std::string, std::vector<std::pair<std::string, CFDictionaryRef>>>
    BuildFiles;

size_t totalFilesCount(const std::string& target,
                       const Dependencies& dependencies,
                       const BuildFiles& buildFiles) {
  size_t sum = buildFiles.at(target).size();
  for (auto& dep : dependencies.at(target)) {
    sum += totalFilesCount(dep, dependencies, buildFiles);
  }
  return sum;
}

bool objectIsTarget(CFDictionaryRef object) {
  auto isa = (CFStringRef)CFDictionaryGetValue(object, CFSTR("isa"));
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

namespace fs = std::filesystem;

std::vector<fs::path> collectFiles(const std::string& workingDir) {
  std::filesystem::path workDir(workingDir);
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

/*
Extracts FileRef locations from an XML of the following form:

 <?xml version="1.0" encoding="UTF-8"?>
 <Workspace version = "1.0">
  <FileRef location = "group:PathToProject.xcodeproj">
  </FileRef>
 </Workspace>

 */
std::vector<fs::path> readProjectsFromWorkspace(const std::string& workspace) {
  fs::path workspacePath(workspace);
  auto workspaceData = workspacePath / "contents.xcworkspacedata";
  if (!fs::exists(workspaceData)) {
    std::cerr << "[xcode autobuilder] Cannot read workspace: file does not exist '" << workspaceData
              << "\n";
    return {};
  }

  auto xmlDoc = xmlParseFile(workspaceData.c_str());
  if (!xmlDoc) {
    std::cerr << "[xcode autobuilder] Cannot parse workspace file '" << workspaceData << "\n";
    return {};
  }
  auto root = xmlDocGetRootElement(xmlDoc);
  auto first = xmlFirstElementChild(root);
  auto last = xmlLastElementChild(root);
  std::vector<xmlNodePtr> children;
  for (; first != last; first = xmlNextElementSibling(first)) {
    children.push_back(first);
  }
  children.push_back(first);
  std::vector<std::string> locations;
  for (auto child : children) {
    if (child) {
      auto prop = xmlGetProp(child, xmlCharStrdup("location"));
      if (prop) {
        locations.emplace_back((char*)prop);
      }
    }
  }
  xmlFreeDoc(xmlDoc);

  std::vector<fs::path> projects;
  for (auto& location : locations) {
    auto colon = location.find(':');
    if (colon != std::string::npos) {
      auto project = location.substr(colon + 1);
      if (!project.empty()) {
        auto fullPath = workspacePath.parent_path() / project;
        projects.push_back(fullPath);
      }
    }
  }

  return projects;
}

CFDictionaryRef xcodeProjectObjects(const std::string& xcodeProject) {
  auto allocator = CFAllocatorGetDefault();
  auto pbxproj = fs::path(xcodeProject) / "project.pbxproj";
  if (!fs::exists(pbxproj)) {
    return CFDictionaryCreate(allocator, nullptr, nullptr, 0, nullptr, nullptr);
  }
  std::ifstream ifs(pbxproj, std::ios::in);
  std::string content((std::istreambuf_iterator<char>(ifs)), (std::istreambuf_iterator<char>()));
  auto data = CFDataCreate(allocator, (UInt8*)content.data(), content.size());
  CFErrorRef error = nullptr;
  auto plist = CFPropertyListCreateWithData(allocator, data, 0, nullptr, &error);
  if (error) {
    auto description = CFCopyDescription(error);
    std::cerr << "[xcode autobuilder] Cannot read Xcode project: "
              << CFStringGetCStringPtr(description, kCFStringEncodingUTF8) << ": " << pbxproj
              << "\n";
    CFRelease(description);
    return CFDictionaryCreate(allocator, nullptr, nullptr, 0, nullptr, nullptr);
  }

  return (CFDictionaryRef)CFDictionaryGetValue((CFDictionaryRef)plist, CFSTR("objects"));
}

std::string stringValue(CFDictionaryRef dict, CFStringRef key) {
  auto cfValue = (CFStringRef)CFDictionaryGetValue(dict, key);
  if (cfValue) {
    auto length = CFStringGetLength(cfValue);
    std::string s(length, '\0');
    if (CFStringGetCString(cfValue, s.data(), length + 1, kCFStringEncodingUTF8)) {
      return s;
    }
  }
  return {};
}

struct CFKeyValues {
  static CFKeyValues fromDictionary(CFDictionaryRef dict) {
    auto size = CFDictionaryGetCount(dict);
    CFKeyValues ret(size);
    CFDictionaryGetKeysAndValues(dict, ret.keys.data(), ret.values.data());
    return ret;
  }
  explicit CFKeyValues(size_t size) : size(size), keys(size), values(size) {}
  size_t size;
  std::vector<const void*> keys;
  std::vector<const void*> values;
};

std::vector<std::pair<std::string, std::string>> readTargets(const std::string& project) {
  auto objects = xcodeProjectObjects(project);
  std::vector<std::pair<std::string, std::string>> targets;
  auto kv = CFKeyValues::fromDictionary(objects);
  for (size_t i = 0; i < kv.size; i++) {
    auto object = (CFDictionaryRef)kv.values[i];
    if (objectIsTarget(object)) {
      auto name = stringValue(object, CFSTR("name"));
      auto type = stringValue(object, CFSTR("productType"));
      targets.emplace_back(name, type.empty() ? "<unknown_target_type>" : type);
    }
  }
  return targets;
}

std::unordered_map<std::string, std::vector<std::string>> collectWorkspaces(
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

struct TargetData {
  std::string workspace;
  std::string project;
  std::string type;
};

std::unordered_map<std::string, TargetData> mapTargetsToWorkspace(
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

void mapTargetsToSourceFiles(CFDictionaryRef objects,
                             std::unordered_map<std::string, size_t>& fileCounts) {
  Targets targets;
  Dependencies dependencies;
  BuildFiles buildFiles;

  auto kv = CFKeyValues::fromDictionary(objects);
  for (size_t i = 0; i < kv.size; i++) {
    auto object = (CFDictionaryRef)kv.values[i];
    if (objectIsTarget(object)) {
      auto name = stringValue(object, CFSTR("name"));
      dependencies[name] = {};
      buildFiles[name] = {};
      targets.emplace(name, object);
    }
  }

  for (auto& [targetName, targetObject] : targets) {
    auto deps = (CFArrayRef)CFDictionaryGetValue(targetObject, CFSTR("dependencies"));
    auto size = CFArrayGetCount(deps);
    for (CFIndex i = 0; i < size; i++) {
      auto dependencyID = (CFStringRef)CFArrayGetValueAtIndex(deps, i);
      auto dependency = (CFDictionaryRef)CFDictionaryGetValue(objects, dependencyID);
      auto targetID = (CFStringRef)CFDictionaryGetValue(dependency, CFSTR("target"));
      if (!targetID) {
        // Skipping non-targets (e.g., productRef)
        continue;
      }
      auto targetDependency = (CFDictionaryRef)CFDictionaryGetValue(objects, targetID);
      auto dependencyName = stringValue(targetDependency, CFSTR("name"));
      if (!dependencyName.empty()) {
        dependencies[targetName].push_back(dependencyName);
      }
    }
  }

  for (auto& [targetName, targetObject] : targets) {
    auto buildPhases = (CFArrayRef)CFDictionaryGetValue(targetObject, CFSTR("buildPhases"));
    auto buildPhaseCount = CFArrayGetCount(buildPhases);
    for (CFIndex buildPhaseIndex = 0; buildPhaseIndex < buildPhaseCount; buildPhaseIndex++) {
      auto buildPhaseID = (CFStringRef)CFArrayGetValueAtIndex(buildPhases, buildPhaseIndex);
      auto buildPhase = (CFDictionaryRef)CFDictionaryGetValue(objects, buildPhaseID);
      auto fileRefs = (CFArrayRef)CFDictionaryGetValue(buildPhase, CFSTR("files"));
      if (!fileRefs) {
        continue;
      }
      auto fileRefsCount = CFArrayGetCount(fileRefs);
      for (CFIndex fileRefIndex = 0; fileRefIndex < fileRefsCount; fileRefIndex++) {
        auto fileRefID = (CFStringRef)CFArrayGetValueAtIndex(fileRefs, fileRefIndex);
        auto fileRef = (CFDictionaryRef)CFDictionaryGetValue(objects, fileRefID);
        auto fileID = (CFStringRef)CFDictionaryGetValue(fileRef, CFSTR("fileRef"));
        if (!fileID) {
          // FileRef is not a reference to a file (e.g., PBXBuildFile)
          continue;
        }
        auto file = (CFDictionaryRef)CFDictionaryGetValue(objects, fileID);
        if (!file) {
          // Sometimes the references file belongs to another project, which is not present for
          // various reasons
          continue;
        }
        auto isa = stringValue(file, CFSTR("isa"));
        if (isa != "PBXFileReference") {
          // Skipping anything that is not a 'file', e.g. PBXVariantGroup
          continue;
        }
        auto fileType = stringValue(file, CFSTR("lastKnownFileType"));
        auto path = stringValue(file, CFSTR("path"));
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

// Maps each target to the number of Swift source files it contains transitively
std::unordered_map<std::string, size_t> mapTargetsToSourceFiles(
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

struct Target {
  std::string workspace;
  std::string project;
  std::string name;
  std::string type;
  size_t fileCount;
};

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

extern char** environ;

static int waitpid_status(pid_t child) {
  int status;
  while (waitpid(child, &status, 0) == -1) {
    if (errno != EINTR) break;
  }
  return status;
}

static bool exec(const std::vector<std::string>& argv) {
  const char** c_argv = (const char**)calloc(argv.size() + 1, sizeof(char*));
  for (size_t i = 0; i < argv.size(); i++) {
    c_argv[i] = argv[i].c_str();
  }
  c_argv[argv.size()] = nullptr;

  pid_t pid = 0;
  if (posix_spawn(&pid, argv.front().c_str(), nullptr, nullptr, (char* const*)c_argv, environ) !=
      0) {
    fprintf(stderr, "[xcode autobuilder] posix_spawn failed: %s\n", strerror(errno));
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
    std::string s;
    for (auto& arg : argv) {
      s += arg + " ";
    }
    std::cout << s << "\n";
  } else {
    if (!exec(argv)) {
      std::cerr << "Build failed\n";
      exit(1);
    }
  }
}

void doTheWork(const std::string& workingDir, bool dryRun) {
  auto targets = collectTargets(workingDir);

  // Filter out non-application/framework targets
  std::unordered_set<std::string> allowedTargetTypes({Application, Framework});
  targets.erase(
      std::remove_if(std::begin(targets), std::end(targets),
                     [&](Target& t) -> bool { return !allowedTargetTypes.count(t.type); }),
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

  buildTarget(targets.front(), dryRun);
}

int main(int argc, char** argv) {
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
    path = fs::current_path();
  }
  doTheWork(path, dryRun);
  return 0;
}
