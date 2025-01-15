/** Provides a class to identify implicitly exported Android components. */
overlay[local?]
module;

private import semmle.code.xml.AndroidManifest

/**
 * An Android component without an `exported` attribute explicitly set
 * that also has an `intent-filter` element.
 */
class ImplicitlyExportedAndroidComponent extends AndroidComponentXmlElement {
  ImplicitlyExportedAndroidComponent() {
    this.hasAnIntentFilterElement() and
    not this.hasExportedAttribute() and
    // Components with category LAUNCHER or with action MAIN need to be exported since
    // they are entry-points to the application. As a result, we do not consider these
    // components to be implicitly exported since the developer intends them to be exported anyways.
    not this.getAnIntentFilterElement().getACategoryElement().getCategoryName() =
      "android.intent.category.LAUNCHER" and
    not this.getAnIntentFilterElement().getAnActionElement().getActionName() =
      "android.intent.action.MAIN" and
    // The `permission` attribute can be used to limit components' exposure to other applications.
    // As a result, we do not consider components with an explicitly set `permission` attribute to be
    // implicitly exported since the developer has already limited access to such components.
    not this.requiresPermissions() and
    not this.getParent().(AndroidApplicationXmlElement).requiresPermissions() and
    not this.getFile().(AndroidManifestXmlFile).isInBuildDirectory()
  }
}
