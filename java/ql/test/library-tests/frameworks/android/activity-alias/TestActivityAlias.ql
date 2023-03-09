import java
import semmle.code.xml.AndroidManifest

from AndroidActivityAliasXmlElement alias
select alias.getComponentName(), alias.getTarget().getComponentName()
