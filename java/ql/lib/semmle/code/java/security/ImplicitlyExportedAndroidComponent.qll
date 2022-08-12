/** Provides a class to identify implicitly exported Android components. */

private import semmle.code.xml.AndroidManifest

/** An implicitly exported Android component */
class ImplicitlyExportedAndroidComponent extends AndroidComponentXmlElement {
  ImplicitlyExportedAndroidComponent() {
    this.hasAnIntentFilterElement() and
    not this.hasExportedAttribute() and
    not this.getAnIntentFilterElement().getACategoryElement().getCategoryName() =
      "android.intent.category.LAUNCHER" and
    not this.getAnIntentFilterElement().getAnActionElement().getActionName() =
      "android.intent.action.MAIN" and
    not this.requiresPermissions() and
    not this.getParent().(AndroidApplicationXmlElement).requiresPermissions() and
    not this.getFile().(AndroidManifestXmlFile).isInBuildDirectory()
  }
}
