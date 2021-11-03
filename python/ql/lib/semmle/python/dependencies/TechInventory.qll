import python
import semmle.python.dependencies.Dependencies
import semmle.python.dependencies.DependencyKind

/**
 * Combine the source-file and package into a single string:
 * /path/to/file.py<|>package-name-and-version
 */
string munge(File sourceFile, ExternalPackage package) {
  result =
    "/" + sourceFile.getRelativePath() + "<|>" + package.getName() + "<|>" + package.getVersion()
  or
  not exists(package.getVersion()) and
  result = "/" + sourceFile.getRelativePath() + "<|>" + package.getName() + "<|>unknown"
}

abstract class ExternalPackage extends Object instanceof ModuleObject {
  abstract string getName();

  abstract string getVersion();

  Object getAttribute(string name) { result = super.attr(name) }

  PackageObject getPackage() { result = super.getPackage() }
}

bindingset[text]
private predicate is_version(string text) { text.regexpMatch("\\d+\\.\\d+(\\.\\d+)?([ab]\\d+)?") }

bindingset[v]
private string version_format(float v) {
  exists(int i, int f | i = (v + 0.05).floor() and f = ((v + 0.05 - i) * 10).floor() |
    result = i + "." + f
  )
}

class DistPackage extends ExternalPackage {
  DistPackage() {
    exists(Folder parent |
      parent = this.(ModuleObject).getPath().getParent() and
      parent.isImportRoot() and
      /* Not in standard library */
      not parent.isStdLibRoot() and
      /* Not in the source */
      not exists(parent.getRelativePath())
    )
  }

  /*
   * We don't extract the meta-data for dependencies (yet), so make a best guess from the source
   * https://www.python.org/dev/peps/pep-0396/
   */

  private predicate possibleVersion(string version, int priority) {
    exists(Object v | v = this.getAttribute("__version__") and priority = 3 |
      version = v.(StringObject).getText() and is_version(version)
      or
      version = version_format(v.(NumericObject).floatValue())
      or
      version = version_format(v.(NumericObject).intValue())
    )
    or
    exists(SequenceObject tuple, NumericObject major, NumericObject minor, string base_version |
      this.getAttribute("version_info") = tuple and
      major = tuple.getInferredElement(0) and
      minor = tuple.getInferredElement(1) and
      base_version = major.intValue() + "." + minor.intValue()
    |
      version = base_version + "." + tuple.getBuiltinElement(2).(NumericObject).intValue()
      or
      not exists(tuple.getBuiltinElement(2)) and version = base_version
    ) and
    priority = 2
    or
    exists(string v | v.toLowerCase() = "version" |
      is_version(version) and
      version = this.getAttribute(v).(StringObject).getText()
    ) and
    priority = 1
  }

  override string getVersion() {
    this.possibleVersion(result, max(int priority | this.possibleVersion(_, priority)))
  }

  override string getName() { result = this.(ModuleObject).getShortName() }

  predicate fromSource(Object src) {
    exists(ModuleObject m |
      m.getModule() = src.(ControlFlowNode).getEnclosingModule() or
      src = m
    |
      m = this
      or
      m.getPackage+() = this and
      not exists(DistPackage inter |
        m.getPackage*() = inter and
        inter.getPackage+() = this
      )
    )
  }
}

predicate dependency(AstNode src, DistPackage package) {
  exists(DependencyKind cat, Object target | cat.isADependency(src, target) |
    package.fromSource(target)
  )
}
