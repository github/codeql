/**
 * @name MavenDeps
 * @description Dependency between Maven POMs
 */

import java
import semmle.code.xml.MavenPom

from Dependency d
select d, d.getParent*().(Pom), d.getPom()
