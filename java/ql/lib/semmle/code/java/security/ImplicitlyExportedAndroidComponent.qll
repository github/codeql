/** Provides a class to reason about Android implicitly exported components. */

private import semmle.code.xml.AndroidManifest

class ImplicitlyExportedAndroidComponent extends AndroidComponentXmlElement {
  //ImplicitlyExportedAndroidComponent() {  }
  predicate isImplicitlyExported() {
    not this.hasExportedAttribute() and
    this.hasAnIntentFilterElement() and
    not this.requiresPermissions() and
    not this.getParent().(AndroidApplicationXmlElement).hasAttribute("permission") and
    not this.getAnIntentFilterElement().hasLauncherCategoryElement() and
    not this.getFile().(AndroidManifestXmlFile).isInBuildDirectory()
  }
}
