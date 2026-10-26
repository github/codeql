import semmle.code.xml.MavenPom

from Dependency d
select d, d.getShortCoordinate(), d.getVersionString()
