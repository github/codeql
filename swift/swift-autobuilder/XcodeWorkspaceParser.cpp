#include <libxml/tree.h>
#include <libxml/parser.h>
#include <iostream>
#include "swift/swift-autobuilder/XcodeWorkspaceParser.h"

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
