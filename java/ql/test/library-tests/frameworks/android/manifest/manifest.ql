import java
import semmle.code.xml.AndroidManifest

from AndroidActivityXmlElement e
select e.getResolvedComponentName(),
  e.getAnIntentFilterElement().getAnActionElement().getActionName()
