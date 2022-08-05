/**
 * @name Implicitly exported Android component
 * @description TODO after more background reading
 * @kind problem
 * @problem.severity warning (TODO: confirm after more background reading)
 * @security-severity 0.1 (TODO: run script)
 * @id java/android/implicitly-exported-component
 * @tags security
 *       external/cwe/cwe-926
 * @precision TODO after MRVA
 */

import java
import semmle.code.xml.AndroidManifest

// FIRST DRAFT
// from AndroidComponentXmlElement compElem
// where
//   not compElem.hasAttribute("exported") and
//   compElem.getAChild().hasName("intent-filter") and
//   not compElem.hasAttribute("permission") and
//   not compElem
//       .getAnIntentFilterElement()
//       .getAnActionElement()
//       .getActionName()
//       .matches("android.intent.action.MAIN") and // filter out anything that is android intent (e.g. don't just filter out MAIN) because I think those are fine (but need to look at docs to confirm)
//   //not compElem.getAnIntentFilterElement().getAnActionElement().getActionName() = "android.intent.category.LAUNCHER" and // I should add this as well, but above will techincally filter out since they always seem to occur together
//   not compElem.getFile().getRelativePath().matches("%build%") // switch to not isInBuildDirectory() once new predicate is merged into main
// select compElem, "This component is implicitly exported."
// SECOND DRAFT
// from AndroidComponentXmlElement compElem
// where
//   // Does NOT have `exported` attribute
//   not compElem.hasAttribute("exported") and
//   // and DOES have an intent-filter (DOUBLE-CHECK THIS CODE AND CHECK AGAINST OTHER VERSIONS THAT SEEMED TO WORK THE SAME)
//   compElem.getAChild().hasName("intent-filter") and // compElem.getAChild("intent-filter"); need hasComponent with exists(...) here?
//   // and does NOT have `permission` attribute
//   not compElem.hasAttribute("permission") and
//   // and is NOT in build directory (NOTE: switch to not isInBuildDirectory() once new predicate is merged into main)
//   not compElem.getFile().getRelativePath().matches("%build%") and
//   // and does NOT have a LAUNCHER category, see docs: https://developer.android.com/about/versions/12/behavior-changes-12#exported
//   // Constant Value: "android.intent.category.LAUNCHER" from https://developer.android.com/reference/android/content/Intent#CATEGORY_LAUNCHER
//   // I think beloew is actually too coarse because there can be multiple intent-filters in one component, so 2nd intent-filter without the launcher
//   // could maybe be an issue, e.g. https://github.com/microsoft/DynamicsWOM/blob/62c2dad4cbbd4496a55aa3f644336044105bb1c1/app/src/main/AndroidManifest.xml#L56-L66
//   not compElem.getAnIntentFilterElement().getAChild("category").getAttributeValue("name") =
//     "android.intent.category.LAUNCHER" // double-check this code (especially use of getAChild and pattern match with LAUNCHER (e.g. should I do .%LAUNCHER instead?--No, constant value per docs), etc.), and definitely need to add stuff to library for this; should use exists(...) here?
// select compElem, "This component is implicitly exported."
// THIRD DRAFT
from AndroidComponentXmlElement compElem, AndroidManifestXmlElement manifestElem
where
  // Does NOT have `exported` attribute
  not compElem.hasAttribute("exported") and
  // and DOES have an intent-filter (DOUBLE-CHECK THIS CODE AND CHECK AGAINST OTHER VERSIONS THAT SEEMED TO WORK THE SAME)
  compElem.getAChild().hasName("intent-filter") and // compElem.getAChild("intent-filter"); need hasComponent with exists(...) here?
  // and does NOT have `permission` attribute
  not compElem.hasAttribute("permission") and
  // and is NOT in build directory (NOTE: switch to not isInBuildDirectory() once new predicate is merged into main)
  not compElem.getFile().getRelativePath().matches("%build%") and
  // and does NOT have a LAUNCHER category, see docs: https://developer.android.com/about/versions/12/behavior-changes-12#exported
  // Constant Value: "android.intent.category.LAUNCHER" from https://developer.android.com/reference/android/content/Intent#CATEGORY_LAUNCHER
  // I think beloew is actually filtering out too much because there can be multiple intent-filters in one component, so 2nd intent-filter without the launcher
  // could maybe be an issue, e.g. https://github.com/microsoft/DynamicsWOM/blob/62c2dad4cbbd4496a55aa3f644336044105bb1c1/app/src/main/AndroidManifest.xml#L56-L66
  not compElem.getAnIntentFilterElement().getAChild("category").getAttributeValue("name") =
    "android.intent.category.LAUNCHER" and // double-check this code (especially use of getAChild and pattern match with LAUNCHER (e.g. should I do .%LAUNCHER instead?--No, constant value per docs), etc.), and definitely need to add stuff to library for this; should use exists(...) here?
  // and NO <permission> element in manifest file since that will be applied to the component even if no `permission` attribute directly
  // set on component per the docs:
  not manifestElem.getAChild().hasName("permission")
select compElem, "This component is implicitly exported."
