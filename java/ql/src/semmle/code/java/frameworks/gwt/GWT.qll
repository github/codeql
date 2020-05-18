/** Provides classes and predicates for working with the GWT framework. */

import java
import GwtXml
import GwtUiBinder

/** The `com.google.gwt.core.client.EntryPoint` interface. */
class GwtEntryPointInterface extends Interface {
  GwtEntryPointInterface() { this.hasQualifiedName("com.google.gwt.core.client", "EntryPoint") }
}

/** A GWT class that implements the `EntryPoint` interface. */
class GwtEntryPointClass extends Class {
  GwtEntryPointClass() { this.getAnAncestor() instanceof GwtEntryPointInterface }

  /** Gets the method serving as a GWT entry-point. */
  Method getOnModuleLoadMethod() {
    result = this.getACallable() and
    result.hasName("onModuleLoad") and
    result.hasNoParameters()
  }

  /** Gets a GWT module XML file that specifies this class as an entry-point. */
  GwtXmlFile getAGwtXmlFile() {
    exists(GwtXmlFile f |
      result = f and
      this.getQualifiedName() = f.getModuleElement().getAnEntryPointElement().getClassName()
    )
  }

  /**
   * Holds if this entry point is live - that is, whether it is referred to within an XML element.
   */
  predicate isLive() {
    // We must have a `*.gwt.xml` in order to determine whether a particular `EntryPoint` is enabled.
    // In the absence of such a file, we cannot guarantee that `EntryPoint`s without annotations
    // are live.
    isGwtXmlIncluded()
    implies
    // The entry point is live if it is specified in a `*.gwt.xml` file.
    exists(getAGwtXmlFile())
  }
}

/**
 * A compilation unit within a folder that contains
 * a GWT module XML file with a matching source path.
 */
class GwtCompilationUnit extends CompilationUnit {
  GwtCompilationUnit() {
    exists(GwtXmlFile f | getRelativePath().matches(f.getARelativeSourcePath() + "%"))
  }
}

/** A GWT compilation unit that is not referenced from any known non-GWT `CompilationUnit`. */
class ClientSideGwtCompilationUnit extends GwtCompilationUnit {
  ClientSideGwtCompilationUnit() {
    not exists(RefType origin, RefType target |
      target.getCompilationUnit() = this and
      not origin.getCompilationUnit() instanceof GwtCompilationUnit and
      depends(origin, target)
    )
  }
}

private predicate jsni(Javadoc jsni, File file, int startline) {
  // The comment must start with `-{` ...
  jsni.getChild(0).getText().matches("-{%") and
  // ... and it must end with `}-`.
  jsni.getChild(jsni.getNumChild() - 1).getText().matches("%}-") and
  file = jsni.getFile() and
  startline = jsni.getLocation().getStartLine()
}

private predicate nativeMethodLines(Method m, File file, int line) {
  m.isNative() and
  file = m.getFile() and
  line in [m.getLocation().getStartLine() .. m.getLocation().getEndLine()]
}

/** Auxiliary predicate: `jsni` is a JSNI comment associated with method `m`. */
private predicate jsniComment(Javadoc jsni, Method m) {
  exists(File file, int line |
    jsni(jsni, file, line) and
    // The associated callable must be marked as `native`
    // and the comment has to be contained in `m`.
    nativeMethodLines(m, file, line)
  )
}

/**
 * A JavaScript Native Interface (JSNI) comment that contains JavaScript code
 * implementing a native method.
 */
class JSNIComment extends Javadoc {
  JSNIComment() { jsniComment(this, _) }

  /** Gets the method implemented by this comment. */
  Method getImplementedMethod() { jsniComment(this, result) }
}

/**
 * A JavaScript Native Interface (JSNI) method.
 */
class JSNIMethod extends Method {
  JSNIMethod() { jsniComment(_, this) }

  /** Gets the comment containing the JavaScript code for this method. */
  JSNIComment getImplementation() { jsniComment(result, this) }
}
