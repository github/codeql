/** Provides a class to identify implicitly exported Android components. */

private import semmle.code.xml.AndroidManifest

/** Represents an implicitly exported Android component */
class ImplicitlyExportedAndroidComponent extends AndroidComponentXmlElement {
  //   ImplicitlyExportedAndroidComponent() {
  //     not this.hasExportedAttribute() and
  //     this.hasAnIntentFilterElement() and
  //     not this.requiresPermissions() and
  //     not this.getParent().(AndroidApplicationXmlElement).hasAttribute("permission") and
  //     not this.getAnIntentFilterElement().hasLauncherCategoryElement() and
  //     not this.getFile().(AndroidManifestXmlFile).isInBuildDirectory()
  //   }
  /**
   * Holds if this Android component is implicitly exported.
   */
  predicate isImplicitlyExported() {
    not this.hasExportedAttribute() and
    this.hasAnIntentFilterElement() and
    not this.requiresPermissions() and
    not this.getParent().(AndroidApplicationXmlElement).hasAttribute("permission") and
    not this.getAnIntentFilterElement().hasLauncherCategoryElement() and
    not this.getFile().(AndroidManifestXmlFile).isInBuildDirectory()
  }
}
