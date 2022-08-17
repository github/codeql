/**
 * @name Implicitly exported Android component
 * @description An Android component with an '<intent-filter>' and no 'android:exported' attribute is implicitly exported. This can allow for improper access to the component and its data.
 * @kind problem
 * @problem.severity warning
 * @security-severity 8.2
 * @id java/android/implicitly-exported-component
 * @tags security
 *       external/cwe/cwe-926
 * @precision medium
 */

import java
import semmle.code.java.security.ImplicitlyExportedAndroidComponent

from ImplicitlyExportedAndroidComponent impExpAndroidComp
where impExpAndroidComp.isImplicitlyExported()
select impExpAndroidComp, "This component is implicitly exported."
