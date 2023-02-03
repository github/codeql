/**
 * Provides classes modeling package setup as defined by `setuptools`.
 */

private import python
private import semmle.python.dataflow.new.DataFlow

/** Provides models for the use of `setuptools` in setup scripts, and the APIs exported by the library defined using `setuptools`. */
module Setuptools {
  /**
   * Gets a file that sets up a package using `setuptools` (or the deprecated `distutils`).
   */
  private File setupFile() {
    // all of these might not be extracted, but the support is ready for when they are
    result.getBaseName() = ["setup.py", "setup.cfg", "pyproject.toml"]
  }

  /**
   * Gets a file or folder that is exported by a library.
   */
  private Container getALibraryExportedContainer() {
    // a child folder of the root that has a setup.py file
    result = setupFile().getParent().(Folder).getAFolder() and
    // where the folder has __init__.py file
    exists(result.(Folder).getFile("__init__.py")) and
    // and is not a test folder
    not result.(Folder).getBaseName() = ["test", "tests", "testing"]
    or
    // child of a library exported container
    result = getALibraryExportedContainer().getAChildContainer() and
    (
      // either any file
      not result instanceof Folder
      or
      // or a folder with an __init__.py file
      exists(result.(Folder).getFile("__init__.py"))
    )
  }

  /**
   * Gets an AST node that is exported by a library.
   */
  private AstNode getAnExportedLibraryFeature() {
    result.(Module).getFile() = getALibraryExportedContainer()
    or
    result = getAnExportedLibraryFeature().(Module).getAStmt()
    or
    result = getAnExportedLibraryFeature().(ClassDef).getDefinedClass().getAMethod()
    or
    result = getAnExportedLibraryFeature().(ClassDef).getDefinedClass().getInitMethod()
    or
    result = getAnExportedLibraryFeature().(FunctionDef).getDefinedFunction()
  }

  /**
   * Gets a public function (or __init__) that is exported by a library.
   */
  private Function getAnExportedFunction() {
    result = getAnExportedLibraryFeature() and
    (
      result.isPublic()
      or
      result.isInitMethod()
    )
  }

  /**
   * Gets a parameter to a public function that is exported by a library.
   */
  DataFlow::ParameterNode getALibraryInput() {
    result.getParameter() = getAnExportedFunction().getAnArg() and
    not result.getParameter().isSelf()
  }
}
