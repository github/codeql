import java
import semmle.code.xml.MavenPom

from string pkgFrom, string pkgTo, MavenShadeRelocation reloc
where reloc.relocates(pkgFrom, pkgTo)
select pkgFrom, pkgTo
