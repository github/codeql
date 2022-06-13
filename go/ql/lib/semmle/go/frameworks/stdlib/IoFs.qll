/**
 * Provides classes modeling security-relevant aspects of the 'io/fs' package.
 */

import go

/**
 * Provides classes modeling security-relevant aspects of the 'io/fs' package.
 */
module IoFs {
  /** Gets the package name `io/fs`. */
  string packagePath() { result = "io/fs" }

  private class FunctionModels extends TaintTracking::FunctionModel {
    FunctionInput inp;
    FunctionOutput outp;

    FunctionModels() {
      //signature: func FileInfoToDirEntry(info FileInfo) DirEntry
      this.hasQualifiedName(packagePath(), "FileInfoToDirEntry") and
      (inp.isParameter(0) and outp.isResult())
      or
      //signature: func Glob(fsys FS, pattern string) (matches []string, err error)
      this.hasQualifiedName(packagePath(), "Glob") and
      (inp.isParameter(0) and outp.isResult(0))
      or
      //signature: func ReadFile(fsys FS, name string) ([]byte, error)
      this.hasQualifiedName(packagePath(), "ReadFile") and
      (inp.isParameter(0) and outp.isResult(0))
      or
      //signature: func ReadDir(fsys FS, name string) ([]DirEntry, error)
      this.hasQualifiedName(packagePath(), "ReadDir") and
      (inp.isParameter(0) and outp.isResult(0))
      or
      //signature: func Sub(fsys FS, dir string) (FS, error)
      this.hasQualifiedName(packagePath(), "Sub") and
      (inp.isParameter(0) and outp.isResult(0))
    }

    override predicate hasTaintFlow(FunctionInput input, FunctionOutput output) {
      input = inp and output = outp
    }
  }

  /**
   * Models a step from `fs` to `path` and `d` in
   * `fs.WalkDir(fs, "root", func(path string, d DirEntry, err error) {}`
   */
  private class WalkDirStep extends TaintTracking::AdditionalTaintStep {
    override predicate step(DataFlow::Node pred, DataFlow::Node succ) {
      //signature: func WalkDir(fsys FS, root string, fn WalkDirFunc) error
      exists(DataFlow::CallNode call, DataFlow::FunctionNode f |
        call.getTarget().hasQualifiedName(packagePath(), "WalkDir") and
        f.getASuccessor*() = call.getArgument(2)
      |
        pred = call.getArgument(0) and
        succ = f.getParameter([0, 1])
      )
    }
  }

  private class MethodModels extends TaintTracking::FunctionModel, Method {
    FunctionInput inp;
    FunctionOutput outp;

    MethodModels() {
      //signature: func (DirEntry) Name() string
      this.implements(packagePath(), "DirEntry", "Name") and
      (inp.isReceiver() and outp.isResult())
      or
      //signature: func (DirEntry) Info() (FileInfo, error)
      this.implements(packagePath(), "DirEntry", "Info") and
      (inp.isReceiver() and outp.isResult(0))
      or
      //signature: func (FS) Open(name string) (File, error)
      this.implements(packagePath(), "FS", "Open") and
      (inp.isReceiver() and outp.isResult(0))
      or
      //signature: func (GlobFS) Glob(pattern string) ([]string, error)
      this.implements(packagePath(), "GlobFS", "Glob") and
      (inp.isReceiver() and outp.isResult(0))
      or
      //signature: func (ReadDirFS) ReadDir(name string) ([]DirEntry, error)
      this.implements(packagePath(), "ReadDirFS", "ReadDir") and
      (inp.isReceiver() and outp.isResult(0))
      or
      //signature: func (ReadFileFS) ReadFile(name string) ([]byte, error)
      this.implements(packagePath(), "ReadFileFS", "ReadFile") and
      (inp.isReceiver() and outp.isResult(0))
      or
      //signature: func (SubFS) Sub(dir string) (FS, error)
      this.implements(packagePath(), "SubFS", "Sub") and
      (inp.isReceiver() and outp.isResult(0))
      or
      //signature: func (File) Read([]byte) (int, error)
      this.implements(packagePath(), "File", "Read") and
      (inp.isReceiver() and outp.isParameter(0))
    }

    override predicate hasTaintFlow(FunctionInput input, FunctionOutput output) {
      input = inp and output = outp
    }
  }
}
