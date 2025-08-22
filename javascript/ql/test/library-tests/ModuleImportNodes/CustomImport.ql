import javascript

class CustomImport extends DataFlow::ModuleImportNode::Range, DataFlow::CallNode {
  CustomImport() { this.getCalleeName() = "customImport" }

  override string getPath() { result = this.getArgument(0).getStringValue() }
}

from string path, CustomImport imprt
where imprt = DataFlow::moduleImport(path)
select path, imprt.getPath(), imprt
