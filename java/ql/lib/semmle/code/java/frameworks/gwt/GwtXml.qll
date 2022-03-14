/** Provides classes and predicates for working with `*.gwt.xml` files. */

import semmle.code.xml.XML

/**
 * Holds if any `*.gwt.xml` files are included in this snapshot.
 */
predicate isGwtXmlIncluded() { exists(GwtXmlFile webXml) }

/** A GWT module XML file with a `.gwt.xml` suffix. */
class GwtXmlFile extends XMLFile {
  GwtXmlFile() { this.getBaseName().matches("%.gwt.xml") }

  /** Gets the top-level module element of a GWT module XML file. */
  GwtModuleElement getModuleElement() { result = this.getAChild() }

  /** Gets the name of an inherited GWT module, for example `com.google.gwt.user.User`. */
  string getAnInheritedModuleName() {
    result = this.getModuleElement().getAnInheritsElement().getAnInheritedName()
  }

  /** Gets a GWT module XML file (from source) inherited from this module. */
  GwtXmlFile getAnInheritedXmlFile() {
    exists(GwtXmlFile f, string name |
      name = this.getAnInheritedModuleName() and
      f.getAbsolutePath().matches("%/" + name.replaceAll(".", "/") + ".gwt.xml") and
      result = f
    )
  }

  /** Gets the relative path of the folder containing this GWT module XML file. */
  string getRelativeRootFolderPath() { result = this.getParentContainer().getRelativePath() }

  /** Gets a GWT-translatable source sub-folder explicitly defined in a `<source>` element. */
  string getAnExplicitSourceSubPath() {
    result = this.getModuleElement().getASourceElement().getASourcePath()
  }

  /**
   * Gets a GWT-translatable source sub-folder of this GWT module XML file.
   * Either the default `client` folder or as specified by `<source>` tags.
   */
  string getASourceSubPath() {
    result = "client" and not exists(this.getAnExplicitSourceSubPath())
    or
    result = this.getAnExplicitSourceSubPath()
  }

  /**
   * Gets a translatable source folder of this GWT module XML file.
   * Either the default `client` folder or as specified by `<source>` tags.
   * (Includes the full relative root folder path of the GWT module.)
   */
  string getARelativeSourcePath() {
    result = this.getRelativeRootFolderPath() + "/" + this.getASourceSubPath()
  }
}

/** The top-level `<module>` element of a GWT module XML file. */
class GwtModuleElement extends XMLElement {
  GwtModuleElement() {
    this.getParent() instanceof GwtXmlFile and
    this.getName() = "module"
  }

  /** Gets an element of the form `<inherits>`, which specifies a GWT module to inherit. */
  GwtInheritsElement getAnInheritsElement() { result = this.getAChild() }

  /** Gets an element of the form `<entry-point>`, which specifies a GWT entry-point class name. */
  GwtEntryPointElement getAnEntryPointElement() { result = this.getAChild() }

  /** Gets an element of the form `<source>`, which specifies a GWT-translatable source path. */
  GwtSourceElement getASourceElement() { result = this.getAChild() }
}

/** An `<inherits>` element within a GWT module XML file. */
class GwtInheritsElement extends XMLElement {
  GwtInheritsElement() {
    this.getParent() instanceof GwtModuleElement and
    this.getName() = "inherits"
  }

  /** Gets the name of an inherited GWT module, for example `com.google.gwt.user.User`. */
  string getAnInheritedName() { result = this.getAttribute("name").getValue() }
}

/** An `<entry-point>` element within a GWT module XML file. */
class GwtEntryPointElement extends XMLElement {
  GwtEntryPointElement() {
    this.getParent() instanceof GwtModuleElement and
    this.getName() = "entry-point"
  }

  /** Gets the name of a class that serves as a GWT entry-point. */
  string getClassName() { result = this.getAttribute("class").getValue().trim() }
}

/** A `<source>` element within a GWT module XML file. */
class GwtSourceElement extends XMLElement {
  GwtSourceElement() {
    this.getParent() instanceof GwtModuleElement and
    this.getName() = "source"
  }

  /** Gets a path specified to be GWT translatable source code. */
  string getASourcePath() {
    result = this.getAttribute("path").getValue() and
    // Conservative approximation, ignoring Ant-style `FileSet` semantics.
    not exists(this.getAChild()) and
    not exists(this.getAttribute("includes")) and
    not exists(this.getAttribute("excludes"))
  }
}

/** A `<servlet>` element within a GWT module XML file. */
class GwtServletElement extends XMLElement {
  GwtServletElement() {
    this.getParent() instanceof GwtModuleElement and
    this.getName() = "servlet"
  }

  /** Gets the name of a class that is used as a servlet. */
  string getClassName() { result = this.getAttribute("class").getValue().trim() }
}
