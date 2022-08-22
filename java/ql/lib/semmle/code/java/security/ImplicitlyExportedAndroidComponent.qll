/** Provides a class to identify implicitly exported Android components. */

private import semmle.code.xml.AndroidManifest

/** Represents an implicitly exported Android component */
class ImplicitlyExportedAndroidComponent extends AndroidComponentXmlElement {
  ImplicitlyExportedAndroidComponent() {
    not this.hasExportedAttribute() and
    this.hasAnIntentFilterElement() and
    not this.getAnIntentFilterElement().getACategoryElement().getCategoryName() =
      "android.intent.category.LAUNCHER" and
    not this.requiresPermissions() and
    not this.getParent().(AndroidApplicationXmlElement).requiresPermissions() and
    //not this.getAnIntentFilterElement().hasLauncherCategoryElement() and
    not this.getFile().(AndroidManifestXmlFile).isInBuildDirectory()
    //this.getFile() instanceof SourceAndroidManifestXmlFile
  }
  //   predicate isImplicitlyExported() {
  //     not this.hasExportedAttribute() and
  //     this.hasAnIntentFilterElement() and
  //     not this.requiresPermissions() and
  //     not this.getParent().(AndroidApplicationXmlElement).hasAttribute("permission") and
  //     not this.getAnIntentFilterElement().hasLauncherCategoryElement() and
  //     not this.getFile().(AndroidManifestXmlFile).isInBuildDirectory() //and
  //     not this.getAnIntentFilterElement().getAnActionElement().getActionName().matches("%MEDIA%") and // try MEDIA exclusion -- MRVA returns 251 results, so only removed 13
  //     not this.getAnIntentFilterElement().getAnActionElement().getActionName() =
  //       "android.intent.action.MAIN" // try MAIN exclusion -- MRVA returns 193 results, so removed 251-193 = 58 results
  //   }
}
