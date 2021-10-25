/**
 * @name MavenPoms
 * @description Verify that Maven Poms are correctly identified.
 */

import java
import semmle.code.xml.MavenPom

from Pom p
select p, p.getGroup().getValue(), p.getArtifact().getValue()
