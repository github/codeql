import javascript

class CustomImport extends DataFlow::ModuleImportNode::Range, DataFlow::CallNode {
  CustomImport() { getCalleeName() = "customImport" }

  override string getPath() { result = getArgument(0).getStringValue() }
}

from string path, CustomImport imprt
where imprt = DataFlow::moduleImport(path)
select path, imprt.getPath(), imprt
