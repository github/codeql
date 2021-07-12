import javascript
import semmle.javascript.PackageExports as Exports

query DataFlow::Node getALibraryInputParameter() { result = Exports::getALibraryInputParameter() }

query DataFlow::Node getAnExportedValue(Module mod, string name) {
  result = mod.getAnExportedValue(name)
}
