/**
 * @name Implicitly exported Android component
 * @description Android components with an '<intent-filter>' and no 'android:exported' attribute are implicitly exported, which can allow for improper access to the components themselves and to their data.
 * @kind problem
 * @problem.severity warning
 * @security-severity 8.2
 * @id java/android/implicitly-exported-component
 * @tags security
 *       external/cwe/cwe-926
 * @precision high
 */

import java
import semmle.code.java.security.ImplicitlyExportedAndroidComponent

from ImplicitlyExportedAndroidComponent impExpAndroidComp
select impExpAndroidComp, "This component is implicitly exported."
