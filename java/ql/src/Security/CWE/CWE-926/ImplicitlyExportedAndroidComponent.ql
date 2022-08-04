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

from AndroidComponentXmlElement compElem
where
  not compElem.hasAttribute("exported") and
  compElem.getAChild().hasName("intent-filter") and
  not compElem.hasAttribute("permission") and
  not compElem
      .getAnIntentFilterElement()
      .getAnActionElement()
      .getActionName()
      .matches("android.intent.action.%") and // filter out anything that is android intent (e.g. don't just filter out MAIN) because I think those are fine (but need to look at docs to confirm)
  //not compElem.getAnIntentFilterElement().getAnActionElement().getActionName() = "android.intent.category.LAUNCHER" and // I should add this as well, but above will techincally filter out since they always seem to occur together
  not compElem.getFile().getRelativePath().matches("%build%") // switch to not isInBuildDirectory() once new predicate is merged into main
select compElem, "This component is implicitly exported."
